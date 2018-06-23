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
```
*********************************************************************
* LD Score Regression (LDSC)
* Version 1.0.0
* (C) 2014-2015 Brendan Bulik-Sullivan and Hilary Finucane
* Broad Institute of MIT and Harvard / MIT Department of Mathematics
* GNU General Public License v3
*********************************************************************
Call: 
./ldsc.py \
--h2 ldsc.sumstats.gz \
--ref-ld-chr baseline_v1.1/baseline. \
--out ldsc_baseline \
--overlap-annot  \
--frqfile-chr 1000G_Phase3_frq/1000G.EUR.QC. \
--w-ld-chr 1000G_Phase3_weights_hm3_no_MHC/weights.hm3_noMHC. 

Beginning analysis at Sat Jun 23 09:44:33 2018
Reading summary statistics from ldsc.sumstats.gz ...
Read summary statistics for 1025112 SNPs.
Reading reference panel LD Score from baseline_v1.1/baseline.[1-22] ...
Read reference panel LD Scores for 1190321 SNPs.
Removing partitioned LD Scores with zero variance.
Reading regression weight LD Score from 1000G_Phase3_weights_hm3_no_MHC/weights.hm3_noMHC.[1-22] ...
Read regression weight LD Scores for 1187349 SNPs.
After merging with reference panel LD, 1016832 SNPs remain.
After merging with regression SNP LD, 1014419 SNPs remain.
Removed 15 SNPs with chi^2 > 795.64 (1014404 SNPs remain)
Total Observed scale h2: 0.1614 (0.0051)
Categories: baseL2_0 Coding_UCSC.bedL2_0 Coding_UCSC.extend.500.bedL2_0 Conserved_LindbladToh.bedL2_0 Conserved_LindbladToh.extend.500.bedL2_0 CTCF_Hoffman.bedL2_0 CTCF_Hoffman.extend.500.bedL2_0 DGF_ENCODE.bedL2_0 DGF_ENCODE.extend.500.bedL2_0 DHS_peaks_Trynka.bedL2_0 DHS_Trynka.bedL2_0 DHS_Trynka.extend.500.bedL2_0 Enhancer_Andersson.bedL2_0 Enhancer_Andersson.extend.500.bedL2_0 Enhancer_Hoffman.bedL2_0 Enhancer_Hoffman.extend.500.bedL2_0 FetalDHS_Trynka.bedL2_0 FetalDHS_Trynka.extend.500.bedL2_0 H3K27ac_Hnisz.bedL2_0 H3K27ac_Hnisz.extend.500.bedL2_0 H3K27ac_PGC2.bedL2_0 H3K27ac_PGC2.extend.500.bedL2_0 H3K4me1_peaks_Trynka.bedL2_0 H3K4me1_Trynka.bedL2_0 H3K4me1_Trynka.extend.500.bedL2_0 H3K4me3_peaks_Trynka.bedL2_0 H3K4me3_Trynka.bedL2_0 H3K4me3_Trynka.extend.500.bedL2_0 H3K9ac_peaks_Trynka.bedL2_0 H3K9ac_Trynka.bedL2_0 H3K9ac_Trynka.extend.500.bedL2_0 Intron_UCSC.bedL2_0 Intron_UCSC.extend.500.bedL2_0 PromoterFlanking_Hoffman.bedL2_0 PromoterFlanking_Hoffman.extend.500.bedL2_0 Promoter_UCSC.bedL2_0 Promoter_UCSC.extend.500.bedL2_0 Repressed_Hoffman.bedL2_0 Repressed_Hoffman.extend.500.bedL2_0 SuperEnhancer_Hnisz.bedL2_0 SuperEnhancer_Hnisz.extend.500.bedL2_0 TFBS_ENCODE.bedL2_0 TFBS_ENCODE.extend.500.bedL2_0 Transcribed_Hoffman.bedL2_0 Transcribed_Hoffman.extend.500.bedL2_0 TSS_Hoffman.bedL2_0 TSS_Hoffman.extend.500.bedL2_0 UTR_3_UCSC.bedL2_0 UTR_3_UCSC.extend.500.bedL2_0 UTR_5_UCSC.bedL2_0 UTR_5_UCSC.extend.500.bedL2_0 WeakEnhancer_Hoffman.bedL2_0 WeakEnhancer_Hoffman.extend.500.bedL2_0
Lambda GC: 2.5641
Mean Chi^2: 3.4336
Intercept: 1.0937 (0.0226)
Ratio: 0.0385 (0.0093)
Reading annot matrix from baseline_v1.1/baseline.[1-22] ...
Results printed to ldsc_baseline.results
Analysis finished at Sat Jun 23 09:46:12 2018
Total time elapsed: 1.0m:39.16s
```
and
```bash
python ldsc.py --h2 ldsc.sumstats.gz\
        --w-ld-chr 1000G_Phase3_weights_hm3_no_MHC/weights.hm3_noMHC.\
        --ref-ld-chr 1000G_Phase3_cell_type_groups/cell_type_group.3.,baseline_v1.1/baseline.\
        --overlap-annot\
        --frqfile-chr 1000G_Phase3_frq/1000G.EUR.QC.\
        --out ldsc_CNS\
        --print-coefficients
```
```
*********************************************************************
* LD Score Regression (LDSC)
* Version 1.0.0
* (C) 2014-2015 Brendan Bulik-Sullivan and Hilary Finucane
* Broad Institute of MIT and Harvard / MIT Department of Mathematics
* GNU General Public License v3
*********************************************************************
Call: 
./ldsc.py \
--h2 ldsc.sumstats.gz \
--ref-ld-chr 1000G_Phase3_cell_type_groups/cell_type_group.3.,baseline_v1.1/baseline. \
--out ldsc_CNS \
--overlap-annot  \
--frqfile-chr 1000G_Phase3_frq/1000G.EUR.QC. \
--w-ld-chr 1000G_Phase3_weights_hm3_no_MHC/weights.hm3_noMHC. \
--print-coefficients  

Beginning analysis at Sat Jun 23 09:46:17 2018
Reading summary statistics from ldsc.sumstats.gz ...
Read summary statistics for 1025112 SNPs.
Reading reference panel LD Score from 1000G_Phase3_cell_type_groups/cell_type_group.3.,baseline_v1.1/baseline.[1-22] ...
Read reference panel LD Scores for 1190321 SNPs.
Removing partitioned LD Scores with zero variance.
Reading regression weight LD Score from 1000G_Phase3_weights_hm3_no_MHC/weights.hm3_noMHC.[1-22] ...
Read regression weight LD Scores for 1187349 SNPs.
After merging with reference panel LD, 1016832 SNPs remain.
After merging with regression SNP LD, 1014419 SNPs remain.
Removed 15 SNPs with chi^2 > 795.64 (1014404 SNPs remain)
Total Observed scale h2: 0.162 (0.0051)
Categories: L2_0 baseL2_1 Coding_UCSC.bedL2_1 Coding_UCSC.extend.500.bedL2_1 Conserved_LindbladToh.bedL2_1 Conserved_LindbladToh.extend.500.bedL2_1 CTCF_Hoffman.bedL2_1 CTCF_Hoffman.extend.500.bedL2_1 DGF_ENCODE.bedL2_1 DGF_ENCODE.extend.500.bedL2_1 DHS_peaks_Trynka.bedL2_1 DHS_Trynka.bedL2_1 DHS_Trynka.extend.500.bedL2_1 Enhancer_Andersson.bedL2_1 Enhancer_Andersson.extend.500.bedL2_1 Enhancer_Hoffman.bedL2_1 Enhancer_Hoffman.extend.500.bedL2_1 FetalDHS_Trynka.bedL2_1 FetalDHS_Trynka.extend.500.bedL2_1 H3K27ac_Hnisz.bedL2_1 H3K27ac_Hnisz.extend.500.bedL2_1 H3K27ac_PGC2.bedL2_1 H3K27ac_PGC2.extend.500.bedL2_1 H3K4me1_peaks_Trynka.bedL2_1 H3K4me1_Trynka.bedL2_1 H3K4me1_Trynka.extend.500.bedL2_1 H3K4me3_peaks_Trynka.bedL2_1 H3K4me3_Trynka.bedL2_1 H3K4me3_Trynka.extend.500.bedL2_1 H3K9ac_peaks_Trynka.bedL2_1 H3K9ac_Trynka.bedL2_1 H3K9ac_Trynka.extend.500.bedL2_1 Intron_UCSC.bedL2_1 Intron_UCSC.extend.500.bedL2_1 PromoterFlanking_Hoffman.bedL2_1 PromoterFlanking_Hoffman.extend.500.bedL2_1 Promoter_UCSC.bedL2_1 Promoter_UCSC.extend.500.bedL2_1 Repressed_Hoffman.bedL2_1 Repressed_Hoffman.extend.500.bedL2_1 SuperEnhancer_Hnisz.bedL2_1 SuperEnhancer_Hnisz.extend.500.bedL2_1 TFBS_ENCODE.bedL2_1 TFBS_ENCODE.extend.500.bedL2_1 Transcribed_Hoffman.bedL2_1 Transcribed_Hoffman.extend.500.bedL2_1 TSS_Hoffman.bedL2_1 TSS_Hoffman.extend.500.bedL2_1 UTR_3_UCSC.bedL2_1 UTR_3_UCSC.extend.500.bedL2_1 UTR_5_UCSC.bedL2_1 UTR_5_UCSC.extend.500.bedL2_1 WeakEnhancer_Hoffman.bedL2_1 WeakEnhancer_Hoffman.extend.500.bedL2_1
Lambda GC: 2.5641
Mean Chi^2: 3.4336
Intercept: 1.0872 (0.0225)
Ratio: 0.0358 (0.0093)
Reading annot matrix from 1000G_Phase3_cell_type_groups/cell_type_group.3.,baseline_v1.1/baseline.[1-22] ...
Results printed to ldsc_CNS.results
Analysis finished at Sat Jun 23 09:48:01 2018
Total time elapsed: 1.0m:43.6s
```

## References

Yengo L, et al. Meta-analysis of genome-wide association studies for height and body mass index in ~700,000 individuals of European ancestry. BioRxiv,
https://www.biorxiv.org/content/early/2018/03/02/274654
