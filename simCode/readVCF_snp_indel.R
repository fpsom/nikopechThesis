readVCF_snp_indel = function(names){
  library(data.table)
  library(stringi)
  library(stringr)
  
  indel = readVCFindel(names[1])
  snp = readVCFsnp(names[2])
  
  name = names[1]
  name = str_split(name, "/")
  name = unlist(name)
  name = name[str_detect(name, ".vcf")]
  name = str_remove(name, ".vcf")
  name = str_split(name, "indel")
  name = unlist(name)
  name = paste(name, collapse = "")
  name = str_split(name, "snp")
  name = unlist(name)
  name = paste(name, collapse = "")
  name = str_remove(name, "[.]")
  
  
  chrpos_indel = paste(indel$chromosome_name, indel$start_position, indel$end_position, sep = "")
  chrpos_snp   = paste(snp$chromosome_name, snp$start_position, snp$end_position, sep = "")
  
  sameindel = indel[which(chrpos_indel %in% chrpos_snp), ]
  samesnp   = snp[which(chrpos_snp %in% chrpos_indel), ]
  
  otherindel = indel[!(chrpos_indel %in% chrpos_snp), ]
  othersnp   = snp[!(chrpos_snp %in% chrpos_indel), ]
  
  out = cbind(samesnp, sameindel[ ,5])
  t   = c("A", "G", "T", "C", "INDEL")
  t   = paste(name, t, sep = "_")
  colnames(out)[5:ncol(out)] = t
  
  nas = matrix(nrow = nrow(otherindel), ncol = 4)
  nas = as.data.table(nas)
  
  temp = cbind(otherindel[,1:4], nas)
  otherindel = cbind(temp, otherindel[ ,5])
  colnames(otherindel) = colnames(out)
  
  nas = matrix(nrow = nrow(othersnp), ncol = 1)
  nas = as.data.table(nas)
  
  othersnp = cbind(othersnp, nas)
  colnames(othersnp) = colnames(out) 
  
  out = rbind(out, otherindel)
  out = rbind(out, othersnp)
  
  return(out)
}