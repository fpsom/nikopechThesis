library(stringr)
library(stringi)
library(karyoploteR)

pre_data = read.csv("biodata_pre_integration.csv", sep = ";")

# meth_data = pre_data[which(str_detect(pre_data$ID, "cg")), ]
# meth_data$chromosome_name = paste("chr", meth_data$chromosome_name, sep = "")

gene_data = pre_data[which(str_detect(pre_data$ID, "ENSG")), ]
gene_data$chromosome_name = paste("chr", gene_data$chromosome_name, sep = "")

chr_to_visual = "chr14"

# kp = plotKaryotype(genome="hg19", chromosomes = chr_to_visual)
# kpDataBackground(kp)
# kpAddBaseNumbers(kp)
# kpAxis(kp, r0 = 0, r1 = 1, ymin = min(meth_data[ ,6]), ymax = 100)
# kpPoints(kp, chr = meth_data$chromosome_name, x = meth_data$end_position, y = (meth_data[ ,6] / 100), col = "red")

kp = plotKaryotype(genome="hg19", chromosomes = chr_to_visual)
kpDataBackground(kp)
kpAddBaseNumbers(kp)
kpAxis(kp, r0 = 0, r1 = 1, ymin = min(gene_data[ ,6]), ymax = 100)
kpBars(kp, chr = gene_data$chromosome_name, x0 = gene_data$start_position, x1 = gene_data$end_position, y1 = (gene_data[ ,6] / 100))