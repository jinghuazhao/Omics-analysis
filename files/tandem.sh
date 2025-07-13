#!/usr/bin/env bash
set -euo pipefail

export peak=/rds/project/rds-C1Ph08tkaOA/public/ms-proteomics/MSV000086195/peak
export out=tandem_result
export fasta=uniprot_sprot.fasta

module load ceuadmin/tandem/2017.2.1.4

mkdir -p "$out"
cd "$out"

ln -sf "$peak"/*.mgf .
ln -sf "/rds/project/rds-4o5vpvAowP0/UniProt/$fasta" "$fasta"

for mgf_path in "$peak"/*.mgf; do
  mgf=$(basename "$mgf_path")
  base="${mgf%.mgf}"

  cat > "${base}.bioml" <<EOF
<?xml version="1.0"?>
<bioml>
  <note type="input" label="list path, default parameters">default_input.xml</note>
  <note type="input" label="list path, taxonomy information">taxonomy.xml</note>
  <note type="input" label="spectrum, path">$(realpath "$mgf")</note>
  <note type="input" label="output, path">$(realpath "${base}.mzid")</note>
  <note type="input" label="protein, taxon">Homo sapiens</note>
  <note type="input" label="protein, fasta">$(realpath "$fasta")</note>
</bioml>
EOF

  tandem.exe "${base}.bioml" > "${base}.log"
done

cd -
