# 18-1-2025 JHZ

n.designs <- 6
designs <- 1:n.designs
N <- 50 * designs
n.grids <- 100
index <- 1:n.grids
grids <- index / n.grids
MAF <- seq(0.005, n.grids/2, by=0.5) / n.grids
plot(MAF,grids,type="n",ylab="Power")
mtext(expression(paste("(",alpha," = 0.05)")),1,line=4.5)
colors <- grDevices::hcl.colors(n.designs)
for (design in designs)
{
  power.SLR <- rep(NA,n.grids)
  for (j in index) power.SLR[j] <- powerEQTL::powerEQTL.SLR(MAF = MAF[j], FWER = 0.05, nTests = 240, slope = 0.13,
                                                            n = N[design], sigma.y = 0.13)
  lines(MAF,power.SLR,col=colors[design])
}
legend("bottomright", inset=.02, title="Sample size (N)", paste(N), col=colors, horiz=FALSE, cex=0.8, lty=designs)

Power Estimation for eQTL Studies of 240 SNPs
