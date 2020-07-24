## functions for MEPHAS

##' @title List of variable types
##'
##' @param data input data frame
##' @export
var.class <- function(data){
  x <- sapply(data, class)
  x[sapply(data, function(v){
    x <- unique(v)
    length(x) - sum(is.na(x)) == 2L
  })] <- "binary"
  x <- as.data.frame(x)
  colnames(x) <- "Variable Type"
  return(x)
}

##' @title Summary of factor variables
##'
##' @param data input data frame
##' @export
desc.factor<-function(data){
  x <- var.class(data)
  a<-x[,1] %in% c("binary", "factor")

  if(sum(a)==0){
    df <-data.frame(NULL)
  }

  else if(sum(a)==1){
    df <- cbind(
      round(table(data[,a, drop=FALSE])),
      round(prop.table(table(data[,a, drop=FALSE])),3)
    )
    colnames(df)<- c("N", "%")
  }
  else{
  x.list<-sapply(data[,a, drop=FALSE], function(v){
    cbind(
      round(table(v)),
      round(prop.table(table(v)),6)
    )
  }
  )
  x.data<-NULL
  for (i in 1:length(x.list)){
    x.data <- rbind(x.data,x.list[[i]])
  }
  var2<- rownames(x.data)
  var1 <- rep(names(x.list), sapply(x.list, nrow))
  df <- cbind.data.frame(var1,var2, x.data)
  colnames(df)<- c("Variable","Values", "N", "%")
  rownames(df)<- NULL
  }
  return(df)
}


##' @title Summary of numeric variables
##'
##' @param data input data frame
##' @export
desc.numeric<- function(data){
x <- var.class(data)
a<-x[,1] %in% c("integer", "numeric")

if(sum(a)==0) {df <- data.frame(NULL)}
else{
  data2<- data[,a,drop=FALSE]
  df <- round(as.data.frame(psych::describe(data2))[,-c(1,6,7)],6)
  rownames(df) = names(data2)
  colnames(df) <- c("Total Number of Valid Values", "Mean" ,"SD", "Median", "Minimum", "Maximum", "Range","Skew","Kurtosis","SE")
}

return(df)
}