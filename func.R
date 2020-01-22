MFSscat <- function(data, varx, vary){
  x = data[, varx]
  y = data[, vary]
  ggplot(data, aes(x=x,y=y)) + 
    geom_point(shape = 19, size=1) + 
    geom_smooth(method = "lm", size=0.5) + 
    xlab(varx) + ylab(vary) + 
    theme_minimal() + theme(legend.title = element_blank())
}

MFSslgt <- function(data, varx, vary){
  x = data[, varx]
  y = as.numeric(as.factor(data[, vary]))-1
  ggplot(data, aes(x=x, y=y)) + 
  geom_point(shape = 19,  size = 1) + 
  stat_smooth(method="glm", method.args=list(family="binomial"), se=FALSE,  size = 0.5) +
  xlab(varx) + ylab(vary) +  
  theme_minimal() + theme(legend.title = element_blank())
}

MFSres <- function(data, varx, vary){
  x = data[, varx]
  y = data[, vary]
  ggplot(data, aes(x=x, y=y))+
  geom_point(shape = 19, size=1) + 
  stat_smooth(method="loess", size=0.5)+
  geom_hline(yintercept=0, col="red", linetype="dashed", size=0.3)+
  xlab("Fitted values")+ylab("Residuals")+
  theme_minimal() + theme(legend.title = element_blank())
}

##----------##----------##----------##----------##----------##----------##
MFSbox1 <- function(data, varx){
  value = data[,varx]
  ggplot(data, aes(x = varx, y = value)) + 
  geom_boxplot(outlier.colour = "red", fill="cornflowerblue", size=0.3) + 
  xlab("")+ylab("")+
  theme_minimal() + theme(legend.title = element_blank())
}

MFSbox2 <- function(data2){
  data2$group <- rownames(data2)
  data <- reshape::melt(data2, id="group")
  value = data$value
  variable = data$variable
  ggplot(data, aes(x = variable, y = value, fill = variable)) + 
  geom_boxplot(outlier.colour = "red",size=0.3) + 
  scale_fill_brewer(palette="Set1")+
  theme_minimal() + theme(legend.title = element_blank())
  
}

MFSboxm <- function(datam){
  #data <- reshape::melt(datam, id=names(datam))
  value = datam[,1]
  variable = datam[,2]
  ggplot(datam, aes(x = variable, y = value, fill = variable)) + 
  geom_boxplot(outlier.colour = "red",size=0.3) + 
  scale_fill_brewer(palette="Set1")+
  theme_minimal() + theme(legend.title = element_blank())
  
}

##----------##----------##----------##----------##----------##----------##

MFSmsd1 <- function(data, varx){
  des <- data.frame(psych::describe(data[, varx]))
  rownames(des) = varx
  variable <-rownames(des)
  mean <- des[,"mean"]
  sd <- des[,"sd"]
  ggplot(des, aes(x = variable, y = mean)) + 
  #ylab(expression(Mean %+-% SD)) + 
  ylab("Mean with standard deviation bar") + 
  xlab("")+
  geom_bar(position = position_dodge(), stat = "identity", width = 0.3, fill="cornflowerblue") + 
  geom_errorbar(width = .1, position = position_dodge(.9), aes(ymin = mean - sd, ymax = mean + sd), data = des) +
  theme_minimal() + theme(legend.title = element_blank())
}

MFSmsd2 <- function(data){
  des = data.frame(psych::describe(data))
  rownames(des) = names(data)
  variable <-rownames(des)
  mean <- des[,"mean"]
  sd <- des[,"sd"]
  ggplot(des, aes(x = variable, y = mean, fill = variable)) + 
  #ylab(expression(Mean %+-% SD)) + 
  ylab("Mean with standard deviation bar") + 
  xlab("")+
  geom_bar(position = position_dodge(), stat = "identity", width = 0.3) + 
  geom_errorbar(width = .1, position = position_dodge(.9), aes(ymin = mean - sd, ymax = mean + sd), data = des) +
  scale_fill_brewer(palette="Set1")+ 
  theme_minimal() + theme(legend.title = element_blank())
}

MFSmsdm <- function(datam, var, grp){
  des = data.frame(psych::describeBy(datam[,var], datam[,grp], mat=TRUE))
  rownames(des) = des[,"group1"]
  variable <-rownames(des)
  mean <- des[,"mean"]
  sd <- des[,"sd"]
  ggplot(des, aes(x = variable, y = mean, fill = variable)) + 
  #ylab(expression(Mean %+-% SD)) + 
  ylab("Mean with standard deviation bar") + 
  xlab("")+
  geom_bar(position = position_dodge(), stat = "identity", width = 0.3) + 
  geom_errorbar(width = .1, position = position_dodge(.9), aes(ymin = mean - sd, ymax = mean + sd), data = des) +
  scale_fill_brewer(palette="Set1")+ 
  theme_minimal() + theme(legend.title = element_blank())
}

##----------##----------##----------##----------##----------##----------##
MFSline2 <- function(data2, var, grp1, grp2){
  des <- data.frame(psych::describeBy(data2[,var], list(data2[,grp1],data2[,grp2]), mat=TRUE))
  group1 <-des[,"group1"]
  group2 <-des[,"group2"]
  mean   <-des[,"mean"]

  ggplot(des, aes(x=group1, y=mean, colour=group2, group=group2)) + 
  geom_line() + 
  xlab("") +ylab("")+
  geom_point(shape=21, size=1) +
  scale_colour_brewer(palette="Set1")+ 
  theme_minimal() + theme(legend.title = element_blank())
}


##----------##----------##----------##----------##----------##----------##

MFShist1 <- function(data, varx, bw){
  
  variable = data[, varx]
  if (bw==0) {
  ggplot(data, aes(x = variable)) + 
      stat_bin(colour = "white", fill = "lightblue4", size = 0.1, alpha = 0.7) + 
      xlab(varx) + 
      theme_minimal() + theme(legend.title = element_blank())  
  }
  else{
  ggplot(data, aes(x = variable)) + 
    stat_bin(bins=bw, colour = "white", fill = "lightblue4", size = 0.1, alpha = 0.7) + 
    xlab(varx) + 
    theme_minimal() + theme(legend.title = element_blank())
  }
}

MFShist1c <- function(data, varx, bw){
  
  variable = data[, varx]
  if (bw==0) {
    ggplot(data, aes(x = variable)) + 
      stat_bin(colour = "white", fill = "cornflowerblue", size = 0.1, alpha = 0.7) + 
      xlab(varx) + 
      theme_minimal() + theme(legend.title = element_blank())  
  }
  else{
    ggplot(data, aes(x = variable)) + 
      stat_bin(bins=bw, colour = "white", fill = "cornflowerblue", size = 0.1, alpha = 0.7) + 
      xlab(varx) + 
      theme_minimal() + theme(legend.title = element_blank())
  }
}

MFShist2 <- function(data2, bw){
  data2$group <- rownames(data2)
  data <- reshape::melt(data2, id="group")
  value = data$value
  variable = data$variable
  if (bw==0) {
    ggplot(data, aes(x = value, colour = variable, fill = variable)) + 
      stat_bin(colour = "white", size=0.1, alpha = .5, position = "identity") + 
      xlab("") + 
      scale_fill_brewer(palette="Set1")+
      theme_minimal() + theme(legend.title = element_blank())
  }
  else{
    ggplot(data, aes(x = value, colour = variable, fill = variable)) + 
      stat_bin(bins = bw, colour = "white", size=0.1,alpha = .5, position = "identity") + 
      xlab("") + 
      scale_fill_brewer(palette="Set1")+
      theme_minimal() + theme(legend.title = element_blank())
  }
}

##----------##----------##----------##----------##----------##----------##

MFSdensity1 <- function(data, varx){
  variable = data[, varx]
  ggplot(data, aes(x = variable)) + 
  geom_density(size=0.3) + 
  xlab(varx) + 
  theme_minimal() + theme(legend.title = element_blank())
}

MFSdensity2 <- function(data2){
  data2$group <- rownames(data2)
  data <- reshape::melt(data2, id="group")
  value = data$value
  variable = data$variable
  ggplot(data, aes(x = value, colour=variable)) + 
    geom_density(size=0.3) + 
    xlab("") + 
    scale_colour_brewer(palette="Set1")+
    theme_minimal() + theme(legend.title = element_blank())
}

##----------##----------##----------##----------##----------##----------##

MFSqq1 <- function(data, varx){
  variable = data[, varx]
  ggplot(data, aes(sample = variable)) + 
    stat_qq() + stat_qq_line(size=0.3, colour="red")+
    xlab(varx) + 
    theme_minimal() + theme(legend.title = element_blank())
}

MFSqq2 <- function(data2){
  data2$group <- rownames(data2)
  data <- reshape::melt(data2, id="group")
  value <- data$value
  variables <- factor(data$variable)
  ggplot(data, aes(sample = value, color=variable)) + 
    stat_qq() + stat_qq_line()+
    xlab("") + 
    scale_colour_brewer(palette="Set1")+
    theme_minimal() + theme(legend.title = element_blank())
}

##----------##----------##----------##----------##----------##----------##
MFSpie <- function(data){
  value <- data[,"value"]
  groups <- data[,"group"]
  ggplot(data, aes(x=" ", y=value, fill=groups))+ 
  geom_bar(width = 1, stat = "identity", alpha = 0.7) + 
  coord_polar("y", start=0) + 
  xlab("")+ ylab("") + 
  scale_fill_brewer(palette="Set1")+
  theme_minimal()+theme(legend.title=element_blank())

}

MFSpiely <- function(data){
  value <- data[,"value"]
  groups <- data[,"group"]
  colors <- c('rgb(211,94,96)', 'rgb(114,147,203)')
  plotly::plot_ly(data, labels = ~group, values = ~value, type = 'pie',
    textposition = 'inside',textinfo = 'label+percent',
    marker = list(colors = colors, line = list(color = '#FFFFFF', width = 1))) %>%
  layout(
         xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
         yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
}

##----------##----------##----------##----------##----------##----------##

MFSbar <- function(count){
  mx <- reshape(count, varying = list(names(count)), times = names(count), ids = row.names(count), direction = "long")
  variables <- mx[,"time"]
  value <- mx[,2]
  groups <- mx[,"id"]
    ggplot(mx, aes(x = variables, y = value, fill = groups))+
    geom_bar(stat = "identity", position = position_dodge(), colour="white", size=0.3, alpha=0.7) + 
    ylab("") + xlab("") + labs(fill = "") + 
    scale_fill_brewer(palette="Set1")+
    theme_minimal() +theme(legend.title=element_blank())
}

MFSbar1 <- function(count){
  mx <- reshape(count, varying = list(names(count)), times = names(count), ids = row.names(count), direction = "long")
  variables <- mx[,"time"]
  value <- mx[,2]
  groups <- mx[,"id"]
    ggplot(mx, aes(x = variables, y = value, fill = groups))+
    geom_bar(position="fill", stat="identity", colour="white", size=0.3, alpha=0.7) + 
    ylab("") + xlab("") +  
    scale_fill_brewer(palette="Set1")+
    theme_minimal() +theme(legend.title=element_blank())
}
##----------##----------##----------##----------##----------##----------##
MFSroc <- function(yhat, y){

  p <- ROCR::prediction(yhat, y)
  ps <- ROCR::performance(p, "tpr", "fpr")
  pf <- ROCR::performance(p, "auc")

  df <- data.frame(
    tpr=unlist(ps@y.values), 
    fpr=unlist(ps@x.values))

  ggplot(df, aes(fpr,tpr)) + 
  #geom_step() +
  geom_line() +
  geom_point(size=0.5, color="cornflowerblue") +
  coord_cartesian(xlim=c(0,1), ylim=c(0,1)) +
  ggtitle("") +
  xlab("False positive rate (1-specificity)")+
  ylab("True positive rate (sensitivity)")+
  theme_minimal() +theme(legend.title=element_blank())+
  annotate("text", x = .75, y = .25, label = paste("AUC =",pf@y.values))

}

##----------##----------##----------##----------##----------##----------##


###----------PCA and PLS

MFS3D <- function(scores, loads, nx,ny,nz, scale){
  
  x <- scores[,nx]
  y <- scores[,ny]
  z <- scores[,nz]
  scale.loads <- scale
  layout <- list(
    scene = list(
      xaxis = list(
        title = names(scores)[nx], 
        showline = TRUE
      ), 
      yaxis = list(
        title = names(scores)[ny], 
        showline = TRUE
      ), 
      zaxis = list(
        title = names(scores)[nz], 
        showline = TRUE
      )
    )#, 
    #title = "FA (3D)"
  )
  
  rnn <- rownames(as.data.frame(scores))
  
  p <- plot_ly() %>%
    add_trace(x=x, y=y, z=z, 
              type="scatter3d", mode = "text+markers", 
              name = "original", 
              linetypes = NULL, 
              opacity = 0.5,
              marker = list(size=2),
              text = rnn) %>%
    layout(p, scene=layout$scene, title=layout$title)
  
  for (k in 1:nrow(loads)) {
    x <- c(0, loads[k,1])*scale.loads
    y <- c(0, loads[k,2])*scale.loads
    z <- c(0, loads[k,3])*scale.loads
    p <- p %>% add_trace(x=x, y=y, z=z,
                         type="scatter3d", mode="lines",
                         line = list(width=4),
                         opacity = 1) 
  }
  p
}
  

MFSload <- function(loads, a){
  
  ll <- loads
  ll$group <- rownames(ll)
  loadings.m <- reshape::melt(ll, id="group",
                              measure=colnames(ll)[1:a])
  
  ggplot(loadings.m, aes(group, abs(value), fill=value)) + 
    facet_wrap(~ variable, nrow=1) + #place the factors in separate facets
    geom_bar(stat="identity") + #make the bars
    coord_flip() + #flip the axes so the test names can be horizontal  
    #define the fill colour gradient: blue=positive, red=negative
    scale_fill_gradient2(name = "Loading", 
                         high = "blue", mid = "white", low = "red", 
                         midpoint=0, guide=F) +
    ylab("Loading Strength") + #improve y-axis label
    theme_bw(base_size=10)
}

MFScorr <- function(data){
  c <- as.data.frame(cor(data))
  c$group <- rownames(c)
  corrs.m <- reshape::melt(c, id="group",
                           measure=rownames(c))
  
  ggplot(corrs.m, aes(group, variable, fill=abs(value))) + 
    geom_tile() + #rectangles for each correlation
    #add actual correlation value in the rectangle
    geom_text(aes(label = round(value, 2)), size=2.5) + 
    theme_bw(base_size=10) + #black and white theme with set font size
    #rotate x-axis labels so they don't overlap, 
    #get rid of unnecessary axis titles
    #adjust plot margins
    theme(axis.text.x = element_text(angle = 90), 
          axis.title.x=element_blank(), 
          axis.title.y=element_blank(), 
          plot.margin = unit(c(3, 1, 0, 0), "mm")) +
    #set correlation fill gradient
    scale_fill_gradient(low="white", high="red") + 
    guides(fill=F) #omit unnecessary gradient legend
  
}

