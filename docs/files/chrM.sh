#!/bin/bash

INPUT_VCF="gnomad.genomes.v3.1.sites.chrM.vcf.bgz"
OUTPUT_VCF="gnomad.genomes.v3.1.sites.M.vcf"
OUTPUT_VCF_GZ="${OUTPUT_VCF}.gz"

# 1. Extract and edit the header, replace chrM with M
bcftools view -h "$INPUT_VCF" | sed 's/chrM/M/g' > header.txt

# 2. Extract variant lines (no header)
bcftools view -H "$INPUT_VCF" > body.txt

# 3. Replace chrM with M in the variant lines
sed 's/^chrM/M/' body.txt > body_renamed.txt

# 4. Concatenate header and renamed body to create new VCF
cat header.txt body_renamed.txt > "$OUTPUT_VCF"

# 5. Compress and index the new VCF
bgzip -c "$OUTPUT_VCF" > "$OUTPUT_VCF_GZ"
tabix -p vcf "$OUTPUT_VCF_GZ"

# Cleanup intermediate files
rm header.txt body.txt body_renamed.txt "$OUTPUT_VCF"

echo "Done. Created $OUTPUT_VCF_GZ with chrM renamed to M."
