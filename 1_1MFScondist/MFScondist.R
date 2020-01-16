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
##' @importFrom stats dchisq dnorm dt pbinom pnorm ppois qchisq qexp qf qgamma qnorm qt quantile rchisq rexp rf rgamma rnorm rt sd var
##' @importFrom utils head

##' @examples
##' # mephas::MFScondist()
##' ## or,
##' # library(mephas)
##' # MFScondist()

##' @export
MFScondist <- function(){


##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
ui <- tagList(

navbarPage(

title = "Continuous Probability Distribution",

##########----------##########----------##########

tabPanel("Normal",

headerPanel("Normal Distribution"),

HTML(
" 
<i><h4>Case Example</h4>
Suppose we wanted to see the shape of N(0, 1), and wanted to know 1. at which point x0 when Pr(X < x0)= 0.025, and 2. what is the probability between means+/-1SD area  </i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
),

hr(),

source("p1_ui.R", local=TRUE)$value,

hr()
)
,

##########----------##########----------##########
tabPanel("Exponential",

headerPanel("Exponential Distribution"), 

HTML(
" 
<i><h4>Case Example</h4>
Suppose we wanted to see the shape of E(2), and wanted to know at which point x0 when Pr(X < x0)= 0.05 </i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>

"

),

hr(),

source("p2_ui.R", local=TRUE)$value,

hr()
),

##########----------##########----------##########
tabPanel("Gamma",

headerPanel("Gamma Distribution"), 

HTML(
" 
<i><h4>Case Example</h4>
Suppose we wanted to see the shape of Gamma(9,0.5), and wanted to know at which point x0 when Pr(X < x0)= 0.05 </i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
),

hr(),

source("p3_ui.R", local=TRUE)$value,

hr()
),

##########----------##########----------##########
tabPanel("Beta",

headerPanel("Beta Distribution"), 

HTML(
" 
<i><h4>Case Example</h4>
Suppose we wanted to see the shape of Beta(2, 2), and wanted to know at which point x0 when Pr(X < x0)= 0.05 </i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
),

hr(),

source("p4_ui.R", local=TRUE)$value,

hr()
),

##########----------##########----------##########
tabPanel("T",

headerPanel("Student's T Distribution"), 

HTML(
" 
<i><h4>Case Example</h4>
Suppose we wanted to see the shape of T(4) and wanted to know at which point x0 when Pr(X < x0)= 0.025 </i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
),

hr(),

source("p5_ui.R", local=TRUE)$value,

hr()
),

##########----------##########----------##########
tabPanel("Chi",

headerPanel("Chi-Squared Distribution"), 

HTML(
" 
<i><h4>Case Example</h4>
Suppose we wanted to see the shape of Chi(4), and wanted to know at which point x0 when Pr(X < x0)= 0.05 </i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
),

hr(),

source("p6_ui.R", local=TRUE)$value,

hr()
),

##########----------##########----------##########
tabPanel("F",

headerPanel("F Distribution"), 

HTML(
" 
<i><h4>Case Example</h4>
Suppose we wanted to see the shape of F(100, 10), and wanted to know at which point x0 when Pr(X < x0)= 0.05 </i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
),

hr(),

source("p7_ui.R", local=TRUE)$value,

hr()
),

##########----------##########----------##########
tabPanel((a("Help",
            target = "_blank",
            style = "margin-top:-30px; color:DodgerBlue",
            href = paste0("https://mephas.github.io/helppage/"))))

)

)


##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########

server <- function(input, output) {

source("p1_server.R", local=TRUE)$value

source("p2_server.R", local=TRUE)$value

source("p3_server.R", local=TRUE)$value

source("p4_server.R", local=TRUE)$value

source("p5_server.R", local=TRUE)$value

source("p6_server.R", local=TRUE)$value

source("p7_server.R", local=TRUE)$value

}

##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########

app <- shinyApp(ui = ui, server = server)

runApp(app, quiet = TRUE)

}

