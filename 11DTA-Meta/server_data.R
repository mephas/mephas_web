####------------------------------ define functions




####------------------------------ update data

#observe====
observe({
  inFile1 <- input$filer

  separater <- input$Delimiter
  
  if (is.null(inFile1)||input$manualInputTRUE=='Manually input data'){
    
    DATA<-read.table(text=input$manualInput,sep = separater,header = TRUE)
    #validate(need(DATA$TP & DATA$FN & DATA$TN & DATA$FP,"Data must contain TP,FN,TN,FP"))
    
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
      # return()
    }

    data(DATA)
  }

  else{

    list1<-read.csv(inFile1$datapath, sep = separater, header=TRUE)
    
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

}) %>% bindEvent(input$calculateStart)


