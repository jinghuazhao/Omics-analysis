<img src="eQTL/eQTL.png" height="400" width="500" align="right">

## Omics analysis of complex traits

Seeding comprehensive analysis in their named directories (e.g., [BMI](BMI)), the repository links to technical issues documented in [physalia](https://github.com/jinghuazhao/physalia), [Mixed-Models](https://github.com/jinghuazhao/Mixed-Models), [software-notes](https://github.com/jinghuazhao/software-notes) and other sister repositories: 
[SUMSTATS](https://github.com/jinghuazhao/SUMSTATS),
[FM-pipeline](https://github.com/jinghuazhao/FM-pipeline),
[PW-pipeline](https://github.com/jinghuazhao/PW-pipeline),
[hess-pipeline](https://github.com/jinghuazhao/hess-pipeline),
[TWAS-pipeline](https://github.com/jinghuazhao/TWAS-pipeline),
[EWAS-fusion](https://github.com/jinghuazhao/EWAS-fusion).
for fine-mapping, pathway analysis, TWAS, Mendelian randomisation, predictive analytics and other topics as highlighted in the [wiki page](https://github.com/jinghuazhao/Omics-analysis/wiki).

Earlier or broader aspects have been reflected in the following repositories: [Haplotype-Analysis](https://github.com/jinghuazhao/Haplotype-Analysis), [misc](https://github.com/jinghuazhao/misc), [R](https://github.com/jinghuazhao/R).

The figure on the right was produced with [eQTL.R](eQTL/eQTL.R).

## Resources

### --- Annotation ---

The following script gives information on genes from ENSEMBL as well as attributes (columns) that contains `gene`.
```r
library(biomaRt)
ensembl <- useMart("ensembl", dataset="hsapiens_gene_ensembl", host="grch37.ensembl.org", path="/biomart/martservice")
attr <- listAttributes(ensembl)
attr_select <- c('ensembl_gene_id', 'chromosome_name', 'start_position', 'end_position', 'description', 'hgnc_symbol', 'transcription_start_site')
gene <- getBM(attributes = attr_select, mart = ensembl)
filter <- listFilters(ensembl)
searchFilters(mart = ensembl, pattern = "gene")
```
See also [https://sites.google.com/site/jpopgen/wgsa](https://sites.google.com/site/jpopgen/wgsa) for precompiled annotation. Alternatively, 
```r
# GENCODE v19
url <- "ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_19/gencode.v19.chr_patch_hapl_scaff.annotation.gtf.gz"
gtf <- rtracklayer::import(url)
gencode <- as.data.frame(gtf)
```

### --- Linkage disequilibrium ---

LDlink: https://ldlink.nci.nih.gov/?tab=home.

### --- FUMA GWAS ---

https://fuma.ctglab.nl/ (https://github.com/Kyoko-wtnb/FUMA-webapp/)

### --- GTEx and eQTLGen ---

* https://www.gtexportal.org/home/
* http://www.eqtlgen.org/

### --- MR-Base ---

http://www.mrbase.org

### --- PredictDB data repository ---

http://predictdb.org/

### --- RegulomeDB ---

http://regulomedb.org/

### --- Roadmap ---

http://www.roadmapepigenomics.org/

### --- TWAS ---

https://github.com/hakyimlab/MetaXcan

http://gusevlab.org/projects/fusion/

### --- GWAS Catalog ---

https://www.ebi.ac.uk/gwas/

### --- Biobanks ---

* UK Biobank
  * [AMS](http://amsportal.ukbiobank.ac.uk/) (access@ukbiobank.ac.uk), https://www.ukbiobank.ac.uk/wp-content/uploads/2019/09/Access_019-Access-Management-System-User-Guide-V4.0.pdf.
  * Accessing data guide, http://biobank.ctsu.ox.ac.uk/crystal/exinfo.cgi?src=AccessingData.
  * Imputation, http://biobank.ctsu.ox.ac.uk/crystal/crystal/docs/impute_ukb_v1.pdf.
  * [PHESANT](https://github.com/MRCIEU/PHESANT).
  * [Showcase User Guide](http://biobank.ctsu.ox.ac.uk/~bbdatan/ShowcaseUserGuide.pdf).
  * [GWAS sumstats](http://www.nealelab.is/blog/2019/9/16/biomarkers-gwas-results) and [GitHub](https://github.com/Nealelab/UK_Biobank_GWAS).
  * COVID-19 [data](http://biobank.ndph.ox.ac.uk/ukb/exinfo.cgi?src=COVID19), [format](http://biobank.ndph.ox.ac.uk/ukb/exinfo.cgi?src=COVID19_tests) and [field](http://biobank.ctsu.ox.ac.uk/ukb/field.cgi?id=40100).
* China Kadoorie Biobank
  * https://www.ckbiobank.org/.

### --- Other links ---

* [NCBI account](https://www.ncbi.nlm.nih.gov/myncbi/) ([settings](https://www.ncbi.nlm.nih.gov/account/settings/)).
* [Institute of Translational Genomics](https://github.com/hmgu-itg).
* [SNiPA](https://snipa.helmholtz-muenchen.de/snipa3/).
* [genego](https://portal.genego.com/).
