getBioConnection = function(BioLoc1, BioLoc2){
  
  output = data.frame(col1 = character(), col2 = character(), scale = numeric())
  
  if(nrow(BioLoc1) > nrow(BioLoc2)){
    colnames(output) = c(colnames(BioLoc2)[1], colnames(BioLoc1)[1], "scale")
    
    for (var in 1:nrow(BioLoc1)) {
      connectors = BioLoc2[which(BioLoc2$chromosome_name == BioLoc1[var, "chromosome_name"]), ]
      
      if(nrow(connectors) == 0){
        next
      }
      
      connectors = connectors[which(connectors$start_position <= BioLoc1[var, "start_position"]), ]
      
      connectors = connectors[which(connectors$end_position >= BioLoc1[var, "end_position"]), ]
      
      if(nrow(connectors) == 0){
        next
      }
      
      
      
    }
  } else {
    for (var in 1:nrow(BioLoc2)) {
      connectors = BioLoc1[which(BioLoc1$chromosome_name == BioLoc2[var, "chromosome_name"]), ]
      
      if(nrow(connectors) == 0){
        next
      }
      
      #connectors = connectors[which(connectors$start_position <= BioLoc2[var, "start_position"] && 
      #                                connectors$end_position >= BioLoc2[var, "end_position"]), ]
      
      
      
      
    }
  }
}