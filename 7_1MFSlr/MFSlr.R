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
##' @import survival
##' @import survminer
##'
##' @importFrom stargazer stargazer
##' @importFrom stats anova as.formula lm predict residuals step relevel
##' @importFrom utils str write.table
##'
##' @examples
##' #mephas::MFSlr()
##' ## or,
##' # library(mephas)
##' # MFSlr()

##' @export
MFSlr <- function(){

##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
ui <- tagList(



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

source("p1_server.R", local=TRUE)$value

source("p2_server.R", local=TRUE)$value

source("p3_server.R", local=TRUE)$value

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })

}

##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########

app <- shinyApp(ui = ui, server = server)

runApp(app, quiet = TRUE)

}
