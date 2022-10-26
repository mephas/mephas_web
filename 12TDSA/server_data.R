data<-reactiveValues()
# c("study",)
#DATA INPUT====
output$data<-renderDataTable({
    if(is.null(input$dataselect))return()
    data[["excel"]][[match(input$dataselect,data[["excellist"]])]]
    })
output$dataselect<-renderUI({
    if(is.null(data[["excellist"]]))return()
    pickerInput(
               inputId = "dataselect",
               label = "Show data On the right side",
               choices = data[["excellist"]]
               #width = "100%"
             )
})
observe({
    if(is.null(input$filer))return()
    extend<-tools::file_ext(input$filer$datapath)
    if(extend=="xlsx"){
        data[["excel"]]<-c(data[["excel"]],lapply(excel_sheets(input$filer$datapath), read_excel, path = input$filer$datapath))
        data[["excellist"]]<-c(data[["excellist"]],excel_sheets(input$filer$datapath))
    }
    if(extend=="txt"||extend=="csv"){
        data[["excel"]]<-c(data[["excel"]],list(read.csv(input$filer$datapath,sep = ",", header=TRUE)))
        data[["excellist"]]<-c(data[["excellist"]],paste0(extend,length(data[["excellist"]])))

    }        
    # i<-0
    #     sapply(data[["excel"]],function(x){
    #         i<-i+1
    #         paste(data[["excellist"]][[i]],"$",colnames(x))
    #     })
})%>%bindEvent(input$filer)
#DATA SELECT===
observe({
    if(is.null(input$filer))return()
    for(i in 1:data[["excel"]]
})

output$HRselect<-renderUI({
    if(is.null(data[["excellist"]]))return()
    pickerInput(
        inputId = "HRselect",
        label = "HRselect",
        choices = data[["excellist"]]
        #width = "100%"
        )
})
output$OSselect<-renderUI({
    if(is.null(data[["excellist"]]))return()
    pickerInput(
        inputId = "OSselect",
        label = "OSselect",
        choices = data[["excellist"]]
        #width = "100%"
        )
})
output$MCTselect<-renderUI({
    if(is.null(data[["excellist"]]))return()
    pickerInput(
        inputId = "MCTselect",
        label = "MCTselect",
        choices = data[["excellist"]]
        #width = "100%"
        )
})
output$HRdataselect<-renderUI({
    if(is.null(input[["HRselect"]]))return()
    pickerInput(
        inputId = "HRdataselect",
        label = "HRdataselect",
        choices = colnames(data[["excel"]][[match(input$HRselect,data[["excellist"]])]])
        #width = "100%"
        )
})
output$HRdataselect<-renderUI({
    if(is.null(input[["HRselect"]]))return()
    pickerInput(
        inputId = "HRdataselect",
        label = "HRdataselect",
        choices = colnames(data[["excel"]][[match(input$HRselect,data[["excellist"]])]])
        #width = "100%"
        )
})

