## Getting required libraries

library(stringr)
library(stringi)
library(karyoploteR)
library(png)
library(magick)

## Inputs

# file to read
file_name = "biodata_pre_integration_1.csv"
pre_data = read.csv(file_name, sep = ";")

image_folder_name = "images"
image_folder_name = paste(image_folder_name, "/", sep = "")

# chromosomes to visualize
chr_to_visual = "chr14"

# patient to visualize
patient = colnames(pre_data)[6:length(pre_data)]
# patient = which(colnames(pre_data) %in% patient)

## Reading data

meth_data = pre_data[which(str_detect(pre_data$ID, "cg")), ]
meth_data$chromosome_name = paste("chr", meth_data$chromosome_name, sep = "")

gene_data = pre_data[which(str_detect(pre_data$ID, "ENSG")), ]
gene_data$chromosome_name = paste("chr", gene_data$chromosome_name, sep = "")

var_data = pre_data[is.na(pre_data$ID), ]
var_data$chromosome_name = paste("chr", var_data$chromosome_name, sep = "")

var_data_num = var_data[ ,6:ncol(var_data)]
var_data_num = ifelse(is.na(var_data_num), 0, 1)

duplicate = duplicated(var_data[ ,2:3])
var_data_num[(which(duplicate) - 1), ] = var_data_num[(which(duplicate) - 1), ] + var_data_num[which(duplicate), ]

var_data_num = var_data_num[!duplicate, ]
var_data = var_data[!duplicate, ]

var_data = cbind(var_data[,1:5], var_data_num)
rm(var_data_num)

## Plotting

for(i in patient){
  png(filename = paste(image_folder_name, i, ".png", sep = ""), width = 2494, height = 1812)
  
  plot.params = getDefaultPlotParams(plot.type = 1)
  plot.params$data1height = 138
  plot.params$bottommargin = 10
  plot.params$data1inmargin = 5
  plot.params$rightmargin = 0.02
  plot.params$leftmargin = 0.04
  plot.params$ideogramheight = 10
  
  kp = plotKaryotype(genome="hg19", chromosomes = chr_to_visual, plot.type = 1, plot.params = plot.params)
  kpAddBaseNumbers(kp, add.units = TRUE)
  
  kpDataBackground(kp, data.panel = 1, r0=0, r1=0.45)
  kpAxis(kp, r0 = 0, r1 = 0.45, ymin = 0, ymax = 100)
  kpPoints(kp, chr = meth_data$chromosome_name, r0 = 0, r1 = 0.45, x = meth_data$end_position, y = (meth_data[ ,i] / 100), col = "salmon")
  
  kpDataBackground(kp, data.panel = 1, r0=0.5, r1=1)
  kpAxis(kp, r0 = 0.5, r1 = 1, ymin = 0, ymax = 100)
  kpBars(kp, chr = gene_data$chromosome_name, r0 = 0.5, r1 = 1, x0 = gene_data$start_position, x1 = gene_data$end_position, y1 = (gene_data[ ,i] / 100))
  
  kpDataBackground(kp, data.panel = 1, r0=1.05, r1=1.5)
  kpAxis(kp, r0 = 1.05, r1 = 1.5, ymin = 0, ymax = 5, numticks = 6)
  
  kpSegments(kp, chr = var_data$chromosome_name,
             r0 = 1.05, r1 = 1.5,
             x0 = var_data$start_position,
             x1=var_data$start_position,
             y0 = 0, y1=(var_data[ ,i] / 5),
             col = "mediumorchid4")
  
  kpDataBackground(kp, data.panel = 1, r0=1.55, r1=2)
  kpAxis(kp, r0 = 1.55, r1 = 2, ymin = 0, ymax = 100)
  kpAxis(kp, r0 = 1.55, r1 = 2, ymin = 0, ymax = 5, numticks = 6, side = 2)
  kpPoints(kp, chr = meth_data$chromosome_name, r0 = 1.55, r1 = 2, x = meth_data$end_position, y = (meth_data[ ,i] / 100), col = "salmon")
  kpBars(kp, chr = gene_data$chromosome_name, r0 = 1.55, r1 = 2, x0 = gene_data$start_position, x1 = gene_data$end_position, y1 = (gene_data[ ,i] / 100))
  kpSegments(kp, chr = var_data$chromosome_name,
             r0 = 1.55, r1 = 2,
             x0 = var_data$start_position,
             x1=var_data$start_position,
             y0 = 0, y1=(var_data[ ,i] / 5),
             col = "mediumorchid4")
  
  dev.off()
}

rm(i)

for(i in seq(1, length(patient), by = 2)){
  img_pre = image_read(paste(image_folder_name, patient[i], ".png", sep = ""))
  img_post = image_read(paste(image_folder_name, patient[i + 1], ".png", sep = ""))
  
  img = c(img_pre, img_post)
  img = image_append(img)
  
  image_write(img, path = paste(image_folder_name, patient[i], "_", patient[i + 1], ".png", sep = ""), format = "png")
}

rm(gene_data, meth_data, plot.params, pre_data, var_data, chr_to_visual, duplicate, file_name, i, patient, img_pre, img_post, img)