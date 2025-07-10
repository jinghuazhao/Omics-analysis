#!/usr/bin/bash
# https://crux.ms/fileformats.html

module load ceuadmin/wine/8.21
module load ceuadmin/pwiz/3_0_24163_9bfa69a-wine
export massive=/rds/project/rds-C1Ph08tkaOA/public/ms-proteomics/MSV000086195/raw
export raw=ScltlMsclsMAvsCntr_Batch1_BRPhsFr5.raw

singularity --version
export crux=/rds/project/rds-zuZwCZMsS0w/Caprion_proteomics/analysis/crux
export SIF=pwiz-skyline-i-agree-to-the-vendor-licenses_latest.sif
ln -s $crux/$SIF
function sif()
{
   singularity pull --name ${SIF} docker://chambm/pwiz-skyline-i-agree-to-the-vendor-licenses
 # http://localhost:8080, Admin, password
   ln -sf /rds/project/rds-4o5vpvAowP0/software/.apptainer/ ${HOME}/.apptainer
   singularity pull docker://quay.io/galaxy/introduction-training
}
for format in --mzML
do
singularity exec --env WINEDEBUG=-all \
                  -B ${massive}:/data \
                      ${crux}/${SIF} \
                      wine msconvert ${format} /data/${raw}
done
# --mzXML --mz5 --mzMLb --mgf --text --ms1 --cms1 --ms2 --cms2

module load ceuadmin/ThermoRawFileParser
export cwd=$(pwd -P)
cd $ThermoRawFileParser_HOME;
ThermoRawFileParser.exe -i $massive/$raw -p
cd -
