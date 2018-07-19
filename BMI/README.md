# BMI analysis

We work on the latest GIANT+Biiobank data on BMI (Yengo et al. 2018), including both the genomewide
```bash
wget https://portals.broadinstitute.org/collaboration/giant/images/0/0f/Meta-analysis_Locke_et_al+UKBiobank_2018.txt.gz
```
and GCTA --cojo results as used in Mendelian Randomisation analysis downloaded below on the fly. We would refer to [software-notes](https://github.com/jinghuazhao/software-notes) where information specific software can be seen from their respective directories.

## --- Pathway analysis ---

```bash
gunzip -c Meta-analysis_Locke_et_al+UKBiobank_2018.txt.gz | awk '
{
   FS=OFS="\t"
   if(NR==1) print "SNP","Chr","Pos","P"
   else if($9<=5e-8) print $3,$1,$2,$9
}' | gzip -f > BMI.txt.gz

```
where we opt to customise the header/column rather than the DEPICT configuration file. Moreover, the (hg19) chromosomal positions are *eventually* back in the data which would facilitate GCTA --cojo analysis and mirrors https://github.com/jinghuazhao/SUMSTATS.

As usual, we make a call to [BMI.cfg](BMI.cfg) via
```bash
depict.py BMI.cfg
```
where the `DEPICT_v1_rel194.tar.gz` version is used. Once started, there was complaint that
```
Retrieving background loci
Exiting.. To few background files in data/backgrounds/nloci723_nperm500_kb500_rsq0.1_mhc25000000-35000000_colld0.5-collection-1000genomespilot-depict-150429/. Please remove the folder, rerun DEPICT and contact tunepers@broadinstitute.org if the error prevails.
```
Follow instruction and remove the directory. It is very slow-going, ~20 hours on our Linux node but surprisingly half that time under my Windows 10 whose directory zipped and then unzipped under Linux and run`depict.py`there.

We then generate [BMI.xlsx](BMI.xlsx) as in [PW-pipelne](https://github.com/jinghuazhao/PW-pipeline/wiki). While there are 859 genesets with FDR<0.05, tissue enrichment shows compelingly an overwhelming role of the nervous system.

This is detailed from [PW-pipeline/wiki](https://github.com/jinghuazhao/PW-pipeline/wiki) for the analysis.

## --- Partitioned heritabilty ---

Information for the documentation example is available from [software-notes](https://github.com/jinghuazhao/software-notes/). Here we carry on with the .gz file above.
```bash
gunzip -c Meta-analysis_Locke_et_al+UKBiobank_2018.txt.gz > ldsc.txt
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

A documented example on BMI-lung cancer is adapted in [software-notes](https://github.com/jinghuazhao/software-notes) but our focus here is on BMI-T2D from DIAGRAM,
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
where instead of chromosome-specific summary statistics as shown in [software-notes](https://github.com/jinghuazhao/software-notes) we use `ldsc.txt` created above directly with results contained in [MX.csv](MX.csv) and screen output [MX.log](MX.log).

We would also be tempting to contrast results with FUSION,
```bash
gunzip -c Meta-analysis_Locke_et_al+UKBiobank_2018.txt.gz | awk '
{
   FS=OFS="\t"
   if(NR==1) print "SNP","A1","A2","Z"
   else print $3,$4,$5,$7/$8
}' > fusion.txt
for chr in $(seq 22)
do
    Rscript FUSION.assoc_test.R --sumstats fusion.txt \
                                --weight1s WEIGHTS/NTR.BLOOD.RNAARR.pos --weights_dir WEIGHTS/ \
                                --ref_ld_chr LDREF/1000G.EUR. --chr $chr --out fusion.$chr.dat
done
```
Note again the header/column is customised differently from its DEPICT counterpart and results are obtained by chromosome.

Two additional aspects are useful to explore:

### Fine-mapping

In line with the fact that both TWAS and GWAS z scores are available, the option `--caviar` natually put them as input files for `CARIAR`,
```bash
for chr in $(seq 22)
do
Rscript FUSION.assoc_test.R \
--sumstats fusion.txt \
--weights /home/jhz22/D/mrc/genetics/FUSION/GE/CMC.BRAIN.RNASEQ.pos \
--weights_dir /home/jhz22/D/mrc/genetics/FUSION/GE/ \
--ref_ld_chr /home/jhz22/D/genetics/fusion_twas/LDREF/1000G.EUR. \
--chr $chr \
--caviar \
--out caviar
done
```
which are CAVIAR.EQTL.Z, CAVIAR.GWAS.Z, CAVIAR.LD triplets with prefix caviar.genename.

### Colocalisation

This is furnished with `--coloc_P --GWASN`,
```bash
for chr in $(seq 22)
do
Rscript FUSION.assoc_test.R \
--sumstats fusion.txt \
--weights /home/jhz22/D/mrc/genetics/FUSION/GE/CMC.BRAIN.RNASEQ.pos \
--weights_dir /home/jhz22/D/mrc/genetics/FUSION/GE/ \
--ref_ld_chr /home/jhz22/D/genetics/fusion_twas/LDREF/1000G.EUR. \
--chr $chr \
--coloc_P 5e-8 \
--GWASN 70000 \
--out coloc$chr.dat
done
```

### Prediction

See [software-notes](https://github.com/jinghuazhao/software-notes) on the use of `utils/make_score.R`, which is based on the best model.

### Approximately independent LD blocks

We can use these blocks genomewide or a specific gene, e.g., MC4R,
```bash
awk 'NR>1' ldsc.txt | sort -k1,1n -k2,2n | awk '
{
  OFS="\t"
  if (NR==1) print "#chrom", "Start", "End", "SNP", "A1", "A2", "FreqA1", "BETA", "SE", "P", "N"
  print "chr" $1, $2-1, $2, $3, $4, $5, $6, $7, $8, $9, $10
}' > BMI.bed

# EUR.bed is now with FM-pipeline
intersectBed -a BMI.bed -b EUR.bed -loj | cut -f12-14 --complement > BMI.txt

cut -f4,10 BMI.txt > BMI.snpandp
# gene-based association
vegas2v2 -G -snpandp BMI.snpandp -custom $PWD/g1000p3_EUR -glist glist-hg19 -out genes
# pathway-based association
awk '(NR>1){OFS="\t";gsub(/"/,"",$0);print $2,$8}' genes.out > BMI.geneandp
vegas2v2 -P -geneandp BMI.geneandp -glist glist-hg19 -geneandpath biosystems20160324.vegas2pathSYM -out pathways

# grep MC4R glist-hg19 --> 18 58038563 58040001 MC4R
# 1439 bp
# EUR.bed -- > 1563   chr18 57630483 59020751 region1563
# 1390268 bp

awk /region1563/ BMI.txt > MC4R.txt

# wc -l MC4R.txt
# 1342 SNPs

cut -f4,10 MC4R.txt > MC4R.snpandp
echo MC4R > MC4R.genelist
vegas2v2 -G -snpandp MC4R.snpandp -custom $PWD/g1000p3_EUR -glist glist-hg19 -genelist MC4R.genelist -out MC4R
```
The reason to use ldsc.txt is to allow for the possibility of finemapping.

## References

Yengo L, et al. Meta-analysis of genome-wide association studies for height and body mass index in ~700,000 individuals of European ancestry. BioRxiv,
https://www.biorxiv.org/content/early/2018/03/02/274654
