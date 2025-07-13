#!/usr/bin/env bash

export peak=/rds/project/rds-C1Ph08tkaOA/public/ms-proteomics/MSV000086195/peak
export out=tandem_result
export fasta=uniprot_sprot.fasta

module load ceuadmin/tandem/2017.2.1.4

mkdir -p "$out"
cd "$out"

ln -sf "$peak"/*.mgf .
ln -sf "/rds/project/rds-4o5vpvAowP0/UniProt/$fasta" "$fasta"

for mgf in *.mgf; do
  base="${mgf%.mgf}"
  echo "Processing $mgf → $base"
  sed "s|MGF|$mgf|; s|MZID|${base}.mzid|" input.xml > "${base}.xml"
  tandem.exe "${base}.xml" > "${base}.log"
  mv -v ${base}*.t.mzid ${base}.mzid
done

cd -
