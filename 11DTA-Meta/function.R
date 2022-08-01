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
reform.dtametasa<-function(est.rf,p.seq,c1.square=0.5){
  #est.rf<-match.fun(est.rf)
  sauc.ci <- sprintf("%.3f (%.3f, %.3f)", est.rf(c1.square,par ="sauc.ci","sauc"),est.rf(c1.square,par ="sauc.ci","sauc.lb"),est.rf(c1.square,par ="sauc.ci","sauc.ub"))
  se.ci   <- sprintf("%.3f (%.3f, %.3f)", est.rf(c1.square,par ="mu1.ci","sens"),est.rf(c1.square,par ="mu1.ci","se.lb"),est.rf(c1.square,par ="mu1.ci","se.ub"))
  sp.ci   <- sprintf("%.3f (%.3f, %.3f)", est.rf(c1.square,par ="mu2.ci","spec"),est.rf(c1.square,par ="mu2.ci","sp.lb"),est.rf(c1.square,par ="mu2.ci","sp.ub"))
  b.ci    <- sprintf("%.3f (%.3f, %.3f)", est.rf(c1.square,par ="beta.ci","beta"),est.rf(c1.square,par ="beta.ci","beta.lb"),est.rf(c1.square,par ="beta.ci","beta.ub"))
  par<-est.rf(c1.square,c("mu1","mu2","tau1","tau2","rho"))
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
    p(tags$strong("Data must contain TP,FN,TN,FP:
                             "), "Please edit the data-set",br(),
      tags$i(tags$u("")), "If you need more important, please check",tags$a(href="https://mephas.github.io/helppage/", "DTA-Meta Manual",target="_blank") ), 
    br(),
    modalButton("Close"),
    footer = NULL
  ))
}
ui.plot_baseset_drop<-function(id){
dropdown(                     width = 300,
  shinyWidgets::colorPickr(paste0("each_point_color",id),"point colour",selected="#ff7f50"),
  sliderInput(paste0("each_point_radius",id),"Each Point Radius",min = 0,max=10,value = 3),
  sliderInput(paste0("each_point_shape",id),"Each Point Shape",min = 0,max=25,value = 20),
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
  label = paste(id,"setting")
)}
ui.plot_baseline_drop<-function(id,plot_title="title",x_axis="",y_axis=waiver()){
  dropdown(label = paste(id,"Plot Outline"),
    textInput(paste0("plot_title",id),"title",plot_title),
    textInput(paste0("plot_x_axis",id),"x_axis",x_axis),
    textInput(paste0("plot_y_axis",id),"y_axis",y_axis)
  )
}
ui.plot_srocline_drop<-function(plot_id,p.seq){
  dropdown(label = paste(plot_id,"SROC setting"),
  lapply(1:length(p.seq), function(i) dropdown(label =paste("p=",p.seq[i]),width = 300
                                                 ,colorPickr(paste0("sroc_point_color",plot_id,i),label = "Summary Point Colour",selected = "#800080")
                                                 ,sliderInput(paste0("sroc_point_radius",plot_id,i), "Summary Point Radius",min = 0,max=10,value = 5,step = 0.01)
                                                 ,sliderInput(paste0("sroc_point_shape",plot_id,i),"Each Point Shape",min = 0,max=25,value = 20)
                                                 ,colorPickr(paste0("sroc_curve_color",plot_id,i),label="SROC Curve color",selected="#00ced1")
                                                 ,sliderInput(paste0("sroc_curve_thick",plot_id,i), "Curve thickness",min = 0,max = 3,value = 1,step = 0.01)
                                                 ,sliderTextInput(paste0("sroc_curve_shape",plot_id,i),grid = TRUE,label =  "Curve shape",choices = c("blank","solid","dashed","dotted","dotdash","longdash","twodash"),selected = "solid")))
)
}
