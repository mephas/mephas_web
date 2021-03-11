
#shinyServer(
function(input, output) {
  
#source("../tab/func.R")
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


}

#)



