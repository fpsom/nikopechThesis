getBioConnection = function(BioLoc1, BioLoc2){
  
  # row.names(biodata1) = as.character(biodata1[ ,1])
  # row.names(biodata2) = as.character(biodata2[ ,1])
  
  # output = matrix(nrow = nrow(biodata1), ncol = ncol(biodata1))
  # output = as.data.frame(output)
  # colnames(output) = colnames(biodata1)
  
  # for (var in 1:nrow(BioLoc1)) {
    connectors = BioLoc2[which(BioLoc2$chromosome_name == as.numeric(BioLoc1[2])), ]
    
    if(nrow(connectors) == 0){
      output = data.frame(chromosomeName = BioLoc1[2], startPosition = as.numeric(BioLoc1[3]), endPosition = as.numeric(BioLoc1[4]), data = NA)
      return(output)
    }
    
    connectors = connectors[!(connectors$start_position > as.numeric(BioLoc1[4])), ]
    
    if(nrow(connectors) == 0){
      output = data.frame(chromosomeName = BioLoc1[2], startPosition = as.numeric(BioLoc1[3]), endPosition = as.numeric(BioLoc1[4]), data = NA)
      return(output)
    }
    
    connectors = connectors[!(connectors$end_position < as.numeric(BioLoc1[3])), ]
    
    if(nrow(connectors) == 0){
      output = data.frame(chromosomeName = BioLoc1[2], startPosition = as.numeric(BioLoc1[3]), endPosition = as.numeric(BioLoc1[4]), data = NA)
      return(output)
    }
    
    
    connectors = connectors[order(connectors$start_position), ]
    scale = as.numeric(BioLoc1[4]) - as.numeric(BioLoc1[3]) + 1
    
    numpos = ceiling(max(connectors$end_position) - min(connectors$start_position))
    
    start = seq(min(connectors$start_position), max(connectors$end_position), by = scale)
    end = start + scale
    
    output = data.frame(chromosomeName = BioLoc1[2], startPosition = start, endPosition = end, data = NA)
    
    # numerator = pmin(as.numeric(BioLoc1[4]), connectors$end_position) - pmax(as.numeric(BioLoc1[3]), connectors$start_position)
    # numerator = ifelse(numerator == 0, 1, numerator)
    # 
    # denominator = connectors$end_position - connectors$start_position
    # denominator = ifelse(denominator == 0, 1, denominator)
    # 
    # fraction = numerator / denominator
    # 
    # comdata = biodata2[as.character(connectors[,1]), ]
    # comdata = comdata[, 2:ncol(comdata)] * fraction
    # 
    # comdata = colSums(comdata) / nrow(connectors)
    # 
    # comdata = ifelse(is.nan(comdata), NA, comdata)
    
    # output[var, 1] = as.character(BioLoc1[var, 1])
    # output[var, 2:ncol(biodata1)] = as.numeric(comdata)
  # }
  
    # output = comdata  
  
  return(output)
}