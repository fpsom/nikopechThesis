createScale = function(data){
  matrixScales = c()
  
  for(temp in data){
    matrixScales = cbind(matrixScales, max(colSums(temp[,2:ncol(temp)])))
  }
  
  maxScale = max(matrixScales)
  
  i = 0
  
  for(temp in data){
    i = i + 1
    tempScale = max(colSums(temp[,2:ncol(temp)]))
    
    numericData = temp[,2:ncol(temp)]
    numericData = numericData * (maxScale / tempScale)
    temp = cbind(temp[,1], numericData)
    data[[i]] = temp
  }
  
  
  return(data)
}