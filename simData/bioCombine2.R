bioCombine2 = function(biodata1, biodata2){
  library(data.table)
  library(gtools)
  
  cn = colnames(biodata1)
  cn[1] = "ID"
  colnames(biodata1) = cn

  cn = colnames(biodata2)
  cn[1] = "ID"
  colnames(biodata2) = cn

  bioLocation1 = getBioLocation(biodata1[ ,ID])
  bioLocation2 = getBioLocation(biodata2[ ,ID])
  # bioLocation2 = loc

  biodata1 = biodata1[biodata1$ID %in% bioLocation1$ID, ]
  biodata1 = biodata1[order(biodata1$ID), ]
  bioLocation1 = bioLocation1[order(bioLocation1$ID), ]

  biodata2 = biodata2[biodata2$ID %in% bioLocation2$ID, ]
  biodata2 = biodata2[order(biodata2$ID), ]
  bioLocation2 = bioLocation2[order(bioLocation2$ID), ]

  bioLocation1 = cbind(bioLocation1, biodata1[,2:ncol(biodata1)])
  bioLocation2 = cbind(bioLocation2, biodata2[,2:ncol(biodata2)])


  rm(biodata1, biodata2)

  bioLocation = rbind(bioLocation1, bioLocation2)
  
  rm(bioLocation1, bioLocation2)
  
  # return(bioLocation)
  
  # bioLocation = loc
  
  # bioLocation = bioLocation[which(bioLocation$chromosome_name == 7), ]

  chr = as.factor(bioLocation$chromosome_name)
  chr = levels(chr)

  out = lapply(chr, chrProcessing, bioLocation)
  out = rbindlist(out)
  out = as.data.table(out)

  return(out)
}