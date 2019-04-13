getBioConnection = function(biodata1, biodata2, BioLoc1, BioLoc2){
  
  row.names(biodata1) = as.character(biodata1[ ,1])
  row.names(biodata2) = as.character(biodata2[ ,1])
  
  output = matrix(nrow = nrow(biodata1), ncol = ncol(biodata1))
  output = as.data.frame(output)
  colnames(output) = colnames(biodata1)
  
  for (var in 1:nrow(BioLoc1)) {
    print(var)
    connectors = BioLoc2[which(BioLoc2$chromosome_name == BioLoc1[var, "chromosome_name"]), ]
    
    # if(nrow(connectors) == 0){
    #   next
    # }
    
    connectors = connectors[!(connectors$start_position > BioLoc1[var, "end_position"]), ]
    
    # if(nrow(connectors) == 0){
    #   next
    # }
    
    connectors = connectors[!(connectors$end_position < BioLoc1[var, "start_position"]), ]
    
    # if(nrow(connectors) == 0){
    #   next
    # }
    
    numerator = pmin(BioLoc1[var, "end_position"], connectors$end_position) - pmax(BioLoc1[var, "start_position"], connectors$start_position)
    numerator = ifelse(numerator == 0, 1, numerator)
    
    denominator = connectors$end_position - connectors$start_position
    denominator = ifelse(denominator == 0, 1, denominator)
    
    fraction = numerator / denominator
    
    comdata = biodata2[as.character(connectors[,1]), ]
    comdata = comdata[, 2:ncol(comdata)] * fraction
    
    comdata = colSums(comdata) / nrow(connectors)
    
    comdata = ifelse(is.nan(comdata), NA, comdata)
    
    output[var, 1] = as.character(BioLoc1[var, 1])
    output[var, 2:ncol(biodata1)] = as.numeric(comdata)
  }
  
  return(output)
}