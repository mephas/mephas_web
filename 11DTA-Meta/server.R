

function(input, output, session) {
  
  source("./server_outline.R",local = TRUE)
  source("./server_data.R",local = TRUE)  
  source("./server_dta.R",local = TRUE)
source("./server_resm.R",local = TRUE)
source("./server_funnel.R",local = TRUE)
source("./server_sensi.R",local = TRUE)
  
  observe({
    if (input$close > 0) stopApp()                             # stop shiny
  })
  #  onBookmark(function(state) {
  #   savedTime <- as.character(Sys.time())
  #   txt<-texttoui()
  #   texttoui(paste0(txt,savedTime))
  #   # cat("Last saved at", savedTime, "\n")
  #   # # state is a mutable reference object, and we can add arbitrary values to
  #   # # it.
  #   # state$values$time <- savedTime
  # })

texttoui<-reactiveVal("")

output$uiprint<-renderPrint({
  session
})
  # onRestore(function() {
  #   print("restore")
  # })
  # session$onRestored(function(){
  #   print("restored")
  # })
  # onFlushed(function(){
  #   print("flushed")

  #    #updateTabsetPanel(session,"Main_Panel",selected = "Meta-Analysis")

  # })
  # session$onFlush(function(){
  #   input["alpa"]<-c(-3,3)
  #   print("flush")
  # })
#   observe({
#     if(length(getQueryString()$main_tab)>0){
#     #if(getQueryString()$main_tab=="Diagnostic Studies"){

#     updateTabsetPanel(session,"Main_Panel",selected =getQueryString()$main_tab)
# }#}
#   })
}