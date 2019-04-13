bioCombine2 = function(biodata1, biodata2){
  
  bioLocation1 = getBioLocation(biodata1[ ,1])
  bioLocation2 = getBioLocation(biodata2[ ,1])
  
  all = biggestRange(bioLocation1, bioLocation2, biodata1, biodata2)
  
  bioLocation1 = all$small
  biodata1 = all$smalldata
  
  bioLocation2 = all$big
  biodata2 = all$bigdata
  
  biodata2 = getBioConnection(biodata1, biodata2, bioLocation1, bioLocation2)
  
  rownames(biodata1) = biodata1[ ,1]
  rownames(biodata2) = biodata2[ ,1]
  
  biodata1 = biodata1[ ,2:ncol(biodata1)]
  biodata2 = biodata2[ ,2:ncol(biodata2)]
  
  # print(biodata2)
  # print(biodata1)
  
  return(list(a = biodata1, b = biodata2))
}