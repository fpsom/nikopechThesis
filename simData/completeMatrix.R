completeMatrix = function(bioLoc, matr){
  connectors = matr[which(matr$chromosomeName == bioLoc[2]), ]
  
  if(nrow(connectors) == 0){
    out = data.frame(chromosomeName = bioLoc[2], startPosition = bioLoc[3], endPosition = bioLoc[4], data = NA)
    return(out)
  }
  
  connectors = connectors[which(connectors$startPosition <= bioLoc[4]), ]
  
  if(nrow(connectors) == 0){
    out = data.frame(chromosomeName = bioLoc[2], startPosition = bioLoc[3], endPosition = bioLoc[4], data = NA)
    return(out)
  }
  
  connectors = connectors[which(connectors$endPosition > bioLoc[3]), ]
  
  if(nrow(connectors) == 0){
    out = data.frame(chromosomeName = bioLoc[2], startPosition = bioLoc[3], endPosition = bioLoc[4], data = NA)
    return(out)
  }
  
  return()
  
}