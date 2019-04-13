biggestRange = function(bioLoc1, bioLoc2, biodata1, biodata2){
  if(sum(bioLoc1[,"end_position"] - bioLoc1[,"start_position"]) > sum(bioLoc2[,"end_position"] - bioLoc2[,"start_position"])){
    return(list(small = bioLoc2, smalldata = biodata2, big = bioLoc1, bigdata = biodata1))
  } else {
    return(list(small = bioLoc1, smalldata = biodata1, big = bioLoc2, bigdata = biodata2))
  }
}