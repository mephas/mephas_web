  output$ManualPDF_download<-downloadHandler("DTAmanual.pdf"
                                             ,content = function(file){
                                               file.copy("./DTAmanual.pdf",file)
                                             }
                                             ,contentType = "application/pdf")
  observe({
    showModal(modalDialog(
      title = "Create",
      easyClose = FALSE,
      p(tags$strong("Data must contain TP,FN,TN,FP:
                             "), "Please edit the data-set",br(),
        tags$i(tags$u("")), "If you need more important, please check",tags$a(href="https://mephas.github.io/helppage/", "DTA-Meta Manual",target="_blank") ),
      textInput("html",value = "repot",label = "m"),
      br(),
      actionButton("htmldownload","download"),modalButton("Cancel"),
      footer = NULL
    ))
  })%>%bindEvent(input$downloadreport)