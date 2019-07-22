bioCombine = function(biodata, colCmb = NULL){
  start = Sys.time()
  
  library(data.table)
  library(gtools)
  library(stringr)
  library(stringi)
  
  tablet = list()
  dataVCF = list()
  
  for(i in 1:length(biodata)){
    temp = biodata[[i]]
    
    if(str_detect(as.character(temp), ".csv")){
      tablet = c(tablet, readCSV(temp))
    } else if(str_detect(as.character(temp), ".txt")) {
      tablet = c(tablet, lapply(temp, readTXT))
    } else {
      dataVCF = c(dataVCF, lapply(temp, readVCF))
    }
  }
  
  biodata = tablet
  
  rm(tablet)
  
  # out = biodata
  
  ###########################################################
  
  numMat = 1:length(biodata)

  biodata = lapply(numMat, getAttConnection, biodata, colCmb)
  
  numMat = 1:length(dataVCF) + length(biodata)
  
  dataVCF = lapply(numMat, getAttConnection, dataVCF, colCmb, length(biodata))
  
  # biodata = createScale(biodata)

  if(is.null(colCmb)){
    biodata = rbindlist(biodata, use.names = FALSE)
    dataVCF = rbindlist(dataVCF, use.names = FALSE)
    colnames(biodata)[1] = "ID"
  } else {
    biodata = rbindlist(biodata, use.names = TRUE)
  }

  rm(colCmb)

  bioLocation = getBioLocation(biodata$ID)

  biodata = biodata[biodata$ID %in% bioLocation$ID, ]

  biodata = biodata[order(as.character(biodata$ID)), ]
  bioLocation = bioLocation[order(as.character(bioLocation$ID)), ]

  biodata = cbind(bioLocation, biodata[ ,2:ncol(biodata)])
  
  colnames(dataVCF) = colnames(biodata)
  
  biodata = rbind(biodata, dataVCF)
  
  biodata = biodata[sample(nrow(biodata), 50000)]

  ###########################################################
  print("starting integration process")

  chr = as.factor(biodata$chromosome_name)
  chr = levels(chr)

  out = lapply(chr, chrProcessing, biodata)
  out = rbindlist(out)
  out = as.data.table(out)

  end = Sys.time()
  print(end - start)
  
  ###########################################################
  
  return(out)
}