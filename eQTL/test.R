library("circlize")

eQTLs <- e$QTLs
eQTL_labels <- e$annotated
pQTLs <- p$QTLs
pQTL_labels <- p$annotated

setEPS()
postscript(file = "test.eps", width = 7.08, height = 7.08, horizontal = FALSE, paper = "special", colormodel="rgb")
circos.clear()
circos.par("start.degree" = 90, gap.degree = c(rep(c(0.7), 21), 8), track.margin = c(0.005, 0.005), cell.padding = c(0.001, 0.01, 0.01, 0.001))
circos.initializeWithIdeogram(plotType = NULL, species = "hg19",  chromosome.index = paste0("chr", 1:22))
circos.genomicLabels(eQTL_labels, labels.column = 5, side = "outside", cex = 0.3, line_lwd = 0.8,
                     connection_height = convert_height(8, "mm"),
                     line_col = as.numeric(factor(eQTL_labels[[6]])), col = as.numeric(factor(eQTL_labels[[6]])))
circos.track(ylim = c(0, 1),
             panel.fun = function(x, y) {
               chr  = gsub("chr", get.current.chromosome(), replace = "")
               xlim = 0.3
               ylim = 0.5
               circos.text(mean(xlim), mean(ylim), chr, cex = 0.9, col = "black", facing = "inside", niceFacing = TRUE)
             },
             track.height = 0.03,  bg.border = NA)
circos.genomicTrackPlotRegion(eQTLs, panel.fun = function(region, value,  ...)
                              circos.genomicPoints(region, value, pch = 16, col = "green", cex = 0.3),
                              track.height = 0.2, bg.border = NA, bg.col = "#FFC0CB", ylim = c(0, 10))
circos.yaxis(side = "left", at = c(0, 10), labels = c(0, 10), sector.index = get.all.sector.index()[1], labels.cex = 0.3, lwd = 0.3,
             tick.length = 0.5*(convert_x(1, "mm", get.cell.meta.data("sector.index"), get.cell.meta.data("track.index"))))
circos.genomicTrackPlotRegion(pQTLs, panel.fun = function(region, value,  ...)
                              circos.genomicPoints(region, value, pch = 19, col = "red", cex = 0.3),
                              track.height = 0.2, bg.border = NA, bg.col = "#A6E1F4", ylim = c(-30, 0))
circos.yaxis(side = "left", at = c(-30,-15,0), labels = c(-30,-15,0), sector.index = get.all.sector.index()[1], labels.cex = 0.3, lwd = 0.3)
circos.genomicLabels(pQTL_labels, labels.column = 5, side = "outside", cex = 0.4, line_lwd = 0.8,
                     connection_height = convert_height(1, "mm"),
                     line_col = as.numeric(factor(pQTL_labels[[6]])), col = as.numeric(factor(pQTL_labels[[6]])), facing = "reverse.clockwise")
title("A circos plot of eQTL/pQTL druggability")
dev.off()
# convert -density 300 test.eps test.pdf
# convert -density 300 test.eps test.png
# https://www.rapidtables.com/web/color/RGB_Color.html
