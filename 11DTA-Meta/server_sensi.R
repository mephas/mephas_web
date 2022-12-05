# observe({
	
# 	updatePickerInput(session,"sensisetting",selected = input$Sensitivity_Panel)

# }
# )%>%bindEvent(input$Sensitivity_Panel)

observe({
	
	updateTabsetPanel(session,"Sensitivity_Panel",selected = input$sensisetting)

}
)%>%bindEvent(input$sensisetting)



####------------------------------ set values 

p.seq   <-reactiveVal(NULL)


studyId <-reactiveVal(0)


esting  <-reactiveValues()

esting_omg<-reactiveValues()
## RC FC function
alpha<-reactive({
  if(length(input$alpha)==0)return (c(-3,3)) else return(input$alpha)
})

# beta0<-reactive({
#   if(length(input$beta0)==0) return (1)
#   input$beta0
# })


beta<-reactive({
  if(length(input$beta)==0) return (c(0,2)) else return(input$beta)
})

beta0<-reactive({
  if(length(input$beta)==0) return (1) else {
    set.seed(123)
    return(runif(1, input$beta[1], input$beta[2]))
  }
})


c0<-reactive({
  if(length(input$c0)==0) return(0.5) else return(input$c0)
})

est.add_rf<-function(p,c1.square=0.5,fix.c=TRUE){
  rf<-c(p=p,dtametasa(data.cc(),
  p,
  fix.c=fix.c,
  c1.square=c1.square,
  beta0=beta0(),
  beta.interval=beta(),
  alpha.interval=alpha(),
  #ci.level = input$ci.level,
  sauc.type =  input$Sauc1,correct.type = input$allsingle))
  esting_omg[[paste0(p,fix.c,c1.square,beta0(),paste0(beta(),collapse=""),paste0(alpha(),collapse=""),input$Sauc1,input$allsingle,studyId())]]<-rf
  rf
}
est.rfc<-function(p.seq,c1.square,fix.c=TRUE){
  sapply(p.seq,function(p){
  if(length(esting_omg[[paste0(p,fix.c,c1.square,beta0(),paste0(beta(),collapse=""),paste0(alpha(),collapse=""),input$Sauc1,input$allsingle,studyId())]])==0) est.add_rf(p,c1.square,fix.c)
})}
est.rf<-function(c1.square=0.5,fix.c=TRUE,...,par="par",p=p.seq(),informMessage="Please click to calculate SAUC."){
  validate(need(p,"Selection probabilities is missing"))
  sapply(p,function(x){
  validate(need(esting_omg[[paste0(x,fix.c,c1.square,beta0(),paste0(beta(),collapse=""),paste0(alpha(),collapse=""),input$Sauc1,input$allsingle,studyId())]],
  	informMessage))
  esting_omg[[paste0(x,fix.c,c1.square,beta0(),paste0(beta(),collapse=""),paste0(alpha(),collapse=""),input$Sauc1,input$allsingle,studyId())]][[par]][...]
})}
est.m<-function(c1.square=0.5,fix.c=TRUE,...,par="par",p=p.seq(),informMessage="Please click to calculate SAUC."){
  validate(need(p,"Selection probabilities is missing"))
  sapply(p,function(x){
  validate(need(length(esting_omg[[paste0(x,fix.c,c1.square,beta0(),paste0(beta(),collapse=""),paste0(alpha(),collapse=""),input$Sauc1,input$allsingle,studyId())]])>0,
  	informMessage))
  esting_omg[[paste0(x,fix.c,c1.square,beta0(),paste0(beta(),collapse=""),paste0(alpha(),collapse=""),input$Sauc1,input$allsingle,studyId())]][[par]][...]
})}


# output$beta0<-renderUI({
#   # list(
#     sliderInput("beta0", label = HTML("Initial value of beta"), min = input$beta[1], 
#         max = input$beta[2], value = 1)
#     # sliderInput("c0",label = HTML("Initial value of $c_1^2$"), min = 0.1, 
#     #     max = -.9, value = 0.5, step=0.1))
# })


## SROC plot function 

sroc_ggplot_over <- function(plot_id,c1.square,fix.c=TRUE,fun=est.rf,informMessage="Please click to calculate SROC."){

  if(input$batch){
    each_point_color<-ifelse(is.null(input$each_point_color),"#47848C",input$each_point_color)
    each_point_radius<-ifelse(is.null(input$each_point_radius),3,input$each_point_radius)
    each_point_shape<-ifelse(is.null(input$each_point_shape),20,input$each_point_shape)
    sroc_curve_color<-sapply(p.seq(),function(i)ifelse(is.null(input$sroc_curve_color),"#39377A",input$sroc_curve_color))
    sroc_curve_thick<-sapply(p.seq(),function(i)ifelse(is.null(input$sroc_curve_thick),1,input$sroc_curve_thick))
    sroc_curve_shape<-sapply(p.seq(),function(i)ifelse(is.null(input$sroc_curve_shape),"solid",input$sroc_curve_shape))
    sroc_point_color<-sapply(p.seq(),function(i)ifelse(is.null(input$sroc_point_color),"#0A99BD",input$sroc_point_color))
    sroc_point_radius<-sapply(p.seq(),function(i)ifelse(is.null(input$sroc_point_radius),5,input$sroc_point_radius))
    sroc_point_shape<-sapply(p.seq(),function(i)ifelse(is.null(input$sroc_point_shape),20,input$sroc_point_shape))
  }

  else{ 
    each_point_color<-ifelse(is.null(input[[paste0("each_point_color",plot_id)]]),"#47848C",input[[paste0("each_point_color",plot_id)]])
    each_point_radius<-ifelse(is.null(input[[paste0("each_point_radius",plot_id)]]),2,input[[paste0("each_point_radius",plot_id)]])
    each_point_shape<-ifelse(is.null(input[[paste0("each_point_shape",plot_id)]]),20,input[[paste0("each_point_shape",plot_id)]])
    sroc_curve_color<-sapply(1:length(p.seq()),function(i)ifelse(is.null(input[[paste0("sroc_curve_color",plot_id,i)]]),"#39377A",input[[paste0("sroc_curve_color",plot_id,i)]]))
    sroc_curve_thick<-sapply(1:length(p.seq()),function(i)ifelse(is.null(input[[paste0("sroc_curve_thick",plot_id,i)]]),1,input[[paste0("sroc_curve_thick",plot_id,i)]]))
    sroc_curve_shape<-sapply(1:length(p.seq()),function(i)ifelse(is.null(input[[paste0("sroc_curve_shape",plot_id,i)]]),"solid",input[[paste0("sroc_curve_shape",plot_id,i)]]))
    sroc_point_color<-sapply(1:length(p.seq()),function(i)ifelse(is.null(input[[paste0("sroc_point_color",plot_id,i)]]),"#0A99BD",input[[paste0("sroc_point_color",plot_id,i)]]))
    sroc_point_radius<-sapply(1:length(p.seq()),function(i)ifelse(is.null(input[[paste0("sroc_point_radius",plot_id,i)]]),3,input[[paste0("sroc_point_radius",plot_id,i)]]))
    sroc_point_shape<-sapply(1:length(p.seq()),function(i)ifelse(is.null(input[[paste0("sroc_point_shape",plot_id,i)]]),20,input[[paste0("sroc_point_shape",plot_id,i)]]))
  }

  est.par<- fun(c1.square,fix.c=fix.c,c("mu1","mu2","tau1","tau2","rho"),informMessage=informMessage) 
  #validate(need(length(est.par)>0,"Input marginal selection probabilities is missing."))
  par <- as.matrix(est.par)
  spec <- plogis(par[2, ])
  sens <- plogis(par[1, ])
  
  color<-c(rep( each_point_color,length(sp())),sroc_point_color)
  size<-c(rep( each_point_radius,length(sp())),sroc_point_radius)
  shape<-c(rep( each_point_shape,length(sp())),sroc_point_shape)

  data<-data.frame(sp=c(sp(),spec),se=c(se(),sens))

  p<-ggplot(data = data,mapping = aes(x=1-sp,y=se))+ ylim(0,1)+ xlim(0,1)
  p<-p+geom_point(colour=color,size=size,shape=shape)+gg_theme()+labs(x=input$xlim,y=input$ylim)

  p<-p+mapply(function(i) {
    u1 <- par["mu1", i]
    u2 <- par["mu2", i]
    t1 <- par["tau1", i]
    t2 <- par["tau2", i]
    if (input$Sauc1 == "sroc"){
      r <- par["rho", i]}
    else{ r <- -1}
    stat_function(fun = function(x)plogis(u1 - (t1 * t2 * r/(t2^2))*(qlogis(x) + u2)), color=sroc_curve_color[i], linewidth=sroc_curve_thick[i],linetype = sroc_curve_shape[i],aes(linetype="h"))
  }
  , 1:ncol(par))
  
  esting_omg[[plot_id]]<-p
  p
}





output$uiprob <- renderText({

  probs<-as.numeric(unlist(strsplit(input$plist, "[ |,;\n\t\r]")))
  probs<-probs[!is.na(probs)]
  #validate(need(length(probs)>0, paste("Input marginal selection probabilities is missing, now it uses the previous value though.",paste("p=",p.seq()," ",collapse = ""))))
  validate(need(identical(probs<=1&probs>0,rep(TRUE,length(probs))),
  	paste("Each value must be from 0 to 1.\n Each value must be separated by a comma (,) ",
  		paste(probs,collapse = ","))))

  probs<-sort(probs,decreasing = TRUE)
  p.seq(probs)
  paste("p=",probs," ",sep = "")

  })



## SROC

#2.Sensitivity Analysis====
##SROC====
###sroc_ggplot_over====


###sroc B plot setting=====================

output$srocBsetting_curve<-renderUI({
  ui.plot_srocline_drop("c1c2_estimate",p.seq())
})

# srocB <- eventReactive(input$sroc.saplot, {sroc_ggplot_over("c1c2_estimate", 0.5, est.r)})

# output$srocB<-renderPlot({
# # srocB()
# sroc_ggplot_over("c1c2_estimate", c0(),fix.c=FALSE)
# })

output$srocB<-plotly::renderPlotly(
  {plotly::ggplotly(sroc_ggplot_over("c1c2_estimate", c0(),fix.c=FALSE))}
)

# output$downloadsauc_gg_estimate<-downloadHandler(

#   filename = function(){paste("c1c2_estimate",'.png',sep='')},
#   content = function(file){
#     ggsave(file,plot=esting_omg$c1c2_estimate)
#   })
###sroc C plot setting=====================


output$srocCsetting_curve_11<-renderUI({
  ui.plot_srocline_drop("c1c2_11",p.seq())
})
output$srocCsetting_curve_10<-renderUI({
  ui.plot_srocline_drop("c1c2_10",p.seq())
})
output$srocCsetting_curve_01<-renderUI({
  ui.plot_srocline_drop("c1c2_01",p.seq())
})


# srocC_11 <- eventReactive(input$sroc.saplot, {sroc_ggplot_over("c1 c2_11",0.5)})
# srocC_10 <- eventReactive(input$sroc.saplot, {sroc_ggplot_over("c1 c2_10",1)})
# srocC_01 <- eventReactive(input$sroc.saplot, {sroc_ggplot_over("c1 c2_01",0)})

output$srocC_11<-renderPlot({
# srocC_11()
sroc_ggplot_over("c1c2_11",0.5)
})
output$srocC_10<-renderPlot({
# srocC_10()
sroc_ggplot_over("c1c2_10",1)
})
output$srocC_01<-renderPlot({
# srocC_01()
sroc_ggplot_over("c1c2_01",0)
})

output$srocC_11<-plotly::renderPlotly(
  {plotly::ggplotly(sroc_ggplot_over("c1c2_11",0.5))}
)
output$srocC_10<-plotly::renderPlotly(
  {plotly::ggplotly(sroc_ggplot_over("c1c2_10",1))}
)
output$srocC_01<-plotly::renderPlotly(
  {plotly::ggplotly(sroc_ggplot_over("c1c2_01",0))}
)

# output$download_srocC_11<-downloadHandler(
#   filename = function(){paste("c1c2_11",'.png',sep='')},
#   content = function(file){
#     ggsave(file,plot=esting_omg[["c1c2_11"]])
#   })
# output$download_srocC_10<-downloadHandler(
#   filename = function(){paste("c1c2_10",'.png',sep='')},
#   content = function(file){
#     ggsave(file,plot=esting_omg[["c1c2_10"]])
#   })
# output$download_srocC_01<-downloadHandler(
#   filename = function(){paste("c1c2_01",'.png',sep='')},
#   content = function(file){
#     ggsave(file,plot=esting_omg[["c1c2_01"]])
#   })


###sroc D plot setting=====================

output$srocDsetting_curve<-renderUI(ui.plot_srocline_drop("c1c2_manul",p.seq()))

# srocD <- eventReactive(input$sroc.saplot, {sroc_ggplot_over(plot_id ="c1c2_manul",input$c1c2_set)})

# output$srocD<-renderPlot({
#  # srocD()             
#  sroc_ggplot_over(plot_id ="c1c2_manul",input$c1c2_set)
# })

output$srocD<-plotly::renderPlotly(
  {plotly::ggplotly(sroc_ggplot_over(plot_id ="c1c2_manul",input$c1c2_set))}
)
# output$download_c1c2_manul<-downloadHandler(
#   filename = function(){paste("c1c2_estimate",'.png',sep='')},
#   content = function(file){
#     ggsave(file,plot=esting_omg$c1c2_manul)
#   })

observe({
  
  # withProgress(message = "Calculating",detail = 'This may take a while...', value = 0,
               # {

                 est.rfc(p.seq(),c1.square=c0(),fix.c=FALSE)
                 est.rfc(p.seq(),c1.square = 1)
                 est.rfc(p.seq(),c1.square = 0.5)
                 est.rfc(p.seq(),c1.square = 0)
               # })
})%>%
bindEvent(input$Sauc1,input$allsingle,input$calculateSROC)


observe({
  withProgress(message = "Calculating SAUC",detail = 'Please wait...', value = 0,
               {
                 est.rfc(p.10(),c0(),fix.c=FALSE)
                 incProgress(1/4)
                 est.rfc(p.10(),c1.square = 1)
                 incProgress(1/4)
                 est.rfc(p.10(),c1.square = 0.5)
                 incProgress(1/4)
                 est.rfc(p.10(),c1.square = 0)
                 incProgress(1/4)
               })
})%>%bindEvent(input$calculateSAUC)

observe(est.rfc(p.seq(),c1.square =input$c1c2_set))%>%bindEvent(input$c1c2_set,input$Sauc1,input$allsingle,studyId())
observe({
  withProgress(message = "Calculating SAUC",detail = 'Please wait...', value = 0,{
est.rfc(p.10(),c1.square =input$c1c2_set)
  }
  )
  
  })%>%bindEvent(input$c1c2_set_button)

