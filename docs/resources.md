# Resources

## Annotation

[The Ensembl public MySQL Servers](https://www.ensembl.org/info/data/mysql.html)

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

## Biobanks

* China Kadoorie Biobank
    * <https://www.ckbiobank.org/>
    * <https://pheweb.ckbiobank.org/>
* Estonian Biobank
    * <https://genomics.ut.ee/en/>
* FinGenn
    * <https://www.finngen.fi/en>
* Japan Biobank
    * <https://biobankjp.org/>
    * <https://humandbs.biosciencedbc.jp/en/hum0014-v21>
* UK Biobank
    * [AMS](https://ams.ukbiobank.ac.uk/ams/) (<mailto:access@ukbiobank.ac.uk>), [Access_019-Access-Management-System-User-Guide-V4.0.pdf](https://www.ukbiobank.ac.uk/wp-content/uploads/2019/09/Access_019-Access-Management-System-User-Guide-V4.0.pdf), [messages](https://bbams.ndph.ox.ac.uk/ams/resMessages).
    * Accessing data guide, <http://biobank.ctsu.ox.ac.uk/crystal/exinfo.cgi?src=AccessingData>.
    * Allele frequency browser, <https://afb.ukbiobank.ac.uk/>.
    * AstraZeneca PheWAS Portal, <https://azphewas.com/> ([CGR Proteogenomics Portal](https://astrazeneca-cgr-publications.github.io/pqtl-browser/)).
    * Data access guide 3.2, <https://biobank.ndph.ox.ac.uk/~bbdatan/Data_Access_Guide_v3.2.pdf>.
    * DNAnexus, [GitHub](https://github.com/dnanexus), [landing](https://ukbiobank.dnanexus.com/landing), [partnerships](https://www.dnanexus.com/partnerships/ukbiobank)
    * Evoker, <https://www.sanger.ac.uk/tool/evoker/>.
    * Genetic correlation between traits and disorders, <https://ukbb-rg.hail.is/>.1;5C
    * Imputation, <http://biobank.ctsu.ox.ac.uk/crystal/crystal/docs/impute_ukb_v1.pdf>.
    * Gene ATLAS, <http://geneatlas.roslin.ed.ac.uk/>.
    * [genebass](https://genebass.org/).
    * UKB-Biobank, <https://github.com/UK-Biobank> ([ukbrapR](https://github.com/lcpilling/ukbrapR), [ukbnmr](https://cran.r-project.org/package=ukbnmr))
    * [PHESANT](https://github.com/MRCIEU/PHESANT).
    * Online showcase, <https://biobank.ndph.ox.ac.uk/ukb/> ([Showcase User Guide](https://biobank.ctsu.ox.ac.uk/crystal/crystal/exinfo/ShowcaseUserGuide.pdf)).
    * [Pan-UK Biobank](https://pan.ukbb.broadinstitute.org/), [GWAS sumstats](http://www.nealelab.is/blog/2019/9/16/biomarkers-gwas-results) and [GitHub](https://github.com/Nealelab/UK_Biobank_GWAS).
    * COVID-19 [data](http://biobank.ndph.ox.ac.uk/ukb/exinfo.cgi?src=COVID19), [format](http://biobank.ndph.ox.ac.uk/ukb/exinfo.cgi?src=COVID19_tests) and [field](http://biobank.ctsu.ox.ac.uk/ukb/field.cgi?id=40100).

## Catalog

- eQTL Catalog, <https://www.ebi.ac.uk/eqtl/>
- GWAS Catalog, <https://www.ebi.ac.uk/gwas/>
- PheWAS Catalog, <https://phewascatalog.org/>

## EFO

<https://www.ebi.ac.uk/efo/>

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

## eQTLGen

<http://www.eqtlgen.org/>

## MetaMapLite

<https://metamap.nlm.nih.gov/MetaMapLite.shtml>

## MR-Base/OpenGWAS

* <http://www.mrbase.org> ([MRCIEU demo](https://github.com/MRCIEU/ieu-gwas-db-demo/))
* <https://gwas.mrcieu.ac.uk>

## OpenTargets

These reflects v4 using GraphQL, <https://platform-docs.opentargets.org/data-access/graphql-api>.

Our first example is from the document (except ENSG00000164308) whose output is as `ERAP2.json`.

```bash
#!/usr/bin/bash

# https://platform.opentargets.org/api

module load ceuadmin/R
Rscript -e '
  ERAP2 <- subset(pQTLdata::caprion,Gene=="ERAP2")
  ERAP2$ensGenes
  data <- jsonlite::fromJSON("ERAP2.json")
  diseases_data <- data$data$target$associatedDiseases$rows
  diseases_data <- tidyr::unnest(diseases_data, cols = everything(), names_sep = "_")
  write.table(diseases_data, file = "ERAP2.tsv", sep = "\t", row.names = FALSE, quote = FALSE)
'
```

In fact it is effectively done as follows,

```r
library(httr)
library(jsonlite)
gene_id <- "ENSG00000164308"
query_string <- "
  query target($ensemblId: String!){
    target(ensemblId: $ensemblId){
      id
      approvedSymbol
      associatedDiseases {
        count
        rows {
          disease {
            id
            name
          }
          datasourceScores {
            id
            score
          }
        }
      }
    }
  }
"
base_url <- "https://api.platform.opentargets.org/api/v4/graphql"
variables <- list("ensemblId" = gene_id)
post_body <- list(query = query_string, variables = variables)
r <- httr::POST(url = base_url, body = post_body, encode = 'json')
if (status_code(r) == 200) {
  data <- iconv(r, "", "ASCII")
  content <- jsonlite::fromJSON(data)
} else {
  print(paste("Request failed with status code", status_code(r)))
}
# Step 1: Access the nested data
target <- content$data$target

# Step 2: Extract scalar fields
scalar_fields <- data.frame(
  Field = c("ID", "Approved Symbol", "Biotype"),
  Value = c(target$id, target$approvedSymbol, target$biotype)
)

# Step 3: Generate a table for scalar fields
cat("### Scalar Fields\n")
knitr::kable(scalar_fields, caption = "Basic Information")

# Step 4: Generate a table for geneticConstraint
cat("\n### Genetic Constraint\n")
knitr::kable(target$geneticConstraint, caption = "Genetic Constraint Metrics")

# Step 5: Generate a table for tractability
cat("\n### Tractability\n")
knitr::kable(target$tractability, caption = "Tractability Information")
```

where `jsonlite::fromJSON(content(r,"text"))` is also possible when R is nicely compiled with libiconv.

A Bash implementation is copied here

```bash
curl 'https://api.platform.opentargets.org/api/v4/graphql' \
     -H 'Accept-Encoding: gzip, deflate, br' \
     -H 'Content-Type: application/json' \
     -H 'Accept: application/json' \
     -H 'Connection: keep-alive' \
     -H 'DNT: 1' \
     -H 'Origin: https://api.platform.opentargets.org' \
     --data-binary '{"query":"query targetInfo {\n  target(ensemblId: \"ENSG00000164308\") {\n    id\n    approvedSymbol\n    biotype\n    geneticConstraint {\n      constraintType\n      exp\n      obs\n      score\n      oe\n      oeLower\n      oeUpper\n    }\n    tractability {\n      label\n      modality\n      value\n    }\n  }\n}\n"}' \
     --compressed
```

The Python script can be used directly without change

```python3
import requests
import json

gene_id = "ENSG00000164308"
query_string = """
  query target($ensemblId: String!){
    target(ensemblId: $ensemblId){
      id
      approvedSymbol
      biotype
      geneticConstraint {
        constraintType
        exp
        obs
        score
        oe
        oeLower
        oeUpper
      }
      tractability {
        label
        modality
        value
      }
    }
  }
"""
variables = {"ensemblId": gene_id}
base_url = "https://api.platform.opentargets.org/api/v4/graphql"
r = requests.post(base_url, json={"query": query_string, "variables": variables})
print(r.status_code)
api_response = json.loads(r.text)
print(api_response)
```

Lastly we turn to R, which again gets around `httr::content(r)` for `iconvlist()` with `iconv()`.

```r
library(httr)
library(jsonlite)

gene_id <- "ENSG00000164308"
query_string = "
  query target($ensemblId: String!){
    target(ensemblId: $ensemblId){
      id
      approvedSymbol
      biotype
      geneticConstraint {
        constraintType
        exp
        obs
        score
        oe
        oeLower
        oeUpper
      }
      tractability {
        label
        modality
        value
      }
    }
  }
"
base_url <- "https://api.platform.opentargets.org/api/v4/graphql"
variables <- list("ensemblId" = gene_id)
post_body <- list(query = query_string, variables = variables)
r <- httr::POST(url=base_url, body=post_body, encode='json')
data <- iconv(r, "", "ASCII")
content <- jsonlite::fromJSON(data)
```

## rentrez

The relevant URLs are as follows, 

* <https://cran.r-project.org/web/packages/rentrez/vignettes/rentrez_tutorial.html>
* <https://pubmed.ncbi.nlm.nih.gov/>
* <https://www.ncbi.nlm.nih.gov/pmc/pmctopmid/>

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

## Roadmap

<http://www.roadmapepigenomics.org/>

## snakemake workflow catalogue

<https://snakemake.github.io/snakemake-workflow-catalog/>

## TWAS

- MetaXcan, <https://github.com/hakyimlab/MetaXcan>
- FUSION, <http://gusevlab.org/projects/fusion/>
- OmicsPred, <https://www.omicspred.org/>
- PredictDB data repository, <http://predictdb.org/>
- TWAS-hub, <http://twas-hub.org/>

## Other links

* [CALIBER](https://www.ucl.ac.uk/health-informatics/caliber).
* deCode [summary statistics](https://www.decode.com/summarydata/)
* [Galaxy Europe](https://usegalaxy.eu/)
* [Genome in a Bottle WGS samples](https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/data/)
* [genego](https://portal.genego.com/).
* MVP GWAS summary statistics, <https://ftp.ncbi.nlm.nih.gov/dbgap/studies/phs002453/analyses/>.
* [The Australian e-Health Research Centre](https://github.com/aehrc).
* [Institute of Translational Genomics](https://github.com/hmgu-itg) and [omicscience](https://omicscience.org/).
* [idep](http://bioinformatics.sdstate.edu/idep/)
* [NCBI account](https://www.ncbi.nlm.nih.gov/myncbi/) ([settings](https://www.ncbi.nlm.nih.gov/account/settings/)).
