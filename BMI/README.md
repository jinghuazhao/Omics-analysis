# BMI analysis

We work on the latest GIANT+Biiobank data on BMI (Yengo et al. 2018).

## --- Pathway analysis ---

```bash
wget https://portals.broadinstitute.org/collaboration/giant/images/0/0f/Meta-analysis_Locke_et_al%2BUKBiobank_2018.txt.gz
gunzip -c Meta-analysis_Locke_et_al+UKBiobank_2018.txt.gz | awk '
{
   FS=OFS="\t"
   if(NR==1) print "SNP","Chr","Pos","P"
   else if($9<=5e-8) print $3,$1,$2,$9
}' | gzip -f > BMI.txt.gz

```
where we opt to customise the header rather than the DEPICT configuration file. Moreover, the (hg19) chromosomal positions are *eventually* back in the data which would facilitate GCTA-COJO analysis and mirrors [SUMSTATS](https://github.com/jinghuazhao/SUMSTATS).

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
where we fix the header with appropriate command-line parameters. We see that
```
*********************************************************************
* LD Score Regression (LDSC)
* Version 1.0.0
* (C) 2014-2015 Brendan Bulik-Sullivan and Hilary Finucane
* Broad Institute of MIT and Harvard / MIT Department of Mathematics
* GNU General Public License v3
*********************************************************************
Call: 
./munge_sumstats.py \
--out ldsc \
--merge-alleles w_hm3.snplist \
--a1-inc  \
--a1 Tested_Allele \
--a2 Other_allele \
--sumstats ldsc.txt 

Interpreting column names as follows:
P:	p-Value
Other_Allele:	Allele 2, interpreted as non-ref allele for signed sumstat.
Tested_Allele:	Allele 1, interpreted as ref allele for signed sumstat.
SNP:	Variant ID (e.g., rs number)
N:	Sample size

Reading list of SNPs for allele merge from w_hm3.snplist
Read 1217311 SNPs for allele merge.
Reading sumstats from ldsc.txt into memory 5000000 SNPs at a time.


.WARNING: 1 SNPs had P outside of (0,1]. The P column may be mislabeled.
 done
Read 2348397 SNPs from --sumstats file.
Removed 1323282 SNPs not in --merge-alleles.
Removed 0 SNPs with missing values.
Removed 0 SNPs with INFO <= 0.9.
Removed 0 SNPs with MAF <= 0.01.
Removed 1 SNPs with out-of-bounds p-values.
Removed 0 variants that were not SNPs or were strand-ambiguous.
1025114 SNPs remain.
Removed 2 SNPs with duplicated rs numbers (1025112 SNPs remain).
Removed 0 SNPs with N < 461633.333333 (1025112 SNPs remain).
Removed 0 SNPs whose alleles did not match --merge-alleles (1025112 SNPs remain).
Writing summary statistics for 1217311 SNPs (1025112 with nonmissing beta) to ldsc.sumstats.gz.

Metadata:
Mean chi^2 = 3.465
Lambda GC = 2.566
Max chi^2 = 1416.756
13191 Genome-wide significant SNPs (some may have been removed by filtering).

Conversion finished at Sat Jun 23 00:46:44 2018
Total time elapsed: 8.0h:23.0m:47.25s
```
and we carry on with
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

## References

Yengo L, et al. Meta-analysis of genome-wide association studies for height and body mass index in ~700,000 individuals of European ancestry. BioRxiv,
https://www.biorxiv.org/content/early/2018/03/02/274654
