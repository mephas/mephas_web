# legend.cex <- 1.2
# col <- 1:4
# title.cex <- 1.5
 p.10 <- seq(1, 0.1, -0.1)

data<-reactiveVal(NULL)
md <- reactive(mada::madad(data()))
p.seq<-eventReactive(input$calculateStart,as.numeric(unlist(strsplit(input$plist, "[,;\n\t\r]"))))
output$uiprob<-renderText({
  probs<-as.numeric(unlist(strsplit(input$plist, "[,;\n\t\r]")))
  validate(need(identical(probs<=1&probs>=0,rep(TRUE,length(probs))),paste("Each value must be from 0 to 1.\nEach value must be separated by a space or a comma.",paste(probs,collapse = ","))))
  paste("p=",probs," ",sep = "")})
logitData<-eventReactive(input$calculateStart,logit.data(correction(data(), type = input$allsingle)))
###data preculculate=====
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
est.sauc2 <-reactive(#input$calculateStart,
                          withProgress(message = 'Calculation FC1',
                                       detail = 'This may take a while...', value = 0,
                                       {sapply(p.10, function(p) {
                                         incProgress(1/10)
                                         opt2 <- dtametasa.rc(data(), p, beta.interval = c(0,2), sauc.type = input$Sauc1,correct.type = input$allsingle)
                                         c(opt2$sauc.ci)
                                       })}))
est.sauc11 <-reactive(#input$calculateStart,
                           withProgress(message = 'Calculation FC2',
                                        detail = 'This may take a while...', value = 0,
                                        {sapply(p.10, function(p) {
                                          incProgress(1/10)
                                          
                                          opt1 <- dtametasa.fc(data(), p,  c1.square=0.5, beta.interval = c(0,2), sauc.type =  input$Sauc1,correct.type = input$allsingle)
                                          
                                          c(opt1$sauc.ci)
                                        })}))
est.sauc10 <-reactive(#input$calculateStart,
                           withProgress(message = 'Calculation FC3',
                                        detail = 'This may take a while...', value = 0,
                                        {sapply(p.10, function(p) {
                                          incProgress(1/10)
                                          
                                          opt1 <- dtametasa.fc(data(), p,  c1.sq = 1, beta.interval = c(0,2), sauc.type =input$Sauc1,correct.type = input$allsingle)
                                          
                                          c(opt1$sauc.ci)
                                          
                                        })}))
est.sauc01 <-reactive(#input$calculateStart,
                           withProgress(message = 'Calculation FC4',
                                        detail = 'This may take a while...', value = 0,
                                        {sapply(p.10, function(p) {
                                          
                                          incProgress(1/10)
                                          opt1 <- dtametasa.fc(data(), p,  c1.sq = 0, beta.interval = c(0,2), sauc.type = input$Sauc1,correct.type = input$allsingle)
                                          
                                          c(opt1$sauc.ci)
                                          
                                        })}))
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
output$LogitData<-renderDataTable(datatable(logitData()
                                            ,extensions = 'Buttons',
                                            options=(list(scrollX = TRUE,
                                                          dom = 'Blfrtip',
                                                          buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
                                                          lengthMenu = list(c(12))
                                            ))))
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
#sroc plot setting=====================
output$srocB<-renderUI({
  dropdown()
})
output$srocC<-renderPlot({
  sp <- data()$TN/(data()$TN+data()$FP)
  se <- data()$TP/(data()$TP+data()$FN)
  
  data_m<-data.frame(sp,se)
  print(str(data_m))
  p<-ggplot(data = data_m,mapping = aes(x=1-sp,y=se))+ ylim(0,1)+ xlim(0,1)
  p<-p+layer(geom = "point", stat = "identity", position = "identity")
  if(input$calculateStart>0){
     est2.par  <- est2()[15:19,]
    print(est2.par[1,1])
    par <- as.matrix(est2.par)
    p<-p+mapply(function(i) {
    u1 <- par[1, i]
    u2 <- par[2, i]
    t1 <- par[3, i]
    t2 <- par[4, i]
    if (input$Sauc1 == "sroc"){
      r <- par[5, i]}
    else{ r <- -1}
      stat_function(fun = function(x)plogis(u1 - (t1 * t2 * r/(t2^2))*(qlogis(x) + u2)))}
           , 1:ncol(par))
    sens <- plogis(par[1, ])
    spec <- plogis(par[2, ])
    print(sens)
    print(spec)
    p<-p+sapply(1:ncol(par),function(i)geom_point(aes(x=1-spec[i],y=sens[i]),color="blue",size=5))
    
  #p<-p+geom_point(aes(x=1-sens[1],y=spec[1]),color="blue")
   }
  #stat_function(fun = function(x)plogis(u1 - (t1 * t2 * r/(t2^2))*(qlogis(x) + u2)))#}
  p<-p+geom_point(aes(x=1,y=0,color="blue",size=5))
 # plotly::ggplotly(p)
  p
})
#sroc====================================
output$srocA<-renderPlot({
  
  par(mfrow = c(2,2), oma = c(0.2, 3, 0.2, 0.3), mar = c(2, 0.2, 2, 0.2))
  sp <- data()$TN/(data()$TN+data()$FP)
  se <- data()$TP/(data()$TP+data()$FN)
  withProgress(message = 'Calculation in progress(1/2)',
               detail = 'This may take a while...(SROC)', value = 0,
               {
  legend.cex <- 1
  col <- 1:4
  title.cex <- 1.5
  p.10 <- seq(1, 0.1, -0.1)
  est2.par  <- est2()[15:19,]
  sauc2  <- est2()[2,]
  
  incProgress(1/4)
  ##B=======#   
  ## ESITMATION WHEN c1 = c2
  est11.par <- est11()[15:19,]
  sauc11 <- est11()[2,]   
  
  incProgress(1/4)
  est10.par<-est10()[15:19,]
  
  incProgress(1/4)
  est01.par <- est01()[15:19,]
  
  sauc10 <- est10()[2,]
  sauc01 <- est01()[2,]
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
  SROC(est11.par, addon = TRUE, sauc.type = input$Sauc1)
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
  SROC(est11.par, addon = TRUE, sauc.type = input$Sauc1)
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
                 
                 matplot(t(est.sauc2()),ylim=c(0,1), type = "b",lty = c(1,2,2), pch=20, col = c(1, 2,2),
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
                 
                 matplot(t(est.sauc11()),ylim=c(0,1), type = "b",lty = c(1,2,2), pch=20, col = c(1, 2,2),
                         ylab = "SAUC", xlab = "", xaxt = "n", yaxt = "n")
                 title(TeX("$(c_1, \\,c_2) = (1/\\sqrt{2}, 1/\\sqrt{2})$"), cex.main = title.cex)
                 axis(1, at = 1:10, labels = p.10)
                 abline(h=0.5, col="grey54", lty=2)
                 title("(F)", adj = 0, font.main = 1, cex.main = title.cex)
                 title(xlab = "p", line=2, cex = 0.7) 
                 matplot(t(est.sauc10()),ylim=c(0,1), type = "b",lty = c(1,2,2), pch=20, col = c(1, 2,2),
                         ylab = "SAUC", xlab = "", xaxt = "n", yaxt = "n")
                 title(TeX("$(c_1, \\,c_2) = (1, \\,0)$"), cex.main = title.cex)
                 axis(1, at = 1:10, labels = p.10)
                 axis(2, at = seq(0.4,1, 0.2), labels = seq(0.4,1, 0.2))
                 abline(h=0.5, col="grey54", lty=2)
                 title("(G)", adj = 0, font.main = 1, cex.main = title.cex)
                 title(xlab = "p", line=2, cex = 0.7)
                 
                 
                 incProgress(1/4)
                 ## H(D)
                 
                 matplot(t(est.sauc01()),ylim=c(0,1), type = "b",lty = c(1,2,2), pch=20, col = c(1, 2,2),
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
output$downloadsauc <- downloadHandler(filename ="dtametasa_fc.png",
                                       content = function(file) {
                                         png(file)
                                         par(mfrow = c(2,2), oma = c(0.2, 3, 0.2, 0.3), mar = c(3, 2, 2, 0.2))
                                         
                                         matplot(t(est.sauc2()),ylim=c(0,1), type = "b",lty = c(1,2,2), pch=20, col = c(1, 2,2),
                                                 ylab = "SAUC", xlab = "", xaxt = "n", yaxt = "n")
                                         title(TeX("$(\\hat{c}_1, \\, \\hat{c}_2)$"), cex.main = title.cex)
                                         axis(1, at = 1:10, labels = p.10)
                                         axis(2, at = seq(0, 1, 0.2), labels = seq(0, 1, 0.2))
                                         abline(h=0.5, col="grey54", lty=2)
                                         title("(E)", adj = 0, font.main = 1, cex.main = title.cex)
                                         title(xlab = "p", line=2, cex = 0.7)
                                         mtext("SAUC", side=2, line=2, at=0.5, cex = 0.7)
                                         
                                         ## F(B)
                                         
                                         matplot(t(est.sauc11()),ylim=c(0,1), type = "b",lty = c(1,2,2), pch=20, col = c(1, 2,2),
                                                 ylab = "SAUC", xlab = "", xaxt = "n", yaxt = "n")
                                         title(TeX("$(c_1, \\,c_2) = (1/\\sqrt{2}, 1/\\sqrt{2})$"), cex.main = title.cex)
                                         axis(1, at = 1:10, labels = p.10)
                                         abline(h=0.5, col="grey54", lty=2)
                                         title("(F)", adj = 0, font.main = 1, cex.main = title.cex)
                                         title(xlab = "p", line=2, cex = 0.7)
                                         matplot(t(est.sauc10()),ylim=c(0,1), type = "b",lty = c(1,2,2), pch=20, col = c(1, 2,2),
                                                 ylab = "SAUC", xlab = "", xaxt = "n", yaxt = "n")
                                         title(TeX("$(c_1, \\,c_2) = (1, \\,0)$"), cex.main = title.cex)
                                         axis(1, at = 1:10, labels = p.10)
                                         axis(2, at = seq(0.4,1, 0.2), labels = seq(0.4,1, 0.2))
                                         abline(h=0.5, col="grey54", lty=2)
                                         title("(G)", adj = 0, font.main = 1, cex.main = title.cex)
                                         title(xlab = "p", line=2, cex = 0.7)
                                         
                                         
                                         ## H(D)
                                         
                                         matplot(t(est.sauc01()),ylim=c(0,1), type = "b",lty = c(1,2,2), pch=20, col = c(1, 2,2),
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
