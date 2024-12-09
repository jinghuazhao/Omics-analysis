# 18-12-2019 JHZ

n.designs <- 6
designs <- 1:n.designs
N <- 50 * designs
n.grids <- 100
index <- 1:n.grids
grids <- index / n.grids
MAF <- seq(0.005, n.grids/2, by=0.5) / n.grids
require(powerEQTL)
png("eQTL.png", res=300, height=4.5, width=6, units="in")
plot(MAF,grids,type="n",ylab="Power")
mtext(expression(paste("Power Estimation for eQTL Studies of 240 SNPs (",alpha," = 0.05)")),1,line=4.5)
colors <- hcl.colors(n.designs)
for (design in designs)
{
  power.SLR <- rep(NA,n.grids)
  for (j in index) power.SLR[j] <- powerEQTL.SLR(MAF = MAF[j], typeI = 0.05, nTests = 240, slope = 0.13,
                                                 myntotal = N[design], mystddev = 0.13, verbose = FALSE)
  lines(MAF,power.SLR,col=colors[design])
}
legend("bottomright", inset=.02, title="Sample size (N)", paste(N), col=colors, horiz=FALSE, cex=0.8, lty=designs)
dev.off()

# MAF <- c(0.5, 1.0, 2.0, 5.0, 10.0, 20.0)/100
#  power.ANOVA2 <- rep(NA,n.grids)
#  for (j in index) power.ANOVA2[j] <- powerEQTL.ANOVA2(effsize = 0.8,
#                                                       MAF = MAF[j], typeI = 0.05, nTests = 240,
#                                                       myntotal = N[design], verbose = FALSE)
