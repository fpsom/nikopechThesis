rangeProcessing = function(biorange, exout){
  connectors = exout[which(biorange[1] >= exout$start_position), ]
  connectors = connectors[which(biorange[2] <= connectors$end_position), ]
  temp = connectors[ ,5:ncol(connectors)]
  
  out = data.table(ID = character(nrow(connectors)), 
                   chromosome_name = character(nrow(connectors)), 
                   start_position = numeric(nrow(connectors)), 
                   end_position = numeric(nrow(connectors)))
  
  if(nrow(connectors) != 0){
    
    out$ID = connectors$ID
    out$chromosome_name = connectors$chromosome_name
    out$start_position = biorange[1]
    out$end_position = biorange[2]
    
    scl = (biorange[2] - biorange[1]) / (connectors$end_position - connectors$start_position)
    
    # out = rbind(out, data.table(ID = connectors$ID, chromosome_name = connectors$chromosome_name,
    #                             start_position = biorange[1], end_position = biorange[2]))
    
    temp = scl * connectors[ ,5:ncol(connectors)]
    
    # out = data.table(ID = connectors$ID, chromosome_name = connectors$chromosome_name,
    #                  start_position = biorange[1], end_position = biorange[2])
  }
  
  out = cbind(out, temp)
  
  return(out)
}