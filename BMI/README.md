# BMI analysis

We work on the latest GIANT+Biiobank data on BMI (Yengo et al. 2018), including both the genomewide and GCTA --cojo results.
```bash
wget https://portals.broadinstitute.org/collaboration/giant/images/0/0f/Meta-analysis_Locke_et_al+UKBiobank_2018.txt.gz
```
the latter as used in Mendelian Randomisation analysis below is downloaded on the fly.

## --- Pathway analysis ---

```bash
gunzip -c Meta-analysis_Locke_et_al+UKBiobank_2018.txt.gz | awk '
{
   FS=OFS="\t"
   if(NR==1) print "SNP","Chr","Pos","P"
   else if($9<=5e-8) print $3,$1,$2,$9
}' | gzip -f > BMI.txt.gz

```
where we opt to customise the header rather than the DEPICT configuration file. Moreover, the (hg19) chromosomal positions are *eventually* back in the data which would facilitate GCTA --cojo analysis and mirrors https://github.com/jinghuazhao/SUMSTATS.

As usual, we make a call to [BMI.cfg](BMI.cfg) via
```bash
depict.py BMI.cfg
```
where the `DEPICT_v1_rel194.tar.gz` version is used. Once started, there was complaint that
```
Retrieving background loci
Exiting.. To few background files in data/backgrounds/nloci723_nperm500_kb500_rsq0.1_mhc25000000-35000000_colld0.5-collection-1000genomespilot-depict-150429/. Please remove the folder, rerun DEPICT and contact tunepers@broadinstitute.org if the error prevails.
```
Follow instruction and remove the directory. It is very slow-going, ~20 hours on our Linux note but surprisingly half that time under my Windows 10 whose directory zipped and then unzipped under Linux and run`depict.py`there.

We then generate [BMI.xlsx](BMI.xlsx) as in [PW-pipelne](https://github.com/jinghuazhao/PW-pipeline/wiki). While there are 859 genesets with FDR<0.05, tissue enrichment shows compelingly an overwhelming role of the nervous system.


This is detailed in [software-notes/DEPICT](https://github.com/jinghuazhao/software-notes/tree/master/DEPICT) together with [PW-pipeline/wiki](https://github.com/jinghuazhao/PW-pipeline/wiki) for the latest GIANT+UKBB pathway analysis.

## --- Partitioned heritabilty ---

Information for the documentation example is available from [software-notes](https://github.com/jinghuazhao/software-notes/). Here we carry on with the .gz file above.
```bash
gunzip -c Meta-analysis_Locke_et_al%2BUKBiobank_2018.txt.gz > BMI.txt
python munge_sumstats.py --sumstats ldsc.txt --a1 Tested_Allele --a2 Other_allele --merge-alleles w_hm3.snplist --out ldsc --a1-inc
```
where we fix the header with appropriate command-line parameters. We see [ldsc.sumstats.gz](ldsc.sumstats.gz) and [ldsc.log](ldsc.log) and carry on with
```bash
python ldsc.py --h2 ldsc.sumstats.gz\
        --ref-ld-chr baseline_v1.1/baseline.\
        --w-ld-chr 1000G_Phase3_weights_hm3_no_MHC/weights.hm3_noMHC.\
        --overlap-annot\
        --frqfile-chr 1000G_Phase3_frq/1000G.EUR.QC.\
        --out ldsc_baseline
```
to generate [ldsc_baseline.results](ldsc_baseline.results) and [ldsc_baseline.log](ldsc_baseline.log) and
```bash
python ldsc.py --h2 ldsc.sumstats.gz\
        --w-ld-chr 1000G_Phase3_weights_hm3_no_MHC/weights.hm3_noMHC.\
        --ref-ld-chr 1000G_Phase3_cell_type_groups/cell_type_group.3.,baseline_v1.1/baseline.\
        --overlap-annot\
        --frqfile-chr 1000G_Phase3_frq/1000G.EUR.QC.\
        --out ldsc_CNS\
        --print-coefficients
```
for [ldsc_baseline.results](ldsc_CNS.results) and [ldsc_baseline.log](ldsc_CNS.log).


## --- Mendelian Randomisation ---

A documented example on BMI-lung cancer is adapted in [software-notes](https://github.com/jinghuazhao/software-notes). We employ the analysis between BMI-T2D from DIAGRAM,
```bash
wget -qO- https://portals.broadinstitute.org/collaboration/giant/images/e/e2/Meta-analysis_Locke_et_al+UKBiobank_2018_top_941_from_COJO_analysis_UPDATED.txt.gz > BMI-COJO.gz
R --no-save -q < MR.R > MR.log
```
and call [MR.R](MR.R) to generate [MR.log](MR.log) and [MR.pdf](MR.pdf).

## --- TWAS ---

We start with `MetaXcan` as follows,
```bash
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
```
where instead of chromosome-specific summary statistics as shown in [software-notes](https://github.com/jinghuazhao/software-notes) we use `ldsc.txt` created above directly with results contained in [MX.csv](MX.csv). The screen output is as follows,
```
INFO - Processing GWAS command line parameters
INFO - Building beta for ldsc.txt and /home/jhz22/D/genetics/hakyimlab/PredictDB/GTEx-V7_HapMap-2017-11-29/gtex_v7_Brain_Amygdala_imputed_europeans_tw_0.5_signif.db
INFO - Reading input gwas with special handling: ldsc.txt
INFO - Processing input gwas
INFO - Successfully parsed input gwas in 4.09205794334 seconds
INFO - Started metaxcan process
INFO - Loading model from: /home/jhz22/D/genetics/hakyimlab/PredictDB/GTEx-V7_HapMap-2017-11-29/gtex_v7_Brain_Amygdala_imputed_europeans_tw_0.5_signif.db
INFO - Loading covariance data from: /home/jhz22/D/genetics/hakyimlab/PredictDB/GTEx-V7_HapMap-2017-11-29/gtex_v7_Brain_Amygdala_imputed_eur_covariances.txt.gz
INFO - Processing input gwas
INFO - Started metaxcan association
INFO - 10 % of model's snps found so far in the gwas study
INFO - 20 % of model's snps found so far in the gwas study
INFO - 30 % of model's snps found so far in the gwas study
INFO - 40 % of model's snps found so far in the gwas study
INFO - 50 % of model's snps found so far in the gwas study
INFO - 60 % of model's snps found so far in the gwas study
INFO - 70 % of model's snps found so far in the gwas study
INFO - 80 % of model's snps found so far in the gwas study
INFO - 80 % of model's snps used
INFO - Sucessfully processed metaxcan association in 28.323292017 seconds
```

## References

Yengo L, et al. Meta-analysis of genome-wide association studies for height and body mass index in ~700,000 individuals of European ancestry. BioRxiv,
https://www.biorxiv.org/content/early/2018/03/02/274654
