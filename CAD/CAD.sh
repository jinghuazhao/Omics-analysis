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

export INF=/rds/project/jmmh2/rds-jmmh2-projects/olink_proteomics/scallop/INF
echo $INF/INTERVAL/INTERVAL > gsmr_ref_data
echo IL.6 $INF/work/IL.6.ma > gsmr_exposure
echo CAD gsmr_outcome.txt > gsmr_outcome

gcta-1.9 --mbfile gsmr_ref_data --gsmr-file gsmr_exposure gsmr_outcome --gsmr-direction 0 --out gsmr_result

R --no-save -q <<END
  source("http://cnsgenomics.com/software/gcta/static/gsmr_plot.r")
  gsmr_data <- read_gsmr_data("gsmr_result.eff_plot.gz")
  gsmr_summary(gsmr_data)
  plot_gsmr_effect(gsmr_data, "IL.6", "cad", colors()[75])           
END
