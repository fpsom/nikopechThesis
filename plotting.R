## Getting required libraries

library(stringr)
library(stringi)
library(karyoploteR)
library(data.table)
library(png)
library(magick)

## Inputs

# file to read
file_name = "biodata_pre_integration_chr17.csv"
pre_data = read.csv(file_name, sep = ";")

image_folder_name = "images"
image_folder_name = paste(image_folder_name, "/", sep = "")

# chromosomes to visualize
chr_to_visual = "chr17"

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

var_data[,6:ncol(var_data)] = ifelse(is.na(var_data[,6:ncol(var_data)]), 0, 1)

temp = unique(var_data[,1:4])
temp = split(temp, seq(nrow(temp)))

temp = lapply(temp, function(obj, data){
  data = data[which(data$chromosome_name == obj$chromosome_name), ]
  data = data[which(data$start_position == obj$start_position), ]
  data = data[which(data$end_position == obj$end_position), ]
  
  varAn = paste(data$VarAnnotation, collapse = ";")
  numericData = colSums(data[ ,6:ncol(data)])
  
  varAn = data.frame(VarAnnotation = varAn)
  rownames(varAn) = rownames(obj)
  numericData = t(as.data.frame(numericData))
  rownames(numericData) = rownames(obj)
  
  out = cbind(obj, varAn, numericData)
  
  return(out)
}, var_data)

var_data = rbindlist(temp)
var_data = as.data.frame(var_data)

rm(temp)

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
  
  png(filename = paste(image_folder_name, patient[i], "_", patient[i + 1], "_diff.png", sep = ""), width = 2494, height = 1812)
  
  plot.params = getDefaultPlotParams(plot.type = 1)
  plot.params$data1height = 138
  plot.params$bottommargin = 10
  plot.params$data1inmargin = 5
  plot.params$rightmargin = 0.02
  plot.params$leftmargin = 0.04
  plot.params$ideogramheight = 10

  kp = plotKaryotype(genome="hg19", chromosomes = chr_to_visual, plot.type = 1, plot.params = plot.params)
  kpAddBaseNumbers(kp, add.units = TRUE)

  kpDataBackground(kp, data.panel = 1, r0=1.55, r1=2)
  kpAxis(kp, r0 = 1.55, r1 = 2, ymin = 0, ymax = 100)
  kpAxis(kp, r0 = 1.55, r1 = 2, ymin = 0, ymax = 5, numticks = 6, side = 2)

  kpDataBackground(kp, data.panel = 1, r0=0, r1=0.45)
  kpAxis(kp, r0 = 0, r1 = 0.45, ymin = 0, ymax = 100)

  data_to_visualize = abs(meth_data[ ,patient[i]] - meth_data[ ,patient[i + 1]])
  data_to_visualize = ifelse(data_to_visualize == 0, 0, meth_data[ ,patient[i + 1]])

  kpPoints(kp, chr = meth_data$chromosome_name, r0 = 0, r1 = 0.45, x = meth_data$end_position, y = (data_to_visualize / 100), col = "royalblue1")
  kpPoints(kp, chr = meth_data$chromosome_name, r0 = 1.55, r1 = 2, x = meth_data$end_position, y = (data_to_visualize / 100), col = "royalblue1")

  data_to_visualize = abs(meth_data[ ,patient[i]] - meth_data[ ,patient[i + 1]])
  data_to_visualize = ifelse(data_to_visualize == 0, 0, meth_data[ ,patient[i]])

  kpPoints(kp, chr = meth_data$chromosome_name, r0 = 0, r1 = 0.45, x = meth_data$end_position, y = (data_to_visualize / 100), col = "orangered")
  kpPoints(kp, chr = meth_data$chromosome_name, r0 = 1.55, r1 = 2, x = meth_data$end_position, y = (data_to_visualize / 100), col = "orangered")

  kpDataBackground(kp, data.panel = 1, r0=0.5, r1=1)
  kpAxis(kp, r0 = 0.5, r1 = 1, ymin = 0, ymax = 100)

  data_to_visualize = abs(gene_data[ ,patient[i]] - gene_data[ ,patient[i + 1]])
  data_to_visualize = ifelse(data_to_visualize == 0, 0, gene_data[ ,patient[i]])
  kpBars(kp, chr = gene_data$chromosome_name,
         r0 = 0.5, r1 = 1,
         x0 = gene_data$start_position, x1 = gene_data$end_position,
         y1 = (data_to_visualize / 100), border = "red4")
  kpBars(kp, chr = gene_data$chromosome_name, r0 = 1.55, r1 = 2, x0 = gene_data$start_position, x1 = gene_data$end_position, y1 = (data_to_visualize / 100), border = "red4")

  data_to_visualize = abs(gene_data[ ,patient[i]] - gene_data[ ,patient[i + 1]])
  data_to_visualize = ifelse(data_to_visualize == 0, 0, gene_data[ ,patient[i + 1]])
  kpBars(kp, chr = gene_data$chromosome_name,
         r0 = 0.5, r1 = 1,
         x0 = gene_data$start_position, x1 = gene_data$end_position,
         y1 = (data_to_visualize / 100), border = "blue4")
  kpBars(kp, chr = gene_data$chromosome_name, r0 = 1.55, r1 = 2, x0 = gene_data$start_position, x1 = gene_data$end_position, y1 = (data_to_visualize / 100), border = "blue4")


  kpDataBackground(kp, data.panel = 1, r0=1.05, r1=1.5)
  kpAxis(kp, r0 = 1.05, r1 = 1.5, ymin = 0, ymax = 5, numticks = 6)
  data_to_visualize = abs(var_data[ ,patient[i]] - var_data[ ,patient[i + 1]])
  data_to_visualize = ifelse(data_to_visualize == 0, 0, var_data[ ,patient[i]])
  kpSegments(kp, chr = var_data$chromosome_name,
             r0 = 1.05, r1 = 1.5,
             x0 = var_data$start_position,
             x1=var_data$start_position,
             y0 = 0, y1=(data_to_visualize / 5),
             col = "red")
  kpSegments(kp, chr = var_data$chromosome_name,
             r0 = 1.55, r1 = 2,
             x0 = var_data$start_position,
             x1=var_data$start_position,
             y0 = 0, y1=(data_to_visualize / 5),
             col = "red")

  data_to_visualize = abs(var_data[ ,patient[i]] - var_data[ ,patient[i + 1]])
  data_to_visualize = ifelse(data_to_visualize == 0, 0, var_data[ ,patient[i + 1]])
  kpSegments(kp, chr = var_data$chromosome_name,
             r0 = 1.05, r1 = 1.5,
             x0 = var_data$start_position,
             x1=var_data$start_position,
             y0 = 0, y1=(data_to_visualize / 5),
             col = "blue")
  kpSegments(kp, chr = var_data$chromosome_name,
             r0 = 1.55, r1 = 2,
             x0 = var_data$start_position,
             x1=var_data$start_position,
             y0 = 0, y1=(data_to_visualize / 5),
             col = "blue")
  dev.off()
}

rm(gene_data, meth_data, plot.params, pre_data, var_data, chr_to_visual, file_name, i, patient, img_pre, img_post, img, kp, image_folder_name, data_to_visualize)