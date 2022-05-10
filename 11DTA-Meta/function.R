logit.data <- function(data){
  
  sens <- data$TP/(data$TP+data$FN)
  spec <- data$TN/(data$TN+data$FP)
  
  y1 <- qlogis(sens)  ##y1 <- log(sens/(1-sens))
  y2 <- qlogis(spec)  ##y2 <- log(spec/(1-spec))
  
  v1 <- (1/data$TP)+(1/data$FN)
  v2 <- (1/data$TN)+(1/data$FP)
  
  data.frame(sens = sens,
             spec = spec,
             y1 = y1,
             y2 = y2,
             v1 = v1,
             v2 = v2)
  
}
correction <- function(data,value = 0.5,type = c("single", "all")){  
  type <- match.arg(type)
  
  if(type == "all"){
    
    if(any(c(data$TP,data$FN,data$FP,data$TN) == 0)){
      
      data$TP <- data$TP + value
      data$FN <- data$FN + value
      data$FP <- data$FP + value
      data$TN <- data$TN + value
    }
  }
  
  if(type == "single"){
    
    correction = ((((data$TP == 0)|(data$FN == 0))|(data$FP == 0))| (data$TN == 0)) * value
    
    data$TP <- correction + data$TP
    data$FN <- correction + data$FN
    data$FP <- correction + data$FP
    data$TN <- correction + data$TN
    
  }
  return(data)
}
