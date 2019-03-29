getBioLocation = function(Biovector, database = "ensembl", dataSet="hsapiens_gene_ensembl"){
  
  #------------------------------ Libraries ------------------------------
  
  if(!require("biomaRt")){
    print("biomaRt package is required")
    return(Biovector)
  } else {
    library(biomaRt)
  }
  
  if(!require("IlluminaHumanMethylation450kanno.ilmn12.hg19")){
    print("IlluminaHumanMethylation450kanno.ilmn12.hg19 is required")
    return(Biovector)
  } else {
    library(IlluminaHumanMethylation450kanno.ilmn12.hg19)
    data(Locations)
  }
  
  library(stringi)
  library(stringr)
  
  #------------------------------ Creating output data frame ------------------------------
  
  Biovector = as.character(Biovector)
  
  if(str_detect(Biovector[1], "cg")){
    # Methylation data
    
    output = Locations[Biovector, 1:2]
    output = data.frame(sgID = Biovector, chromosome_name = as.integer(str_remove(output$chr, "chr")), 
                                          start_position = output$pos, 
                                          end_position = output$pos)
    
    return(output)
    
  } else if(str_detect(Biovector[1], "NM")){
    # RefSeq mRNA data
    
    biomart = ensembl = useMart(database, dataset=dataSet)
    refseqids = Biovector
    
    output = getBM(attributes=c("refseq_mrna","chromosome_name", "start_position", "end_position"), 
                 filters="refseq_mrna",
                 values=refseqids, 
                 mart=biomart)
    
    return(output)
  } else{
    # Not known id found
    
    print("Please give a suitable vector")
    return(Biovector)
  }
}