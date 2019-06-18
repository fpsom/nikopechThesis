bioCombine = function(biodata, colCmb){
  library(data.table)
  library(gtools)
  
  # cn = colnames(biodata1)
  # cn[1] = "ID"
  # colnames(biodata1) = cn
  # 
  # cn = colnames(biodata2)
  # cn[1] = "ID"
  # colnames(biodata2) = cn

  # bioLocation1 = getBioLocation(biodata1[ ,ID])
  # bioLocation2 = getBioLocation(biodata2[ ,ID])
  # bioLocation2 = loc
  
  # out = data.table(ID = character(), chromosome_name = character(), start_position = character(), end_position = character())  
  
  numMat = 1:length(biodata)
  
  biodata = lapply(numMat, getAttConnection, biodata, colCmb)
  biodata = createScale(biodata)
  return(biodata)
  # biodata = rbindlist(biodata, use.names = TRUE)
  # 
  # rm(colCmb)
  # 
  # # biodata = rbindlist(biodata)
  # #
  # bioLocation = getBioLocation(biodata$ID)
  # 
  # biodata = biodata[biodata$ID %in% bioLocation$ID, ]
  # 
  # biodata = biodata[order(as.character(biodata$ID)), ]
  # bioLocation = bioLocation[order(as.character(bioLocation$ID)), ]
  # 
  # biodata = cbind(bioLocation, biodata[ ,2:ncol(biodata)])
  # 
  # # rm(bioLocation)biodata[ ,ID]
  # 
  # # out = biodata
  # ############################
  # # biodata1 = biodata1[biodata1$ID %in% bioLocation1$ID, ]
  # # biodata1 = biodata1[order(biodata1$ID), ]
  # # bioLocation1 = bioLocation1[order(bioLocation1$ID), ]
  # #
  # # biodata2 = biodata2[biodata2$ID %in% bioLocation2$ID, ]
  # # biodata2 = biodata2[order(biodata2$ID), ]
  # # bioLocation2 = bioLocation2[order(bioLocation2$ID), ]
  # #
  # # bioLocation1 = cbind(bioLocation1, biodata1[,2:ncol(biodata1)])
  # # bioLocation2 = cbind(bioLocation2, biodata2[,2:ncol(biodata2)])
  # 
  # 
  # # rm(biodata1, biodata2)
  # #
  # # bioLocation = rbind(bioLocation1, bioLocation2)
  # #
  # # rm(bioLocation1, bioLocation2)
  # #
  # # # return(bioLocation)
  # #
  # # # bioLocation = loc
  # #
  # # # bioLocation = bioLocation[which(bioLocation$chromosome_name == 7), ]
  # #
  # ###########################################################
  # 
  # chr = as.factor(biodata$chromosome_name)
  # chr = levels(chr)
  # 
  # out = lapply(chr, chrProcessing, biodata)
  # out = rbindlist(out)
  # out = as.data.table(out)
  # 
  # return(out)
}