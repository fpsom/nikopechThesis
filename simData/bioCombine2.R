bioCombine2 = function(biodata1, biodata2){
  library(data.table)
  library(gtools)
  
  row.names(biodata1) = biodata1[ ,1]
  row.names(biodata2) = biodata2[ ,1]
  
  bioLocation1 = getBioLocation(biodata1[ ,1])
  bioLocation2 = getBioLocation(biodata2[ ,1])
  
  # row.names(bioLocation1) = bioLocation1[ ,1]
  # row.names(bioLocation2) = bioLocation2[ ,1]
  
  all = biggestRange(bioLocation1, bioLocation2, biodata1, biodata2)
  
  bioLocation1 = all$small
  biodata1 = all$smalldata
  
  bioLocation2 = all$big
  biodata2 = all$bigdata
  
  tbioLocation1 = transpose(bioLocation1)
  row.names(tbioLocation1) = colnames(bioLocation1)
  colnames(tbioLocation1) = row.names(bioLocation1)
  
  outS = lapply(tbioLocation1, getBioConnection, bioLocation2)
  outS = rbindlist(outS)
  outS = as.data.frame(outS)
  
  tbioLocation2 = transpose(bioLocation2)
  row.names(tbioLocation2) = colnames(bioLocation2)
  colnames(tbioLocation2) = row.names(bioLocation2)
  
  outB = lapply(tbioLocation2, completeMatrix, outS)
  outB = rbindlist(outB)
  outB = as.data.frame(outB)
  
  out = rbind(outS, outB)
  out = out[mixedorder(as.character(out$chromosomeName)), ]
  row.names(out) = c(1:nrow(out))
  
  return(out)
  
  # biodata2 = getBioConnection(biodata1, biodata2, bioLocation1, bioLocation2)
  
  # rownames(biodata1) = biodata1[ ,1]
  # rownames(biodata2) = biodata2[ ,1]
  # 
  # biodata1 = biodata1[ ,2:ncol(biodata1)]
  # biodata2 = biodata2[ ,2:ncol(biodata2)]
  
  # print(biodata2)
  # print(biodata1)
  
  # return(list(a = biodata1, b = biodata2))
}