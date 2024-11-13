
load("example.RData")
var.class <- function(data){
  x <- sapply(data, class)
  x[sapply(data, function(v){
    x <- unique(v)
    length(x) - sum(is.na(x)) == 2L
  })] <- "binary"
  x <- as.data.frame(x)
  colnames(x) <- "Variable Type"
  return(x)
}

# Define server logic required to draw a histogram
function(input, output, session) {

## binary outcomes
  source("server1.R", local = TRUE, encoding = "utf-8")$value
##survival outcomes
  source("server2.R", local = TRUE, encoding = "utf-8")$value
###--------------------------------------------------------------------
observe({
  if (input$close > 0) stopApp() # stop shiny
})

}
