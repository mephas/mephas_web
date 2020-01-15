##----------#----------#----------#----------
##
## 1MFSdistribution UI
##
## Language: EN
## 
## DT: 2019-01-08
## Update: 2019-12-05
##
##----------#----------#----------#----------

shinyUI(

tagList(
source("../0tabs/font.R",local=TRUE, encoding="UTF-8")$value,

navbarPage(

title = "Discrete Probability Distribution",

##---------- Panel 1 ---------

tabPanel("Binomial",

titlePanel("Binomial Distribution"),

HTML(
" 
<h4><b>What you can do on this page  </b></h4>
<ul>
<li> Get a plot of Binomial Distribution B(n,p); n is the total sample size, p is the probability of success / event from the total sample; np=mean, np(1-p)=variance
<li> Get the probability of a certain position (at the red point)
</ul>

<i><h4>Case Example</h4>
Suppose we wanted to know the probability of 2 lymphocytes of 10 white blood cells if the probability of any cell being a lymphocyte is 0.2</i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>

"
),
hr(),

source("p1_ui.R", local=TRUE)$value,
hr()

),

tabPanel("Poisson",

titlePanel("Poisson Distribution"),

HTML(
" 
<h4><b>What you can do on this page  </b></h4>
<ul>
<li> Draw a plot of Poisson Distribution P(Rate); Rate indicates the expected number of occurrences; Rate = mean =variance
<li> Get the probability of a certain position (at the red point)
</ul>

<i><h4>Case Example</h4>
Suppose the number of death from typhoid fever over a 12 month period is Poisson distributed with parameter rate=2.3.
What is the probability distribution of the number of deaths over a 6-month period?</i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>

"
),
hr(),
source("p2_ui.R", local=TRUE)$value,
hr()

),
##---------- other panels ----------

source("../0tabs/stop.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/help.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/home.R",local=TRUE, encoding="UTF-8")$value


))
)



