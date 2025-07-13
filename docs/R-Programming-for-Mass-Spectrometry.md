# R Programming for Mass Spectrometry[^ref]

## Data download instructions

The supplement is in .html for each chapter but it is more useful to convert to markdown, and it is handy to run from a
Linux terminal than otherwise nevertheless the markdown format renders can be rendered as follows,

```bash
for f in data-analysis intro-ms wrangle-data eda spectra-analysis chrom machine-learning
do
  export f=${f}
  pandoc ${f}.html --lua-filter=html.lua -t markdown -o ${f}.Rmd
  sed -i 's/``` {.r/```{r/' ${f}.Rmd
  Rscript -e 'f=Sys.getenv("f");rmarkdown::render(paste0(f,".Rmd"),output_dir="output"))'
done
```

with [html.lua](R-Programming-for-Mass-Spectrometry/html.lua). For instance, in order to run through the R code,

1. **data-analysis.Rmd** requires caution over Bash code blocks Rscript hello.R and R CMD BATCH hello.R, and a not-R code block.
2. **intro-ms.Rmd** needs c("tidyverse").
3. **wrangle-data.Rmd** requires c("tidyverse") and "tandem_result/" created by X!Tandem (tandem.sh, input.xml, default_input.xml, taxonomy.xml) shown [here](https://github.com/jinghuazhao/Omics-analysis/tree/master/docs/R-Programming-for-Mass-Spectrometry) following <ftp://ftp.thegpm.org/projects/tandem/source/>.
4. **eda.Rmd** requires c("Spectra").
5. **spectra-analysis.Rmd** needs c("tidyverse", "Spectra", "infer", "xml2", "mzID", "MSnbase") as with `inten_label` and `pal`.
6. **chrom.Rmd** needs c("tidyverse", "baseline", "signal", "EnvStats", "MassSpecWavelet", "MSnbase", "xcms", "latex2exp", "ggpubr", "fda.usc") as with `inten_label` and `pal`.
7. **machine-learning.Rmd** requires c("tidymodels", "tidyverse", "visdat", "ggfortify", "factoextra", "colino", "heatmaply", "Spectra").

`inten_label` and `pal` are from **intro-ms.Rmd** and **data-analysis.Rmd**, respectively. Batch load of packages can be done, e.g., pkgs <- c("tidyverse", "Spectra", "infer", "mzID", "MSnbase"); lapply(pkgs,library,character.only = TRUE).

**large-data/mona/** (Chapter 7)

[MoNA-export-LC-MS-MS_Positive_Mode.msp](https://mona.fiehnlab.ucdavis.edu/rest/downloads/retrieve/873fbe29-4808-46d1-a4a3-a4134ac8c755)

**MTBLS4938** (Chapter 7)

- [NIAID](https://data.niaid.nih.gov/resources?id=mtbls4938)
- [MetaboLights](https://www.ebi.ac.uk/metabolights/MTBLS4938)

**large-data/MSV000081318/MSV000086195**

We start with wget

```bash
wget -r -nH --cut-dirs=2 -R "index.html*" ftp://massive-ftp.ucsd.edu/v01/MSV000081318/
wget -r -nH --cut-dirs=1 -R "index.html*" ftp://massive-ftp.ucsd.edu/v03/MSV000086195/
```

Directory listing including file transfer can also be done with

```bash
ftp massive-ftp.ucsd.edu <<EOF
anonymous
ls
cd z01/MSV000086195/ccms_peak/
prompt
mget *
EOF
```

where `anonymous` is the user name, or preferably by lftp,

```bash
lftp massive-ftp.ucsd.edu <<EOF
mirror --parallel=10 --verbose /v03/MSV000086195 ./MSV000086195
bye
EOF
# to resume
lftp -e "mirror --continue --parallel=4 /z01/MSV000086195/ccms_peak/ ccms_peak/; quit" \
      ftp://massive-ftp.ucsd.edu
```

`ScltlMsclsMAvsCntr_Batch1_BRPhsFr5_prof.mzML` in Chapters 4 & 5 is made with MSConvert (6GB!) or ThermoRawFileParser/1.4.4 (6.2GB with -p but 750MB without) as in [mzML.sh](R-Programming-for-Mass-Spectrometry/mzML.sh) following exercises in the Caprion project.

**schema/** (Chapter 3):

- [mzIdentML1.1.0.xsd](https://raw.githubusercontent.com/HUPO-PSI/mzIdentML/refs/heads/master/schema/mzIdentML1.1.0.xsd)
- [Skyline_3.73.xsd](https://raw.githubusercontent.com/ProteoWizard/pwiz/refs/heads/master/pwiz_tools/Skyline/TestUtil/Schemas/Skyline_3.73.xsd)

[^ref]: **Julian RK (2025). R Programming for Mass Spectrometry: Effective and Reproducible Data Analysis. ISBN: 978-1-119-87235-1.**
