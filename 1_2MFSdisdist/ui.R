
tagList(

source("../0tabs/font.R",local=TRUE, encoding="UTF-8")$value,
tags$head(includeScript("../0tabs/navtitle.js")),
tags$style(type="text/css", "body {padding-top: 70px;}"),
source("../0tabs/onoff.R", local=TRUE)$value,

navbarPage(
theme = shinythemes::shinytheme("cerulean"),
title = a("Discrete Probability Distribution", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
collapsible = TRUE,
#id="navbar", 
position="fixed-top",


##########----------##########----------##########

tabPanel("Binomial",p(br()),

titlePanel("Binomial Distribution"),

#condiPa 1
conditionalPanel(
condition = "input.explain_on_off",
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
)
),
hr(),
source("ui_bio.R", local=TRUE)$value,
hr()

),


##########----------##########----------##########

tabPanel("Poisson",

titlePanel("Poisson Distribution"),
#condiPa 1
conditionalPanel(
condition = "input.explain_on_off",
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
)
),
hr(),
source("ui_poi.R", local=TRUE)$value,
hr()

),

##########----------##########----------##########
#source("../0tabs/stop.R",local=TRUE, encoding="UTF-8")$value,
#source("../0tabs/help.R",local=TRUE, encoding="UTF-8")$value,
#source("../0tabs/home.R",local=TRUE, encoding="UTF-8")$value,
#source("../0tabs/onoff.R",local=TRUE, encoding="UTF-8")$value,

tabPanel(tags$button(
				    id = 'close',
				    type = "button",
				    class = "btn action-button",
				    icon("power-off"),
				    style = "background:rgba(255, 255, 255, 0); display: inline-block; padding: 0px 0px;",
				    onclick = "setTimeout(function(){window.close();},500);")),
navbarMenu("",icon=icon("link"))


))

