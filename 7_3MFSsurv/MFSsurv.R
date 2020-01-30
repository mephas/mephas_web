##'
##' MFSsurv includes
##' (1) K-M estimation and log-rank test for survival probability curves,
##' (2) Cox regression
##' and (3) accelerated failure time model
##'
##' @title MEPHAS: Survival Analysis (Advanced Method)
##'
##' @return shiny interface
##'
##' @import shiny
##' @import ggplot2
##' @import survival
##' @import survminer
##'
##' @importFrom utils str write.table
##' @importFrom stats plogis resid
##' @importFrom survAUC predErr AUC.cd AUC.sh AUC.uno AUC.hc
##'
##' @examples
##' # library(mephas)
##' # MFSsurv()
##' # or,
##' # mephas::MFSsurv()
##' # or,
##' # mephasOpen("surv")
##' # Use 'Stop and Quit' Button in the top to quit the interface

##' @export
MFSsurv <- function(){

requireNamespace("shiny", quietly = TRUE)
requireNamespace("ggplot2", quietly = TRUE)
requireNamespace("DT", quietly = TRUE)
requireNamespace("survival", quietly = TRUE)
requireNamespace("survminer", quietly = TRUE)
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
ui <- tagList(

navbarPage(

title = "Survival Analysis",

##########----------##########----------##########


#source("0data_ui.R", local=TRUE, encoding="UTF-8")$value,

#source("1km_ui.R", local=TRUE, encoding="UTF-8")$value

#source("3cox_ui.R", local=TRUE, encoding="UTF-8")$value

#source("3pr_ui.R", local=TRUE, encoding="UTF-8")$value

#source("2aft_ui.R", local=TRUE, encoding="UTF-8")$value

#source("2pr_ui.R", local=TRUE, encoding="UTF-8")$value


##########----------##########----------##########
##########----------##########----------##########
tabPanel((a("Help Pages Online",
            target = "_blank",
            style = "margin-top:-30px; color:DodgerBlue",
            href = paste0("https://mephas.github.io/helppage/")))),
tabPanel(
  tags$button(
    id = 'close',
    type = "button",
    class = "btn action-button",
    style = "margin-top:-8px; color:Tomato; background-color: #F8F8F8  ",
    onclick = "setTimeout(function(){window.close();},500);",  # close browser
    "Stop and Quit"))

))

##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########

server <- function(input, output) {


#source("0data_server.R", local=TRUE)$value

#source("1km_server.R", local=TRUE)$value

#source("2aft_server.R", local=TRUE)$value

#source("2pr_server.R", local=TRUE)$value

#source("3cox_server.R", local=TRUE)$value

#source("3pr_server.R", local=TRUE)$value



observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })

}

##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########

app <- shinyApp(ui = ui, server = server)

runApp(app, quiet = TRUE)

}
