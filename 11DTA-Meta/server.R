

function(input, output, session) {

  source("./server_uni.R",local = TRUE)
  source("./server_dtameta.R",local = TRUE)
  
  observe({
    if (input$close > 0) stopApp()                             # stop shiny
  })
}