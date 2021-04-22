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
listMarts()
mart <- useMart("ENSEMBL_MART_FUNCGEN")
listDatasets(mart)
mart <- useMart("ensembl")
listDatasets(mart)
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

### --- EFO ---

https://www.ebi.ac.uk/efo/

Example code,
```r
library(ontologyIndex)

id <- function(ontology)
{
  inflammatory <- grep(ontology$name,pattern="inflammatory")
  immune <- grep(ontology$name,pattern="immune")
  inf <- union(inflammatory,immune)
  list(id=ontology$id[inf],name=ontology$name[inf])
}
# GO
data(go)
goidname <- id(go)
# EFO
file <- "efo.obo"
get_relation_names(file)
efo <- get_ontology(file, extract_tags="everything")
length(efo) # 89
length(efo$id) # 27962
efoidname <- id(efo)
diseases <- get_descendants(efo,"EFO:0000408")
efo_0000540 <- get_descendants(efo,"EFO:0000540")
efo_0000540name <- efo$name[efo_0000540]
isd <- data.frame(efo_0000540,efo_0000540name)
save(efo,diseases,isd,efoidname,goidname, file="work/efo.rda")
write.table(isd,file="efo_0000540.csv",col.names=FALSE,row.names=FALSE,sep=",")
pdf("efo_0000540.pdf",height=15,width=15)
library(ontologyPlot)
onto_plot(efo,efo_0000540)
dev.off()
```

### --- FUMA GWAS ---

https://fuma.ctglab.nl/ (https://github.com/Kyoko-wtnb/FUMA-webapp/)

### --- GTEx and eQTLGen ---

* https://www.gtexportal.org/home/ ([datasets](https://gtexportal.org/home/datasets))
* http://www.eqtlgen.org/

### --- MetaMapLite ---

https://metamap.nlm.nih.gov/MetaMapLite.shtml

### --- MR-Base/OpenGWAS ---

* http://www.mrbase.org ([MRCIEU demo](https://github.com/MRCIEU/ieu-gwas-db-demo/))
* https://gwas.mrcieu.ac.uk

### --- PredictDB data repository ---

http://predictdb.org/

### --- RegulomeDB ---

http://regulomedb.org/

### --- Roadmap ---

http://www.roadmapepigenomics.org/

### --- TWAS ---

https://github.com/hakyimlab/MetaXcan

http://gusevlab.org/projects/fusion/

### --- eQTL Catalog ---

https://www.ebi.ac.uk/eqtl/

### --- GWAS Catalog ---

https://www.ebi.ac.uk/gwas/

### --- PGS Catalog ---

https://www.pgscatalog.org/

### --- rentrez ---

The relevant URLs are as follows, 

* https://cran.r-project.org/web/packages/rentrez/vignettes/rentrez_tutorial.html
* https://pubmed.ncbi.nlm.nih.gov/
* https://www.ncbi.nlm.nih.gov/pmc/pmctopmid/

with example code,
```r
library(rentrez)
entrez_dbs()
entrez_db_links("pubmed")
pubmed_fields <- entrez_db_searchable("pubmed")
# set_entrez_key("")
Sys.getenv("ENTREZ_KEY")
term <- "pQTLs OR (protein AND quantitative AND trait AND loci) AND human [MH] AND (plasma OR Serum)"
r <- entrez_search(db="pubmed",term=term,use_history=TRUE)
class(r)
names(r)
with(r,web_history)
unlink(paste("pubmed",c("fetch","summary"),sep="."))
fields <- c("uid", "pubdate", "sortfirstauthor", "title", "source", "volume", "pages")
for(i in seq(1,with(r,count),50))
{
  cat(i+49, "records downloaded\r")
  f <- entrez_fetch(db="pubmed", web_history=with(r,web_history), rettype="text", retmax=50, retstart=i)
  write.table(f, col.names=FALSE, row.names=FALSE, file="pubmed.fetch", append=TRUE)
  s <- entrez_summary(db="pubmed", web_history=with(r,web_history), rettype="text", retmax=50, retstart=i)
  e <- extract_from_esummary(s, fields)
  write.table(t(e), col.names=FALSE, row.names=FALSE, file="pubmed.summary", append=TRUE, sep="\t")
}
id <- 600807
upload <- entrez_post(db="omim", id=id)
asthma_variants <- entrez_link(dbfrom="omim", db="clinvar", cmd="neighbor_history", web_history=upload)
asthma_variants
snp_links <- entrez_link(dbfrom="clinvar", db="snp", web_history=asthma_variants$web_histories$omim_clinvar, cmd="neighbor_history")
all_links <- entrez_link(dbfrom='pubmed', id=id, db='all')
```

### --- TWAS-hub ---

http://twas-hub.org/

### --- Biobanks ---

* UK Biobank
  * [AMS](http://amsportal.ukbiobank.ac.uk/) (access@ukbiobank.ac.uk), https://www.ukbiobank.ac.uk/wp-content/uploads/2019/09/Access_019-Access-Management-System-User-Guide-V4.0.pdf.
  * Accessing data guide, http://biobank.ctsu.ox.ac.uk/crystal/exinfo.cgi?src=AccessingData.
  * Imputation, http://biobank.ctsu.ox.ac.uk/crystal/crystal/docs/impute_ukb_v1.pdf.
  * Gene ATLAS, http://geneatlas.roslin.ed.ac.uk/.
  * [PHESANT](https://github.com/MRCIEU/PHESANT).
  * [Showcase User Guide](https://biobank.ctsu.ox.ac.uk/crystal/crystal/exinfo/ShowcaseUserGuide.pdf).
  * [Pan-UK Biobank](https://pan.ukbb.broadinstitute.org/), [GWAS sumstats](http://www.nealelab.is/blog/2019/9/16/biomarkers-gwas-results) and [GitHub](https://github.com/Nealelab/UK_Biobank_GWAS).
  * COVID-19 [data](http://biobank.ndph.ox.ac.uk/ukb/exinfo.cgi?src=COVID19), [format](http://biobank.ndph.ox.ac.uk/ukb/exinfo.cgi?src=COVID19_tests) and [field](http://biobank.ctsu.ox.ac.uk/ukb/field.cgi?id=40100).
* China Kadoorie Biobank
  * https://www.ckbiobank.org/.
* Japan Biobank
  * https://biobankjp.org/
  * https://humandbs.biosciencedbc.jp/en/hum0014-v21

### --- Other links ---

* [NCBI account](https://www.ncbi.nlm.nih.gov/myncbi/) ([settings](https://www.ncbi.nlm.nih.gov/account/settings/)).
* [Institute of Translational Genomics](https://github.com/hmgu-itg) and [omicscience](https://omicscience.org/).
* [SNiPA](https://snipa.helmholtz-muenchen.de/snipa3/).
* [genego](https://portal.genego.com/).
