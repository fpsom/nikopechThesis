readVcfFile = function(name){
  library(VariantAnnotation)
  library(data.table)
  library(stringi)
  library(stringr)
  
  f = readVcf(as.character(name), "hg19")
  ids = rownames(as.data.frame(f@rowRanges))
  ids = as.data.table(ids)
  colnames(ids) = "ID"
  ranges = as.data.table(f@rowRanges)
  ranges = ranges[ ,1:3]
  ranges[,3] = ranges[,3] + 1
  colnames(ranges) = c("chromosome_name", "start_position", "end_position")
  
  ranges$chromosome_name = as.data.table(str_remove(ranges$chromosome_name, "chr"))
  
  ranges = cbind(ids, ranges)
  
  gene = geno(f)
  AF = gene$AF
  DP = gene$DP
  
  items = lapply(AF, length)
  items = unlist(items)
  items = as.data.table(items)
  
  AF = lapply(AF, getWesData, max(items))
  AF = rbindlist(AF)
  
  DP = unlist(DP)
  DP = as.data.table(DP)
  
  # names = paste(colnames(DP), colnames(AF), sep = "_")
  # colnames(AF) = names
  
  data = cbind(AF, DP)
  
  ranges = cbind(ranges, data)
  
  return(ranges)
}