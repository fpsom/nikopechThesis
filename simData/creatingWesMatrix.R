creatingWesMatrix = function(biodata){
  library(vcfR)
  library(data.table)
  library(stringi)
  library(stringr)
  
  f = read.vcfR(biodata[[1]])
  f = as.data.table(f@fix[,1:3])
  
  out = as.data.table(matrix(nrow = 0, ncol = 3))
  colnames(out) = colnames(f)
  
  for(t in unlist(biodata)){
    f = read.vcfR(t)
    f = as.data.table(cbind(f@fix[,1:3], f@gt))
    f = f[,c(1:3,5)]

    data = c(f[,4])
    data = data[[1]]
    data = str_split(data, ":")
    data = lapply(data, getWesData)
    data = lapply(data, combWesData)
    data = as.data.table(matrix(data = unlist(data), nrow = length(data), byrow = TRUE))
    colnames(data) = colnames(f[,4])
    f[,4] = data
    

    temp1 = out[which(out$POS %in% f$POS), ]
    temp2 = out[!(out$POS %in% f$POS), ]

    temp3 = f[which(f$POS %in% out$POS), ]
    temp4 = f[!(f$POS %in% out$POS), ]
    
    temp1 = temp1[order(temp1$POS), ]
    temp2 = temp2[order(temp2$POS), ]
    temp3 = temp3[order(temp3$POS), ]
    temp4 = temp4[order(temp4$POS), ]
    
    # print(temp1)
    # print(temp2)
    # print(temp3)
    # print(temp4)

    chrom1 = temp1[which(temp1$CHROM == temp3$CHROM), ]
    chrom2 = temp3[which(temp1$CHROM == temp3$CHROM), ]

    out = cbind(chrom1, chrom2[,4:ncol(chrom2)])

    chrom1 = temp1[which(temp1$CHROM != temp3$CHROM), ]
    chrom2 = temp3[which(temp1$CHROM != temp3$CHROM), ]

    temp2 = rbind(temp2, chrom1)
    temp4 = rbind(temp4, chrom2)

    temp2 = cbind(temp2, as.data.table(matrix(nrow = nrow(temp2), ncol = (ncol(temp4) - 3))))
    colnames(temp2) = colnames(out)

    temp4 = cbind(temp4[ ,1:3], as.data.table(matrix(nrow = nrow(temp4), ncol = (ncol(temp1) - 3))), temp4[,4:ncol(temp4)])
    colnames(temp4) = colnames(out)

    out = rbind(out, temp2, temp4)
    rm(f)
  }
  
  chromo= as.data.table(str_remove(out$CHROM, "chr"))
  colnames(chromo) = "chromosome_name"
  
  location = data.table(start_position = (as.numeric(out$POS) - 1), end_position = out$POS)
  
  out = cbind(out$ID, chromo, location, out[,4:ncol(out)])
  colnames(out)[1] = "ID"
  
  return(out)
}