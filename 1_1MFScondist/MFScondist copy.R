##'
##' MFScondist includes probability distribution of
##' (1) normal distribution
##' (2) exponential distribution
##' (3) gamma distribution
##' (4) beta distribution
##' (5) t distribution
##' (6) chi-square distribution
##' and (7) F distribution.
##'
##' MFScondist also generates random numbers draw the distribution of user data
##'
##' @title MEPHAS: Continuous Probability Distribution (Probability)
##'
##' @return shiny interface
##'
##' @import shiny
##' @import ggplot2
##' @importFrom stats dchisq dnorm dt pbinom pnorm ppois qchisq qexp qf qgamma qnorm qt quantile rchisq rexp rf rgamma rnorm rt sd var qbeta rbeta
##' @importFrom utils head

##' @examples
##' # library(mephas)
##' # MFScondist()
##' # or,
##' # mephas::MFScondist()
##' # or,
##' # mephasOpen("condist")
##' # Use 'Stop and Quit' Button in the top to quit the interface

##' @export
MFScondist <- function(){

requireNamespace("shiny", quietly = TRUE)
requireNamespace("ggplot2", quietly = TRUE)
requireNamespace("DT", quietly = TRUE)
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
ui <- tagList(

navbarPage(

title = "Continuous Probability Distribution",





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

