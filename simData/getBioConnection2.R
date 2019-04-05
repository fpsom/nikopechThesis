getBioConnection2 = function(BioLoc1, BioLoc2){

  range1 = sum(BioLoc1[,"end_position"] - BioLoc1[,"start_position"])
  range2 = sum(BioLoc2[,"end_position"] - BioLoc2[,"start_position"])
  
  if(range2 > range1){
    
    output = matrix(ncol = nrow(BioLoc2), nrow = nrow(BioLoc1))
    colnames(output) = BioLoc2[,1]
    row.names(output) = BioLoc1[,1]
    
    output = as.data.frame(output)
    
    for (var in 1:nrow(BioLoc1)) {
      connectors = BioLoc2[which(BioLoc2$chromosome_name == BioLoc1[var, "chromosome_name"]), ]
      
      if(nrow(connectors) == 0){
        next
      }
      
      connectors = connectors[!(connectors$start_position > BioLoc1[var, "end_position"]), ]
      
      if(nrow(connectors) == 0){
        next
      }
      
      connectors = connectors[!(connectors$end_position < BioLoc1[var, "start_position"]), ]
      
      if(nrow(connectors) == 0){
        next
      }
      
      numerator = pmin(BioLoc1[var, "end_position"], connectors$end_position) - pmax(BioLoc1[var, "start_position"], connectors$start_position)
      numerator = ifelse(numerator == 0, 1, numerator)
      
      denominator = connectors$end_position - connectors$start_position
      denominator = ifelse(denominator == 0, 1, denominator)
      
      fraction = numerator / denominator
      
      output[as.character(BioLoc1[var, 1]), as.character(connectors[,1])] = fraction
    }
  } else {
    
    output = matrix(ncol = nrow(BioLoc1), nrow = nrow(BioLoc2))
    colnames(output) = BioLoc1[,1]
    row.names(output) = BioLoc2[,1]
    
    output = as.data.frame(output)
    
    for (var in 1:nrow(BioLoc2)) {
      connectors = BioLoc1[which(BioLoc1$chromosome_name == BioLoc2[var, "chromosome_name"]), ]
      
      if(nrow(connectors) == 0){
        next
      }
      
      connectors = connectors[!(connectors$start_position > BioLoc2[var, "end_position"]), ]
      
      if(nrow(connectors) == 0){
        next
      }
      
      connectors = connectors[!(connectors$end_position < BioLoc2[var, "start_position"]), ]
      
      if(nrow(connectors) == 0){
        next
      }
      
      numerator = pmin(BioLoc2[var, "end_position"], connectors$end_position) - pmax(BioLoc2[var, "start_position"], connectors$start_position)
      numerator = ifelse(numerator == 0, 1, numerator)
      
      denominator = connectors$end_position - connectors$start_position
      denominator = ifelse(denominator == 0, 1, denominator)
      
      fraction = numerator / denominator
      
      output[as.character(BioLoc2[var, 1]), as.character(connectors[,1])] = fraction
    }
  }
  
  return(output)
}