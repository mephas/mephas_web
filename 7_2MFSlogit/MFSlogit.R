##'
##' MFSlogit includes
##' (1) logistic regression for binary outcomes,
##'
##' @title MEPHAS: Logistic Regression Model (Advanced Method)
##'
##' @return shiny interface
##'
##' @import shiny
##' @import ggplot2
##'
##' @importFrom stargazer stargazer
##' @importFrom ROCR performance prediction
##' @importFrom stats anova as.formula binomial glm predict residuals step relevel
##' @importFrom utils str write.table
##'
##' @examples
##' # library(mephas)
##' # MFSlogit()
##' # or,
##' # mephas::MFSlogit()
##' # or,
##' # mephasOpen("logisreg")
##' # Use 'Stop and Quit' Button in the top to quit the interface

##' @export
MFSlogit <- function(){

requireNamespace("shiny", quietly = TRUE)
requireNamespace("ggplot2", quietly = TRUE)
requireNamespace("DT", quietly = TRUE)
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
ui <- tagList(

navbarPage(

title = "Logistic Regression",

##########----------##########----------##########

#source("0data_server.R", local=TRUE)$value

#source("1lm_ui.R", local=TRUE, encoding="UTF-8")$value

#source("2pr_ui.R", local=TRUE, encoding="UTF-8")$value


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
#****************************************************************************************************************************************************
#load("LGT.RData")



#source("1lm_server.R", local=TRUE)$value
#****************************************************************************************************************************************************model



#source("2pr_server.R", local=TRUE)$value
#****************************************************************************************************************************************************pred





observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })

}

##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########

app <- shinyApp(ui = ui, server = server)

runApp(app, quiet = TRUE)

}
