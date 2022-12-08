####------------------------------ define functions




####------------------------------ update data

#observe====
observe({
  inFile1 <- input$filer

  separater <- input$Delimiter
  if (is.null(inFile1)||input$manualInputTRUE=='Manually input data'){
    
    DATA<-try(read.table(text=input$manualInput,sep = separater,header = TRUE),silent=TRUE)
    #validate(need(DATA$TP & DATA$FN & DATA$TN & DATA$FP,"Data must contain TP,FN,TN,FP"))
    if(inherits(DATA, "try-error")){
      showModal(modalDialog(
        title = "Error message",
        easyClose = FALSE,
        p(tags$strong(DATA), 

        br(),

          # tags$i(tags$u("")), 
          #"If you need more help, please refresh and refer to the format of the example data",
          # tags$a(href="https://github.com/mephas/datasets/blob/master/dtameta_data/dtameta_example_dat.csv", 
          #   "DTA-Meta Example CSV Data",target="_blank") 
          ), 
        br(),
        modalButton("Close"),
        footer = NULL
      ))
      return()
    }
    if(length(DATA$tp)>0) DATA$TP<-DATA$tp
    if(length(DATA$fn)>0) DATA$FN<-DATA$fn
    if(length(DATA$fp)>0) DATA$FP<-DATA$fp
    if(length(DATA$tn)>0) DATA$TN<-DATA$tn
    if(is.null(DATA$TP) || is.null(DATA$FN)|| is.null(DATA$TN) || is.null(DATA$FP)){
      
      showModal(modalDialog(
        title = "Error message",
        easyClose = FALSE,
        p(tags$strong("Please check your data: 
          1. variable names must contain TP,FN,TN,FP; 
          2. delimiter is correctly selected"), 

        br(),

          # tags$i(tags$u("")), 
          "If you need more help, please refresh and refer to the format of the example data",
          # tags$a(href="https://github.com/mephas/datasets/blob/master/dtameta_data/dtameta_example_dat.csv", 
          #   "DTA-Meta Example CSV Data",target="_blank") 
          ), 
        br(),
        modalButton("Close"),
        footer = NULL
      ))
       return()
    }
    tp<-try(DATA$TP+1,silent=TRUE)
    tn<-try(DATA$TN+1,silent=TRUE)
    fn<-try(DATA$FN+1,silent=TRUE)
    fp<-try(DATA$FP+1,silent=TRUE)
    if(inherits(tp,"try-error")||inherits(tn,"try-error")||inherits(fp,"try-error")||inherits(fn,"try-error")){
      ifelse(inherits(tp,"try-error"),"tp")
      data_ErrorMessage(paste(paste(ifelse(inherits(tp,"try-error"),"TP",""),ifelse(inherits(tn,"try-error"),"TN",""),
      ifelse(inherits(fp,"try-error"),"FP",""),ifelse(inherits(fn,"try-error"),"FN",""),sep=" "),"contains invalid value"))
      return()#NA未対応
    }
    data(DATA)
  }
  else{
    if(tools::file_ext(inFile1$datapath)=="xlsx"){
      list1<-readxl::read_excel(inFile1$datapath,1)
    }
    else{
      list1<-read.csv(inFile1$datapath, sep = separater, header=TRUE)
    }
    
    
    validate(need(list1$TP & list1$FN & list1$TN & list1$FP,"Data must contain TP,FP,FN,TP"))
    if(tools::file_ext(inFile1$datapath)=="xlsx"){
      list2<-readxl::read_excel(inFile1$datapath,1, col_names = FALSE)
    }
    else{
    list2<-read.csv(inFile1$datapath,sep = separater, header=FALSE)
    }
    
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

}) %>% bindEvent(input$calculateStart)

observe({
  inFile1 <- input$filer
  separater <- input$Delimiter
    if(tools::file_ext(inFile1$datapath)=="xlsx"){
      list1<-readxl::read_excel(inFile1$datapath,1)      
    }
    else{
      list1<-read.csv(inFile1$datapath, sep = separater, header=TRUE)
    }
  if(is.null(list1$TP) || is.null(list1$FN)|| is.null(list1$TN) || is.null(list1$FP)){
    data_ErrorMessage()
    return()
    }

  if(tools::file_ext(inFile1$datapath)=="xlsx"){
      list2<-readxl::read_excel(inFile1$datapath,1, col_names = FALSE)
    }
  else{
    list2<-read.csv(inFile1$datapath,sep = separater, header=FALSE)
    }
  y<-""
  for (i in 1:length(list2)){
    if (i==length(list2)) {
      y<-paste(y,list2[[i]],sep = "")
      break()
    }
    y<-paste(y,list2[[i]],separater,sep = "")
  }
  updateAceEditor(session,"manualInput",value =paste(y,collapse ="\n"))
  #updateRadioButtons(session,"manualInputTRUE",selected = "Manual input")
  
})%>%bindEvent(input$filer)

