##'
##' MFSlr includes
##' (1) linear regression for continuous outcomes
##'
##' @title MEPHAS: Linear Regression Model (Advanced Method)
##'
##' @return shiny interface
##'
##' @import shiny
##' @import ggplot2
##'
##' @importFrom stargazer stargazer
##' @importFrom stats anova as.formula lm predict residuals step relevel
##' @importFrom utils str write.table
##'
##' @examples
##' # library(mephas)
##' # MFSlr()
##' # or,
##' # mephas::MFSlr()
##' # or,
##' # mephasOpen("linereg")
##' # Use 'Stop and Quit' Button in the top to quit the interface

##' @export
MFSlr <- function(){

requireNamespace("shiny", quietly = TRUE)
requireNamespace("ggplot2", quietly = TRUE)
requireNamespace("DT", quietly = TRUE)
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
ui <- tagList(

navbarPage(

title = "Linear Regression",

##########----------##########----------##########
#source("0data_ui.R", local=TRUE, encoding="UTF-8")$value,

#source("1lm_ui.R", local=TRUE, encoding="UTF-8")$value,

#source("2pr_ui.R", local=TRUE, encoding="UTF-8")$value,




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

#source("1lm_server.R", local=TRUE)$value


#source("2pr_server.R", local=TRUE)$value




observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })

}

##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########

app <- shinyApp(ui = ui, server = server)

runApp(app, quiet = TRUE)

}
