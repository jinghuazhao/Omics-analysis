# BMI analysis

We work on the latest GIANT+Biiobank data on BMI (Yengo et al. 2018).

## --- Pathway analysis ---

```bash
wget https://portals.broadinstitute.org/collaboration/giant/images/0/0f/Meta-analysis_Locke_et_al+UKBiobank_2018.txt.gz
gunzip -c Meta-analysis_Locke_et_al+UKBiobank_2018.txt.gz | awk '
{
   FS=OFS="\t"
   if(NR==1) print "SNP","Chr","Pos","P"
   else if($9<=5e-8) print $3,$1,$2,$9
}' | gzip -f > BMI.txt.gz

```
where we opt to customise the header rather than the DEPICT configuration file. Moreover, the (hg19) chromosomal positions are *eventually* back in the data which would facilitate GCTA-COJO analysis and mirrors https://github.com/jinghuazhao/SUMSTATS.

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

We employ the analysis between BMI-T2D from DIAGRAM,
```bash
wget -qO- https://portals.broadinstitute.org/collaboration/giant/images/e/e2/Meta-analysis_Locke_et_al+UKBiobank_2018_top_941_from_COJO_analysis_UPDATED.txt.gz > BMI-COJO.gz
R --vanilla -q <<END
gz <- gzfile("BMI-COJO.gz")
d <- read.delim(gz,as.is=TRUE)
library(TwoSampleMR)
exposure_dat <- format_data(d, type="exposure", snp_col = "SNP", effect_allele_col = "Tested_Allele", other_allele_col = "Other_Allele",
                            eaf_col = "Freq_Tested_Allele_in_HRS", beta_col = "BETA_COJO", se_col = "SE_COJO", pval_col = "P_COJO", samplesize_col = "N")
ao <- available_outcomes()
subset(ao,consortium=="DIAGRAM")
outcome_dat <- extract_outcome_data(exposure_dat$SNP, 23, proxies = 1, rsq = 0.8, align_alleles = 1, palindromes = 1, maf_threshold = 0.3)
dat <- harmonise_data(exposure_dat, outcome_dat, action = 2)
mr_results <- mr(dat)
mr_heterogeneity(dat)
mr_pleiotropy_test(dat)
res_single <- mr_singlesnp(dat)
mr_leaveoneout(dat)
pdf("MR.pdf")
mr_scatter_plot(mr_results, dat)
mr_forest_plot(res_single)
mr_leaveoneout_plot(res_loo)
mr_funnel_plot(res_single)

library(MendelianRandomization)
MRInputObject <- with(dat, mr_input(bx = beta.exposure, bxse = se.exposure, by = beta.outcome, byse = se.outcome,
                                    exposure = "Body mass index", outcome = "T2D", snps = SNP))
mr_ivw(MRInputObject, model = "default", robust = FALSE, penalized = FALSE, weights = "simple", distribution = "normal", alpha = 0.05)
mr_egger(MRInputObject, robust = FALSE, penalized = FALSE, distribution = "normal", alpha = 0.05)
mr_maxlik(MRInputObject, model = "default", distribution = "normal", alpha = 0.05)
mr_median(MRInputObject, weighting = "weighted", distribution = "normal", alpha = 0.05, iterations = 10000, seed = 314159265)
mr_allmethods(MRInputObject, method = "all")
mr_plot(MRInputObject, error = TRUE, orientate = FALSE, interactive = TRUE, labels = TRUE, line = "ivw")
dev.off()
END
```
where both `TwoSampleMR` and `MendelianRandomization` packages are used.

## --- TWAS ---

## References

Yengo L, et al. Meta-analysis of genome-wide association studies for height and body mass index in ~700,000 individuals of European ancestry. BioRxiv,
https://www.biorxiv.org/content/early/2018/03/02/274654
