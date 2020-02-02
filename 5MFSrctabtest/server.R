if (!require("psych")) {install.packages("psych")}; library("psych")
if (!require("shiny")) {install.packages("shiny")}; library("shiny")
if (!require("ggplot2")) {install.packages("ggplot2")}; library("ggplot2")
if (!require("DT")) {install.packages("DT")}; library(DT)
if (!require("plotly")) {install.packages("plotly")}; library("plotly")
if (!require("shinyWidgets")) {install.packages("shinyWidgets")}; library("shinyWidgets")

shinyServer(
function(input, output) {
  
source("../func.R")
##########----------##########----------##########
source("server_1_chi.R", local=TRUE)$value
source("server_2_fisher.R", local=TRUE)$value
source("server_3_mcnemar.R", local=TRUE)$value
source("server_4_2cchi.R", local=TRUE)$value
source("server_5_rcchi.R", local=TRUE)$value
source("server_6_2kappa.R", local=TRUE)$value
source("server_7_kappa.R", local=TRUE)$value
source("server_8_mh.R", local=TRUE)$value
source("server_9_cmh.R", local=TRUE)$value

##########----------##########----------##########

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })


})



