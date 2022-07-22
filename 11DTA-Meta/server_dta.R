 p.10 <- seq(10,1, -1)/10
#p.10 <- 0.5
studyId<-reactiveVal(0)
data<-reactiveVal(data.frame(study=seq(1:14)
                             ,TP=c(12,10,17,13,4,15,45,18,5,8,5,11,5,7)
                             ,FN=c(0,2,1,0,0,2,5,4,0,9,0,2,1,5)
                             ,FP=c(29,14,36,18,21,122,28,69,11,15,7,122,6,25)
                             ,TN=c(289,72,85,67,225,403,34,133,34,96,63,610,145,342)))
esting<-reactiveValues()
esting_omg<-reactiveValues()
observe({
  inFile1 <- input$filer
  separater <- input$Delimiter
  if (is.null(inFile1)||input$manualInputTRUE=='Manual input'){
    DATA<-read.table(text=input$manualInput,sep = separater,header = TRUE)
    #validate(need(DATA$TP & DATA$FN & DATA$TN & DATA$FP,"Data must contain TP,FN,TN,FP"))
    if(is.null(DATA$TP) || is.null(DATA$FN)|| is.null(DATA$TN) || is.null(DATA$FP)){
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
      return()
    }
    data(DATA)
  }
  else{
    list1<-read.csv(inFile1$datapath,sep = separater, header=TRUE)
    validate(need(list1$TP & list1$FN & list1$TN & list1$FP,"Data must contain TP,FP,FN,TP"))
    list2<-read.csv(inFile1$datapath,sep = separater, header=FALSE)
    data(list1)
    y<-""
    for (i in 1:length(list2)){
      if (i==length(list2)) {
        y<-paste(y,list2[[i]],sep = "")
        break()
      }
      y<-paste(y,list2[[i]],separater,sep = "")
    }
    updateAceEditor(session,"manualInput",value =paste(y,collapse ="\n"))
  }
  data(read.csv(text=input$manualInput,sep = separater,header = TRUE))
  newID<-studyId()+1
  studyId(newID)
})%>%bindEvent(input$calculateStart)
observe({
  withProgress(message = "Calculation one second",detail = 'This may take a while...', value = 0,
               {
                 est.rc(p.10)
                 incProgress(1/4)
                 est.fc(p.10,c1.square = 1)
                 incProgress(1/4)
                 est.fc(p.10,c1.square = 0.5)
                 incProgress(1/4)
                 est.fc(p.10,c1.square = 0)
                 incProgress(1/5)
                 est.rc(p.seq())
                 est.fc(p.seq(),c1.square = 1)
                 est.fc(p.seq(),c1.square = 0.5)
                 est.fc(p.seq(),c1.square = 0)
               })
})%>%bindEvent(p.seq(),input$Sauc1,input$allsingle,input$calculateStart)
observe(est.fc(p.seq(),c1.square =input$c1c2_set))%>%bindEvent(input$c1c2_set,input$Sauc1,input$allsingle,input$calculateStart)

observe({
  inFile1 <- input$filer
  separater <- input$Delimiter
  list1<-read.csv(inFile1$datapath,sep = separater, header=TRUE)
  if(is.null(list1$TP) || is.null(list1$FN)|| is.null(list1$TN) || is.null(list1$FP)){
    data_ErrorMessage()
    return()
    }
  list2<-read.csv(inFile1$datapath,sep = separater, header=FALSE)
  y<-""
  for (i in 1:length(list2)){
    if (i==length(list2)) {
      y<-paste(y,list2[[i]],sep = "")
      break()
    }
    y<-paste(y,list2[[i]],separater,sep = "")
  }
  updateAceEditor(session,"manualInput",value =paste(y,collapse ="\n"))
  updateRadioButtons(session,"manualInputTRUE",selected = "Manual input")
  
})%>%bindEvent(input$filer)
md <- reactive(mada::madad(data()))
p.seq<-reactiveVal(NULL)
output$studyId<-renderUI({
  radioButtons("momomo","",inline = TRUE,choices = paste0("studyID",seq(studyId(),0)))
})
output$uiprob<-renderText({
  probs<-round(as.numeric(unlist(strsplit(input$plist, "[,;\n\t\r]"))),2)
  validate(need(identical(probs<=1&probs>0,rep(TRUE,length(probs))),paste("Each value must be from 0 to 1.\nEach value must be separated by a space or a comma.",paste(probs,collapse = ","))))
  probs<-sort(probs,decreasing = TRUE)
  p.seq(probs)
  paste("p=",probs," ",sep = "")})
logitData<-reactive(logit.data(correction(data(), type = input$allsingle)))%>%bindCache(input$allsingle,studyId())%>%bindEvent(input$calculateStart,input$allsingle)
###data preculculate=====

sp <-reactive(data()$TN/(data()$TN+data()$FP))%>%bindEvent(studyId())
se <-reactive(data()$TP/(data()$TP+data()$FN))%>%bindEvent(studyId())
est.add_rc<-function(p,  c1.square=0.5){
  rc<-c(p=p,dtametasa.rc(data(), p,  c1.square0 = 0.5, beta.interval = c(0,2), sauc.type =  input$Sauc1,correct.type = input$allsingle))
  esting[[paste0(p,input$Sauc1,input$allsingle,studyId())]]<-rc
  rc
}
est.add_fc<-function(p,  c1.square=0.5){
  fc<- c(p=p,dtametasa_fc(data(), p,  c1.square=c1.square, beta.interval = c(0,2), sauc.type =  input$Sauc1,correct.type = input$allsingle))
  esting_omg[[paste0(p,c1.square,input$Sauc1,input$allsingle,studyId())]]<-fc
  fc
}
est.rc<-function(p.seq){sapply(p.seq,function(p){
  if(length(esting[[paste0(p,input$Sauc1,input$allsingle,studyId())]])==0) est.add_rc(p)
})}
est.fc<-function(p.seq,c1.square=0.5){sapply(p.seq,function(p){
  if(length(esting_omg[[paste0(p,c1.square,input$Sauc1,input$allsingle,studyId())]])==0) est.add_fc(p,c1.square)
})}
est.r<-function(c1.square=0.5,...,par="par",p=p.seq()){sapply(p,function(x){
  validate(need(length(esting[[paste0(x,input$Sauc1,input$allsingle,studyId())]])>0,"Push Above Button[Reload DATA TO Calculation]\nerror 111"))
  esting[[paste0(x,input$Sauc1,input$allsingle,studyId())]][[par]][...]
})}
est.f<-function(c1.square=0.5,...,par="par",p=p.seq()){sapply(p,function(x){
  validate(need(length(esting[[paste0(x,input$Sauc1,input$allsingle,studyId())]])>0,"Push Above Button[Reload DATA TO Calculation]\nerror 112"))
  esting_omg[[paste0(x,c1.square,input$Sauc1,input$allsingle,studyId())]][[par]][...]
})}
#data input=================e ================================================================
output$RawData<-DT::renderDataTable({
    datatable(data()
              ,extensions = 'Buttons',
              options=(list(scrollX = TRUE,
                            dom = 'Blfrtip',
                            buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
                            lengthMenu = list(c(12))
              )))
  
})
#logit===============
output$LogitData<-renderDataTable(datatable(logitData()%>%round(.,3)
                                            ,extensions = 'Buttons',
                                            options=(list(scrollX = TRUE,
                                                          dom = 'Blfrtip',
                                                          buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
                                                          lengthMenu = list(c(12))
                                            ))))
output$Results<-renderDataTable({
  tb2<-reform.dtametasa(est.rf=est.r,p.seq())
  tb11<-reform.dtametasa(est.f,p.seq())
  tb10<-reform.dtametasa(est.f,p.seq(),1)
  tb01<-reform.dtametasa(est.f,p.seq(),0)
  tb1 <- rbind(tb2, tb11, tb10, tb01)
  tb1[c(1,5,9,13), 5] <- ""
  tb1[c(1,5,9,13), 5:6] <- NA
  
  tb <- c( TeX("$(\\hat{c}_1, \\hat{c}_2)$"), "","","",
           "$(0.7, 0.7)$","","","",
           "$(1, 0)$", "","","",
           "$(0, 1)$","","","")
  # tb <- cbind("$(c_1, \\,c_2)$" = c("$(\\hat{c}_1, \\hat{c}_2)$", rep("", 3),
  #                                   "$(0.7, 0.7)$", rep("",3),
  #                                   "$(1, 0)$", rep("", 3),
  #                                   "$(0, 1)$", rep("", 3)),
  #             tb1)
  datatable(tb1,rownames = tb# c(paste(expression(hat(ca)),expression(hat(c))) ,"0&#60;c^",HTML("&#x2266;"),"h'","m","d","v","u","yo","i","o","h","m","d","v","u")
            ,extensions = 'Buttons',
            options=(list(scrollX = TRUE,
                          dom = 'Blfrtip',
                          buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
                          lengthMenu = list(c(12))
            )))})
#RMD====
rmd<-reactive({
paste0("---
title: 'DTA'
author: 'mochi'
output: html_document
date: '`r format(Sys.Date())`'
---

```{r setup, include=FALSE}
library(knitr)
library(kableExtra)
library(latex2exp)
library(mvmeta)
library(meta)
library(mada)
knitr::opts_chunk$set(echo = TRUE)
```

# TABLE: ESTIMATES

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:

```{r}
prob<- c(",paste(p.seq(),collapse =","),")
summary(cars)
```

## Including Plots

You can also embed plots, for example:

```{r pressure, echo=FALSE}
plot(pressure)
```

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.
"
)})
output$Rmd<-reactive(rmd())
output$RMDdownload<-downloadHandler(
  filename = "momo.Rmd",
  content = function(file){
    cat(rmd(),file=file)
  }
)
#=======
output$htmldownload <- downloadHandler(
  # For PDF output, change this to "report.pdf"
  
  filename = input$html,
  
  content = function(file) {
    
    #tempReport <- file.path(tempdir(), "momo.Rmd")
    #file.copy("momo.Rmd", tempReport, overwrite = TRUE)
    params <- list(n="mo",p = p.seq(),data=data(),sauc=input$Sauc1)
    
    progress <- shiny::Progress$new() #过程监视弹窗
    on.exit(progress$close())
    progress$set(message = "Result", value = 0)
    progress$inc(0.70, detail = "generating Rmarkdown file")
    
    rmarkdown::render("momo.Rmd", output_file = file,
                      params = params,
                      envir = new.env(parent = globalenv())#globalenv()
    )
  }
)
#meta forest====================================
output$meta_sesp<-renderPlot({
  par(mfrow=c(1,2),pty="m")
  forest(md(),type="sens",main="Sensitivity")
  forest(md(),type="spec",main="Specificity")
} )
output$meta_se<-renderPlot(expr = {forest(md(),type="sens",main="Sensitivity"
                                          ,pch=15,cex=1
)})
output$meta_sp<-renderPlot({
  forest(md(),type="spec",main="Specificity"
         ,pch=15,cex=1
  )
})
output$meta_sesp_plot<-renderUI({
  flowLayout(style='width:300px',plotOutput("meta_se",height =paste0((md()$nobs*13.5+200),"px"),width = "600px" )
             ,plotOutput("meta_sp",height =paste0((md()$nobs*13.5+200),"px"),width = "600px" )
  ) })
output$meta_sp_plot<-renderUI({
  
  
})
output$meta_LDOR<-renderPlot({
  forest(md(),type="DOR",log=TRUE,main="Log diagnostic odds ratio")
})
#FRP=====================================
output$plot_FRP<-renderPlot({
  par(pty="s",mfrow = c(1,2))
  plot(1-md()$spec$spec,md()$sens$sens,xlim = c(0,1),ylim=c(0,1),xlab="False positive rate\n(1-Speficity)",ylab = "Sensitivity",pch=16)
  if(input$ROCellipse){
    ROCellipse(data(),pch = 16,add = TRUE)
  }
  if(input$mslSROC){
    mslSROC(data(),lty = 2,add = TRUE)
  }
  if (input$rsSROC) {
    rsSROC(data(),lty=3,add = TRUE)
  }
  if(input$mrfit){
    mrfit<-reitsma(data())
    plot(mrfit,predict=TRUE,cex=2)
    points(1-md()$spec$spec,md()$sens$sens,pch=16)
  }
})
#Download FRP============================
output$downloadFRP1<-downloadHandler(filename = "FRP1.png",content = function(file){
  png(file)
  par(pty="s",mfrow = c(1,2))
  plot(1-md()$spec$spec,md()$sens$sens,xlim = c(0,1),ylim=c(0,1),xlab="False positive rate\n(1-Speficity)",ylab = "Sensitivity",pch=16)
  if(input$ROCellipse){
    ROCellipse(data(),pch = 16,add = TRUE)
  }
  if(input$mslSROC){
    mslSROC(data(),lty = 2,add = TRUE)
  }
  if (input$rsSROC) {
    rsSROC(data(),lty=3,add = TRUE)
  }
  if(input$mrfit){
    mrfit<-reitsma(data())
    plot(mrfit,predict=TRUE,cex=2)
    points(1-md()$spec$spec,md()$sens$sens,pch=16)
  }
  dev.off()
})
output$downloadFRP2<-downloadHandler(filename = "FRP2.png",content = function(file){
  png(file)
  par(pty="s")
  mrfit<-reitsma(data())
  plot(mrfit,predict=TRUE,cex=2)
  points(1-md()$spec$spec,md()$sens$sens,pch=16)
  dev.off()
})

#sroc B plot setting=====================
output$srocBsetting_curve<-renderUI({
  ui.plot_srocline_drop("c1c2_estimate",p.seq())
})

#gg theme--------
gg_theme   <- reactive({
  switch(input$ggplot_theme
     ,theme_bw = theme_bw()
     ,theme_classic = theme_classic()
     ,theme_light = theme_light()
     ,theme_linedraw = theme_linedraw()
     ,theme_minimal = theme_minimal()
     ,theme_test = theme_test()
     ,theme_void = theme_void()
     ,theme_default = NULL
    )

})
output$srocB<-renderPlot({
  plot_id<-"c1c2_estimate"
  withProgress(message = "c1c2 estimate",value = 0,detail = "take a minutes",
               {
                 data_m<-data.frame(sp=sp(),se=se())
                 p<-ggplot(data = data_m,mapping = aes(x=1-sp,y=se))+ ylim(0,1)+ xlim(0,1)
                 p<-p+
                 geom_point(color=input[[paste0("each_point_color",plot_id)]],size=input[[paste0("each_point_radius",plot_id)]],shape=as.numeric(input[[paste0("each_point_shape",plot_id)]]))+gg_theme()
                 #p<-p+layer(geom = "point", stat = "identity", position = "identity")
                 
                 est2.par<- est.r(0.5,c("mu1","mu2","tau1","tau2","rho")) 
                 par <- as.matrix(est2.par)
                 p<-p+mapply(function(i) {
                   u1 <- par["mu1", i]
                   u2 <- par["mu2", i]
                   t1 <- par["tau1", i]
                   t2 <- par["tau2", i]
                   if (input$Sauc1 == "sroc"){
                     r <- par["rho", i]}
                   else{ r <- -1}
                   stat_function(fun = function(x)plogis(u1 - (t1 * t2 * r/(t2^2))*(qlogis(x) + u2)),color=ifelse(length(input[[paste0("sroc_curve_color",plot_id,i)]])==0,"#000000",input[[paste0("sroc_curve_color",plot_id,i)]]),size=ifelse(length(input[[paste0("sroc_curve_thick",plot_id,i)]])==0,1,input[[paste0("sroc_curve_thick",plot_id,i)]]),linetype = ifelse(is.null(input[[paste0("sroc_curve_shape",plot_id,i)]]),"solid",input[[paste0("sroc_curve_shape",plot_id,i)]]),aes(linetype="h"))
                 }
                 , 1:ncol(par))
                 sens <- plogis(par[1, ])
                 spec <- plogis(par[2, ])
                 
                 p<-p+
                   sapply(1:ncol(par),function(t)geom_point(mapping=aes(x=1-spec[t],y=sens[t]),color=ifelse(length(input[[paste0("sroc_point_color",plot_id,t)]])==0,"#000000",input[[paste0("sroc_point_color",plot_id,t)]]),size=ifelse(is.null(input[[paste0("sroc_point_radius",plot_id,t)]]),3,input[[paste0("sroc_point_radius",plot_id,t)]])))+
                   ggtitle(plot_id)+
                   theme(title= element_text(size = 16))+ gg_theme()
                   
                 
                 esting$plot_sroc<-p
                 p})
})
output$downloadsauc_gg_estimate<-downloadHandler(
  filename = function(){paste("c1c2_estimate",'.png',sep='')},
  content = function(file){
    ggsave(file,plot=esting$plot_sroc)
  })
#sroc C plot setting=====================
output$srocCsetting_curve_11<-renderUI({
  ui.plot_srocline_drop("c1c2_11",p.seq())
})
output$srocCsetting_curve_10<-renderUI({
  ui.plot_srocline_drop("c1c2_10",p.seq())
})
output$srocCsetting_curve_01<-renderUI({
  ui.plot_srocline_drop("c1c2_01",p.seq())
})
output$srocC_11<-renderPlot({
  withProgress(message = "c1 = 2^(-1/2),c2 = 2^(-1/2)",value = 0,detail = "take a minutes",
               {
                 sroc_ggplot("c1c2_11",0.5)
               })
})
output$srocC_10<-renderPlot({
  withProgress(message = "c1 = 1,c2 = 0",value = 0,detail = "take a minutes",
               {  
                 sroc_ggplot("c1c2_10",1)
               })
})
output$srocC_01<-renderPlot({
  withProgress(message = "c1 = 0,c2 = 1",value = 0,detail = "take a minutes",
               {  
                 sroc_ggplot("c1c2_01",0)
               })
})
output$download_srocC_11<-downloadHandler(
  filename = function(){paste("c1c2_11",'.png',sep='')},
  content = function(file){
    ggsave(file,plot=esting_omg[["c1c2_11"]])
  })
output$download_srocC_10<-downloadHandler(
  filename = function(){paste("c1c2_10",'.png',sep='')},
  content = function(file){
    ggsave(file,plot=esting_omg[["c1c2_10"]])
  })
output$download_srocC_01<-downloadHandler(
  filename = function(){paste("c1c2_01",'.png',sep='')},
  content = function(file){
    ggsave(file,plot=esting_omg[["c1c2_01"]])
  })
#sroc D plot setting=====================
output$srocDsetting_curve<-renderUI(ui.plot_srocline_drop("c1c2_manul",p.seq()))
output$srocD<-renderPlot({
  sroc_ggplot(plot_id ="c1c2_manul",input$c1c2_set)
})
output$download_c1c2_manul<-downloadHandler(
  filename = function(){paste("c1c2_estimate",'.png',sep='')},
  content = function(file){
    ggsave(file,plot=esting_omg$c1c2_manul_plot)
  })
#sroc Ploting=================================
sroc_ggplot<-function(plot_id,c1.square){
  data<-data.frame(sp=sp(),se=se())
  p<-ggplot(data = data,mapping = aes(x=1-sp,y=se))+ ylim(0,1)+ xlim(0,1)
  p<-p+geom_point(color=input[[paste0("each_point_color",plot_id)]],size=input[[paste0("each_point_radius",plot_id)]],shape=as.numeric(input[[paste0("each_point_shape",plot_id)]]))+gg_theme()
  est.par<- est.f(c1.square,c("mu1","mu2","tau1","tau2","rho")) 
  par <- as.matrix(est.par)
  p<-p+mapply(function(i) {
    u1 <- par["mu1", i]
    u2 <- par["mu2", i]
    t1 <- par["tau1", i]
    t2 <- par["tau2", i]
    if (input$Sauc1 == "sroc"){
      r <- par["rho", i]}
    else{ r <- -1}
    stat_function(fun = function(x)plogis(u1 - (t1 * t2 * r/(t2^2))*(qlogis(x) + u2)),color=ifelse(length(input[[paste0("sroc_curve_color",plot_id,i)]])==0,"#000000",input[[paste0("sroc_curve_color",plot_id,i)]]),size=ifelse(is.null(input[[paste0("sroc_curve_thick",plot_id,i)]]),1,input[[paste0("sroc_curve_thick",plot_id,i)]]),linetype = ifelse(is.null(input[[paste0("sroc_curve_shape",plot_id,i)]]),"solid",input[[paste0("sroc_curve_shape",plot_id,i)]]),aes(linetype="h"))
  }
  , 1:ncol(par))
  sens <- plogis(par[1, ])
  spec <- plogis(par[2, ])
  p<-p+
    sapply(1:ncol(par),function(t)geom_point(mapping=aes(x=1-spec[t],y=sens[t],color=ifelse(length(input[[paste0("sroc_point_color",plot_id,t)]])==0,"#000000",input[[paste0("sroc_point_color",plot_id,t)]])),color=ifelse(length(input[[paste0("sroc_point_color",plot_id,t)]])==0,"#000000",input[[paste0("sroc_point_color",plot_id,t)]]),size=ifelse(is.null(input[[paste0("sroc_point_radius",plot_id,t)]]),3,input[[paste0("sroc_point_radius",plot_id,t)]])))+
    ggtitle(plot_id)+
    #guide_legend(title = "p=")+
    theme(title= element_text(size = 16)
          ,legend.position = "right",)
  esting_omg[[plot_id]]<-p
  p
}
#sauc ploy==========
output$sauc_gg_estimate<-plotly::renderPlotly(plotly::ggplotly(sauc_ggplot("sauc_c1c2_estimate")))
output$sauc_gg_c11<-plotly::renderPlotly(plotly::ggplotly(sauc_ggplot_b("sauc_c1c2_11",0.5,"(B) c1=c2")))
output$sauc_gg_c10<-plotly::renderPlotly(plotly::ggplotly(sauc_ggplot_b("sauc_c1c2_10",1,"(C) c1=1,c2=0")))
output$sauc_gg_c01<-plotly::renderPlotly(plotly::ggplotly(sauc_ggplot_b("sauc_c1c2_01",0,"(D) c1=0,c2=1")))

sauc_ggplot<-function(plot_id,title="(A) C1,C2 estimate"){
  est.sauc2<-sapply(p.10,function(x)esting[[paste0(x,input$Sauc1,input$allsingle,studyId())]]$sauc.ci)%>%t()
  data<-data.frame(p=c(p.10,p.10,p.10),sauc=c(est.sauc2[,"sauc"],est.sauc2[,"sauc.lb"],est.sauc2[,"sauc.ub"]),sauctype=c(rep("sauc",10),rep("sauc.lb",10),rep("sauc.ub",10)))
  p<-ggplot(data = data,mapping = aes(x=p,y=sauc,colour=sauctype))+gg_theme()+
    ylim(0,1)+
    xlim(0,1)+
    ggtitle(title)+
    theme(title= element_text(size = 16))+
    geom_point()+
    geom_line()
  p
}
sauc_ggplot_b<-function(plot_id,c1.square,title="C1,C2"){
  est.sauc<-sapply(p.10,function(x)esting_omg[[paste0(x,c1.square,input$Sauc1,input$allsingle,studyId())]]$sauc.ci)%>%t()
  data<-data.frame(p=c(p.10,p.10,p.10),sauc=c(est.sauc[,"sauc"],est.sauc[,"sauc.lb"],est.sauc[,"sauc.ub"]),sauctype=c(rep("sauc",10),rep("sauc.lb",10),rep("sauc.ub",10)))
  p<-ggplot(data = data,mapping = aes(x=p,y=sauc,colour=sauctype))+eval(call(input$ggplot_theme))+
    ylim(0,1)+
    xlim(0,1)+
    ggtitle(title)+
    #theme(title= element_text(size = 16))+
    geom_point()+
    geom_line()
  p
}
#sroc====================================
output$srocA<-renderPlot({
  par(mfrow = c(2,2), oma = c(0.2, 3, 0.2, 0.3), mar = c(2, 0.2, 2, 0.2))

  withProgress(message = 'Calculation in progress(1/2)',
               detail = 'This may take a while...(SROC)', value = 0,
               {
                 legend.cex <- 1
                 col <- 1:4
                 title.cex <- 1.5
                 est2.par  <-est.r(0.5,c("mu1","mu2","tau1","tau2","rho"))
                 sauc2  <- est.r(0.5,par="sauc.ci","sauc")
                 incProgress(1/4)
                 ##B=======#   
                 ## ESITMATION WHEN c1 = c2
                 est11.par <- est.f(c1.square=0.5,c("mu1","mu2","tau1","tau2","rho"))
                 sauc11 <- est.f(c1.square=0.5,c("sauc"),par = "sauc.ci")##est11()[2,]
                 incProgress(1/4)
                 est10.par<-est.f(c1.square=1,c("mu1","mu2","tau1","tau2","rho"))#est10()[15:19,]
                 
                 incProgress(1/4)
                 est01.par <- est.f(c1.square=0,c("mu1","mu2","tau1","tau2","rho"))#est01()[15:19,]
                 
                 sauc10 <- est.f(c1.square=1,c("sauc"),par = "sauc.ci")#est10()[2,]
                 sauc01 <- est.f(c1.square=0,c("sauc"),par = "sauc.ci")#est01()[2,]
                 
                 plot(1-sp(), se(), type = "p", ylim = c(0,1), xlim = c(0,1),
                      xlab = "", ylab = "")
                 SROC(est2.par, addon  = TRUE, sroc.type = input$Sauc1)
                 
                 legend("bottomright",
                        bty='n',
                        legend = c(sprintf("p = %.1f, SAUC = %.3f", p.seq(), sauc2)),
                        col = col, pch = 18, pt.cex = 2, cex = legend.cex,
                        lty = rep(1,3))
                 
                 title("(A)", adj = 0, font.main = 1, cex.main = title.cex)
                 title(TeX("$(\\hat{c}_1, \\, \\hat{c}_2)$"), cex.main = title.cex)
                 title(xlab = "FPR", line=2, cex = 0.7)
                 mtext("TPR", side=2, line=2, at=0.5, cex = 0.7)
                 plot(1-sp(), se(), type = "p", ylim = c(0,1), xlim = c(0,1), 
                      xlab = "",
                      yaxt = "n")
                 SROC(est11.par, addon = TRUE,sroc.type =  input$Sauc1)
                 legend("bottomright", 
                        bty='n',
                        legend = c(sprintf("p = %.2f, SAUC = %.3f", p.seq(), sauc11)), 
                        col = col, pch = 18, pt.cex = 2, cex = legend.cex, 
                        lty = rep(1,3))
                 title("(B)", adj = 0, font.main = 1, cex.main = title.cex)
                 title(TeX("$(c_1, \\,c_2) = (1/\\sqrt{2}, 1/\\sqrt{2})$"), cex.main = title.cex)
                 title(xlab = "FPR", line=2, cex = 0.7)
                 ## zC
                 
                 plot(1-sp(), se(), type = "p", ylim = c(0,1), xlim = c(0,1), 
                      xlab = "",
                      yaxt = "n")
                 SROC(est10.par, addon = TRUE, sroc.type = input$Sauc1)
                 legend("bottomright", 
                        bty='n',
                        legend = c(sprintf("p = %.2f, SAUC = %.3f", p.seq(), sauc10)), 
                        col = col, pch = 18, pt.cex = 2, cex = legend.cex, 
                        lty = rep(1,3))
                 title("(C)", adj = 0, font.main = 1, cex.main = title.cex)
                 title(TeX("$(c_1,\\, c_2) = (1,\\, 0)$"), cex.main = title.cex)
                 title(xlab = "FPR", line=2, cex = 0.7)
                 ## D
                 
                 plot(1-sp(), se(), type = "p", ylim = c(0,1), xlim = c(0,1), 
                      xlab = "",
                      yaxt = "n")
                 SROC(est01.par, addon = TRUE, sroc.type = input$Sauc1)
                 legend("bottomright", 
                        bty='n',
                        legend = c(sprintf("p = %.2f, SAUC = %.3f", p.seq(), sauc01)), 
                        col = col, pch = 18, pt.cex = 2, cex = legend.cex, 
                        lty = rep(1,3))
                 title("(D)", adj = 0, font.main = 1, cex.main = title.cex)
                 title(TeX("$(c_1,\\, c_2) = (0,\\, 1)$"), cex.main = title.cex)
                 title(xlab = "FPR", line=2, cex = 0.7)
               })
})
#download sroc====================================
output$downloadsrocA<-downloadHandler(filename = "SROC.png",contentType = "image/png",content = function(file){
  
  legend.cex <- 1
  col <- 1:4
  title.cex <- 1.5
  est2.par  <-est.r(0.5,c("mu1","mu2","tau1","tau2","rho"))
  sauc2  <- est.r(0.5,par="sauc.ci","sauc")
  ##B=======#   
  ## ESITMATION WHEN c1 = c2
  est11.par <- est.f(c1.square=0.5,c("mu1","mu2","tau1","tau2","rho"))
  sauc11 <- est.f(c1.square=0.5,c("sauc"),par = "sauc.ci")##est11()[2,]
  
  est10.par<-est.f(c1.square=1,c("mu1","mu2","tau1","tau2","rho"))#est10()[15:19,]
  est01.par <- est.f(c1.square=0,c("mu1","mu2","tau1","tau2","rho"))#est01()[15:19,]
  
  sauc10 <- est.f(c1.square=1,c("sauc"),par = "sauc.ci")#est10()[2,]
  sauc01 <- est.f(c1.square=0,c("sauc"),par = "sauc.ci")#est01()[2,]
  
  png(file)
  par(mfrow = c(2,2), oma = c(0.2, 3, 0.2, 0.3), mar = c(2, 0.2, 2, 0.2))
  #A
  plot(1-sp(), se(), type = "p", ylim = c(0,1), xlim = c(0,1),
       xlab = "", ylab = "")
  SROC(est2.par, addon  = TRUE, sauc.type = input$Sauc1)
  
  legend("bottomright",
         bty='n',
         legend = c(sprintf("p = %.1f, SAUC = %.3f", p.seq(), sauc2)),
         col = col, pch = 18, pt.cex = 2, cex = legend.cex,
         lty = rep(1,3))
  
  title("(A)", adj = 0, font.main = 1, cex.main = title.cex)
  title(TeX("$(\\hat{c}_1, \\, \\hat{c}_2)$"), cex.main = title.cex)
  title(xlab = "FPR", line=2, cex = 0.7)
  mtext("TPR", side=2, line=2, at=0.5, cex = 0.7)
  #B
  plot(1-sp(), se(), type = "p", ylim = c(0,1), xlim = c(0,1), 
       xlab = "",
       yaxt = "n")
  SROC(est11.par, addon = TRUE, sroc.type =  input$Sauc1)
  legend("bottomright", 
         bty='n',
         legend = c(sprintf("p = %.1f, SAUC = %.3f", p.seq(), sauc11)), 
         col = col, pch = 18, pt.cex = 2, cex = legend.cex, 
         lty = rep(1,3))
  title("(B)", adj = 0, font.main = 1, cex.main = title.cex)
  title(TeX("$(c_1, \\,c_2) = (1/\\sqrt{2}, 1/\\sqrt{2})$"), cex.main = title.cex)
  title(xlab = "FPR", line=2, cex = 0.7)
  ## C
  
  plot(1-sp(), se(), type = "p", ylim = c(0,1), xlim = c(0,1), 
       xlab = "",
       yaxt = "n")
  SROC(est10.par, addon = TRUE, sroc.type = input$Sauc1)
  legend("bottomright", 
         bty='n',
         legend = c(sprintf("p = %.1f, SAUC = %.3f", p.seq(), sauc10)), 
         col = col, pch = 18, pt.cex = 2, cex = legend.cex, 
         lty = rep(1,3))
  title("(C)", adj = 0, font.main = 1, cex.main = title.cex)
  title(TeX("$(c_1,\\, c_2) = (1,\\, 0)$"), cex.main = title.cex)
  title(xlab = "FPR", line=2, cex = 0.7)
  ## D
  
  plot(1-sp(), se(), type = "p", ylim = c(0,1), xlim = c(0,1), 
       xlab = "",
       yaxt = "n")
  SROC(est01.par, addon = TRUE, sroc.type = input$Sauc1)
  legend("bottomright", 
         bty='n',
         legend = c(sprintf("p = %.1f, SAUC = %.3f", p.seq(), sauc01)), 
         col = col, pch = 18, pt.cex = 2, cex = legend.cex, 
         lty = rep(1,3))
  title("(D)", adj = 0, font.main = 1, cex.main = title.cex)
  title(TeX("$(c_1,\\, c_2) = (0,\\, 1)$"), cex.main = title.cex)
  title(xlab = "FPR", line=2, cex = 0.7)
  
  dev.off()
})
###sauc---------------
output$sauc<-renderPlot({
  title.cex <- 1.5
  withProgress(message = 'Calculation in progress(2/2)',
               detail = 'This may take a while...(SAUC)', value = 0,
               {
                 par(mfrow = c(2,2), oma = c(0.2, 3, 0.2, 0.3), mar = c(3, 2, 2, 0.2))
                 est.sauc2<-sapply(p.10,function(x)esting[[paste0(x,input$Sauc1,input$allsingle,studyId())]]$sauc.ci)
                 matplot(t(est.sauc2),ylim=c(0,1), type = "b",lty = c(1,2,2), pch=20, col = c(1, 2,2),
                         ylab = "SAUC", xlab = "", xaxt = "n", yaxt = "n")
                 title(TeX("$(\\hat{c}_1, \\, \\hat{c}_2)$"), cex.main = title.cex)
                 axis(1, at = 1:10, labels = p.10)
                 axis(2, at = seq(0, 1, 0.2), labels = seq(0, 1, 0.2))
                 abline(h=0.5, col="grey54", lty=2)
                 title("(E)", adj = 0, font.main = 1, cex.main = title.cex)
                 title(xlab = "p", line=2, cex = 0.7)
                 mtext("SAUC", side=2, line=2, at=0.5, cex = 0.7)
                 
                 incProgress(1/4)
                 ## F(B)
                 est.sauc2<-sapply(p.10,function(x)esting_omg[[paste0(x,0.5,input$Sauc1,input$allsingle,studyId())]]$sauc.ci)
                 matplot(t(est.sauc2),ylim=c(0,1), type = "b",lty = c(1,2,2), pch=20, col = c(1, 2,2),
                         ylab = "SAUC", xlab = "", xaxt = "n", yaxt = "n")
                 title(TeX("$(c_1, \\,c_2) = (1/\\sqrt{2}, 1/\\sqrt{2})$"), cex.main = title.cex)
                 axis(1, at = 1:10, labels = p.10)
                 abline(h=0.5, col="grey54", lty=2)
                 title("(F)", adj = 0, font.main = 1, cex.main = title.cex)
                 title(xlab = "p", line=2, cex = 0.7) 
                 est.sauc2<-sapply(p.10,function(x)esting_omg[[paste0(x,1,input$Sauc1,input$allsingle,studyId())]]$sauc.ci)
                 matplot(t(est.sauc2),ylim=c(0,1), type = "b",lty = c(1,2,2), pch=20, col = c(1, 2,2),
                         ylab = "SAUC", xlab = "", xaxt = "n", yaxt = "n")
                 title(TeX("$(c_1, \\,c_2) = (1, \\,0)$"), cex.main = title.cex)
                 axis(1, at = 1:10, labels = p.10)
                 axis(2, at = seq(0.4,1, 0.2), labels = seq(0.4,1, 0.2))
                 abline(h=0.5, col="grey54", lty=2)
                 title("(G)", adj = 0, font.main = 1, cex.main = title.cex)
                 title(xlab = "p", line=2, cex = 0.7)
                 
                 
                 incProgress(1/4)
                 ## H(D)
                 
                 est.sauc2<-sapply(p.10,function(x)esting_omg[[paste0(x,0,input$Sauc1,input$allsingle,studyId())]]$sauc.ci)
                 matplot(t(est.sauc2),ylim=c(0,1), type = "b",lty = c(1,2,2), pch=20, col = c(1, 2,2),
                         ylab = "SAUC", xlab = "", xaxt = "n", yaxt = "n")
                 title(TeX("$(c_1, \\,c_2) = (0, \\,1)$"), cex.main = title.cex)
                 axis(1, at = 1:10, labels = p.10)
                 axis(4, at = seq(0.4,1, 0.2), labels = seq(0.4,1, 0.2))
                 abline(h=0.5, col="grey54", lty=2)
                 title("(H)", adj = 0, font.main = 1, cex.main = title.cex)
                 title(xlab = "p", line=2, cex = 0.7)
                 
                 incProgress(1/4)
               })
  
})
#download sauc======================================================
output$downloadsauc <- downloadHandler(filename ="dtametasa_fc.png",contentType = "image/png",
                                       content = function(file) {
                                         png(file)
                                         title.cex <- 1.5
                                         par(mfrow = c(2,2), oma = c(0.2, 3, 0.2, 0.3), mar = c(3, 2, 2, 0.2))
                                         
                                         matplot(t(est.r(c1.square = 0.5,par = "sauc.ci",p = p.10)),ylim=c(0,1), type = "b",lty = c(1,2,2), pch=20, col = c(1, 2,2),
                                                 ylab = "SAUC", xlab = "", xaxt = "n", yaxt = "n")
                                         title(TeX("$(\\hat{c}_1, \\, \\hat{c}_2)$"), cex.main = title.cex)
                                         axis(1, at = 1:10, labels = p.10)
                                         axis(2, at = seq(0, 1, 0.2), labels = seq(0, 1, 0.2))
                                         abline(h=0.5, col="grey54", lty=2)
                                         title("(E)", adj = 0, font.main = 1, cex.main = title.cex)
                                         title(xlab = "p", line=2, cex = 0.7)
                                         mtext("SAUC", side=2, line=2, at=0.5, cex = 0.7)
                                         
                                         ## F(B)
                                         
                                         matplot(t(est.f(c1.square = 0.5,par = "sauc.ci",p = p.10)),ylim=c(0,1), type = "b",lty = c(1,2,2), pch=20, col = c(1, 2,2),
                                                 ylab = "SAUC", xlab = "", xaxt = "n", yaxt = "n")
                                         title(TeX("$(c_1, \\,c_2) = (1/\\sqrt{2}, 1/\\sqrt{2})$"), cex.main = title.cex)
                                         axis(1, at = 1:10, labels = p.10)
                                         abline(h=0.5, col="grey54", lty=2)
                                         title("(F)", adj = 0, font.main = 1, cex.main = title.cex)
                                         title(xlab = "p", line=2, cex = 0.7)
                                         matplot(t(est.f(c1.square = 1,par = "sauc.ci",p = p.10)),ylim=c(0,1), type = "b",lty = c(1,2,2), pch=20, col = c(1, 2,2),
                                                 ylab = "SAUC", xlab = "", xaxt = "n", yaxt = "n")
                                         title(TeX("$(c_1, \\,c_2) = (1, \\,0)$"), cex.main = title.cex)
                                         axis(1, at = 1:10, labels = p.10)
                                         axis(2, at = seq(0.4,1, 0.2), labels = seq(0.4,1, 0.2))
                                         abline(h=0.5, col="grey54", lty=2)
                                         title("(G)", adj = 0, font.main = 1, cex.main = title.cex)
                                         title(xlab = "p", line=2, cex = 0.7)
                                         
                                         
                                         ## H(D)
                                         
                                         matplot(t(est.f(c1.square = 0,par = "sauc.ci",p = p.10)),ylim=c(0,1), type = "b",lty = c(1,2,2), pch=20, col = c(1, 2,2),
                                                 ylab = "SAUC", xlab = "", xaxt = "n", yaxt = "n")
                                         title(TeX("$(c_1, \\,c_2) = (0, \\,1)$"), cex.main = title.cex)
                                         axis(1, at = 1:10, labels = p.10)
                                         axis(4, at = seq(0.4,1, 0.2), labels = seq(0.4,1, 0.2))
                                         abline(h=0.5, col="grey54", lty=2)
                                         title("(H)", adj = 0, font.main = 1, cex.main = title.cex)
                                         title(xlab = "p", line=2, cex = 0.7)
                                         dev.off()}
)
###curve===============
output$curveAandB<-renderPlot({
  title.cex <- 1.5
  par(mfrow = c(2, 2), oma = c(0.2, 1, 0.2, 0.2), mar = c(3, 2.5, 2, 0.2))
  ldata <- logitData()
  c1<- est.r(0.5,"c1")
  #   sapply(p.seq(),function(x){
  #   if(length(esting[[paste0(x,input$Sauc1,input$allsingle)]])==0) est.add_rc(x)$par[c("c1")]
  #   else esting[[paste0(x,input$Sauc1,input$allsingle)]]$par["c1"]
  # })
  #c1 <- sqrt(est2()["c1",]); 
  c2 <- sqrt(1-c1^2)
  t11 <- (ldata$y1 + ldata$y2)/sqrt(ldata$v1+ldata$v2)
  t10 <- (ldata$y1 )/sqrt(ldata$v1)
  t01 <- (ldata$y2)/sqrt(ldata$v2)
  beta2  <- est.r(0.5,c("beta"));  alpha2  <- est.r(par="alpha")
  beta11 <- est.f(0.5,c("beta"));alpha11 <- est.f(0.5,par="alpha")# est11()["beta",]; alpha11 <- est11()["alpha",]
  beta10 <- est.f(1,c("beta")); alpha10 <- est.f(1,par="alpha")
  beta01 <- est.f(0,c("beta")); alpha01 <-est.f(0,par="alpha")
  ytext<-("$p = \\Phi(\\beta \\, t + \\alpha)$")
  ## A
  curve(pnorm(beta2[2]*x + alpha2[2]), -5, 15, ylim = c(0,1),
        xlab = "", 
        col=2,
        yaxt='n')
  axis(2, at=c(0,0.5,1), labels = c(0,0.5,1))
  curve(pnorm(beta2[3]*x + alpha2[3]), -5, 15, add = TRUE, col=3)
  curve(pnorm(beta2[4]*x + alpha2[4]), -5, 15, add = TRUE, col=4)
  
  t02 <- (c1[2]*ldata$y1 + c2[2]*ldata$y2)/sqrt(c1[2]^2*ldata$v1+c2[2]^2*ldata$v2)
  t03 <- (c1[3]*ldata$y1 + c2[3]*ldata$y2)/sqrt(c1[3]^2*ldata$v1+c2[3]^2*ldata$v2)
  t04 <- (c1[4]*ldata$y1 + c2[4]*ldata$y2)/sqrt(c1[4]^2*ldata$v1+c2[4]^2*ldata$v2)
  points(t02, rep(0.2, length(t02)), pch="|", col=2, cex = 1)
  points(t03, rep(0.1, length(t03)), pch="|", col=3, cex = 1)
  points(t04, rep(0,   length(t04)), pch="|", col=4, cex = 1)
  title(TeX("$(\\hat{c}_1, \\, \\hat{c}_2)$"), cex.main = title.cex)
  legend("bottomright", 
         bty='n',
         legend = TeX(sprintf("$p = %.1f$", p.seq()[-1])), 
         col = 2:4, cex = 1.2, 
         lty = rep(1,3))
  title("(A)", adj = 0, font.main = 1, cex.main = title.cex)
  mtext(TeX(c(ytext)), side=2, line=2, at=c(0.5), cex = 0.8)
  title(xlab = "t", line=2, cex = 0.7)
  ## B
  
  curve(pnorm(beta11[2]*x + alpha11[2]), -5, 15,ylim = c(0,1),
        xlab = "", 
        col=2,
        yaxt='n')
  curve(pnorm(beta11[3]*x + alpha11[3]), -5, 15, add = TRUE, col=3)
  curve(pnorm(beta11[4]*x + alpha11[4]), -5, 15, add = TRUE, col=4)
  points(t11, rep(0, length(t11)), pch="|", cex = 1)
  title(TeX("$(c_1, \\,c_2) = (1/\\sqrt{2}, 1/\\sqrt{2})$"), cex.main = title.cex)
  legend("bottomright", 
         bty='n',
         legend = TeX(sprintf("$p = %.1f$", p.seq()[-1])), 
         col = 2:4, cex = 1.2, 
         lty = rep(1,3))
  title("(B)", adj = 0, font.main = 1, cex.main = title.cex)
  title(xlab = "t", line=2, cex = 0.7)
  ## C
  
  curve(pnorm(beta10[2]*x + alpha10[2]), -5, 15,ylim = c(0,1),
        xlab = "", 
        col=2,
        yaxt='n')
  axis(2, at=c(0,0.5,1), labels = c(0,0.5,1))
  curve(pnorm(beta10[3]*x + alpha10[3]), -5, 15, add = TRUE, col=3)
  curve(pnorm(beta10[4]*x + alpha10[4]), -5, 15, add = TRUE, col=4)
  points(t10, rep(0, length(t10)), pch="|", cex = 1)
  title(TeX("$(c_1, \\,c_2) = (1, \\,0)$"), cex.main = title.cex)
  legend("bottomright", 
         bty='n',
         legend = TeX(sprintf("$p = %.1f$", p.seq()[-1])), 
         col = 2:4, cex = 1.2, 
         lty = rep(1,3))
  title("(C)", adj = 0, font.main = 1, cex.main = title.cex)
  mtext(TeX(c(ytext)), side=2, line=2, at=c(0.5), cex = 0.8)
  title(xlab = "t", line=2, cex = 0.7)
  
  ## D
  
  curve(pnorm(beta01[2]*x + alpha01[2]), -5, 15, ylim = c(0,1),
        xlab = "", 
        col=2,
        yaxt='n')
  curve(pnorm(beta01[3]*x + alpha01[3]), -5, 15, add = TRUE, col=3)
  curve(pnorm(beta01[4]*x + alpha01[4]), -5, 15, add = TRUE, col=4)
  points(t01, rep(0, length(t01)), pch="|", cex = 1)
  title(TeX("$(c_1, \\,c_2) = (0, \\,1)$"), cex.main = title.cex)
  legend("bottomright", 
         bty='n',
         legend = TeX(sprintf("$p = %.1f$", p.seq()[-1])), 
         col = 2:4, cex = 1.2, 
         lty = rep(1,3))
  title("(D)", adj = 0, font.main = 1, cex.main = title.cex)
  title(xlab = "t", line=2, cex = 0.7)
  
  
  par(mfrow = c(1, 1))
  
})
###download curve ===============
output$downloadcurveAandB <- downloadHandler(filename = function() {
  paste0("dtametasa_fc.png")
},contentType = "image/png"
,content = function(file) {
  png(file)
  title.cex <- 1.5
  par(mfrow = c(2, 2), oma = c(0.2, 1, 0.2, 0.2), mar = c(3, 2.5, 2, 0.2))
  ldata <- logitData()
  c1<- est.r(0.5,"c1")
  c2 <- sqrt(1-c1^2)
  t11 <- (ldata$y1 + ldata$y2)/sqrt(ldata$v1+ldata$v2)
  t10 <- (ldata$y1 )/sqrt(ldata$v1)
  t01 <- (ldata$y2)/sqrt(ldata$v2)
  beta2  <- est.r(0.5,c("beta"));  alpha2  <- est.r(par="alpha")
  beta11 <- est.f(0.5,c("beta"));alpha11 <- est.f(0.5,par="alpha")# est11()["beta",]; alpha11 <- est11()["alpha",]
  beta10 <- est.f(1,c("beta")); alpha10 <- est.f(1,par="alpha")
  beta01 <- est.f(0,c("beta")); alpha01 <-est.f(0,par="alpha")
  
  ytext<-("$p = \\Phi(\\beta \\, t + \\alpha)$")
  ## A
  curve(pnorm(beta2[2]*x + alpha2[2]), -5, 15, ylim = c(0,1),
        xlab = "", 
        col=2,
        yaxt='n')
  axis(2, at=c(0,0.5,1), labels = c(0,0.5,1))
  curve(pnorm(beta2[3]*x + alpha2[3]), -5, 15, add = TRUE, col=3)
  curve(pnorm(beta2[4]*x + alpha2[4]), -5, 15, add = TRUE, col=4)
  
  t02 <- (c1[2]*ldata$y1 + c2[2]*ldata$y2)/sqrt(c1[2]^2*ldata$v1+c2[2]^2*ldata$v2)
  t03 <- (c1[3]*ldata$y1 + c2[3]*ldata$y2)/sqrt(c1[3]^2*ldata$v1+c2[3]^2*ldata$v2)
  t04 <- (c1[4]*ldata$y1 + c2[4]*ldata$y2)/sqrt(c1[4]^2*ldata$v1+c2[4]^2*ldata$v2)
  points(t02, rep(0.2, length(t02)), pch="|", col=2, cex = 1)
  points(t03, rep(0.1, length(t03)), pch="|", col=3, cex = 1)
  points(t04, rep(0,   length(t04)), pch="|", col=4, cex = 1)
  title(TeX("$(\\hat{c}_1, \\, \\hat{c}_2)$"), cex.main = title.cex)
  legend("bottomright", 
         bty='n',
         legend = TeX(sprintf("$p = %.1f$", p.seq()[-1])), 
         col = 2:4, cex = 1.2, 
         lty = rep(1,3))
  title("(A)", adj = 0, font.main = 1, cex.main = title.cex)
  mtext(TeX(c(ytext)), side=2, line=2, at=c(0.5), cex = 0.8)
  title(xlab = "t", line=2, cex = 0.7)
  ## B
  
  curve(pnorm(beta11[2]*x + alpha11[2]), -5, 15,ylim = c(0,1),
        xlab = "", 
        col=2,
        yaxt='n')
  curve(pnorm(beta11[3]*x + alpha11[3]), -5, 15, add = TRUE, col=3)
  curve(pnorm(beta11[4]*x + alpha11[4]), -5, 15, add = TRUE, col=4)
  points(t11, rep(0, length(t11)), pch="|", cex = 1)
  title(TeX("$(c_1, \\,c_2) = (1/\\sqrt{2}, 1/\\sqrt{2})$"), cex.main = title.cex)
  legend("bottomright", 
         bty='n',
         legend = TeX(sprintf("$p = %.1f$", p.seq()[-1])), 
         col = 2:4, cex = 1.2, 
         lty = rep(1,3))
  title("(B)", adj = 0, font.main = 1, cex.main = title.cex)
  title(xlab = "t", line=2, cex = 0.7)
  ## C
  
  curve(pnorm(beta10[2]*x + alpha10[2]), -5, 15,ylim = c(0,1),
        xlab = "", 
        col=2,
        yaxt='n')
  axis(2, at=c(0,0.5,1), labels = c(0,0.5,1))
  curve(pnorm(beta10[3]*x + alpha10[3]), -5, 15, add = TRUE, col=3)
  curve(pnorm(beta10[4]*x + alpha10[4]), -5, 15, add = TRUE, col=4)
  points(t10, rep(0, length(t10)), pch="|", cex = 1)
  title(TeX("$(c_1, \\,c_2) = (1, \\,0)$"), cex.main = title.cex)
  legend("bottomright", 
         bty='n',
         legend = TeX(sprintf("$p = %.1f$", p.seq()[-1])), 
         col = 2:4, cex = 1.2, 
         lty = rep(1,3))
  title("(C)", adj = 0, font.main = 1, cex.main = title.cex)
  mtext(TeX(c(ytext)), side=2, line=2, at=c(0.5), cex = 0.8)
  title(xlab = "t", line=2, cex = 0.7)
  
  ## D
  
  curve(pnorm(beta01[2]*x + alpha01[2]), -5, 15, ylim = c(0,1),
        xlab = "", 
        col=2,
        yaxt='n')
  curve(pnorm(beta01[3]*x + alpha01[3]), -5, 15, add = TRUE, col=3)
  curve(pnorm(beta01[4]*x + alpha01[4]), -5, 15, add = TRUE, col=4)
  points(t01, rep(0, length(t01)), pch="|", cex = 1)
  title(TeX("$(c_1, \\,c_2) = (0, \\,1)$"), cex.main = title.cex)
  legend("bottomright", 
         bty='n',
         legend = TeX(sprintf("$p = %.1f$", p.seq()[-1])), 
         col = 2:4, cex = 1.2, 
         lty = rep(1,3))
  title("(D)", adj = 0, font.main = 1, cex.main = title.cex)
  title(xlab = "t", line=2, cex = 0.7)
  
  
  par(mfrow = c(1, 1))
  dev.off()})
