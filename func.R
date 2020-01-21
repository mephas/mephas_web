MFSscat <- function(data, varx, vary){
  x = data[, varx]
  y = data[, vary]
  ggplot(data, aes(x=x,y=y)) + 
    geom_point(shape = 19, size=1) + 
    geom_smooth(method = "lm", size=0.5) + 
    xlab(varx) + ylab(vary) + 
    theme_minimal() + theme(legend.title = element_blank())
}

MFShist1 <- function(data, varx, bw){
  
  var = data[, varx]
  if (bw==0) {
  ggplot(data, aes(x = var)) + 
      stat_bin(fill = "grey",color="black", size=0.3, alpha = 1) + 
      xlab(varx) + 
      theme_minimal() + theme(legend.title = element_blank())  
  }
  else{
  ggplot(data, aes(x = var)) + 
    stat_bin(bins=bw, fill = "grey",color="black", alpha = 1, size=0.3, position = "identity") + 
    xlab(varx) + 
    theme_minimal() + theme(legend.title = element_blank())
  }
}

MFSdensity1 <- function(data, varx){
  var = data[, varx]
  ggplot(data, aes(x = var)) + 
  geom_density(size=0.3) + 
  xlab(varx) + 
  theme_minimal() + theme(legend.title = element_blank())
}
