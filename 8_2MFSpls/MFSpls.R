##'
##' MFSpls includes
##' (1) principal component regression
##' (2) partial least squares regression
##' and (3) sparse partial least squares regression
##'
##' @title MEPHAS: Dimensional analysis 2 (Advanced Method)
##'
##' @return The web-based GUI and interactive interfaces
##'
##' @import shiny
##' @import ggplot2
##'
##' @importFrom pls mvr R2 MSEP RMSEP
##' @importFrom spls cv.spls spls
##'
##' @examples
##' # library(mephas)
##' # MFSpls()
##' # or,
##' # mephas::MFSpls()
##' # or,
##' # mephasOpen("pls")
##' # Use 'Stop and Quit' Button in the top to quit the interface

##' @export
MFSpls <- function(){

requireNamespace("shiny", quietly = TRUE)
requireNamespace("ggplot2", quietly = TRUE)
requireNamespace("DT", quietly = TRUE)
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
ui <- tagList(

navbarPage(


title = "Dimensional Analysis 2",

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


observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })

}

##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########

app <- shinyApp(ui = ui, server = server)

runApp(app, quiet = TRUE)

}
