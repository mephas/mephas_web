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
##' @import shinythemes
##' @import ggplot2
##'
##' @importFrom stats dchisq dnorm dt pbinom pnorm ppois qchisq qexp qf qgamma qnorm qt quantile rchisq rexp rf rgamma rnorm rt sd var qbeta rbeta cor reshape
##' @importFrom utils read.csv write.csv head
##' @importFrom plotly plotlyOutput renderPlotly ggplotly layout plot_ly add_trace
##' @importFrom shinyWidgets switchInput 
##' @importFrom magrittr %>% 
##'
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

##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
ui <- 




##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########

server <- 


##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########

app <- shinyApp(ui = ui, server = server)

runApp(app, quiet = TRUE)

}

