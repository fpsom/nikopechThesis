getWesData = function(vector, numcol){
  out = matrix(nrow = 1, ncol = numcol)
  out[1,(numcol - length(vector) + 1):numcol] = vector
  out = as.data.table(out)
  return(out)
}