# 26-6-2018 JHZ

cd /home/jhz22/D/genetics/hakyimlab/MetaXcan/software

./MetaXcan.py \
--model_db_path /home/jhz22/D/genetics/hakyimlab/PredictDB/GTEx-V7_HapMap-2017-11-29/gtex_v7_Brain_Amygdala_imputed_europeans_tw_0.5_signif.db \
--covariance /home/jhz22/D/genetics/hakyimlab/PredictDB/GTEx-V7_HapMap-2017-11-29/gtex_v7_Brain_Amygdala_imputed_eur_covariances.txt.gz \
--gwas_file ldsc.txt \
--snp_column SNP \
--effect_allele_column Tested_Allele \
--non_effect_allele_column Other_Allele \
--beta_column BETA \
--pvalue_column P \
--output_file MX.csv
