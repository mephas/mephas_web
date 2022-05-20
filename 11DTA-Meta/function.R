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
.reform.est <- function(est,p.seq)
{
  est <- est[-c(1, 20,21),]
  sauc.ci <- sprintf("%.3f (%.3f, %.3f)", est[1,], est[2,], est[3,])
  se.ci   <- sprintf("%.3f (%.3f, %.3f)", est[4,], est[5,], est[6,])
  sp.ci   <- sprintf("%.3f (%.3f, %.3f)", est[7,], est[8,], est[9,])
  b.ci    <- sprintf("%.3f (%.3f, %.3f)", est[10,], est[11,], est[12,])
  
  tb <- data.frame(p.seq=p.seq, 
                   sauc.ci= sauc.ci, 
                   se.ci = se.ci,
                   sp.ci = sp.ci,
                   b.ci = b.ci, 
                   round(t(est[-c(1:12),]),3)
  )#[, -c(8:9, 13:14, 18:19)]
  
  colnames(tb) <- c("$p$", "SAUC (95\\%CI)",
                    "Se (95\\%CI)", "Sp (95\\%CI)",
                    "$\\beta$ (95\\%CI)", "$\\alpha_p$",
                    "$\\mu_1$", "$\\mu_2$", "$\\tau_1$","$\\tau_2$","$\\rho$"
  )
  rownames(tb) <- NULL
  
  tb
  
}