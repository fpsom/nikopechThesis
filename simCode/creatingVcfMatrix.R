creatingVcfMatrix = function(biodata){
  library(VariantAnnotation)
  library(data.table)
  library(stringi)
  library(stringr)
  
  
  first = readVcfFile(biodata[[1]])
  
  out = matrix(nrow = 0, ncol = ncol(first))
  out = as.data.table(out)
  colnames(out) = c("ID", "chromosome_name", "start_position", "end_position")
  
  for(t in unlist(biodata)){
    temp = readVcfFile(as.character(t))
    
    sameIDs1 = temp[which(temp$ID %in% out$ID), ]
    otherIDs1 = temp[!(temp$ID %in% out$ID), ]
    
    sameIDs2 = out[which(out$ID %in% temp$ID), ]
    otherIDs2 = out[!(out$ID %in% temp$ID), ]
    
    sameIDs1 = sameIDs1[order(sameIDs1$ID), ]
    sameIDs1 = sameIDs2[order(sameIDs2$ID), ]
    
    out = cbind(sameIDs1, sameIDs2[,5:ncol(sameIDs2)])
    
    nas = matrix(nrow = nrow(otherIDs1), ncol = (ncol(otherIDs2) - 4))
    nas = as.data.table(nas)
    otherIDs1 = cbind(otherIDs1, nas)
    colnames(otherIDs1) = colnames(out)
    
    nas = matrix(nrow = nrow(otherIDs2), ncol = (ncol(otherIDs1) - 4))
    nas = as.data.table(nas)
    temp = cbind(otherIDs2[,1:4], nas)
    otherIDs2 = cbind(temp, otherIDs2[,5:ncol(otherIDs2)])
    colnames(otherIDs2) = colnames(out)
    
    out = rbind(out, otherIDs1)
    out = rbind(out, otherIDs2)
  }
  
  return(out)
}