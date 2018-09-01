# CAD/MI

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

## -- Pathway analysis --

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

## -- MR --

We examine MMP-12 and CAD as in the Nature paper, the input data is generated with [MMP12.sh](MMP12.sh).

THe analogous coding for TwoSampleMR as with MendelianRandomization in [software-notes](https://github.com/jinghuazhao/software-notes)
is contained in [MMP12.R](MMP12.R).
