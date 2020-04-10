library(shiny)
library(multcomp)

shinyServer(
  
  function(input, output,session) {

#panel 0 num
    source("0num_server.R", local=TRUE,encoding = "utf-8")$value
    
#panel 1 Kmeans
    source("1Kmeans_server.R", local=TRUE,encoding = "utf-8")$value

#panel 2 HC
    source("2HC_server.R", local=TRUE,encoding = "utf-8")$value
    

    
  }
)
