if (!require("shiny")) {install.packages("shiny")}; library("shiny")
if (!require("plotly")) {install.packages("plotly")}; library("plotly")
if (!require("shinyWidgets")) {install.packages("shinyWidgets")}; library("shinyWidgets")

shinyServer(

function(input, output) {

##########----------##########----------##########
source("../func.R")

source("server_N.R", local=TRUE)$value

source("server_E.R", local=TRUE)$value

source("server_G.R", local=TRUE)$value

source("server_B.R", local=TRUE)$value

source("server_T.R", local=TRUE)$value

source("server_Chi.R", local=TRUE)$value

source("server_F.R", local=TRUE)$value

##########----------##########----------##########


observeEvent(input$navibar,{

if(input$navibar == "stop"){
      #if (input$close > 0) 
      stopApp()
}  

#if(input$navibar == "hint"){
#  switchInput(
#  inputId = "explain_on_off"
#  )
#}

#if(input$navibar == "help"){
#  browseURL("https://mephas.github.io/helppage/")
#}

#if(input$navibar == "home"){
#  browseURL("https://alain003.phs.osaka-u.ac.jp/mephas/index.html")
#}
})




}
)

