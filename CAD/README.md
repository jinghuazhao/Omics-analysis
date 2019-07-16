# CAD/MI

---
* [MR](https://github.com/jinghuazhao/Omics-analysis/tree/master/CAD#mr)
* [Pathway analysis](https://github.com/jinghuazhao/Omics-analysis/tree/master/CAD#pathway-analysis)
---

The summary statistics is from http://www.cardiogramplusc4d.org/, notably
* [CARDIoGRAM GWA meta-analysis](http://www.cardiogramplusc4d.org/media/cardiogramplusc4d-consortium/data-downloads/cardiogram_gwas_results.zip)

> Schunkert H, König IR, Kathiresan S, Reilly MP, Assimes TL, Holm H et al. Large-scale association analysis identifies 13 new susceptibility loci for coronary artery disease. Nat Genet. 2011 43: 333-338

* [CARDIoGRAMplusC4D 1000 Genomes-based GWAS](http://www.cardiogramplusc4d.org/media/cardiogramplusc4d-consortium/data-downloads/cad.additive.Oct2015.pub.zip)

> Nikpey M, Goel A, Won H, Hall LM, Willenborg C, Kanoni S, Saleheen S, et al. A comprehensive 1000 Genomes–based genome-wide association meta-analysis of coronary artery disease. Nat Genet 2015 47:1121-1130

* [UKBB.GWAS1KG.EXOME.CAD.SOFT.META.PublicRelease.300517](http://www.cardiogramplusc4d.org/media/cardiogramplusc4d-consortium/data-downloads/UKBB.GWAS1KG.EXOME.CAD.SOFT.META.PublicRelease.300517.txt.gz)

> Nelson CP, Goel A, Butterworth AS, Kanoni S, Webb TR, et al. Association analyses based on false discovery rate implicate new loci for coronary artery disease. Nat Genet 2017 Jul 17 49(9): 1385-1391. doi: 10.1038/ng.3913

For the CARDIoGRAMplusC4D 1000 Genomes-based GWAS, the setup is
```bash
wget http://www.cardiogramplusc4d.org/media/cardiogramplusc4d-consortium/data-downloads/cad.additive.Oct2015.pub.zip
unzip cad.additive.Oct2015.pub.zip
```
giving `cad.add.160614.website.txt.

## MR

We examine MMP-12 and CAD as in the Nature paper, the input data is generated with [MMP12.sh](MMP12.sh).

THe analogous coding for TwoSampleMR as with MendelianRandomization in [software-notes](https://github.com/jinghuazhao/software-notes)
is contained in [MMP12.R](MMP12.R).

We could also follow Generalised Summary-data-based Mendelian Randomisation ([GSMR](http://cnsgenomics.com/software/gcta/#Mendelianrandomisation)).
```bash
# 16-7-2019 JHZ

awk '
{
   if (NR==1) print "SNP", "A1", "A2", "freq", "b", "se", "p", "N";
   else {
     CHR=$2
     POS=$3
     a1=$4
     a2=$5
     if (a1>a2) snpid="chr" CHR ":" POS "_" a2 "_" a1;
     else snpid="chr" CHR ":" POS "_" a1 "_" a2
     $1=snpid
     print snpid, a1, a2, $6, $9, $10, $11, 185000
   }
}' CAD/cad.add.160614.website.txt > gsmr_outcome.txt

# awk 'NR==1' CAD/cad.add.160614.website.txt | sed 's|\t|\n|g' | awk '{print "# " NR, $1}'
# 1 markername
# 2 chr
# 3 bp_hg19
# 4 effect_allele
# 5 noneffect_allele
# 6 effect_allele_freq
# 7 median_info
# 8 model
# 9 beta
# 10 se_dgc
# 11 p_dgc
# 12 het_pvalue
# 13 n_studies

xport INF=/rds/project/jmmh2/rds-jmmh2-projects/olink_proteomics/scallop/INF
echo $INF/INTERVAL/INTERVAL > gsmr_ref_data
echo IL.6 $INF/work/IL.6.ma > gsmr_exposure
echo CAD gsmr_outcome.txt > gsmr_outcome

gcta-1.9 --mbfile gsmr_ref_data --gsmr-file gsmr_exposure gsmr_outcome --gsmr-direction 0 --effect-plot --out gsmr_result

R --no-save -q <<END
  source("http://cnsgenomics.com/software/gcta/static/gsmr_plot.r")
  gsmr_data <- read_gsmr_data("gsmr_result.eff_plot.gz")
  gsmr_summary(gsmr_data)
  plot_gsmr_effect(gsmr_data, "IL.6", "cad", colors()[75])
END
```
where we use IL.6 as exposure data; the effect-size plots are generated.

Note that `gcta-1.9` indcates GCTA 1.9.x is necessary since the `--mfile` option is not recognised by GCTA 1.26.0.

## Pathway analysis

MAGMA is illustrated here,

The GWAS summary data can either be formatted with R,
```r
R --no-save <<END
d <- read.delim("`cad.add.160614.website.txt",as.is=TRUE)
db <- "CAD"
write.table(d[c("SNP","CHR","BP")],file=paste0(db,".snploc"),quote=FALSE,row.name=FALSE,col.names=FALSE,sep="\t")
write.table(d[c("SNP","P","NOBS")],file=paste0(db,".pval"),quote=FALSE,row.name=FALSE,sep="\t")
END
```
or more efficiently with bash before pathway analysis
```bash
awk -vOFS="\t" '{print $2,$1,$4}' g1000_eur.bim > g1000_eur.snploc
awk -vOFS="\t" '{if(NR==1) print "SNP", "P", "NOBS"; else print $1,$11,1000}' `cad.add.160614.website.txt > CAD.pval

# Annotation
magma --annotate window=50,50 --snp-loc g1000_eur.snploc --gene-loc NCBI37.3.gene.loc --out CAD
# Gene analysis - SNP p-values
magma --bfile g1000_eur --pval CAD.pval ncol=NOBS --gene-annot CAD.genes.annot --out CAD
# Pathway analysis
# http://software.broadinstitute.org/gsea/downloads.jsp
magma --gene-results CAD.genes.raw --set-annot msigdb.v6.2.entrez.gmt self-contained --model fwer --out CAD
```
