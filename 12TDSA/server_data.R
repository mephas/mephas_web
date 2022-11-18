data<-reactiveValues()
probs<-reactive(round(as.numeric(unlist(strsplit(input$prob, "[,;\n\t\r]"))),2))
output$probability<-renderText({

    validate(need(identical(probs()<=1&probs()>0,rep(TRUE,length(probs()))),paste("Each value must be from 0 to 1.\nEach value must be separated by a space or a comma.",paste(probs(),collapse = ","))))
    return()
})
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
})%>%bindEvent(input$filer)
#DATA SELECT===
# observe({
#     if(is.null(input$filer))return()
#     # for(i in 1:data[["excel"]]
# })

output$HRselect<-renderUI({
    if(is.null(data[["excellist"]]))return()
    pickerInput(
        inputId = "HRselect",
        label = "HRselect",
        choices = data[["excellist"]],
        selected=data[["excellist"]][1]
        #width = "100%"
        )
})
output$OSselect<-renderUI({
    if(is.null(data[["excellist"]]))return()
    pickerInput(
        inputId = "OSselect",
        label = "OSselect",
        choices = data[["excellist"]],
        selected=data[["excellist"]][3]
        #width = "100%"
        )
})
output$MCTselect<-renderUI({
    if(is.null(data[["excellist"]]))return()
    pickerInput(
        inputId = "MCTselect",
        label = "MCTselect",
        choices = data[["excellist"]],
        selected=data[["excellist"]][2]
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
# output$HRdataselect<-renderUI({
#     if(is.null(input[["HRselect"]]))return()
#     pickerInput(
#         inputId = "HRdataselect",
#         label = "HRdataselect",
#         choices = colnames(data[["excel"]][[match(input$HRselect,data[["excellist"]])]])
#         #width = "100%"
#         )
# })
output$yearselect<-renderUI({
    if(is.null(input[["OSselect"]]))return()
    sele<- sort(unique(data[["excel"]][[match(input$OSselect,data[["excellist"]])]][["t"]]))/as.numeric(input$period)
    pickerInput(
        inputId = "yearselect",
        label = "time select",
        choices =sele
        #width = "100%"
        )
})
output$mergedata<-renderDataTable({
    osyear<-data[["excel"]][[match(input$OSselect,data[["excellist"]])]][data[["excel"]][[match(input$OSselect,data[["excellist"]])]]["t"]==as.numeric(input$yearselect)*as.numeric(input$period),]
    merge(osyear, data[["excel"]][[match(input$HRselect,data[["excellist"]])]],all=TRUE)
})
tdsam<-reactive({
    validate(need(identical(probs()<=1&probs()>0,rep(TRUE,length(probs()))),paste("Each value must be from 0 to 1.\nEach value must be separated by a space or a comma.",paste(probs(),collapse = ","))))
    tdsameta(
        list(data[["excel"]][[match(input$HRselect,data[["excellist"]])]],
        data[["excel"]][[match(input$OSselect,data[["excellist"]])]],
        data[["excel"]][[match(input$MCTselect,data[["excellist"]])]]),
        tK=as.numeric(input$yearselect),
        prob=probs(),
        s1.med.mct = s1_mct,s0.med.mct = s0_mct,med.year = mct_mo,period = as.numeric(input$period)
        )
})
output$TDSAMeta<-renderDataTable({
    tdsam()@par
})
output$TDSAMetaSROC<-renderPlot({
    plot(tdsam())
})