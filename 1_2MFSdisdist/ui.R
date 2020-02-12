if (!require("shiny")) {install.packages("shiny")}; library("shiny")
if (!require("ggplot2")) {install.packages("ggplot2")}; library("ggplot2")
#if (!require("plotly")) {install.packages("plotly")}; library("plotly")
#if (!require("shinyWidgets")) {install.packages("shinyWidgets")}; library("shinyWidgets")

source("../tab/tab.R")
source("../tab/panel.R")
source("../tab/func.R")

tagList(

includeCSS("../www/style.css"),
sty.link(),
tabOF(),

##########--------------------##########--------------------##########

navbarPage(
theme = shinythemes::shinytheme("cerulean"),
#title = a("Discrete Probability Distribution", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
title = "Discrete Probability Distribution",
collapsible = TRUE,
#id="navbar", 
position="fixed-top",


##########----------##########----------##########

tabPanel("Binomial",p(br()),

headerPanel("Binomial Distribution"),

#condiPa 1
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b>Functionalities</b></h4>
<ul>
<li> Get a plot of Binomial Distribution B(n,p); n is the total sample size, p is the probability of success / event from the total sample; np=mean, np(1-p)=variance</li>
<li> Get the probability of a certain position (at the red point)</li>
</ul>

<h4><i>Case Example</i></h4>
<i>Suppose we wanted to know the probability of 2 lymphocytes of 10 white blood cells if the probability of any cell being a lymphocyte is 0.2</i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>

"
)
),
hr(),
source("ui_bio.R", local=TRUE)$value,
hr()

),


##########----------##########----------##########

tabPanel("Poisson",

headerPanel("Poisson Distribution"),
#condiPa 1
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b>Functionalities</b></h4>
<ul>
<li> Draw a plot of Poisson Distribution P(Rate); Rate indicates the expected number of occurrences; Rate = mean =variance</li>
<li> Get the probability of a certain position (at the red point)</li>
</ul>

<i><h4>Case Example</h4>
Suppose the number of death from typhoid fever over a 12 month period is Poisson distributed with parameter rate=2.3.
What is the probability distribution of the number of deaths over a 6-month period?</i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>

"
)
),
hr(),
source("ui_poi.R", local=TRUE)$value,
hr()

),

##########----------##########----------##########
tabstop(),
tablink()
#navbarMenu("",icon=icon("link"))


))

