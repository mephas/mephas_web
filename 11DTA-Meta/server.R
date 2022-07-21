

function(input, output, session) {
  source("./server_outline.R",local = TRUE)
  source("./server_uni.R",local = TRUE)
  source("./server_dta.R",local = TRUE)
  source("./server_rmd.R",local=TRUE)
  #source("./server_dtameta.R",local = TRUE)
  observe({
    if (input$close > 0) stopApp()                             # stop shiny
  })
}