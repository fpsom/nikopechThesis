readCSV = function(biodata){
  library(data.table)
  
  out = list()
  
  for(i in 1:length(biodata)){
    link = as.character(biodata[i])
    temp = read.csv(link, sep = ";")
    temp = as.data.table(temp)
    
    out = c(out, list(temp))
  }

  
  return(out)
}