
# output$debug<-renderText(paste(studyId(),input$Sauc1,input$allsingle,p.seq()))



output$studyId<-renderUI({
  radioButtons("momomo","",inline = TRUE,choices = paste0("studyID",seq(studyId(),0)))
})




#data preculculate=====


# sp <-reactive(data()$TN/(data()$TN+data()$FP))%>%bindEvent(studyId())

# se <-reactive(data()$TP/(data()$TP+data()$FN))%>%bindEvent(studyId())

# logitData<-reactive(logit.data(correction(data(), type = input$allsingle)))%>%bindCache(input$allsingle,studyId())%>%bindEvent(input$calculateStart,input$allsingle)


#1.Meta-Analysis------------------------------------------------------------------------------------------------------------------------

## Raw data
data<-reactiveVal({

  data.frame(
    study=seq(1:33)
    ,TP=c(12,10,17,13,4,15,45,18,5,8,5,11,5,7,10,5,5,55,6,42,5,13,20,7,48,11,15,68,13,8,13,14,8)
    ,FN=c(0,2,1,0,0,2,5,4,0,9,0,2,1,5,1,5,0,13,2,26,3,0,0,6,2,1,5,13,1,3,1,1,2)
    ,FP=c(29,14,36,18,21,122,28,69,11,15,7,122,6,25,93,41,15,19,12,19,5,11,24,13,15,14,32,5,5,66,98,0,4)
    ,TN=c(289,72,85,67,225,403,34,133,34,96,63,610,145,342,296,271,53,913,30,913,37,125,287,72,47,72,170,11,72,323,293,155,60)
    )
  # correction(raw.data, value = 0.5, type = input$allsingle)
})

## CC data
data.cc <- reactive({

  correction(data(), value = 0.5, type = input$allsingle)

})

sp <-reactive(data.cc()$TN/(data.cc()$TN+data.cc()$FP))#%>%bindEvent(studyId())

se <-reactive(data.cc()$TP/(data.cc()$TP+data.cc()$FN))#%>%bindEvent(studyId())
## Logit data

data.lg <- reactive({

  round(logit.data(data.cc()), 6)

})

## Output Data Preview

output$RawData<-renderDT(
    {data()},
    extensions = 'Buttons',
    options=list(
      scrollX = TRUE,
      dom = 'Blfrtip',
      buttons = list(
      'copy',
      list(extend = 'csv', title = "DTArawdata"),
      list(extend = 'excel', title = "DTArawdata")
      )
      )
    )

output$CorData<-renderDT(
    {data.cc()},
    extensions = 'Buttons',
    options=list(
      # scrollX = TRUE,
      dom = 'Blfrtip',
      buttons = list(
      'copy',
      list(extend = 'csv', title = "DTArawdata"),
      list(extend = 'excel', title = "DTArawdata")
      )
))

output$LogData<-renderDT(
    {data.lg()},
    extensions = 'Buttons',
    options=list(
      # scrollX = TRUE,
      dom = 'Blfrtip',
      buttons = list(
      'copy',
      list(extend = 'csv', title = "DTArawdata"),
      list(extend = 'excel', title = "DTArawdata")
      )
))


##Descriptive Statistics====

## DTA meta

## model
md <- reactive(

  madad(data(), 
  correction.control = input$allsingle, 
  level = input$ci.level, correction = 0.5, 
  method=input$ci.method)

  )

## SE SP table
se_sp <- reactive({

  md <- md()
  sesp <- data.frame(
    se = md$sens$sens,
    se.ci = md$sens$sens.ci,
    sp = md$spec$spec,
    sp.ci = md$spec$spec.ci  
  )
  
colnames(sesp) <- c(
  "Sens","Sens.CI.lower", "Sens.CI.upper", 
  "Spec","Spec.CI.lower", "Spec.CI.upper")

return(round(sesp,6))
  })


output$se_sp<-renderDT(
    {se_sp()},
    extensions = 'Buttons',
    options=list(
      scrollX = TRUE,
      dom = 'Blfrtip',
      buttons = list(
      'copy',
      list(extend = 'csv', title = "DTA_se_sp"),
      list(extend = 'excel', title = "DTA_se_sp")
      )
))

## SE SP test table

se_sp_test <- reactive({

  md <- md()
  sesp.test <- data.frame(
    stat = c(md$sens.htest$statistic, md$spec.htest$statistic),
    par = c(md$sens.htest$parameter, md$spec.htest$parameter),
    pval = c(md$sens.htest$p.value, md$spec.htest$p.value)
  )
  
colnames(sesp.test) <- c("Statistics","Degree of freedom", "P Value")
rownames(sesp.test) <- c("Test for equality of Sens","Test for equality of Spec")
return(round(sesp.test,6))
  })


output$se_sp_test<-renderDT(
    {se_sp_test()},
    extensions = 'Buttons',
    options=list(
      scrollX = TRUE,
      dom = 'Blfrtip',
      buttons = list(
      'copy',
      list(extend = 'csv', title = "DTA_se_sp_test"),
      list(extend = 'excel', title = "DTA_se_sp_test")
      )
))

DOR <- reactive({

  md <- md()
  dor <- data.frame(
    DOR = md$DOR$DOR,
    DOR.ci = md$DOR$DOR.ci,
    lnDOR.se =  md$DOR$se.lnDOR
  )
  
colnames(dor) <- c(
  "DOR","DOR.CI.lower", "DOR.CI.upper", "lnDOR.se"
  )

return(round(dor,6))
  })

output$dor<-renderDT(
    {DOR()},
    extensions = 'Buttons',
    options=list(
      scrollX = TRUE,
      dom = 'Blfrtip',
      buttons = list(
      'copy',
      list(extend = 'csv', title = "DTA_dor"),
      list(extend = 'excel', title = "DTA_dor")
      )
))



LR <- reactive({

  md <- md()
  uni <- data.frame( 
    posLR = md$posLR$posLR,
    posLR.ci = md$posLR$posLR.ci,
    lnposLR.se =  md$posLR$se.lnposLR,
    
    negLR = md$negLR$negLR,
    negLR.ci = md$negLR$negLR.ci,
    lnnegLR.se =  md$negLR$se.lnnegLR
  )
  
colnames(uni) <- c(
  "PosLR","PosLR.CI.lower", "PosLR.CI.upper", "lnPosLR.se",
  "NegLR","NegLR.CI.lower", "NegLR.CI.upper", "lnNegLR.se"
  )

return(round(uni,6))
  })


output$uni.measure<-renderDT(
    {LR()},
    extensions = 'Buttons',
    options=list(
      scrollX = TRUE,
      dom = 'Blfrtip',
      buttons = list(
      'copy',
      list(extend = 'csv', title = "DTA_LR"),
      list(extend = 'excel', title = "DTA_LR")
      )
))


# output$md.text <- renderPrint({ print(md(), digits=3) })

##Forest Plots for Se/Sp====

output$meta_se<-renderPlot({forest(md(),type="sens",main= input$se.title,pch=15,cex=1)})
output$meta_sp<-renderPlot({forest(md(),type="spec",main=input$sp.title ,pch=15,cex=1)})


output$meta_sesp_plot<-renderUI({

  splitLayout(

  plotOutput("meta_se", height =paste0((md()$nobs*13.5+200),"px"),width = "500px" ),
  plotOutput("meta_sp", height =paste0((md()$nobs*13.5+200),"px"),width = "500px" )

  ) 
})

##Forest Plots for Univariate measures====
output$meta_LDOR  <-renderPlot({forest(md(), type="DOR",  log=input$uni.log1, main=input$u1.title)})
output$meta_negLR <-renderPlot({forest(md(), type="negLR",log=input$uni.log2, main=input$u2.title)})
output$meta_posLR <-renderPlot({forest(md(), type="posLR",log=input$uni.log2, main=input$u3.title)})

output$meta_dor_plot<-renderUI({
   
   plotOutput("meta_LDOR", height = paste0((md()$nobs*13.5+200),"px"),width = "600px")

})

output$meta_uni_plot<-renderUI({
  
  splitLayout(
   
   plotOutput("meta_negLR",height = paste0((md()$nobs*13.5+200),"px"),width = "600px"),
   plotOutput("meta_posLR",height = paste0((md()$nobs*13.5+200),"px"),width = "600px")
   
  ) 
})


## Study distribution ====
output$plot_ci<-renderPlot({

  md <- md()
  
  plot(1-sp(), se(), 
      xlim = c(0, 1), ylim=c(0,1), 
      lty = 1, pch = 16,
      xlab=input$ci.xlab, ylab = input$ci.ylab) 
  
  # if(input$studypp) points(1-sp(), se(), pch = 16)

  if(input$ROCellipse) ROCellipse(data.cc(), 
    lty = 2,  level = input$ci.level, correction =0.5, method=input$ci.method, 
    pch = 16, add = TRUE)
  
  
  if(input$Crosshair) crosshair(data.cc(), 
    lty = 2, level = input$ci.level, correction =0.5, method=input$ci.method, 
    pch = 16,add = TRUE)

    # if(input$mslSROC) mslSROC(data(), 
    # lty = 2,add = TRUE, extrapolate = FALSE, correction = 0.5, correction.control = input$allsingle)

    # if (input$rsSROC) rsSROC(data(), 
    #   lty= 3,add = TRUE, extrapolate = FALSE, correction = 0.5, correction.control = input$allsingle)

  
})


# output$plot_sroc<-renderPlot({
  
#   plot(1-md()$spec$spec,md()$sens$sens, 
#     xlim = c(0,1), ylim=c(0,1),
#     xlab=input$sroc.xlab, ylab = input$sroc.ylab)

# })


# output$meta_ci_plot<-renderUI({
  
#    prettyRadioButtons(
#      inputId = "ci.plot",
#      label = "Type of confidence interval",
#      icon = icon("check"),
#      choiceNames = c("No Confidence Intervals", "Add CI Regions", "Add Crosshair CI"),
#      choiceValues = c("", "ROCellipse", "crosshair"),
#      fill = TRUE
#    ),
   
#    textInput("sroc.xlab", label = "Label for x-axis", value = "1-Specificity"),
#    textInput("sroc.ylab", label = "Label for y-axis", value = "Sensitivity"),
   
#    plotOutput("plot_ci",  height ="600px", width = "600px")

# })

# output$meta_sroc_plot<-renderUI({
  
  # splitLayout(style='width:300px',
             
             # p(tags$b("1. Confidence interval plot")),
             
             # prettyRadioButtons(
             #   inputId = "ci.plot",
             #   label = "Type of confidence interval",
             #   choiceNames = c("No Confidence Intervals", "Add CI Regions", "Add Crosshair CI"),
             #   choiceValues = c("", "ROCellipse",  "crosshair"),
             #   fill = TRUE
             # ),
             
             # textInput("sroc.xlab", label = "Label for x-axis", value = "1-Specificity"),
             # textInput("sroc.ylab", label = "Label for y-axis", value = "Sensitivity"),
             
             # plotOutput("plot_ci",  height ="600px", width = "600px"),
             
             # p(br()),
             
             # p(tags$b("2. SROC curve")),
             
             
             # prettyCheckbox( 
             #   inputId = "mslSROC",
             #   label = "Moses-Shapiro-Littenberg SROC curve", 
             #   value = TRUE,
             #   icon = icon("check"),
             #   status = "info"),
             
             # prettyCheckbox( 
             #   inputId = "rsSROC",
             #   label = "Ruecker-Schumacher (2010) SROC curve", 
             #   value = TRUE,
             #   icon = icon("check"),
             #   status = "info"),
             
             # plotOutput("plot_sroc",height ="600px", width = "600px")
  # )
  
# })

#gg theme--------
gg_theme   <- reactive({
  switch(input$ggplot_theme
     ,theme_bw = theme_bw()
     ,theme_classic = theme_classic()
     ,theme_light = theme_light()
     # ,theme_linedraw = theme_linedraw()
     ,theme_minimal = theme_minimal()
     ,theme_test = theme_test()
     ,theme_void = theme_void()
     ,theme_default = NULL
    )

})

gg_theme2   <- reactive({
  switch(input$ggplot_theme2
     ,theme_bw = theme_bw()
     ,theme_classic = theme_classic()
     ,theme_light = theme_light()
     # ,theme_linedraw = theme_linedraw()
     ,theme_minimal = theme_minimal()
     ,theme_test = theme_test()
     ,theme_void = theme_void()
     ,theme_default = NULL
    )

})


####Old sroc Ploting=================================
# sroc_ggplot<-function(plot_id,c1.square){
#   data<-data.frame(sp=sp(),se=se())
#   p<-ggplot(data = data,mapping = aes(x=1-sp,y=se))+ ylim(0,1)+ xlim(0,1)
#   p<-p+geom_point(color=input[[paste0("each_point_color",plot_id)]],size=input[[paste0("each_point_radius",plot_id)]],shape=as.numeric(input[[paste0("each_point_shape",plot_id)]]))+gg_theme()
#   est.par<- est.f(c1.square,c("mu1","mu2","tau1","tau2","rho")) 
#   par <- as.matrix(est.par)
#   p<-p+mapply(function(i) {
#     u1 <- par["mu1", i]
#     u2 <- par["mu2", i]
#     t1 <- par["tau1", i]
#     t2 <- par["tau2", i]
#     if (input$Sauc1 == "sroc"){
#       r <- par["rho", i]}
#     else{ r <- -1}
#     stat_function(fun = function(x)plogis(u1 - (t1 * t2 * r/(t2^2))*(qlogis(x) + u2)),color=ifelse(length(input[[paste0("sroc_curve_color",plot_id,i)]])==0,"#000000",input[[paste0("sroc_curve_color",plot_id,i)]]),size=ifelse(is.null(input[[paste0("sroc_curve_thick",plot_id,i)]]),1,input[[paste0("sroc_curve_thick",plot_id,i)]]),linetype = ifelse(is.null(input[[paste0("sroc_curve_shape",plot_id,i)]]),"solid",input[[paste0("sroc_curve_shape",plot_id,i)]]),aes(linetype="h"))
#   }
#   , 1:ncol(par))
#   sens <- plogis(par[1, ])
#   spec <- plogis(par[2, ])
#   p<-p+
#     sapply(1:ncol(par),function(t)geom_point(mapping=aes(x=1-spec[t],y=sens[t],color=ifelse(length(input[[paste0("sroc_point_color",plot_id,t)]])==0,"#000000",input[[paste0("sroc_point_color",plot_id,t)]])),color=ifelse(length(input[[paste0("sroc_point_color",plot_id,t)]])==0,"#000000",input[[paste0("sroc_point_color",plot_id,t)]]),shape=ifelse(length(input[[paste0("sroc_point_shape",plot_id,t)]])==0,20,as.numeric(input[[paste0("sroc_point_shape",plot_id,t)]])),size=ifelse(is.null(input[[paste0("sroc_point_radius",plot_id,t)]]),3,input[[paste0("sroc_point_radius",plot_id,t)]])))+
#     ggtitle(plot_id)+
#     #guide_legend(title = "p=")+
#     theme(title= element_text(size = 16)
#           ,legend.position = "right")
  
#   esting_omg[[plot_id]]<-p
#   p
# }

p.10 <- reactive(seq(1,0.1,-input$plistsauc))
output$p10list<-renderText(paste0("p = ",p.10()))
##SAUC====
output$sauc_gg_estimate<-plotly::renderPlotly({plotly::ggplotly(sauc_ggplot("sauc_c1c2_estimate",c1.square=c0(),fix.c=FALSE))})
output$sauc_gg_c11<-plotly::renderPlotly({plotly::ggplotly(sauc_ggplot("sauc_c1c2_11", "$(c_1, \\,c_2) = (1/\\sqrt{2}, 1/\\sqrt{2})$",0.5))})
output$sauc_gg_c10<-plotly::renderPlotly({plotly::ggplotly(sauc_ggplot("sauc_c1c2_10", "$(c_1,\\, c_2) = (1,\\, 0)$",1))})
output$sauc_gg_c01<-plotly::renderPlotly({plotly::ggplotly(sauc_ggplot("sauc_c1c2_01", "$(c_1,\\, c_2) = (0,\\, 1)$",0))})
output$sauc_gg_cset<-plotly::renderPlotly({plotly::ggplotly(sauc_ggplot("sauc_c1c2_set",  paste0("$(c_1,\\, c_2) = (",round(sqrt(input$c1c2_set),4),",\\, ",round(sqrt(1-input$c1c2_set),4),")$"),input$c1c2_set,fun=est.m))})

sauc_ggplot<-function(plot_id, title="(A) $(\\hat{c}_1, \\, \\hat{c}_2)$",c1.square=0.5,fix.c=TRUE,fun=est.rf){

  est.sauc2<-fun(c1.square,fix.c,par="sauc.ci",p=p.10())
  est.sauc2<-t(est.sauc2)
  data<-data.frame(

    p=c(p.10(),p.10(),p.10()),
    SAUC=c(est.sauc2[,"sauc"],est.sauc2[,"sauc.lb"],est.sauc2[,"sauc.ub"]),
    sauctype=c(rep("sauc",length(p.10())),rep("sauc.lb",length(p.10())),rep("sauc.ub",length(p.10())))
    )

  ggplot(data = data,mapping = aes(x=p,y=SAUC,colour=sauctype))+
  gg_theme2()+
  theme(legend.position = "none")+
    ylim(0,1)+
    scale_x_reverse(limits = c(1, 0))+
    ggtitle(title)+
    #theme(title= element_text(size = 16))+
    geom_point()+
    geom_line()+scale_color_manual(values=c('black', 'red', 'red'))
  
}

##Funnel plot====
##Results====
output$Results.est<-renderDataTable({

  tb <-reform.dtametasa(fun=est.rf,p.seq(),fix.c=FALSE)
  # tb11<-reform.dtametasa(est.f,p.seq())
  # tb10<-reform.dtametasa(est.f,p.seq(),1)
  # tb01<-reform.dtametasa(est.f,p.seq(),0)
  # tb1 <- rbind(tb2, tb11, tb10, tb01)
  # tb1[c(1,5,9,13), 5] <- ""
  # tb1[c(1,5,9,13), 5:6] <- NA
  
  # tb <- c( TeX("$(\\hat{c}_1, \\hat{c}_2)$"), "","","",
  #          "$(0.7, 0.7)$","","","",
  #          "$(1, 0)$", "","","",
  #          "$(0, 1)$","","","")
  # tb <- cbind("$(c_1, \\,c_2)$" = c("$(\\hat{c}_1, \\hat{c}_2)$", rep("", 3),
  #                                   "$(0.7, 0.7)$", rep("",3),
  #                                   "$(1, 0)$", rep("", 3),
  #                                   "$(0, 1)$", rep("", 3)),
  #             tb1)
    colnames(tb) <- c("p", "SAUC(95%CI)", "Sens(95%CI)", "Spec(95%CI)", "beta(95%CI)","mu1","mu2","tau1","tau2","rho")

  datatable(tb,# rownames = tb
            ,extensions = 'Buttons',
            options=(list(scrollX = TRUE,
                          dom = 'Blfrtip',
                          buttons = list('copy',list( extend='csv', title = "Estimates from sensitivity analysis"), list( extend='excel', title = "Estimates from sensitivity analysis"), list( extend='pdf', title = "Estimates from sensitivity analysis"),  list( extend='excel', title = "Estimates from sensitivity analysis"), list( extend='print', title = "Estimates from sensitivity analysis")))
            ))
  })

output$Results11<-renderDataTable({

  # tb2 <-reform.dtametasa(est.rf=est.r,p.seq())
  tb <-reform.dtametasa(est.rf,p.seq())
  # tb10<-reform.dtametasa(est.f,p.seq(),1)
  # tb01<-reform.dtametasa(est.f,p.seq(),0)
  # tb1 <- rbind(tb2, tb11, tb10, tb01)
  # tb1[c(1,5,9,13), 5] <- ""
  # tb1[c(1,5,9,13), 5:6] <- NA
  
  # tb <- c( TeX("$(\\hat{c}_1, \\hat{c}_2)$"), "","","",
  #          "$(0.7, 0.7)$","","","",
  #          "$(1, 0)$", "","","",
  #          "$(0, 1)$","","","")
  # tb <- cbind("$(c_1, \\,c_2)$" = c("$(\\hat{c}_1, \\hat{c}_2)$", rep("", 3),
  #                                   "$(0.7, 0.7)$", rep("",3),
  #                                   "$(1, 0)$", rep("", 3),
  #                                   "$(0, 1)$", rep("", 3)),
  #             tb1)
    colnames(tb) <- c("p", "SAUC(95%CI)", "Sens(95%CI)", "Spec(95%CI)", "beta(95%CI)","mu1","mu2","tau1","tau2","rho")

  datatable(tb, #rownames = tb
            ,extensions = 'Buttons',
            options=(list(scrollX = TRUE,
                          dom = 'Blfrtip',
                          buttons = list('copy',list( extend='csv', title = "Estimates from sensitivity analysis"), list( extend='excel', title = "Estimates from sensitivity analysis"), list( extend='pdf', title = "Estimates from sensitivity analysis"),  list( extend='excel', title = "Estimates from sensitivity analysis"), list( extend='print', title = "Estimates from sensitivity analysis")))
            ))
  })

output$Results10<-renderDataTable({

  # tb2 <-reform.dtametasa(est.rf=est.r,p.seq())
  # tb11<-reform.dtametasa(est.f,p.seq())
  tb <-reform.dtametasa(est.rf,p.seq(),1)
  # tb01<-reform.dtametasa(est.f,p.seq(),0)
  # tb1 <- rbind(tb2, tb11, tb10, tb01)
  # tb1[c(1,5,9,13), 5] <- ""
  # tb1[c(1,5,9,13), 5:6] <- NA
  
  # tb <- c( TeX("$(\\hat{c}_1, \\hat{c}_2)$"), "","","",
  #          "$(0.7, 0.7)$","","","",
  #          "$(1, 0)$", "","","",
  #          "$(0, 1)$","","","")
  # tb <- cbind("$(c_1, \\,c_2)$" = c("$(\\hat{c}_1, \\hat{c}_2)$", rep("", 3),
  #                                   "$(0.7, 0.7)$", rep("",3),
  #                                   "$(1, 0)$", rep("", 3),
  #                                   "$(0, 1)$", rep("", 3)),
  #             tb1)
    colnames(tb) <- c("p", "SAUC(95%CI)", "Sens(95%CI)", "Spec(95%CI)", "beta(95%CI)","mu1","mu2","tau1","tau2","rho")

  datatable(tb, #rownames = tb
            ,extensions = 'Buttons',
            options=list(scrollX = TRUE,
                          dom = 'Blfrtip',
                          buttons = list('copy',list( extend='csv', title = "Estimates from sensitivity analysis"), list( extend='excel', title = "Estimates from sensitivity analysis"), list( extend='pdf', title = "Estimates from sensitivity analysis"),  list( extend='excel', title = "Estimates from sensitivity analysis"), list( extend='print', title = "Estimates from sensitivity analysis")))
            )
  })

output$Results01<-renderDataTable({

  # tb2 <-reform.dtametasa(est.rf=est.r,p.seq())
  # tb11<-reform.dtametasa(est.f,p.seq())
  # tb10<-reform.dtametasa(est.f,p.seq(),1)
  tb <-reform.dtametasa(est.rf,p.seq(),0)
  colnames(tb) <- c("p", "SAUC(95%CI)", "Sens(95%CI)", "Spec(95%CI)", "beta(95%CI)","mu1","mu2","tau1","tau2","rho")
    # TeX("$\\beta$(95%CI)"), TeX("$\\mu_1$"), TeX("$\\mu_2$"), TeX("$\\tau_1$"), TeX("$\\tau_2$"), TeX("$\\rho$"))
  # tb1 <- rbind(tb2, tb11, tb10, tb01)
  # tb1[c(1,5,9,13), 5] <- ""
  # tb1[c(1,5,9,13), 5:6] <- NA
  
  # tb <- c( TeX("$(\\hat{c}_1, \\hat{c}_2)$"), "","","",
  #          "$(0.7, 0.7)$","","","",
  #          "$(1, 0)$", "","","",
  #          "$(0, 1)$","","","")
  # tb <- cbind("$(c_1, \\,c_2)$" = c("$(\\hat{c}_1, \\hat{c}_2)$", rep("", 3),
  #                                   "$(0.7, 0.7)$", rep("",3),
  #                                   "$(1, 0)$", rep("", 3),
  #                                   "$(0, 1)$", rep("", 3)),
  #             tb1)
  datatable(tb, #rownames = tb
            ,extensions = 'Buttons',
            options=list(scrollX = TRUE,
                          dom = 'Blfrtip',
                          buttons = list('copy',list( extend='csv', title = "Estimates from sensitivity analysis"), list( extend='excel', title = "Estimates from sensitivity analysis"), list( extend='pdf', title = "Estimates from sensitivity analysis"),  list( extend='excel', title = "Estimates from sensitivity analysis"), list( extend='print', title = "Estimates from sensitivity analysis")))
            )
  })
# output$LogitData<-renderDataTable(datatable(logitData()%>%round(.,3)
#                                             ,extensions = 'Buttons',
#                                             options=(list(scrollX = TRUE,
#                                                           dom = 'Blfrtip',
#                                                           buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
#                                                           lengthMenu = list(c(12))
#                                             ))))

##Reprooducible R codes====
#sever_rmd.R
#Download FRP============================

# output$downloadFRP1<-downloadHandler(filename = "FRP1.png",content = function(file){
#   png(file)
#   par(pty="s",mfrow = c(1,2))
#   plot(1-md()$spec$spec,md()$sens$sens,xlim = c(0,1),ylim=c(0,1),xlab="False positive rate\n(1-Speficity)",ylab = "Sensitivity",pch=16)
#   if(input$ROCellipse){
#     ROCellipse(data(),pch = 16,add = TRUE)
#   }
#   if(input$mslSROC){
#     mslSROC(data(),lty = 2,add = TRUE)
#   }
#   if (input$rsSROC) {
#     rsSROC(data(),lty=3,add = TRUE)
#   }
#   if(input$mrfit){
#     mrfit<-reitsma(data())
#     plot(mrfit,predict=TRUE,cex=2)
#     points(1-md()$spec$spec,md()$sens$sens,pch=16)
#   }
#   dev.off()
# })
# output$downloadFRP2<-downloadHandler(filename = "FRP2.png",content = function(file){
#   png(file)
#   par(pty="s")
#   mrfit<-reitsma(data())
#   plot(mrfit,predict=TRUE,cex=2)
#   points(1-md()$spec$spec,md()$sens$sens,pch=16)
#   dev.off()
# })






##Plot Summary====
#sroc====================================

# sauc1 <- eventReactive(input$sroc.saplot, {input$Sauc1})

SROCA <- reactive({

 sroc.type = input$Sauc1

  par(mfrow = c(2,2), oma = c(3, 3, 0.2, 0.3), mar = c(2, 0.2, 2, 0.2))
#validate(need(length(p.seq())>0,"Input marginal selection probabilities is missing."))
  # withProgress(message = 'Calculating SAUC (1/2)',
  #              detail = 'This may take a while...', value = 0,
  #              {
                 legend.cex <- 1.5
                 col <- gray.colors(length(p.seq()), gamma = 1, start = 0, end = 0.5)
                 title.cex <- 1.7
                 est2.par  <-est.rf(c0(),FALSE,c("mu1","mu2","tau1","tau2","rho"),informMessage="Please click to calculate SROC.")
                 sauc2  <- est.rf(c0(),FALSE,par="sauc.ci","sauc",informMessage="Please click to calculate SROC.")

                 # incProgress(1/4)
                 ##B=======#   
                 ## ESITMATION WHEN c1 = c2
                 est11.par <- est.rf(c1.square=0.5,TRUE,c("mu1","mu2","tau1","tau2","rho"),informMessage="Please click to calculate SROC.")
                 sauc11 <- est.rf(c1.square=0.5,TRUE,c("sauc"),par = "sauc.ci",informMessage="Please click to calculate SROC.")##est11()[2,]


                 # incProgress(2/4)
                 est10.par<-est.rf(c1.square=1,TRUE,c("mu1","mu2","tau1","tau2","rho"),informMessage="Please click to calculate SROC.")#est10()[15:19,]
                 
                 # incProgress(3/4)
                 est01.par <- est.rf(c1.square=0,TRUE,c("mu1","mu2","tau1","tau2","rho"),informMessage="Please click to calculate SROC.")#est01()[15:19,]
                 
                 sauc10 <- est.rf(c1.square=1,TRUE, c("sauc"),par = "sauc.ci",informMessage="Please click to calculate SROC.")#est10()[2,]
                 sauc01 <- est.rf(c1.square=0,TRUE, c("sauc"),par = "sauc.ci",informMessage="Please click to calculate SROC.")#est01()[2,]

                 
                 plot(1-sp(), se(), type = "p", ylim = c(0,1), xlim = c(0,1),
                      xlab = "", ylab = "Sensitivity")
                
                try(SROC(est2.par, addon  = TRUE, sroc.type = sroc.type,sp.pch = 18,sp.cex = 2))            
                 legend("bottomright",
                        bty='n',
                        legend = c(sprintf("p = %.1f, SAUC = %.3f", p.seq(), sauc2)),
                        col = col, 
                        pch = 18, pt.cex = 2, cex = legend.cex,
                        lty = rep(1,3))                 
                 title("(A)", adj = 0, font.main = 1, cex.main = title.cex)
                 title(TeX("$(\\hat{c}_1, \\, \\hat{c}_2)$"), cex.main = title.cex)
                 mtext("Sensitivity", side=2, line=2, at=0.5, cex = 1)
                 


                 plot(1-sp(), se(), type = "p", ylim = c(0,1), xlim = c(0,1), 
                      xlab = "",
                      yaxt = "n")
                 try(SROC(est11.par, addon = TRUE,sroc.type =  sroc.type,sp.pch = 18,sp.cex = 2))
                 legend("bottomright", 
                        bty='n',
                        legend = c(sprintf("p = %.2f, SAUC = %.3f", p.seq(), sauc11)), 
                        col = col, pch = 18, pt.cex = 2, cex = legend.cex, 
                        lty = rep(1,3))
                 title("(B)", adj = 0, font.main = 1, cex.main = title.cex)
                 title(TeX("$(c_1, \\,c_2) = (1/\\sqrt{2}, 1/\\sqrt{2})$"), cex.main = title.cex)

                 ## zC
                 
                 plot(1-sp(), se(), type = "p", ylim = c(0,1), xlim = c(0,1), 
                      xlab = "",
                      ylab = "")
                 try(SROC(est10.par, addon = TRUE, sroc.type = sroc.type,sp.pch = 18,sp.cex = 2))
                 legend("bottomright", 
                        bty='n',
                        legend = c(sprintf("p = %.2f, SAUC = %.3f", p.seq(), sauc10)), 
                        col = col, pch = 18, pt.cex = 2, cex = legend.cex, 
                        lty = rep(1,3))
                 title("(C)", adj = 0, font.main = 1, cex.main = title.cex)
                 title(TeX("$(c_1,\\, c_2) = (1,\\, 0)$"), cex.main = title.cex)
                 mtext("1-Specificity", side=1, line=2, at=0.5, cex = 1)
                 mtext("Sensitivity", side=2, line=2, at=0.5, cex = 1)

                 ## D
                 
                 plot(1-sp(), se(), type = "p", ylim = c(0,1), xlim = c(0,1), 
                      xlab = "",
                      yaxt = "n")

                 try(SROC(est01.par, addon = TRUE, sroc.type = sroc.type,sp.pch = 18,sp.cex = 2))
                 legend("bottomright", 
                        bty='n',
                        legend = c(sprintf("p = %.2f, SAUC = %.3f", p.seq(), sauc01)), 
                        col = col, pch = 18, pt.cex = 2, cex = legend.cex, 
                        lty = rep(1,3))
                 title("(D)", adj = 0, font.main = 1, cex.main = title.cex)
                 title(TeX("$(c_1,\\, c_2) = (0,\\, 1)$"), cex.main = title.cex)
                 mtext("1-Specificity", side=1, line=2, at=0.5, cex = 1)
                  # itle(xlab = "1-Specificity", line=2, cex = 1)
                

  })

output$srocA<-renderPlot({

SROCA()
               # })
})
#download sroc====================================
# output$downloadsrocA<-downloadHandler(

#   filename = "SROC_All.png",#contentType = "image/png",
#   content = function(file){
  
#   png(file)
#   # legend.cex <- 1
#   # col <- gray.colors(length(p.seq()), gamma = 1, start = 0, end = 0.5)
#   # title.cex <- 1.5
#   # est2.par  <-est.r(0.5,c("mu1","mu2","tau1","tau2","rho"))
#   # sauc2  <- est.r(0.5,par="sauc.ci","sauc")
#   # ##B=======#   
#   # ## ESITMATION WHEN c1 = c2
#   # est11.par <- est.f(c1.square=0.5,c("mu1","mu2","tau1","tau2","rho"))
#   # sauc11 <- est.f(c1.square=0.5,c("sauc"),par = "sauc.ci")##est11()[2,]
  
#   # est10.par<-est.f(c1.square=1,c("mu1","mu2","tau1","tau2","rho"))#est10()[15:19,]
#   # est01.par <- est.f(c1.square=0,c("mu1","mu2","tau1","tau2","rho"))#est01()[15:19,]
  
#   # sauc10 <- est.f(c1.square=1,c("sauc"),par = "sauc.ci")#est10()[2,]
#   # sauc01 <- est.f(c1.square=0,c("sauc"),par = "sauc.ci")#est01()[2,]
  
  
#   # replayPlot(SROCA())
#   # par(mfrow = c(2,2), oma = c(0.2, 3, 0.2, 0.3), mar = c(2, 0.2, 2, 0.2))
#   # #A
#   # plot(1-sp(), se(), type = "p", ylim = c(0,1), xlim = c(0,1),
#   #      xlab = "", ylab = "")
#   # SROC(est2.par, addon  = TRUE, sauc.type = input$Sauc1)
  
#   # legend("bottomright",
#   #        bty='n',
#   #        legend = c(sprintf("p = %.1f, SAUC = %.3f", p.seq(), sauc2)),
#   #        col = col, pch = 18, pt.cex = 2, cex = legend.cex,
#   #        lty = rep(1,3))
  
#   # title("(A)", adj = 0, font.main = 1, cex.main = title.cex)
#   # title(TeX("$(\\hat{c}_1, \\, \\hat{c}_2)$"), cex.main = title.cex)
#   # title(xlab = "FPR", line=2, cex = 0.7)
#   # mtext("TPR", side=2, line=2, at=0.5, cex = 0.7)
#   # #B
#   # plot(1-sp(), se(), type = "p", ylim = c(0,1), xlim = c(0,1), 
#   #      xlab = "",
#   #      yaxt = "n")
#   # SROC(est11.par, addon = TRUE, sroc.type =  input$Sauc1)
#   # legend("bottomright", 
#   #        bty='n',
#   #        legend = c(sprintf("p = %.1f, SAUC = %.3f", p.seq(), sauc11)), 
#   #        col = col, pch = 18, pt.cex = 2, cex = legend.cex, 
#   #        lty = rep(1,3))
#   # title("(B)", adj = 0, font.main = 1, cex.main = title.cex)
#   # title(TeX("$(c_1, \\,c_2) = (1/\\sqrt{2}, 1/\\sqrt{2})$"), cex.main = title.cex)
#   # title(xlab = "FPR", line=2, cex = 0.7)
#   # ## C
  
#   # plot(1-sp(), se(), type = "p", ylim = c(0,1), xlim = c(0,1), 
#   #      xlab = "",
#   #      yaxt = "n")
#   # SROC(est10.par, addon = TRUE, sroc.type = input$Sauc1)
#   # legend("bottomright", 
#   #        bty='n',
#   #        legend = c(sprintf("p = %.1f, SAUC = %.3f", p.seq(), sauc10)), 
#   #        col = col, pch = 18, pt.cex = 2, cex = legend.cex, 
#   #        lty = rep(1,3))
#   # title("(C)", adj = 0, font.main = 1, cex.main = title.cex)
#   # title(TeX("$(c_1,\\, c_2) = (1,\\, 0)$"), cex.main = title.cex)
#   # title(xlab = "FPR", line=2, cex = 0.7)
#   # ## D
  
#   # plot(1-sp(), se(), type = "p", ylim = c(0,1), xlim = c(0,1), 
#   #      xlab = "",
#   #      yaxt = "n")
#   # SROC(est01.par, addon = TRUE, sroc.type = input$Sauc1)
#   # legend("bottomright", 
#   #        bty='n',
#   #        legend = c(sprintf("p = %.1f, SAUC = %.3f", p.seq(), sauc01)), 
#   #        col = col, pch = 18, pt.cex = 2, cex = legend.cex, 
#   #        lty = rep(1,3))
#   # title("(D)", adj = 0, font.main = 1, cex.main = title.cex)
#   # title(TeX("$(c_1,\\, c_2) = (0,\\, 1)$"), cex.main = title.cex)
#   # title(xlab = "FPR", line=2, cex = 0.7)
  
#   dev.off()
# })

###sauc---------------

SAUCA <- reactive({

legend.cex <- 1.5
title.cex <- 1.7
  # withProgress(message = 'Calculating SUC (2/2)',
  #              detail = 'This may take a while...', value = 0,
  #              {
 par(mfrow = c(2,2), oma = c(3, 3, 0.2, 0.3), mar = c(2, 0.2, 2, 0.2))
 # par(mfrow = c(2,2), oma = c(0.2, 3, 0.2, 0.3), mar = c(3, 2, 2, 0.2))
 est.sauc2<-est.rf(0.5,FALSE,par="sauc.ci",p=p.10())
 matplot(t(est.sauc2),ylim=c(0,1), type = "b",lty = c(1,2,2), pch=20, col = c(1, 2,2),
         ylab = "SAUC", xlab = "", xaxt = "n", yaxt = "n")
 title(TeX("$(\\hat{c}_1, \\, \\hat{c}_2)$"), cex.main = title.cex)
 axis(1, at = 1:length(p.10()), labels = p.10())
 axis(2, at = seq(0, 1, 0.2), labels = seq(0, 1, 0.2))
 abline(h=0.5, col="grey54", lty=2)
 title("(A)", adj = 0, font.main = 1, cex.main = title.cex)
 title(xlab = "p", line=2, cex = 0.7)
 mtext("SAUC", side=2, line=2, at=0.5, cex = 0.7)
 legend("bottomright", bty='n',legend = c("SAUC", "95%CI"), col = 1:2, lty = 1:2, cex = legend.cex)

 
 # incProgress(1/4)
 ## F(B)
 est.sauc2<-est.rf(c1.square=0.5,TRUE,par = "sauc.ci",p=p.10())
 matplot(t(est.sauc2),ylim=c(0,1), type = "b",lty = c(1,2,2), pch=20, col = c(1, 2,2),
         ylab = "SAUC", xlab = "", xaxt = "n", yaxt = "n")
 title(TeX("$(c_1, \\,c_2) = (1/\\sqrt{2}, 1/\\sqrt{2})$"), cex.main = title.cex)
 axis(1, at = 1:length(p.10()), labels = p.10())
 abline(h=0.5, col="grey54", lty=2)
 title("(B)", adj = 0, font.main = 1, cex.main = title.cex)
 title(xlab = "p", line=2, cex = 0.7) 
  legend("bottomright", bty='n',legend = c("SAUC", "95%CI"), col = 1:2, lty = 1:2, cex = legend.cex)


 est.sauc2<-est.rf(c1.square=1,TRUE,par = "sauc.ci",p=p.10())
 matplot(t(est.sauc2),ylim=c(0,1), type = "b",lty = c(1,2,2), pch=20, col = c(1, 2,2),
         ylab = "SAUC", xlab = "", xaxt = "n", yaxt = "n")
 title(TeX("$(c_1, \\,c_2) = (1, \\,0)$"), cex.main = title.cex)
 axis(1, at = 1:length(p.10()), labels = p.10())
 axis(2, at = seq(0,1, 0.2), labels = seq(0,1, 0.2))
 abline(h=0.5, col="grey54", lty=2)
 title("(C)", adj = 0, font.main = 1, cex.main = title.cex)
 title(xlab = "p", line=2, cex = 0.7)
 mtext("SAUC", side=2, line=2, at=0.5, cex = 0.7)
legend("bottomright", bty='n',legend = c("SAUC", "95%CI"), col = 1:2, lty = 1:2, cex = legend.cex)
 
 
 # incProgress(1/4)
 ## H(D)
 
 est.sauc2<-est.rf(c1.square=0,TRUE,par = "sauc.ci",p=p.10())
 matplot(t(est.sauc2),ylim=c(0,1), type = "b",lty = c(1,2,2), pch=20, col = c(1, 2,2),
         ylab = "SAUC", xlab = "", xaxt = "n", yaxt = "n")
 title(TeX("$(c_1, \\,c_2) = (0, \\,1)$"), cex.main = title.cex)
 axis(1, at = 1:length(p.10()), labels = p.10())
 abline(h=0.5, col="grey54", lty=2)
 title("(D)", adj = 0, font.main = 1, cex.main = title.cex)
 title(xlab = "p", line=2, cex = 0.7)
  legend("bottomright", bty='n',legend = c("SAUC", "95%CI"), col = 1:2, lty = 1:2, cex = legend.cex)

  })

output$sauc<-renderPlot({
  
  SAUCA()
                               # incProgress(1/4)
               # })
  
})
#download sauc======================================================
# output$downloadsauc <- downloadHandler(filename ="dtametasa_fc.png",contentType = "image/png",
#                                        content = function(file) {

#                                         p.10() <- p.10()
#                                          png(file)
#                                          title.cex <- 1.5
#                                          par(mfrow = c(2,2), oma = c(0.2, 3, 0.2, 0.3), mar = c(3, 2, 2, 0.2))
                                         
#                                          matplot(t(est.r(c1.square = 0.5,par = "sauc.ci",p = p.10())),ylim=c(0,1), type = "b",lty = c(1,2,2), pch=20, col = c(1, 2,2),
#                                                  ylab = "SAUC", xlab = "", xaxt = "n", yaxt = "n")
#                                          title(TeX("$(\\hat{c}_1, \\, \\hat{c}_2)$"), cex.main = title.cex)
#                                          axis(1, at = 1:length(p.10()), labels = p.10())
#                                          axis(2, at = seq(0, 1, 0.2), labels = seq(0, 1, 0.2))
#                                          abline(h=0.5, col="grey54", lty=2)
#                                          title("(E)", adj = 0, font.main = 1, cex.main = title.cex)
#                                          title(xlab = "p", line=2, cex = 0.7)
#                                          mtext("SAUC", side=2, line=2, at=0.5, cex = 0.7)
                                         
#                                          ## F(B)
                                         
#                                          matplot(t(est.f(c1.square = 0.5,par = "sauc.ci",p = p.10())),ylim=c(0,1), type = "b",lty = c(1,2,2), pch=20, col = c(1, 2,2),
#                                                  ylab = "SAUC", xlab = "", xaxt = "n", yaxt = "n")
#                                          title(TeX("$(c_1, \\,c_2) = (1/\\sqrt{2}, 1/\\sqrt{2})$"), cex.main = title.cex)
#                                          axis(1, at = 1:length(p.10()), labels = p.10())
#                                          abline(h=0.5, col="grey54", lty=2)
#                                          title("(F)", adj = 0, font.main = 1, cex.main = title.cex)
#                                          title(xlab = "p", line=2, cex = 0.7)
#                                          matplot(t(est.f(c1.square = 1,par = "sauc.ci",p = p.10())),ylim=c(0,1), type = "b",lty = c(1,2,2), pch=20, col = c(1, 2,2),
#                                                  ylab = "SAUC", xlab = "", xaxt = "n", yaxt = "n")
#                                          title(TeX("$(c_1, \\,c_2) = (1, \\,0)$"), cex.main = title.cex)
#                                          axis(1, at = 1:length(p.10()), labels = p.10())
#                                          axis(2, at = seq(0.4,1, 0.2), labels = seq(0.4,1, 0.2))
#                                          abline(h=0.5, col="grey54", lty=2)
#                                          title("(G)", adj = 0, font.main = 1, cex.main = title.cex)
#                                          title(xlab = "p", line=2, cex = 0.7)
                                         
                                         
#                                          ## H(D)
                                         
#                                          matplot(t(est.f(c1.square = 0,par = "sauc.ci",p = p.10())),ylim=c(0,1), type = "b",lty = c(1,2,2), pch=20, col = c(1, 2,2),
#                                                  ylab = "SAUC", xlab = "", xaxt = "n", yaxt = "n")
#                                          title(TeX("$(c_1, \\,c_2) = (0, \\,1)$"), cex.main = title.cex)
#                                          axis(1, at = 1:length(p.10()), labels = p.10())
#                                          axis(4, at = seq(0.4,1, 0.2), labels = seq(0.4,1, 0.2))
#                                          abline(h=0.5, col="grey54", lty=2)
#                                          title("(H)", adj = 0, font.main = 1, cex.main = title.cex)
#                                          title(xlab = "p", line=2, cex = 0.7)
#                                          dev.off()}
# )
###curve===============
# output$curveAandB<-renderPlot({
#   title.cex <- 1.5
#   par(mfrow = c(2, 2), oma = c(0.2, 1, 0.2, 0.2), mar = c(3, 2.5, 2, 0.2))
#   ldata <- data.lg()
#   c1<- est.r(0.5,"c1")
#   #   sapply(p.seq(),function(x){
#   #   if(length(esting[[paste0(x,input$Sauc1,input$allsingle)]])==0) est.add_rc(x)$par[c("c1")]
#   #   else esting[[paste0(x,input$Sauc1,input$allsingle)]]$par["c1"]
#   # })
#   #c1 <- sqrt(est2()["c1",]); 
#   c2 <- sqrt(1-c1^2)
#   t11 <- (ldata$y1 + ldata$y2)/sqrt(ldata$v1+ldata$v2)
#   t10 <- (ldata$y1 )/sqrt(ldata$v1)
#   t01 <- (ldata$y2)/sqrt(ldata$v2)
#   beta2  <- est.r(0.5,c("beta"));  alpha2  <- est.r(par="alpha")
#   beta11 <- est.f(0.5,c("beta"));alpha11 <- est.f(0.5,par="alpha")# est11()["beta",]; alpha11 <- est11()["alpha",]
#   beta10 <- est.f(1,c("beta")); alpha10 <- est.f(1,par="alpha")
#   beta01 <- est.f(0,c("beta")); alpha01 <-est.f(0,par="alpha")
#   ytext<-("$p = \\Phi(\\beta \\, t + \\alpha)$")
#   ## A
#   curve(pnorm(beta2[2]*x + alpha2[2]), -5, 15, ylim = c(0,1),
#         xlab = "", 
#         col=2,
#         yaxt='n')
#   axis(2, at=c(0,0.5,1), labels = c(0,0.5,1))
#   curve(pnorm(beta2[3]*x + alpha2[3]), -5, 15, add = TRUE, col=3)
#   curve(pnorm(beta2[4]*x + alpha2[4]), -5, 15, add = TRUE, col=4)
  
#   t02 <- (c1[2]*ldata$y1 + c2[2]*ldata$y2)/sqrt(c1[2]^2*ldata$v1+c2[2]^2*ldata$v2)
#   t03 <- (c1[3]*ldata$y1 + c2[3]*ldata$y2)/sqrt(c1[3]^2*ldata$v1+c2[3]^2*ldata$v2)
#   t04 <- (c1[4]*ldata$y1 + c2[4]*ldata$y2)/sqrt(c1[4]^2*ldata$v1+c2[4]^2*ldata$v2)
#   points(t02, rep(0.2, length(t02)), pch="|", col=2, cex = 1)
#   points(t03, rep(0.1, length(t03)), pch="|", col=3, cex = 1)
#   points(t04, rep(0,   length(t04)), pch="|", col=4, cex = 1)
#   title(TeX("$(\\hat{c}_1, \\, \\hat{c}_2)$"), cex.main = title.cex)
#   legend("bottomright", 
#          bty='n',
#          legend = TeX(sprintf("$p = %.1f$", p.seq()[-1])), 
#          col = 2:4, cex = 1.2, 
#          lty = rep(1,3))
#   title("(A)", adj = 0, font.main = 1, cex.main = title.cex)
#   mtext(TeX(c(ytext)), side=2, line=2, at=c(0.5), cex = 0.8)
#   title(xlab = "t", line=2, cex = 0.7)
#   ## B
  
#   curve(pnorm(beta11[2]*x + alpha11[2]), -5, 15,ylim = c(0,1),
#         xlab = "", 
#         col=2,
#         yaxt='n')
#   curve(pnorm(beta11[3]*x + alpha11[3]), -5, 15, add = TRUE, col=3)
#   curve(pnorm(beta11[4]*x + alpha11[4]), -5, 15, add = TRUE, col=4)
#   points(t11, rep(0, length(t11)), pch="|", cex = 1)
#   title(TeX("$(c_1, \\,c_2) = (1/\\sqrt{2}, 1/\\sqrt{2})$"), cex.main = title.cex)
#   legend("bottomright", 
#          bty='n',
#          legend = TeX(sprintf("$p = %.1f$", p.seq()[-1])), 
#          col = 2:4, cex = 1.2, 
#          lty = rep(1,3))
#   title("(B)", adj = 0, font.main = 1, cex.main = title.cex)
#   title(xlab = "t", line=2, cex = 0.7)
#   ## C
  
#   curve(pnorm(beta10[2]*x + alpha10[2]), -5, 15,ylim = c(0,1),
#         xlab = "", 
#         col=2,
#         yaxt='n')
#   axis(2, at=c(0,0.5,1), labels = c(0,0.5,1))
#   curve(pnorm(beta10[3]*x + alpha10[3]), -5, 15, add = TRUE, col=3)
#   curve(pnorm(beta10[4]*x + alpha10[4]), -5, 15, add = TRUE, col=4)
#   points(t10, rep(0, length(t10)), pch="|", cex = 1)
#   title(TeX("$(c_1, \\,c_2) = (1, \\,0)$"), cex.main = title.cex)
#   legend("bottomright", 
#          bty='n',
#          legend = TeX(sprintf("$p = %.1f$", p.seq()[-1])), 
#          col = 2:4, cex = 1.2, 
#          lty = rep(1,3))
#   title("(C)", adj = 0, font.main = 1, cex.main = title.cex)
#   mtext(TeX(c(ytext)), side=2, line=2, at=c(0.5), cex = 0.8)
#   title(xlab = "t", line=2, cex = 0.7)
  
#   ## D
  
#   curve(pnorm(beta01[2]*x + alpha01[2]), -5, 15, ylim = c(0,1),
#         xlab = "", 
#         col=2,
#         yaxt='n')
#   curve(pnorm(beta01[3]*x + alpha01[3]), -5, 15, add = TRUE, col=3)
#   curve(pnorm(beta01[4]*x + alpha01[4]), -5, 15, add = TRUE, col=4)
#   points(t01, rep(0, length(t01)), pch="|", cex = 1)
#   title(TeX("$(c_1, \\,c_2) = (0, \\,1)$"), cex.main = title.cex)
#   legend("bottomright", 
#          bty='n',
#          legend = TeX(sprintf("$p = %.1f$", p.seq()[-1])), 
#          col = 2:4, cex = 1.2, 
#          lty = rep(1,3))
#   title("(D)", adj = 0, font.main = 1, cex.main = title.cex)
#   title(xlab = "t", line=2, cex = 0.7)
  
  
#   par(mfrow = c(1, 1))
  
# })
# ###download curve ===============
# output$downloadcurveAandB <- downloadHandler(filename = function() {
#   paste0("dtametasa_fc.png")
# },contentType = "image/png"
# ,content = function(file) {
#   png(file)
#   title.cex <- 1.5
#   par(mfrow = c(2, 2), oma = c(0.2, 1, 0.2, 0.2), mar = c(3, 2.5, 2, 0.2))
#   ldata <- data.lg()
#   c1<- est.r(0.5,"c1")
#   c2 <- sqrt(1-c1^2)
#   t11 <- (ldata$y1 + ldata$y2)/sqrt(ldata$v1+ldata$v2)
#   t10 <- (ldata$y1 )/sqrt(ldata$v1)
#   t01 <- (ldata$y2)/sqrt(ldata$v2)
#   beta2  <- est.r(0.5,c("beta"));  alpha2  <- est.r(par="alpha")
#   beta11 <- est.f(0.5,c("beta"));alpha11 <- est.f(0.5,par="alpha")# est11()["beta",]; alpha11 <- est11()["alpha",]
#   beta10 <- est.f(1,c("beta")); alpha10 <- est.f(1,par="alpha")
#   beta01 <- est.f(0,c("beta")); alpha01 <-est.f(0,par="alpha")
  
#   ytext<-("$p = \\Phi(\\beta \\, t + \\alpha)$")
#   ## A
#   curve(pnorm(beta2[2]*x + alpha2[2]), -5, 15, ylim = c(0,1),
#         xlab = "", 
#         col=2,
#         yaxt='n')
#   axis(2, at=c(0,0.5,1), labels = c(0,0.5,1))
#   curve(pnorm(beta2[3]*x + alpha2[3]), -5, 15, add = TRUE, col=3)
#   curve(pnorm(beta2[4]*x + alpha2[4]), -5, 15, add = TRUE, col=4)
  
#   t02 <- (c1[2]*ldata$y1 + c2[2]*ldata$y2)/sqrt(c1[2]^2*ldata$v1+c2[2]^2*ldata$v2)
#   t03 <- (c1[3]*ldata$y1 + c2[3]*ldata$y2)/sqrt(c1[3]^2*ldata$v1+c2[3]^2*ldata$v2)
#   t04 <- (c1[4]*ldata$y1 + c2[4]*ldata$y2)/sqrt(c1[4]^2*ldata$v1+c2[4]^2*ldata$v2)
#   points(t02, rep(0.2, length(t02)), pch="|", col=2, cex = 1)
#   points(t03, rep(0.1, length(t03)), pch="|", col=3, cex = 1)
#   points(t04, rep(0,   length(t04)), pch="|", col=4, cex = 1)
#   title(TeX("$(\\hat{c}_1, \\, \\hat{c}_2)$"), cex.main = title.cex)
#   legend("bottomright", 
#          bty='n',
#          legend = TeX(sprintf("$p = %.1f$", p.seq()[-1])), 
#          col = 2:4, cex = 1.2, 
#          lty = rep(1,3))
#   title("(A)", adj = 0, font.main = 1, cex.main = title.cex)
#   mtext(TeX(c(ytext)), side=2, line=2, at=c(0.5), cex = 0.8)
#   title(xlab = "t", line=2, cex = 0.7)
#   ## B
  
#   curve(pnorm(beta11[2]*x + alpha11[2]), -5, 15,ylim = c(0,1),
#         xlab = "", 
#         col=2,
#         yaxt='n')
#   curve(pnorm(beta11[3]*x + alpha11[3]), -5, 15, add = TRUE, col=3)
#   curve(pnorm(beta11[4]*x + alpha11[4]), -5, 15, add = TRUE, col=4)
#   points(t11, rep(0, length(t11)), pch="|", cex = 1)
#   title(TeX("$(c_1, \\,c_2) = (1/\\sqrt{2}, 1/\\sqrt{2})$"), cex.main = title.cex)
#   legend("bottomright", 
#          bty='n',
#          legend = TeX(sprintf("$p = %.1f$", p.seq()[-1])), 
#          col = 2:4, cex = 1.2, 
#          lty = rep(1,3))
#   title("(B)", adj = 0, font.main = 1, cex.main = title.cex)
#   title(xlab = "t", line=2, cex = 0.7)
#   ## C
  
#   curve(pnorm(beta10[2]*x + alpha10[2]), -5, 15,ylim = c(0,1),
#         xlab = "", 
#         col=2,
#         yaxt='n')
#   axis(2, at=c(0,0.5,1), labels = c(0,0.5,1))
#   curve(pnorm(beta10[3]*x + alpha10[3]), -5, 15, add = TRUE, col=3)
#   curve(pnorm(beta10[4]*x + alpha10[4]), -5, 15, add = TRUE, col=4)
#   points(t10, rep(0, length(t10)), pch="|", cex = 1)
#   title(TeX("$(c_1, \\,c_2) = (1, \\,0)$"), cex.main = title.cex)
#   legend("bottomright", 
#          bty='n',
#          legend = TeX(sprintf("$p = %.1f$", p.seq()[-1])), 
#          col = 2:4, cex = 1.2, 
#          lty = rep(1,3))
#   title("(C)", adj = 0, font.main = 1, cex.main = title.cex)
#   mtext(TeX(c(ytext)), side=2, line=2, at=c(0.5), cex = 0.8)
#   title(xlab = "t", line=2, cex = 0.7)
  
#   ## D
  
#   curve(pnorm(beta01[2]*x + alpha01[2]), -5, 15, ylim = c(0,1),
#         xlab = "", 
#         col=2,
#         yaxt='n')
#   curve(pnorm(beta01[3]*x + alpha01[3]), -5, 15, add = TRUE, col=3)
#   curve(pnorm(beta01[4]*x + alpha01[4]), -5, 15, add = TRUE, col=4)
#   points(t01, rep(0, length(t01)), pch="|", cex = 1)
#   title(TeX("$(c_1, \\,c_2) = (0, \\,1)$"), cex.main = title.cex)
#   legend("bottomright", 
#          bty='n',
#          legend = TeX(sprintf("$p = %.1f$", p.seq()[-1])), 
#          col = 2:4, cex = 1.2, 
#          lty = rep(1,3))
#   title("(D)", adj = 0, font.main = 1, cex.main = title.cex)
#   title(xlab = "t", line=2, cex = 0.7)
  
  
#   par(mfrow = c(1, 1))
#   dev.off()})
