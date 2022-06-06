# output<-commandArgs()[[2]]
# input<-commandArgs()[[1]]
data_uni<-shiny::reactiveValues()
output$rawdata_uni<-DT::renderDataTable({
  filer<-input$filer_uni
  if (is.null(filer)||input$manualInputTRUE_uni=="Manual input") {
    data_uni$list_uni<-read.table(text = input$manualInput_uni,sep = ",",header = TRUE)
    
  }
  else{
    list1<-read.csv(filer$datapath,header = FALSE)
    t<-""
    for (i in 1:length(list1)){
      if (i==length(list1)) {
        t<-paste(t,list1[[i]],sep = "")
        break()
      }
      t<-paste(t,list1[[i]],",",sep = "")
    }
    updateTextAreaInput(session,"manualInput_uni",value =paste(t,collapse ="\n"))
    data_uni$list_uni<- read.csv(filer$datapath)
  }
})
###===================================================
# output$inputn1<-renderUI({
#   if(!is.null(data_uni$list_uni)){
#     radioGroupButtons(inputId = 'uni_meta_n1',
#                 label = "Number of observations in experimental group.",
#                 choices = colnames(data_uni$list_uni),
#                 selected = colnames(data_uni$list_uni)[[2]],
#                 justified=FALSE
#                 #options = list(`style` = "btn-info"),
#                 #inline = TRUE
#                 )
#     # dropdown(
#     #   
#     #   tags$h3("List of Input"),
#     #   
#     #   pickerInput(inputId = 'xcol2',
#     #               label = 'X Variable',
#     #               choices = names(iris),
#     #               options = list(`style` = "btn-info")),
#     #   
#     #   pickerInput(inputId = 'ycol2',
#     #               label = 'Y Variable',
#     #               choices = names(iris),
#     #               selected = names(iris)[[2]],
#     #               options = list(`style` = "btn-warning")),
#     #   
#     #   sliderInput(inputId = 'clshowModalusters2',
#     #               label = 'Cluster count',
#     #               value = 3,
#     #               min = 1, max = 9),
#     #   
#     #   style = "unite", icon = icon("cog"),
#     #   status = "danger", width = "300px",
#     #   animate = animateOptions(
#     #     enter = animations$fading_entrances$fadeInLeftBig,
#     #     exit = animations$fading_exits$fadeOutRightBig
#     #   ))
#     # 
#   }
# })
# output$inputn0<-renderUI({
#   if(!is.null(data_uni$list_uni)){
#     radioGroupButtons(inputId = 'uni_meta_n0',
#                               label = 'Estimated mean in experimental group.',
#                               choices = colnames(data_uni$list_uni),
#                               selected = colnames(data_uni$list_uni)[[3]]
#                       )
# 
#   }
# })
# output$inputmd1<-renderUI({
#   if(!is.null(data_uni$list_uni)){
#     radioGroupButtons(inputId = 'uni_meta_md1',
#                       label = 'Estimated mean in experimental group.',
#                       choices = colnames(data_uni$list_uni),
#                       selected = colnames(data_uni$list_uni)[[4]]
#     )
#     
#   }
# })
# output$inputsd1<-renderUI({
#   if(!is.null(data_uni$list_uni)){
#     radioGroupButtons(inputId = 'uni_meta_sd1',
#                       label = 'Standard deviation in experimental group.',
#                       choices = colnames(data_uni$list_uni),
#                       selected = colnames(data_uni$list_uni)[[5]]
#     )
#     
#   }
# })
# output$inputmd0<-renderUI({
#   if(!is.null(data_uni$list_uni)){
#     radioGroupButtons(inputId = 'uni_meta_md0',
#                       label = 'Estimated mean in control group.',
#                       choices = colnames(data_uni$list_uni),
#                       selected = colnames(data_uni$list_uni)[[6]]
#     )
#     
#   }
# })
# output$inputsd0<-renderUI({
#   if(!is.null(data_uni$list_uni)){
#     radioGroupButtons(inputId = 'uni_meta_sd0',
#                       label = 'Standard deviation in control group.',
#                       choices = colnames(data_uni$list_uni),
#                       selected = colnames(data_uni$list_uni)[[7]]
#     )
#     
#   }
# })
#Val select==========================================================
output$inputval<-renderUI({
  if(is.null(data_uni$list_uni))return()
  if(input$Meta_OR_MD=="Mean Difference"){
    dropdown(
      label=tags$h2("Select variable"),
      tags$h3("List of Input"),
      tags$h2(input$uni_meta_n0),
      radioGroupButtons(inputId = 'uni_meta_n1',
                        label = "Number of observations in experimental group.",
                        #choices = colnames(data_uni$list_uni),
                        selected = 2,#colnames(data_uni$list_uni)[[2]],
                        justified=FALSE
                        ,choiceNames  = colnames(data_uni$list_uni),
                        choiceValues=1:length(colnames(data_uni$list_uni))
                        #options = list(`style` = "btn-info"),
                        #inline = TRUE
      ),
      radioGroupButtons(inputId = 'uni_meta_md1',
                        label = 'Estimated mean in experimental group.',
                        #choices = colnames(data_uni$list_uni),
                        selected = 4#colnames(data_uni$list_uni)[[4]]#4
                        ,
                        choiceNames  = colnames(data_uni$list_uni),
                        choiceValues=1:length(colnames(data_uni$list_uni))
                        
      ),
      radioGroupButtons(inputId = 'uni_meta_sd1',
                        label = 'Standard deviation in experimental group.',
                       # choices = colnames(data_uni$list_uni),
                        selected =5# colnames(data_uni$list_uni)[[5]]
                        ,
                        choiceNames  = colnames(data_uni$list_uni),
                        choiceValues=1:length(colnames(data_uni$list_uni))
      ),
      radioGroupButtons(inputId = 'uni_meta_n0',
                        label = 'Estimated mean in control group.',
                        #choices = colnames(data_uni$list_uni),
                        selected =3# colnames(data_uni$list_uni)[[3]]
                        ,
                        choiceNames  = colnames(data_uni$list_uni),
                        choiceValues=1:length(colnames(data_uni$list_uni))
      ),
      radioGroupButtons(inputId = 'uni_meta_md0',
                        label = 'Estimated mean in control group.',
                        #choices = colnames(data_uni$list_uni),
                        selected =6# colnames(data_uni$list_uni)[[6]]
                        ,
                        choiceNames  = colnames(data_uni$list_uni),
                        choiceValues=1:length(colnames(data_uni$list_uni))
      ),
      radioGroupButtons(inputId = 'uni_meta_sd0',
                        label = 'Standard deviation in control group.',
                        #choices = colnames(data_uni$list_uni),
                        selected = 7#colnames(data_uni$list_uni)[[7]]
                        ,
                        choiceNames  = colnames(data_uni$list_uni),
                        choiceValues=1:length(colnames(data_uni$list_uni))
      ),
      style = "default", right = TRUE,icon = icon("cog"),
      status = "info", width = "300px"
      # ,animate = animateOptions(
      #   enter = animations$fading_entrances$fadeInLeftBig,
      #   exit = animations$fading_exits$fadeOutRightBig
      # )
    )
    
  }
  else{
    dropdown(
      label=tags$h2("Select variable"),
      tags$h3("List of Input"),
      tags$h2(input$uni_meta_n0),
      radioGroupButtons(inputId = 'uni_meta_n1',
                        label = "Number of observations in experimental group or number of ill participants in diagnostic study.",
                        #choices = colnames(data_uni$list_uni),
                        selected = 2,#colnames(data_uni$list_uni)[[2]],
                        justified=FALSE
                        ,choiceNames  = colnames(data_uni$list_uni),
                        choiceValues=1:length(colnames(data_uni$list_uni))
      ),
      radioGroupButtons(inputId = 'uni_meta_ev1',
                        label = 'Number of events in experimental group or true positives in diagnostic study.',
                        #choices = colnames(data_uni$list_uni),
                        selected = 4#colnames(data_uni$list_uni)[[4]]#4
                        ,
                        choiceNames  = colnames(data_uni$list_uni),
                        choiceValues=1:length(colnames(data_uni$list_uni))
                        
      ),
      radioGroupButtons(inputId = 'uni_meta_n0',
                        label = 'Number of observations in control group or number of healthy participants in diagnostic study.',
                        # choices = colnames(data_uni$list_uni),
                        selected =3# colnames(data_uni$list_uni)[[5]]
                        ,
                        choiceNames  = colnames(data_uni$list_uni),
                        choiceValues=1:length(colnames(data_uni$list_uni))
      ),
      radioGroupButtons(inputId = 'uni_meta_ev0',
                        label = 'Number of events in control group or false positives in diagnostic study.',
                        #choices = colnames(data_uni$list_uni),
                        selected =5# colnames(data_uni$list_uni)[[3]]
                        ,
                        choiceNames  = colnames(data_uni$list_uni),
                        choiceValues=1:length(colnames(data_uni$list_uni))
      ),
      style = "unite", icon = icon("cog"),
      status = "success", width = "300px"
    )
  }
})
output$inputval_bybar<-renderUI(radioGroupButtons(inputId = 'uni_meta_byvar',
                                                  label = "Select byvar value",
                                                  justified=FALSE
                                                  ,choiceNames  = colnames(data_uni$list_uni),
                                                  choiceValues=1:length(colnames(data_uni$list_uni))

))
#pre-calculated====
MD<-reactive({
  if (is.null(input$uni_meta_byvar)||!input$setvalue) {
    meta::metacont(
   # data_uni$list_uni$input$uni_meta_n1, input$uni_meta_md1, input$uni_meta_sd1, 
   # input$uni_meta_n0, input$uni_meta_md0, input$uni_meta_sd0, 
   data_uni$list_uni[[as.numeric(input$uni_meta_n1)]],data_uni$list_uni[[as.numeric(input$uni_meta_md1)]],data_uni$list_uni[[as.numeric(input$uni_meta_sd1)]],
   data_uni$list_uni[[as.numeric(input$uni_meta_n0)]],data_uni$list_uni[[as.numeric(input$uni_meta_md0)]],data_uni$list_uni[[as.numeric(input$uni_meta_sd0)]],
   # n.e = as.factor(input$uni_meta_n1),mean.e = var[[2]],sd.e = var[[2]],
   #   n.c = var[[2]],mean.c = var[[2]],sd.c = var[[2]],
   data = data_uni$list_uni
    #studlab = NCT,
   # overall = TRUE
    #byvar = Control
  )
  }
  else{
    meta::metacont(
            data_uni$list_uni[[as.numeric(input$uni_meta_n1)]],data_uni$list_uni[[as.numeric(input$uni_meta_md1)]],data_uni$list_uni[[as.numeric(input$uni_meta_sd1)]],
      data_uni$list_uni[[as.numeric(input$uni_meta_n0)]],data_uni$list_uni[[as.numeric(input$uni_meta_md0)]],data_uni$list_uni[[as.numeric(input$uni_meta_sd0)]],
      data = data_uni$list_uni,

      byvar = data_uni$list_uni[[as.numeric(input$uni_meta_byvar)]]
    )
  }
 
})
OR<-reactive({
  if(input$Meta_OR_MD=="Binary Outcome")
    meta::metabin(data_uni$list_uni[[as.numeric(input$uni_meta_ev1)]],data_uni$list_uni[[as.numeric(input$uni_meta_n1)]],
                  data_uni$list_uni[[as.numeric(input$uni_meta_ev0)]],data_uni$list_uni[[as.numeric(input$uni_meta_n0)]],
                  sm = input$metabin_sm
  )
})
#meta forest====
output$uni_forest_meta_cont<-renderPlot({
  if(input$Meta_OR_MD!="Binary Outcome"){meta::forest(MD())}
  else{meta::forest(OR())}
})
#fennel plot====
output$uni_fennel_meta<-renderPlot({
  if(input$Meta_OR_MD!="Binary Outcome"){funnel(MD())}
  else{funnel(OR())}
})
output$varselect<-renderUI({
  varSelectInput("m","data",data_uni$list_uni)
})