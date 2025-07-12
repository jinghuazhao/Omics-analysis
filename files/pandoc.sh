#!/usr/bin/bash

for f in $(ls *.md | sed 's/.md//')
do
  pandoc ${f}.md --lua-filter=div2rchunk.lua -t markdown -o ${f}.Rmd
  sed -i 's/``` {.r/```{r/' ${f}.Rmd
done
