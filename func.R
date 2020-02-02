## functions for MEPHAS

##' @title plot functions in MEPHAS
##'
##' @param data input data frame
##' @param varx input x variable name
##' @param vary input y variable name
##'
##' @export
plot_scat <- function(data, varx, vary){
  x = data[, varx]
  y = data[, vary]
  name <- rownames(data)
  ggplot(data, aes(x=x,y=y,label=name)) +
    geom_point(shape = 19, size=1) +
    geom_smooth(method = "lm", size=0.5) +
    xlab(varx) + ylab(vary) +
    theme_minimal() + theme(legend.title = element_blank())
}
##' @title plot functions in MEPHAS
##'
##' @param data input data frame
##' @param varx input x variable name
##' @param vary input y variable name
##'
##' @export
plot_slgt <- function(data, varx, vary){
  x = data[, varx]
  y = as.numeric(as.factor(data[, vary]))-1
  name <- rownames(data)
  ggplot(data, aes(x=x, y=y,label=name)) +
  geom_point(shape = 19,  size = 1) +
  stat_smooth(method="glm", method.args=list(family="binomial"), se=FALSE,  size = 0.5) +
  xlab(varx) + ylab(vary) +
  theme_minimal() + theme(legend.title = element_blank())
}
##' @title plot functions in MEPHAS
##'
##' @param data input data frame
##' @param varx input x variable name
##' @param vary input y variable name
##'
##' @export
plot_res <- function(data, varx, vary){
  x = data[, varx]
  y = data[, vary]
  name <- rownames(data)
  ggplot(data, aes(x=x, y=y,label=name))+
  geom_point(shape = 19, size=1) +
  stat_smooth(method="loess", size=0.5)+
  geom_hline(yintercept=0, col="red", linetype="dashed", size=0.3)+
  xlab("Fitted values")+ylab("Residuals")+
  theme_minimal() + theme(legend.title = element_blank())
}

##' @title plot functions in MEPHAS
##'
##' @param data input data frame
##' @param varx input x variable name
##'
##' @export
plot_box1 <- function(data, varx){
  value = data[,varx]
  ggplot(data, aes(x = varx, y = value)) +
  geom_boxplot(outlier.colour = "red", fill="cornflowerblue", size=0.3) +
  xlab("")+ylab("")+
  theme_minimal() + theme(legend.title = element_blank())
}

##' @title plot functions in MEPHAS
##'
##' @param data2 input data frame
##'
##' @export
plot_box2 <- function(data2){
  data2$group <- rownames(data2)
  data <- reshape::melt(data2, id="group")
  value = data$value
  variable = data$variable
  ggplot(data, aes(x = variable, y = value, fill = variable)) +
  geom_boxplot(outlier.colour = "red",size=0.3) +
  scale_fill_brewer(palette="Set1")+
  theme_minimal() + theme(legend.title = element_blank())

}
##' @title plot functions in MEPHAS
##'
##' @param datam input data frame
##'
##' @export
plot_boxm <- function(datam){
  #data <- reshape::melt(datam, id=names(datam))
  value = datam[,1]
  variable = datam[,2]
  ggplot(datam, aes(x = variable, y = value, fill = variable)) +
  geom_boxplot(outlier.colour = "red",size=0.3) +
  scale_fill_brewer(palette="Set1")+
  theme_minimal() + theme(legend.title = element_blank())

}


##' @title plot functions in MEPHAS
##'
##' @param data input data frame
##' @param varx input x variable name
##'
##' @export
plot_msd1 <- function(data, varx){
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

##' @title plot functions in MEPHAS
##'
##' @param data input data frame
##'
##' @export
plot_msd2 <- function(data){
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

##' @title plot functions in MEPHAS
##'
##' @param datam input data frame
##' @param var input variable name
##' @param grp input factor group variable name
##'
##' @export
plot_msdm <- function(datam, var, grp){
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


##' @title plot functions in MEPHAS
##'
##' @param data input data frame
##' @param varx input x variable name
##' @param vary input y variable name
##'
##' @export
plot_line1 <- function(data, varx, vary){
  x <- data[,varx]
  y <- data[,vary]
  ggplot(data, aes(x=x, y=y)) + 
  geom_line() +
  ylim(0,1) +
  xlab("") +ylab("")+
  geom_point(shape = 19, size=0.5) +
  scale_colour_brewer(palette="Set1")+
  theme_minimal() + theme(legend.title = element_blank())
}

##' @title plot functions in MEPHAS
##'
##' @param data2 input data frame
##' @param var input variable name
##' @param grp1 input factor group 1 name
##' @param grp2 input factor group 2 name
##'
##' @export
plot_line2 <- function(data2, var, grp1, grp2){
  des <- data.frame(psych::describeBy(data2[,var], list(data2[,grp1],data2[,grp2]), mat=TRUE))
  group1 <-des[,"group1"]
  group2 <-des[,"group2"]
  mean   <-des[,"mean"]

  ggplot(des, aes(x=group1, y=mean, colour=group2, group=group2)) +
  geom_line() +
  xlab("") +ylab("")+
  geom_point(shape = 19, size=1) +
  scale_colour_brewer(palette="Set1")+
  theme_minimal() + theme(legend.title = element_blank())
}


plot_mat <- function(data, ybreak){
data$id <- 1:nrow(data) 
plot_data <- reshape::melt(data, id.var=c("id", ybreak))
y <- plot_data[,ybreak]
value <- plot_data[,"value"]
variable <- plot_data[,"variable"]
ggplot(plot_data, aes(x=value, y=y, group=variable)) +
  geom_line(aes(lty=as.factor(variable))) +
  theme_minimal() + theme(legend.title = element_blank())
}

##' @title plot functions in MEPHAS
##'
##' @param data input data frame
##' @param varx input x variable name
##' @param bw input bin numbers
##'
##' @export plot_hist1
plot_hist1 <- function(data, varx, bw){

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

##' @title plot functions in MEPHAS
##'
##' @param data input data frame
##' @param varx input x variable name
##' @param bw input bin numbers
##'
##' @export plot_hist1c
plot_hist1c <- function(data, varx, bw){

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


##' @title plot functions in MEPHAS
##'
##' @param data2 input data frame
##' @param bw input bin numbers
##'
##' @export
plot_hist2 <- function(data2, bw){
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


##' @title plot functions in MEPHAS
##'
##' @param data input data frame
##' @param varx input x variable name
##'
##' @export
plot_density1 <- function(data, varx){
  variable = data[, varx]
  ggplot(data, aes(x = variable)) +
  geom_density(size=0.3) +
  xlab(varx) +
  theme_minimal() + theme(legend.title = element_blank())
}


##' @title plot functions in MEPHAS
##'
##' @param data2 input data frame
##'
##' @export
plot_density2 <- function(data2){
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


##' @title plot functions in MEPHAS
##'
##' @param data input data frame
##' @param varx input x sample name
##'
##' @export
plot_qq1 <- function(data, varx){
  variable = data[, varx]
  names <- rownames(data)
  ggplot(data, aes(sample = variable)) +
    stat_qq() + stat_qq_line(size=0.3, colour="red")+
    xlab(varx) +
    theme_minimal() + theme(legend.title = element_blank())
}


##' @title plot functions in MEPHAS
##'
##' @param data2 input data frame
##'
##' @export
plot_qq2 <- function(data2){
  data2$group <- rownames(data2)
  data <- reshape::melt(data2, id="group")
  value <- data$value
  variable <- factor(data$variable)
  ggplot(data, aes(sample = value, color=variable)) +
    stat_qq() + stat_qq_line()+
    xlab("") +
    scale_colour_brewer(palette="Set1")+
    theme_minimal() + theme(legend.title = element_blank())
}


##' @title plot functions in MEPHAS
##'
##' @param data input data frame
##'
##' @export
plot_pie <- function(data){
  value <- data[,"value"]
  groups <- data[,"group"]
  ggplot(data, aes(x=" ", y=value, fill=groups))+
  geom_bar(width = 1, stat = "identity", alpha = 0.7) +
  coord_polar("y", start=0) +
  xlab("")+ ylab("") +
  scale_fill_brewer(palette="Set1")+
  theme_minimal()+theme(legend.title=element_blank())

}



##' @title plot functions in MEPHAS
##'
##' @param count input count data frame
##'
##' @export
plot_bar <- function(count){
  mx <- reshape(count, varying = list(names(count)), times = names(count), ids = row.names(count), direction = "long")
  group <- mx[,"time"]
  value <- mx[,2]
  status <- mx[,"id"]
    ggplot(mx, aes(x = group, y = value, fill = status))+
    geom_bar(stat = "identity", position = position_dodge(), colour="white", size=0.3, alpha=0.7) +
    ylab("") + xlab("") + labs(fill = "") +
    scale_fill_brewer(palette="Set1")+
    theme_minimal() +theme(legend.title=element_blank())
}


##' @title plot functions in MEPHAS
##'
##' @param count input count data frame
##'
##' @export
plot_bar1 <- function(count){
  mx <- reshape(count, varying = list(names(count)), times = names(count), ids = row.names(count), direction = "long")
  group <- mx[,"time"]
  value <- mx[,2]
  status <- mx[,"id"]
    ggplot(mx, aes(x = group, y = value, fill = status))+
    geom_bar(position="fill", stat="identity", colour="white", size=0.3, alpha=0.7) +
    ylab("") + xlab("") +
    scale_fill_brewer(palette="Set1")+
    theme_minimal() +theme(legend.title=element_blank())
}


##' @title plot functions in MEPHAS
##'
##' @param yhat predicted values
##' @param y itrue values
##'
##' @export
plot_roc <- function(yhat, y){

  p <- ROCR::prediction(yhat, y)
  ps <- ROCR::performance(p, "tpr", "fpr")
  pf <- ROCR::performance(p, "auc")

  df <- data.frame(
    tpr=unlist(ps@y.values),
    fpr=unlist(ps@x.values))

 fpr <- df[,"fpr"]
 tpr <- df[,"tpr"]

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


##' @title plot functions in MEPHAS
##'
##' @param data input data frame
##'
##' @export
plot_coxstep <-function(data){
  time <- data[,"time"]
  hazard <- data[,"H"]
  ggplot() +
  geom_step(data = data, mapping = aes(x = time, y = hazard)) +
  geom_abline(intercept =0,slope = 1, color = "red") +
  theme_minimal() + 
  xlab("Cox-Snell residuals") + ylab("Estimated Cumulative Hazard Function")
}


##' @title plot functions in MEPHAS
##'
##' @param data input data frame
##'
##' @export
plot_devres <- function(data){
  id <- data[,"id"]
  dev <- data[,"dev"]
  ggplot(data, aes(x=id, y=dev)) +
  geom_point(shape = 19, size=1) +
  geom_hline(yintercept = 0, color="red", linetype=2)+
  geom_smooth(method = "loess", linetype=2) +
  theme_minimal() +
  xlab("Observation Id") + ylab("Deviance residuals") 
}



##' @title plot functions in MEPHAS
##'
##' @param loads input loading data frame
##' @param a number of components
##'
##' @export
plot_load <- function(loads, a){

  ll <- loads
  ll$group <- rownames(ll)
  loads.m <- reshape::melt(ll, id="group",
                              measure=colnames(ll)[1:a])
  group <- loads.m[,"group"]
  value <- loads.m[,"value"]
  #variable <- loads.m[,"variable"]
  ggplot(loads.m, aes(group, abs(value), fill=value)) +
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

##' @title plot functions in MEPHAS
##'
##' @param scores input score data frame
##' @param varx input x variable
##' @param vary input y variable
##'
##' @export
plot_scoreg <- function(scores, n1, n2){
  x <- scores[,n1]
  y <- scores[,n2]
  group <- as.factor(scores[,"group"])
  name <- rownames(scores)
  varx <- names(scores)[n1]
  vary <- names(scores)[n2]

  ggplot(scores,aes(x = x, y = y, color=group, label=name, alpha=0.7))+
  geom_point() + geom_hline(yintercept=0, lty=2,size=0.3) +
  geom_vline(xintercept=0, lty=2,size=0.3)+
  xlab(varx)+ylab(vary)+
  scale_colour_brewer(palette="Set1")+
  theme_minimal()+theme(legend.title=element_blank())

}

##' @title plot functions in MEPHAS
##'
##' @param scores input score data frame
##' @param varx input x variable
##' @param vary input y variable
##'
##' @export
plot_scorec <- function(scores, n1, n2, type){
  x <- scores[,n1]
  y <- scores[,n2]
  group <- as.factor(scores[,"group"])
  name <- rownames(scores)
  varx <- names(scores)[n1]
  vary <- names(scores)[n2]

  ggplot(scores,aes(x = x, y = y, label=name, color=group, alpha=0.7))+
  geom_point() + 
  geom_hline(yintercept=0, lty=2,size=0.3) +
  geom_vline(xintercept=0, lty=2,size=0.3)+
  stat_ellipse(type = type)+
  xlab(varx)+ylab(vary)+
  scale_colour_brewer(palette="Set1")+
  theme_minimal()+theme(legend.title=element_blank())

}

##' @title plot functions in MEPHAS
##'
##' @param scores input score data frame
##' @param varx input x variable
##' @param vary input y variable
##'
##' @export
plot_score <- function(scores, n1, n2){
  x <- scores[,n1]
  y <- scores[,n2]
  name <- rownames(scores)
  varx <- names(scores)[n1]
  vary <- names(scores)[n2]

  ggplot(scores,aes(x = x, y = y, label=name))+
  geom_point(color="lightblue4", alpha=0.7) + 
  geom_hline(yintercept=0, lty=2,size=0.3) +
  geom_vline(xintercept=0, lty=2,size=0.3)+
  xlab(varx)+ylab(vary)+
  scale_fill_brewer(palette="Set1")+
  theme_minimal()+theme(legend.title=element_blank())
}

##' @title plot functions in MEPHAS
##'
##' @param scores input score data frame
##' @param loads input loading data frame
##' @param n1 input nth component
##' @param n2 input nth component
##'
##' @export
plot_biplot <- function(scores, loads, n1, n2){
names <- rownames(loads)
pname <- rownames(scores)
loads[[n1]]<-scales::rescale(loads[[n1]], to = c(min(scores[[n1]]),max(scores[[n1]])))
loads[[n2]]<-scales::rescale(loads[[n2]], to = c(min(scores[[n2]]),max(scores[[n2]])))

x1 <- scores[,n1]
y1 <- scores[,n2]
x2 <- loads[,n1]
y2 <- loads[,n2]
varx <- names(scores)[n1]
vary <- names(scores)[n2]
ggplot()+
geom_point(data=scores, aes(x=x1, y=y1, label=pname), colour ="cornflowerblue", alpha=0.5)+
geom_segment(data=loads, aes(x=0, y=0, xend=x2, yend=y2), 
             arrow=arrow(length=unit(0.3,"cm")), alpha=0.5, colour="red")+
geom_text(data=loads, aes(x=x2, y=y2, label=names), alpha=0.5, size=3)+
xlab(varx)+ylab(vary)+
theme_minimal()+theme(legend.title=element_blank())
}

##' @title plot functions in MEPHAS
##'
##' @param data correaltion matrix
##'
##' @export
plot_corr <- function(data){
  c <- as.data.frame(cor(data))
  c <- c[ , order(names(c))]
  c <- c[order(rownames(c)),]
  c$group <- rownames(c)
  corrs.m <- reshape::melt(c, id="group", measure=rownames(c))
  group <- corrs.m[,1]
  value <- corrs.m[,3]
  variable <- corrs.m[,2]

  ggplot(corrs.m, aes(x=group, y=variable, fill=abs(value))) +
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

###----------plotly plot

plot_piely <- function(data){
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

plot_3D <- function(scores, loads, nx,ny,nz, scale){
  
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
