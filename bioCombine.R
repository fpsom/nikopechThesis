bioCombine = function(biodata, colCmb = NULL, scale = 100){
  start = Sys.time()
  
  source("reading_data/check_CHROM_POS.R")
  source("reading_data/check_CHROM_POS_ALT.R")
  source("integrating_process/chrProcessing.R")
  source("preparing_data/createScale.R")
  source("preparing_data/getAttConnection.R")
  source("preparing_data/getBioLocation.R")
  source("integrating_process/rangeProcessing.R")
  source("reading_data/readCSV.R")
  source("reading_data/readTXT.R")
  source("reading_data/readVCF.R")
  source("reading_data/readVCF_snp_indel.R")
  source("reading_data/readVCFindel.R")
  source("reading_data/readVCFsnp.R")
  
  library(data.table)
  library(gtools)
  library(stringr)
  library(stringi)
  library(biomaRt)
  library(IlluminaHumanMethylation450kanno.ilmn12.hg19)
  library(vcfR)
  
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

  biodata = lapply(numMat, getAttConnection, biodata, colCmb, 0, scale)
  
  numMat = 1:length(dataVCF) + length(biodata)
  
  dataVCF = lapply(numMat, getAttConnection, dataVCF, colCmb, length(biodata))
  
  ret = createScale(biodata, dataVCF, scale)
  biodata = ret[[1]]
  dataVCF = ret[[2]]

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
  
  rm(bioLocation)
  
  biodata = biodata[sample(nrow(biodata), 150000)]
  
  write.table(biodata, file = "biodata.csv",row.names=FALSE, sep=",")

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