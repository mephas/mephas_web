# legend.cex <- 1.2
# col <- 1:4
# title.cex <- 1.5
 p.10 <- seq( 10,1, -1)/10
id<-reactiveVal(0)
data<-reactiveVal()
esting<-reactiveValues()
esting_omg<-reactiveValues()
observe({
  newID<-id()+1
  id(newID)
})%>%bindEvent(input$calculateStart)
observe({
  est.rc(p.seq())
  est.fc(p.seq(),c1.square = 1)
  est.fc(p.seq(),c1.square = 0.5)
  est.fc(p.seq(),c1.square = 0)
})%>%bindEvent(p.seq(),input$Sauc1,input$allsingle,input$calculateStart)
md <- reactive(mada::madad(data()))
#p.seq<-eventReactive(input$calculateStart,as.numeric(unlist(strsplit(input$plist, "[,;\n\t\r]"))))
p.seq<-reactiveVal(NULL)
output$uiprob<-renderText({
  probs<-round(as.numeric(unlist(strsplit(input$plist, "[,;\n\t\r]"))),2)
  validate(need(identical(probs<=1&probs>0,rep(TRUE,length(probs))),paste("Each value must be from 0 to 1.\nEach value must be separated by a space or a comma.",paste(probs,collapse = ","))))
  probs<-sort(probs,decreasing = TRUE)
  p.seq(probs)
  paste("p=",probs," ",sep = "")})
logitData<-reactive(logit.data(correction(data(), type = input$allsingle)))%>%bindCache(input$allsingle,id())%>%bindEvent(input$calculateStart,input$allsingle)
###data preculculate=====

sp <-reactive(data()$TN/(data()$TN+data()$FP))%>%bindEvent(id())
se <-reactive(data()$TP/(data()$TP+data()$FN))%>%bindEvent(id())
est.add_rc<-function(p,  c1.square=0.5){
  rc<-c(p=p,dtametasa.rc(data(), p,  c1.square0 = 0.5, beta.interval = c(0,2), sauc.type =  input$Sauc1,correct.type = input$allsingle))
  esting[[paste0(p,input$Sauc1,input$allsingle,id())]]<-rc
  rc
}
est.add_fc<-function(p,  c1.square=0.5){
  print(paste0(p,c1.square,input$Sauc1,input$allsingle,id()))
  fc<- c(p=p,dtametasa.fc(data(), p,  c1.square=c1.square, beta.interval = c(0,2), sauc.type =  input$Sauc1,correct.type = input$allsingle))
  print(c1.square)
  esting_omg[[paste0(p,c1.square,input$Sauc1,input$allsingle,id())]]<-fc
  fc
}
est.rc<-function(p.seq){sapply(p.seq,function(p){
  if(length(esting[[paste0(p,input$Sauc1,input$allsingle,id())]])==0) est.add_rc(p)
})}
est.fc<-function(p.seq,c1.square=0.5){sapply(p.seq,function(p){
  if(length(esting_omg[[paste0(p,c1.square,input$Sauc1,input$allsingle,id())]])==0) est.add_fc(p,c1.square)
})}
est.r<-function(c1.square=0.5,...,par="par",p=p.seq()){sapply(p,function(x){
  validate(need(length(esting[[paste0(x,input$Sauc1,input$allsingle,id())]])>0,"Push Above Button[Reload DATA TO Calculation]\nerror 111"))
  esting[[paste0(x,input$Sauc1,input$allsingle,id())]][[par]][...]
})}
est.f<-function(c1.square=0.5,...,par="par",p=p.seq()){sapply(p,function(x){
  validate(need(length(esting[[paste0(x,input$Sauc1,input$allsingle,id())]])>0,"Push Above Button[Reload DATA TO Calculation]\nerror 112"))
  esting_omg[[paste0(x,c1.square,input$Sauc1,input$allsingle,id())]][[par]][...]
})}

est2<-eventReactive(input$calculateStart,
                    withProgress(message = 'Calculation RC1',
                                 detail = 'This may take a while...', value = 0,
                                 {
                                   sapply(p.seq(), function(p) {
                                   incProgress(1/length(p.seq()))

                                   opt2 <- dtametasa.rc(data(), p, c1.square0 = 0.5, beta.interval = c(0,2), sauc.type = input$Sauc1,correct.type = input$allsingle)

                                   c(conv = opt2$convergence, opt2$sauc.ci, opt2$mu1.ci[4:6], opt2$mu2.ci[4:6], opt2$beta.ci, opt2$alpha, opt2$par)
                                 })}))
est11<-eventReactive(input$calculateStart,
                     withProgress(message = 'Calculation RC2',
                                  detail = 'This may take a while...', value = 0,
                                  {sapply(p.seq(), function(p) {
                                    incProgress(1/length(p.seq()))

                                    opt1 <- dtametasa.fc(data(), p, c1.square = 0.5, beta.interval = c(0,2), sauc.type = input$Sauc1,correct.type = input$allsingle)

                                    c(conv = opt1$convergence, opt1$sauc.ci, opt1$mu1.ci[4:6], opt1$mu2.ci[4:6], opt1$beta.ci, opt1$alpha, opt1$par, c1 = sqrt(0.5))

                                  })}))
est10<-eventReactive(input$calculateStart,
                     withProgress(message = 'Calculation RC3',
                                  detail = 'This may take a while...', value = 0,
                                  {sapply(p.seq(), function(p) {
                                    incProgress(1/length(p.seq()))

                                    opt1 <- dtametasa.fc(data(), p, c1.square = 1, beta.interval = c(0,2), sauc.type = input$Sauc1,correct.type = input$allsingle)

                                    c(conv = opt1$convergence, opt1$sauc.ci, opt1$mu1.ci[4:6], opt1$mu2.ci[4:6], opt1$beta.ci, opt1$alpha, opt1$par, c1 = sqrt(1))

                                  })}))
est01 <-eventReactive(input$calculateStart,
                      withProgress(message = 'Calculation RC4',
                                   detail = 'This may take a while...', value = 0,
                                   {sapply(p.seq(), function(p) {
                                     incProgress(1/length(p.seq()))

                                     opt1 <- dtametasa.fc(data(), p, c1.square = 0, beta.interval = c(0,2), sauc.type = input$Sauc1,correct.type = input$allsingle)

                                     c(conv = opt1$convergence, opt1$sauc.ci, opt1$mu1.ci[4:6], opt1$mu2.ci[4:6], opt1$beta.ci, opt1$alpha, opt1$par, c1 = sqrt(0))

                                   })}))
est<-reactive(withProgress(message = 'Calculation c1c2 FC',
                                  detail = 'This may take a while...', value = 0,
                                  {sapply(p.seq(), function(p) {
                                    incProgress(1/length(p.seq()))
                                    
                                    opt1 <- dtametasa.fc(data(), p, c1.square = input$c1c2_set, beta.interval = c(0,2), sauc.type = input$Sauc1,correct.type = input$allsingle)
                                    
                                    c(conv = opt1$convergence, opt1$sauc.ci, opt1$mu1.ci[4:6], opt1$mu2.ci[4:6], opt1$beta.ci, opt1$alpha, opt1$par, c1 = sqrt(0.5))
                                    
                                  })}))%>%bindCache(input$c1c2_set,input$Sauc1,input$allsingle,id(),p.seq())%>%bindEvent(input$c1c2_set_button,input$c1c2_set,input$Sauc1,input$allsingle,p.seq())
dtametasa.rc_p.10 <-reactive(
  withProgress(message = 'Calculation dtametasa.rc for each seq(0.1, 1, -0.1)',
               detail = 'This may take a while...', value = 0,
               {lapply(p.10, function(p) {
                 message = paste('Calculation dtametasa.rc for',p)
                 incProgress(1/10)
                 r<-c(p,dtametasa.rc(data(), p, beta.interval = c(0,2), sauc.type = input$Sauc1,correct.type = input$allsingle))
               names(r)[1]<-c("p")
               esting[[paste0(p,input$Sauc1,input$allsingle,id())]]<-r
               r
                })
                 }))%>%bindCache(input$Sauc1,input$allsingle,id())%>%bindEvent(input$calculateStart,input$Sauc1,input$allsingle)
dtametasa.fc_c1.square0.5_p.10 <-reactive(
  withProgress(message = 'Calculation dtametasa.fc (c1.square=0.5) for each seq(0.1, 1, -0.1)',
               detail = 'This may take a while...', value = 0,
               {lapply(p.10, function(p) {
                 incProgress(1/10)
                 f<-c(p=p,dtametasa.fc(data(), p,  c1.square=0.5, beta.interval = c(0,2), sauc.type =  input$Sauc1,correct.type = input$allsingle))
               esting_omg[[paste0(p,"0.5",input$Sauc1,input$allsingle,id())]]<-f
               f
                 })}))%>%bindCache(input$Sauc1,input$allsingle,id())%>%bindEvent(input$calculateStart,input$Sauc1,input$allsingle)
dtametasa.fc_c1.square1_p.10 <-reactive(
  withProgress(message = 'Calculation dtametasa.fc (c1.square=1) for each seq(0.1, 1, -0.1)',
               detail = 'This may take a while...', value = 0,
               {lapply(p.10, function(p) {
                 incProgress(1/10)
                 f<-c(p=p,dtametasa.fc(data(), p,  c1.square=1, beta.interval = c(0,2), sauc.type =  input$Sauc1,correct.type = input$allsingle))
                 esting_omg[[paste0(p,"1",input$Sauc1,input$allsingle,id())]]<-f
                 f
                })}))%>%bindCache(input$Sauc1,input$allsingle,id())%>%bindEvent(input$calculateStart,input$Sauc1,input$allsingle)
dtametasa.fc_c1.square0_p.10 <-reactive(
  withProgress(message = 'Calculation dtametasa.fc (c1.square=0) for each seq(0.1, 1, -0.1)',
               detail = 'This may take a while...', value = 0,
               {lapply(p.10, function(p) {
                 incProgress(1/10)
                 f<-c(p=p,dtametasa.fc(data(), p,  c1.square=0, beta.interval = c(0,2), sauc.type =  input$Sauc1,correct.type = input$allsingle))
                 esting_omg[[paste0(p,"0",input$Sauc1,input$allsingle,id())]]<-f
                 f
                 })}))%>%bindCache(input$Sauc1,input$allsingle,id())%>%bindEvent(input$calculateStart,input$Sauc1,input$allsingle)
# est.sauc2 <-reactive(#input$calculateStart,
#                           withProgress(message = 'Calculation FC1',
#                                        detail = 'This may take a while...', value = 0,
#                                        {sapply(p.10, function(p) {
#                                          incProgress(1/10)
#                                          opt2 <- dtametasa.rc(data(), p, beta.interval = c(0,2), sauc.type = input$Sauc1,correct.type = input$allsingle)
#                                          c(opt2$sauc.ci)
#                                        })}))
# 
# est.sauc11 <-reactive(#input$calculateStart,
#                            withProgress(message = 'Calculation FC2',
#                                         detail = 'This may take a while...', value = 0,
#                                         {sapply(p.10, function(p) {
#                                           incProgress(1/10)
#                                           
#                                           opt1 <- dtametasa.fc(data(), p,  c1.square=0.5, beta.interval = c(0,2), sauc.type =  input$Sauc1,correct.type = input$allsingle)
#                                           
#                                           c(opt1$sauc.ci)
#                                         })}))
# est.sauc10 <-reactive(#input$calculateStart,
#                            withProgress(message = 'Calculation FC3',
#                                         detail = 'This may take a while...', value = 0,
#                                         {sapply(p.10, function(p) {
#                                           incProgress(1/10)
#                                           
#                                           opt1 <- dtametasa.fc(data(), p,  c1.sq = 1, beta.interval = c(0,2), sauc.type =input$Sauc1,correct.type = input$allsingle)
#                                           
#                                           c(opt1$sauc.ci)
#                                           
#                                         })}))
# est.sauc01 <-reactive(#input$calculateStart,
#                            withProgress(message = 'Calculation FC4',
#                                         detail = 'This may take a while...', value = 0,
#                                         {sapply(p.10, function(p) {
#                                           
#                                           incProgress(1/10)
#                                           opt1 <- dtametasa.fc(data(), p,  c1.sq = 0, beta.interval = c(0,2), sauc.type = input$Sauc1,correct.type = input$allsingle)
#                                           
#                                           c(opt1$sauc.ci)
#                                           
#                                         })}))

#data input=================================================================================
output$RawData<-DT::renderDataTable({
  inFile1 <- input$filer
  if (is.null(inFile1)||input$manualInputTRUE=='Manual input'){
    DATA<-read.table(text=input$manualInput,sep = ",",header = TRUE)
    validate(need(DATA$TP & DATA$FN & DATA$TN & DATA$FP,"Data must contain TP,FN,TN,FP"))
    data(DATA)
    datatable(DATA
              ,extensions = 'Buttons',
              options=(list(scrollX = TRUE,
                            dom = 'Blfrtip',
                            buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
                            lengthMenu = list(c(12))
              )))
  }
  else{
    list1<-read.csv(inFile1$datapath, header=TRUE)
    # validate(need(list1$TP,#"Data must contain TP",
    #               showModal(modalDialog(title = "Warning", "Data must contain TP,FP,FN,TP", easyClose = TRUE, footer = modalButton("OK")))),
    #          need(list1$FN,"Data must contain FN",
    #               showModal(modalDialog(title = "Warning", "Data must contain TP,FP,FN,TP", easyClose = TRUE, footer = modalButton("OK")))
    #               ),
    #          need(list1$TN,"Data must contain TN",
    #               showModal(modalDialog(title = "Warning", "Data must contain TP,FP,FN,TP", easyClose = TRUE, footer = modalButton("OK")))
    #               ),
    #          need(list1$FP,"Data must contain FP",
    #               showModal(modalDialog(title = "Warning", "Data must contain TP,FP,FN,TP", easyClose = TRUE, footer = modalButton("OK")))
    #               ))
    #validate(need(list1$TP & list1$FN & list1$TN & list1$FP,showModal(modalDialog(title = "Warning", "Data must contain TP,FP,FN,TP", easyClose = TRUE, footer = modalButton("OK")))))
    validate(need(list1$TP & list1$FN & list1$TN & list1$FP,"Data must contain TP,FP,FN,TP"))
    list2<-read.csv(inFile1$datapath, header=FALSE)
    data(list1)
    y<-""
    for (i in 1:length(list2)){
      if (i==length(list2)) {
        y<-paste(y,list2[[i]],sep = "")
        break()
      }
      y<-paste(y,list2[[i]],",",sep = "")
    }
    #y<-paste(list2[[1]],",",list2[[2]],",",list2[[3]],",",list2[[4]],",",list2[[5]],sep =  "")
    updateTextAreaInput(session,"manualInput",value =paste(y,collapse ="\n"))
    datatable(list1
                  ,extensions = 'Buttons',
                  options=(list(scrollX = TRUE,
                                dom = 'Blfrtip',
                                buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
                                lengthMenu = list(c(12))
                  )))
  }}
)
#logit===============
output$LogitData<-renderDataTable(datatable(logitData()
                                            ,extensions = 'Buttons',
                                            options=(list(scrollX = TRUE,
                                                          dom = 'Blfrtip',
                                                          buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
                                                          lengthMenu = list(c(12))
                                            ))))
output$Results<-renderDataTable({
  # tb2  <- .reform.est(est2(),p.seq())
  # tb11 <- .reform.est(est11(),p.seq())
  # tb10 <- .reform.est(est10(),p.seq())
  # tb01 <- .reform.est(est01(),p.seq())
  if(is.null(dtametasa.rc_p.10()))return()
  if(is.null(dtametasa.fc_c1.square0.5_p.10()))return()
  if(is.null(dtametasa.fc_c1.square1_p.10()))return()
  if(is.null(dtametasa.fc_c1.square0_p.10()))return()
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
#meta====================================
output$meta_sesp<-renderPlot({
  par(mfrow=c(1,2),pty="m")
  forest(md(),type="sens",main="Sensitivity")
  forest(md(),type="spec",main="Specificity")
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
output$srocB<-renderPlot({
  plot_id<-"c1c2_estimate"
  if(is.null(dtametasa.rc_p.10()))return()
  if(is.null(dtametasa.fc_c1.square0.5_p.10()))return()
  if(is.null(dtametasa.fc_c1.square1_p.10()))return()
  if(is.null(dtametasa.fc_c1.square0_p.10()))return()
  print(input[[paste0("each_point_color",plot_id)]])
  
  data_m<-data.frame(sp=sp(),se=se())
  p<-ggplot(data = data_m,mapping = aes(x=1-sp,y=se))+ ylim(0,1)+ xlim(0,1)
  p<-p+geom_point(color=input[[paste0("each_point_color",plot_id)]],size=input[[paste0("each_point_radius",plot_id)]],shape=as.numeric(input[[paste0("each_point_shape",plot_id)]]))
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
      stat_function(fun = function(x)plogis(u1 - (t1 * t2 * r/(t2^2))*(qlogis(x) + u2)),color=input[[paste0("sroc_curve_color",plot_id,i)]],size=input[[paste0("sroc_curve_thick",plot_id,i)]],linetype = input[[paste0("sroc_curve_shape",plot_id,i)]],aes(linetype="h"))
      }
           , 1:ncol(par))
    sens <- plogis(par[1, ])
    spec <- plogis(par[2, ])
    p<-p+sapply(1:ncol(par),function(t)geom_point(mapping=aes(x=1-spec[t],y=sens[t]),color=input[[paste0("sroc_point_color",plot_id,t)]],size=input[[paste0("sroc_point_radius",plot_id,t)]]))

  #p<-p+geom_point(aes(x=1-sens[1],y=spec[1]),color="blue")
   
  #stat_function(fun = function(x)plogis(u1 - (t1 * t2 * r/(t2^2))*(qlogis(x) + u2)))#}
  #p<-p+geom_point(aes(x=1,y=0),color=input$mochi3,size=6)
 # plotly::ggplotly(p)
  p
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
sroc_ggplot<-function(plot_id,c1.square){
    data<-data.frame(sp=sp(),se=se())
    
    p<-ggplot(data = data,mapping = aes(x=1-sp,y=se))+ ylim(0,1)+ xlim(0,1)
    p<-p+geom_point(color=input[[paste0("each_point_color",plot_id)]],size=input[[paste0("each_point_radius",plot_id)]],shape=as.numeric(input[[paste0("each_point_shape",plot_id)]]))

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
      stat_function(fun = function(x)plogis(u1 - (t1 * t2 * r/(t2^2))*(qlogis(x) + u2)),color=input[[paste0("sroc_curve_color",plot_id,i)]],size=input[[paste0("sroc_curve_thick",plot_id,i)]],linetype = input[[paste0("sroc_curve_shape",plot_id,i)]],aes(linetype="h"))
    }
    , 1:ncol(par))
    sens <- plogis(par[1, ])
    spec <- plogis(par[2, ])
    p<-p+sapply(1:ncol(par),function(t)geom_point(mapping=aes(x=1-spec[t],y=sens[t]),color=input[[paste0("sroc_point_color",plot_id,t)]],size=input[[paste0("sroc_point_radius",plot_id,t)]]))
    p
}
output$srocC_11<-renderPlot({
  sroc_ggplot("c1c2_11",0.5)
  #p10<-test("c1c2_10",1)
  #p01<-test("c1c2_01",0)
  #gridExtra::grid.arrange(p11,p10,p01)
  
  })
output$srocC_10<-renderPlot({
  sroc_ggplot("c1c2_10",1)
})
output$srocC_01<-renderPlot({
  sroc_ggplot("c1c2_01",0)
})
#sroc D plot setting=====================
output$srocDsetting_curve<-renderUI(ui.plot_srocline_drop("c1c2_manul",p.seq()))
output$srocD<-renderPlot({
  
  if(is.null(dtametasa.rc_p.10()))return()
  if(is.null(dtametasa.fc_c1.square0.5_p.10()))return()
  if(is.null(dtametasa.fc_c1.square1_p.10()))return()
  if(is.null(dtametasa.fc_c1.square0_p.10()))return()
  plot_id<-"c1c2_manul"
  data_m<-data.frame(sp=sp(),se=se())
  p<-ggplot(data = data_m,mapping = aes(x=1-sp,y=se))+ ylim(0,1)+ xlim(0,1)
  p<-p+geom_point(color=input[[paste0("each_point_color",plot_id)]],size=input[[paste0("each_point_radius",plot_id)]],shape=as.numeric(input[[paste0("each_point_shape",plot_id)]]))

    est2.par  <- est()[15:19,]
    par <- as.matrix(est2.par)
    p<-p+mapply(function(i) {
      print(i)
      u1 <- par[1, i]
      u2 <- par[2, i]
      t1 <- par[3, i]
      t2 <- par[4, i]
      if (input$Sauc1 == "sroc"){
        r <- par[5, i]}
      else{ r <- -1}
      stat_function(fun = function(x)plogis(u1 - (t1 * t2 * r/(t2^2))*(qlogis(x) + u2)),color=input[[paste0("sroc_curve_color",plot_id,i)]],size=input[[paste0("sroc_curve_thick",plot_id,i)]],linetype = input[[paste0("sroc_curve_shape",plot_id,i)]])
    }
    , 1:ncol(par))
    sens <- plogis(par[1, ])
    spec <- plogis(par[2, ])
    p<-p+sapply(1:ncol(par),function(t)geom_point(mapping=aes(x=1-spec[t],y=sens[t]),color=input[[paste0("sroc_point_color",plot_id,t)]],size=input[[paste0("sroc_point_radius",plot_id,t)]]))
  
  p<-p+labs(subtitle  = input[[paste0("plot_title",plot_id)]],tag="D")#input[[paste0("plot_y_axis","P")]],x=ifelse((input[[paste0("plot_x_axis","P")]]==""),waiver(),input[[paste0("plot_x_axis","P")]])
  p<-p+xlab(input[[paste0("plot_x_axis",plot_id)]])+ylab(input[[paste0("plot_y_axis",plot_id)]])
  p
})
#sroc====================================
output$srocA<-renderPlot({
  par(mfrow = c(2,2), oma = c(0.2, 3, 0.2, 0.3), mar = c(2, 0.2, 2, 0.2))
  if(is.null(dtametasa.rc_p.10()))return()
  if(is.null(dtametasa.fc_c1.square0.5_p.10()))return()
  if(is.null(dtametasa.fc_c1.square1_p.10()))return()
  if(is.null(dtametasa.fc_c1.square0_p.10()))return()

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
  # incProgress(1/20)
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
output$downloadsrocA<-downloadHandler(filename = "SROC.png",content = function(file){
  sp <- data()$TN/(data()$TN+data()$FP)
  se <- data()$TP/(data()$TP+data()$FN)
  legend.cex <- 1.2
  col <- 1:4
  title.cex <- 1.5
  p.10 <- seq(1, 0.1, -0.1)
  est2.par  <- est2()[15:19,]
  sauc2  <- est2()[2,]
  ##B=======#   
  ## ESITMATION WHEN c1 = c2
  est11.par <- est11()[15:19,]
  sauc11 <- est11()[2,]   
  
  est10.par<-est10()[15:19,]
  est01.par <- est01()[15:19,]
  sauc10 <- est10()[2,]
  sauc01 <- est01()[2,]
  png(file)
  par(mfrow = c(2,2), oma = c(0.2, 3, 0.2, 0.3), mar = c(2, 0.2, 2, 0.2))
  # incProgress(1/20)
  plot(1-sp, se, type = "p", ylim = c(0,1), xlim = c(0,1),
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
  plot(1-sp, se, type = "p", ylim = c(0,1), xlim = c(0,1), 
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
  ## zC
  
  plot(1-sp, se, type = "p", ylim = c(0,1), xlim = c(0,1), 
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
  
  plot(1-sp, se, type = "p", ylim = c(0,1), xlim = c(0,1), 
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
                 est.sauc2<-sapply(dtametasa.rc_p.10(), function(x)x$sauc.ci)
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
                 est.sauc2<-sapply(dtametasa.fc_c1.square0.5_p.10(), function(x)x$sauc.ci)
                 matplot(t(est.sauc2),ylim=c(0,1), type = "b",lty = c(1,2,2), pch=20, col = c(1, 2,2),
                         ylab = "SAUC", xlab = "", xaxt = "n", yaxt = "n")
                 title(TeX("$(c_1, \\,c_2) = (1/\\sqrt{2}, 1/\\sqrt{2})$"), cex.main = title.cex)
                 axis(1, at = 1:10, labels = p.10)
                 abline(h=0.5, col="grey54", lty=2)
                 title("(F)", adj = 0, font.main = 1, cex.main = title.cex)
                 title(xlab = "p", line=2, cex = 0.7) 
                 est.sauc2<-sapply(dtametasa.fc_c1.square1_p.10(), function(x)x$sauc.ci)
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
                 
                 est.sauc2<-sapply(dtametasa.fc_c1.square1_p.10(), function(x)x$sauc.ci)
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
  
})#%>%bindCache(input$Sauc1,input$allsingle,id())%>%bindEvent(input$calculateStart,input$Sauc1,input$allsingle)
#download sauc======================================================
output$downloadsauc <- downloadHandler(filename ="dtametasa_fc.png",
                                       content = function(file) {
                                         png(file)
                                         par(mfrow = c(2,2), oma = c(0.2, 3, 0.2, 0.3), mar = c(3, 2, 2, 0.2))
                                         
                                         matplot(t(dtametasa.rc_p.10()$sauc.ci),ylim=c(0,1), type = "b",lty = c(1,2,2), pch=20, col = c(1, 2,2),
                                                 ylab = "SAUC", xlab = "", xaxt = "n", yaxt = "n")
                                         title(TeX("$(\\hat{c}_1, \\, \\hat{c}_2)$"), cex.main = title.cex)
                                         axis(1, at = 1:10, labels = p.10)
                                         axis(2, at = seq(0, 1, 0.2), labels = seq(0, 1, 0.2))
                                         abline(h=0.5, col="grey54", lty=2)
                                         title("(E)", adj = 0, font.main = 1, cex.main = title.cex)
                                         title(xlab = "p", line=2, cex = 0.7)
                                         mtext("SAUC", side=2, line=2, at=0.5, cex = 0.7)
                                         
                                         ## F(B)
                                         
                                         matplot(t(dtametasa.fc_c1.square0.5_p.10()$sauc.ci),ylim=c(0,1), type = "b",lty = c(1,2,2), pch=20, col = c(1, 2,2),
                                                 ylab = "SAUC", xlab = "", xaxt = "n", yaxt = "n")
                                         title(TeX("$(c_1, \\,c_2) = (1/\\sqrt{2}, 1/\\sqrt{2})$"), cex.main = title.cex)
                                         axis(1, at = 1:10, labels = p.10)
                                         abline(h=0.5, col="grey54", lty=2)
                                         title("(F)", adj = 0, font.main = 1, cex.main = title.cex)
                                         title(xlab = "p", line=2, cex = 0.7)
                                         matplot(t(dtametasa.fc_c1.square1_p.10()$sauc.ci),ylim=c(0,1), type = "b",lty = c(1,2,2), pch=20, col = c(1, 2,2),
                                                 ylab = "SAUC", xlab = "", xaxt = "n", yaxt = "n")
                                         title(TeX("$(c_1, \\,c_2) = (1, \\,0)$"), cex.main = title.cex)
                                         axis(1, at = 1:10, labels = p.10)
                                         axis(2, at = seq(0.4,1, 0.2), labels = seq(0.4,1, 0.2))
                                         abline(h=0.5, col="grey54", lty=2)
                                         title("(G)", adj = 0, font.main = 1, cex.main = title.cex)
                                         title(xlab = "p", line=2, cex = 0.7)
                                         
                                         
                                         ## H(D)
                                         
                                         matplot(t(dtametasa.fc_c1.square0_p.10()$sauc.ci),ylim=c(0,1), type = "b",lty = c(1,2,2), pch=20, col = c(1, 2,2),
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
  # p.seq<- as.numeric(unlist(strsplit(input$plist, "[,;\n\t]")))
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
  print("mo.")
  print(beta2)
  print("mo0")
  beta11 <- est.f(0.5,c("beta"));alpha11 <- est.f(0.5,par="alpha")# est11()["beta",]; alpha11 <- est11()["alpha",]
  beta10 <- est.f(1,c("beta")); alpha10 <- est.f(1,par="alpha")
  beta01 <- est.f(0,c("beta")); alpha01 <-est.f(0,par="alpha")
  print(beta01)
  print(alpha01)
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
  
})#%>%bindCache(input$Sauc1,input$allsingle,id())%>%bindEvent(input$calculateStart,input$Sauc1,input$allsingle)
###download curve ===============
output$downloadcurveAandB <- downloadHandler(filename = function() {
  "dtametasa_fc.png"
}
,content = function(file) {
  png(file)
  par(mfrow = c(2, 2), oma = c(0.2, 1, 0.2, 0.2), mar = c(3, 2.5, 2, 0.2))
  ldata <- logitData()
  c1 <- sqrt(est2()[21,]); c2 <- sqrt(1-c1^2)
  t11 <- (ldata$y1 + ldata$y2)/sqrt(ldata$v1+ldata$v2)
  t10 <- (ldata$y1 )/sqrt(ldata$v1)
  t01 <- (ldata$y2)/sqrt(ldata$v2)
  beta2  <- est2()[11,];  alpha2  <- est2()[14,]
  beta11 <- est11()[11,]; alpha11 <- est11()[14,]
  beta10 <- est10()[11,]; alpha10 <- est10()[14,]
  beta01 <- est01()[11,]
  alpha01 <- est01()[14,]
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
  legend("topright", 
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
  legend("topright", 
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
  legend("topright", 
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
  legend("topright", 
         bty='n',
         legend = TeX(sprintf("$p = %.1f$", p.seq()[-1])), 
         col = 2:4, cex = 1.2, 
         lty = rep(1,3))
  title("(D)", adj = 0, font.main = 1, cex.main = title.cex)
  title(xlab = "t", line=2, cex = 0.7)
  dev.off()})
