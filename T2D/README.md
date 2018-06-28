# T2D analysis

The diagram summary statistics used in the BMI-T2D analysis is available from http://www.diagram-consortium.org/downloads.html. It is necessary to check the box in front of "I agree with the terms above." to download the file, `TransEthnic_T2D_GWAS.MegaMeta.2014OCT16.zip`, so
```bash
unzip  TransEthnic_T2D_GWAS.MegaMeta.2014OCT16.zip 
```
gives `diagram.mega-meta.txt`.

### Pathway analysis

As before we prepare for DEPICT file,
```bash
awk '{
  OFS="\t"
  if(NR==1) print "SNP","Chr","Pos","P"
  else print $1,$2,$3,$9
}' diagram.mega-meta.txt | gzip -f > T2D.txt.gz

```
and [T2D.cfg](T2D.cfg) slightly changed from its BMI counterpart.
