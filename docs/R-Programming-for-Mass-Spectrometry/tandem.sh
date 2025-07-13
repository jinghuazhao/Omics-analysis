#!/usr/bin/env bash

export peak=/rds/project/rds-C1Ph08tkaOA/public/ms-proteomics/MSV000086195/peak
export out=tandem_result
export fasta=uniprot_sprot.fasta

module load ceuadmin/tandem/2017.2.1.4

mkdir -p "$out"
cd "$out"

ln -sf "$peak"/*.mgf .
ln -sf "/rds/project/rds-4o5vpvAowP0/UniProt/$fasta" "$fasta"

ls $peak | sed 's/.mgf//' | parallel -j5 -C' ' '
  echo Processing {}
  sed "s|MGF|{}.mgf|; s|MZID|{}.mzid|" input.xml > {}.xml
  tandem.exe {}.xml > {}.log
  mv -v {}*.t.mzid {}.mzid
'
cd -
