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

correction <- function(data, value = 0.5,type = c("single", "all")){  
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

reform.dtametasa<-function(fun=est.rf,p.seq,c1.square=0.5,fix.c=TRUE,informMessage="Please click to calculate SROC."){
  #est.rf<-match.fun(est.rf)
  sauc.ci<-sapply(p.seq,function(p){
    sauc<-try(sprintf("%.3f (%.3f, %.3f)", fun(c1.square,fix.c,par ="sauc.ci","sauc",p=p,informMessage=informMessage),fun(c1.square,fix.c,par ="sauc.ci","sauc.lb",p=p,informMessage=informMessage),fun(c1.square,fix.c,par ="sauc.ci","sauc.ub",p=p,informMessage=informMessage)),silent=TRUE)
    if(inherits(sauc,"try-error"))return("NA (NA,NA)")
    sauc
  })
  #sauc.ci <- try(sprintf("%.3f (%.3f, %.3f)", fun(c1.square,fix.c,par ="sauc.ci","sauc"),fun(c1.square,fix.c,par ="sauc.ci","sauc.lb"),fun(c1.square,fix.c,par ="sauc.ci","sauc.ub")))
  se.ci   <- sapply(p.seq,function(p){
    se<-try(sprintf("%.3f (%.3f, %.3f)", fun(c1.square,fix.c,par ="mu1.ci","sens",p=p,informMessage=informMessage),fun(c1.square,fix.c,par ="mu1.ci","se.lb",p=p,informMessage=informMessage),fun(c1.square,fix.c,par ="mu1.ci","se.ub",p=p,informMessage=informMessage)),silent=TRUE)
    if(inherits(se,"try-error"))return("NA (NA,NA)")
    se
  })
  sp.ci   <- sapply(p.seq,function(p){
    sp<-try(sprintf("%.3f (%.3f, %.3f)", fun(c1.square,fix.c,par ="mu2.ci","spec",p=p,informMessage=informMessage),fun(c1.square,fix.c,par ="mu2.ci","sp.lb",p=p,informMessage=informMessage),fun(c1.square,fix.c,par ="mu2.ci","sp.ub",p=p,informMessage=informMessage)),silent=TRUE)
    if(inherits(sp,"try-error"))return("NA (NA,NA)")
    sp
  })
  b.ci    <- sapply(p.seq,function(p){
    b<-try(sprintf("%.3f (%.3f, %.3f)", fun(c1.square,fix.c,par ="beta.ci","beta",p=p,informMessage=informMessage),fun(c1.square,fix.c,par ="beta.ci","beta.lb",p=p,informMessage=informMessage),fun(c1.square,fix.c,par ="beta.ci","beta.ub",p=p,informMessage=informMessage)),silent=TRUE)
    if(inherits(b,"try-error"))return("NA (NA,NA)")
    b
  })
  # if(inherits(sauc.ci,'try-error')) sauc.ci<-rep("NA (NA,NA)",length(p.seq))
  # if(inherits(se.ci,'try-error')) se.ci<-rep("NA (NA,NA)",length(p.seq))
  # if(inherits(sp.ci,'try-error')) sp.ci<-rep("NA (NA,NA)",length(p.seq))
  # if(inherits(b.ci,'try-error')) b.ci<-rep("NA (NA,NA)",length(p.seq))
  par<-fun(c1.square,fix.c,c("mu1","mu2","tau1","tau2","rho"),informMessage=informMessage)
  tb <- data.frame(p.seq=p.seq, 
                   sauc.ci= sauc.ci, 
                   se.ci = se.ci,
                   sp.ci = sp.ci,
                   b.ci = b.ci,
                  par%>%round(.,3)%>%t())

  # sapply(object,function(x)c(x$alpha,x$mu1.c1["mu1"],x$mu2.ci["mu2"],x$par[c("tau1","tau2","rho")]))%>%round(.,3)%>%t())
}


data_ErrorMessage<-function(){
  showModal(modalDialog(
    title = "Error message",
    easyClose = FALSE,
    p(tags$strong("Data must be named as TP,FN,TN,FP"), "Please edit the data-set",br()
      # tags$i(tags$u("")), "If you need more important, please check",tags$a(href="https://mephas.github.io/helppage/", "DTA-Meta Manual",target="_blank") 
      ), 
    br(),
    modalButton("Close"),
    footer = NULL
  ))
}
ui.plot_baseset_drop<-function(id){
dropdown(width = 300,
  shinyWidgets::colorPickr(paste0("each_point_color",id),"Point colour",selected="#47848C"),
  sliderInput(paste0("each_point_radius",id),"Point radius",min = 0,max=10,value = 2, step=0.1),
  sliderInput(paste0("each_point_shape",id),"Point shape",min = 0,max=25,value = 1, step=1),
  shinyWidgets::switchInput(#
    inputId = paste0("setting_each_point",id),#
    label = "<i class=\"fa fa-book\"></i>", # Explanation in Details
    inline = TRUE,
    onLabel = "Close",
    offLabel = "Advanced Setting",
    size = "mini"
  ),
  conditionalPanel(condition = paste0("input.setting_each_point",id,"==1"),
                   sliderInput(paste0("each_point_transparency",id),"Point Transparency",min = 0,max=1,value = 1)
  )
  ,
  label = "Diagnostic studies",
  circle = FALSE,
    icon = icon("gear")#, width = "300px"
)}

ui.plot_baseline_drop<-function(id,plot_title="title",x_axis="",y_axis=waiver()){
  dropdown(label = paste(id,"Plot outline"),
    textInput(paste0("plot_title",id),"title",plot_title),
    textInput(paste0("plot_x_axis",id),"x_axis",x_axis),
    textInput(paste0("plot_y_axis",id),"y_axis",y_axis)
  )
}
ui.plot_srocline_drop<-function(plot_id,p.seq){
  dropdown(label = "SROC",width = 300,
    circle = FALSE,
    icon = icon("gear"),
  lapply(1:length(p.seq), function(i) dropdown(label =paste("p=",p.seq[i])
                                                 ,colorPickr(paste0("sroc_point_color",plot_id,i),label = "Summary point's colour",selected = "#0A99BD")
                                                 ,sliderInput(paste0("sroc_point_radius",plot_id,i), "Summary point's radius",min = 0,max=10,value = 2,step = 0.1)
                                                 ,sliderInput(paste0("sroc_point_shape",plot_id,i),"Summary point's shape",min = 0,max=25,value = 18)
                                                 ,colorPickr(paste0("sroc_curve_color",plot_id,i),label="SROC curve's color",selected="#39377A")
                                                 ,sliderInput(paste0("sroc_curve_thick",plot_id,i), "SROC curve's thickness",min = 0,max = 3,value = 0.5,step = 0.1)
                                                 ,sliderTextInput(paste0("sroc_curve_shape",plot_id,i),grid = TRUE,label =  "SROC curve's type",choices = c("blank","solid","dashed","dotted","dotdash","longdash","twodash"),selected = "solid")))
)
}



GLMMmodel <- function(data){
  
  data$n1 <- data$TP+data$FN 
  data$n0 <- data$FP+data$TN 
  data$true1 <- data$TP 
  data$true0 <- data$TN 
  data$recordid <- 1:nrow(data)

  
  Y = reshape(data, 
              direction="long", 
              varying=list(c("n1", "n0"), 
                           c("true1", "true0")), 
              timevar="sens", 
              times=c(1,0), 
              v.names=c("n","true"))
  Y = Y[order(Y$id),] 
  Y$spec<- 1-Y$sens
  
  fit <- glmer(formula=cbind(true, n - true) ~ 0 + sens + spec + (0+sens + spec|recordid), 
               data=Y, family=binomial, nAGQ=1, verbose=0)
  summary(fit)
  
  
}