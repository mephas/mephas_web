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
  
  variable = data[, varx]
  if (bw==0) {
  ggplot(data, aes(x = variable)) + 
      stat_bin(color = "white", fill = "grey", size = 0.1, alpha = 1) + 
      xlab(varx) + 
      theme_minimal() + theme(legend.title = element_blank())  
  }
  else{
  ggplot(data, aes(x = variable)) + 
    stat_bin(bins=bw, color = "white", fill = "grey", size = 0.1, alpha = 1) + 
    xlab(varx) + 
    theme_minimal() + theme(legend.title = element_blank())
  }
}

MFShist1c <- function(data, varx, bw){
  
  variable = data[, varx]
  if (bw==0) {
    ggplot(data, aes(x = variable)) + 
      stat_bin(color = "white", fill = "cornflowerblue", size = 0.1, alpha = 1) + 
      xlab(varx) + 
      theme_minimal() + theme(legend.title = element_blank())  
  }
  else{
    ggplot(data, aes(x = variable)) + 
      stat_bin(bins=bw, color = "white", fill = "cornflowerblue", size = 0.1, alpha = 1) + 
      xlab(varx) + 
      theme_minimal() + theme(legend.title = element_blank())
  }
}

MFSdensity1 <- function(data, varx){
  variable = data[, varx]
  ggplot(data, aes(x = variable)) + 
  geom_density(size=0.3) + 
  xlab(varx) + 
  theme_minimal() + theme(legend.title = element_blank())
}

MFSqq1 <- function(data, varx){
  variable = data[, varx]
  ggplot(data, aes(sample = variable)) + 
    stat_qq() + stat_qq_line(size=0.3, color="red")+
    xlab(varx) + 
    theme_minimal() + theme(legend.title = element_blank())
}

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
    #define the fill color gradient: blue=positive, red=negative
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

