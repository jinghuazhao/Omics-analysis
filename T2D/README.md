# T2D

The diagram summary statistics used in the BMI-T2D analysis is available from http://www.diagram-consortium.org/downloads.html. It is necessary to check the box in front of "I agree with the terms above." to download the file, `TransEthnic_T2D_GWAS.MegaMeta.2014OCT16.zip`, so
```bash
unzip  TransEthnic_T2D_GWAS.MegaMeta.2014OCT16.zip 
```
gives `diagram.mega-meta.txt`.

## --- Pathway analysis ---

As before we prepare for DEPICT file,
```bash
awk '{
  OFS="\t"
  if(NR==1) print "SNP","Chr","Pos","P"
  else print $1,$2,$3,$9
}' diagram.mega-meta.txt | gzip -f > T2D.txt.gz

```
and [T2D.cfg](T2D.cfg) slightly changed from its BMI counterpart.

## --- mtCOJO analysis ---

For this analysis, a most up-to-date version of GCTA is required. To imitate the documentation script, we regenerate the `bmi_test.raw` as follows
```bash
gunzip -c /home/jhz22/D/genetics/broad/ftp/Meta-analysis_Locke_et_al+UKBiobank_2018.txt.gz | \
awk '{OFS="\t"; if(NR==1) {print "SNP","A1","A2","freq","b","se","p","N"} else print $3,$4,$5,$6,$7,$8,$9,$10}' | \
uniq > bmi_test.raw
```
which uses `uniq` to remove duplicate lines. As for T2D,
```bash
awk '
   function f(x) {return exp(x)/(1+exp(x))}
   {
     if (NR==1) print "SNP","A1","A2","freq","b","se","p","N"
     print $1,$4,$5,rand(),f($6),(f($8)-f($7))/2,$9,$10
   }
' /home/jhz22/D/genetics/ldsc/diagram.mega-meta.txt > t2d_test.raw
```
Since the summary statistics does not contain effect allele frequencies and we assign a random variable to run through.

Now we download and unpack the LD scores,
```bash
wget -qO- https://data.broadinstitute.org/alkesgroup/LDSCORE/eur_ref_ld_chr.tar.bz2 | tar xfvz -
wget -qO- https://data.broadinstitute.org/alkesgroup/LDSCORE/eur_w_ld_chr.tar.bz2 | tar xvfz -
```
from https://data.broadinstitute.org/alkesgroup/LDSCORE/.

At last we could trick GCTA with [test_data.zip](http://cnsgenomics.com/software/gsmr/static/test_data.zip)
```bash
wget http://cnsgenomics.com/software/gsmr/static/test_data.zip
unzip test_data
echo gsmr_example > mtcojo_ref_data.txt
echo -e "t2d t2d_test.raw 0.176306984 0.09\nbmi bmi_test.raw" > mtcojo_summary_data.list
gcta64 --mbfile mtcojo_ref_data.txt --mtcojo-file mtcojo_summary_data.list --ref-ld-chr eur_w_ld_chr/ --w-ld-chr eur_w_ld_chr/ --out test_mtcojo_result
```
which proceeds with no complaints thouugh the results won't be sensible in this case.
