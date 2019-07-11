bioCombine = function(biodata, colCmb = NULL){
  start = Sys.time()
  
  library(data.table)
  library(gtools)
  library(stringr)
  library(stringi)
  
  tablet = list()
  
  for(i in 1:length(biodata)){
    temp = biodata[[i]]
    
    if(str_detect(as.character(temp), ".csv")){
      tablet = c(tablet, readCSV(temp))
    } else {
      tablet = c(tablet, lapply(temp, readTXT))
    }
  }
  
  biodata = tablet
  
  rm(tablet)
  
  out = biodata
  
  ###########################################################
  
  numMat = 1:length(biodata)

  biodata = lapply(numMat, getAttConnection, biodata, colCmb)
  biodata = createScale(biodata)

  if(is.null(colCmb)){
    biodata = rbindlist(biodata, use.names = FALSE)
    colnames(biodata)[1] = "ID"
  } else {
    biodata = rbindlist(biodata, use.names = TRUE)
  }


  rm(colCmb)

  # biodata = rbindlist(biodata)

  bioLocation = getBioLocation(biodata$ID)

  biodata = biodata[biodata$ID %in% bioLocation$ID, ]

  biodata = biodata[order(as.character(biodata$ID)), ]
  bioLocation = bioLocation[order(as.character(bioLocation$ID)), ]

  biodata = cbind(bioLocation, biodata[ ,2:ncol(biodata)])

  out = biodata

  ###########################################################

  # chr = as.factor(biodata$chromosome_name)
  # chr = levels(chr)
  # 
  # out = lapply(chr, chrProcessing, biodata)
  # out = rbindlist(out)
  # out = as.data.table(out)
  # 
  # end = Sys.time()
  # print(end - start)
  
  ###########################################################
  
  return(out)
}