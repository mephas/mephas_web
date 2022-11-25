

function(input, output, session) {
  
  source("./server_outline.R",local = TRUE)
  source("./server_data.R",local = TRUE)  
  # source("./server_uni.R",local = TRUE)
  source("./server_dta.R",local = TRUE)
  source("./server_resm.R",local = TRUE)
  source("./server_funnel.R",local = TRUE)
	source("./server_sensi.R",local = TRUE)
  # source("./server_rmd.R",local=TRUE)
  #source("./server_dtameta.R",local = TRUE)
  
  observe({
    if (input$close > 0) stopApp()                             # stop shiny
  })
   onBookmark(function(state) {
    savedTime <- as.character(Sys.time())
    txt<-texttoui()
    texttoui(paste0(txt,savedTime))
    # cat("Last saved at", savedTime, "\n")
    # # state is a mutable reference object, and we can add arbitrary values to
    # # it.
    # state$values$time <- savedTime
  })
  texttoui<-reactiveVal("")
output$uiprint<-renderPrint({
  texttoui()
})
  onRestore(function(state) {
    txt<-texttoui()
    texttoui(paste0(txt,"restore"))
  })
  session$onRestored(function(){
    txt<-texttoui()
    texttoui(paste0(txt,"restored"))
  })
  session$onFlushed(function(){
    txt<-texttoui()
    texttoui(paste0(txt,"flushed"))
  })
  session$onFlush(function(){
    txt<-texttoui()
    texttoui(paste0(txt,"flush"))
  })
}