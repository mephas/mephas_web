if (!require(shiny)) {install.packages("shiny")}; library(shiny)
if (!require(ggfortify)) {install.packages("ggfortify")}; library(ggfortify)
if (!require(pls)) {install.packages("pls")}; library(pls)
if (!require(spls)) {install.packages("spls")}; library(spls)
##----------#----------#----------#----------
##
## 8MFSpcapls SERVER
##
## Language: EN
## 
## DT: 2019-01-15
##
##----------#----------#----------#----------

shinyServer(

function(input, output, session) {

#----------0. dataset input----------

source("0data_server.R", local=TRUE, encoding="UTF-8")

#----------1. PCA ----------

source("pcr_server.R", local=TRUE, encoding="UTF-8")

#----------2. PLS ----------

source("plsr_server.R", local=TRUE, encoding="UTF-8") 

#----------3. SPLS ----------

#source("3spls_server.R", local=TRUE, encoding="UTF-8") 


#---------------------------##

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })


}
)



