#!/usr/bin/bash

for f in data-analysis intro-ms wrangle-data eda spectra-analysis chrom machine-learning
do
  pandoc ${f}.html --lua-filter=html.lua -t markdown -o ${f}.Rmd
  sed -i 's/``` {.r/```{r/' ${f}.Rmd
done
