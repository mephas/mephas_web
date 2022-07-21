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
      textInput("html",value = "report.html",label = "file name"),
      br(),downloadButton("htmldownload","download")
      ,tags$style("#htmldownload {
                   outline-color:#0000ff;
                    background-color: white;                   
                    background: #4169e1;
                    color:white;}"
                  )

      ,modalButton("Cancel"),
      footer = NULL
    ))
  })%>%bindEvent(input$downloadreport)
  observe({
    removeModal()
    params <- list(p = p.seq())
    rmarkdown::render("momo.Rmd", output_file = input$html,
                      params = params,
                      envir = globalenv()#new.env(parent = globalenv())
                      )
    })%>%bindEvent(input$htmldownlo)