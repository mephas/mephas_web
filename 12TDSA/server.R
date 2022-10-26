

function(input, output, session) {
  source("./server_data.R",local = TRUE)
  observe({
    if (input$close > 0) stopApp()                             # stop shiny
  })
}