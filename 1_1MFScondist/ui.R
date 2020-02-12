

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
#title = a("Continuous Probability Distribution", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
title = "Continuous Probability Distribution",
collapsible = TRUE,
#id="navbar",
position="fixed-top",

##########----------##########----------##########
tabPanel("Normal",

headerPanel("Normal Distribution"),

#condiPa 1
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b>Functionalities</b></h4>
<p><b>Draw a Mathematical-based Normal Distribution</b></p>
<ul>
<li>Draw a Normal Distribution with N(&#956, &#963); &#956 indicates the mean (location), and &#963 indicates its standard deviation (shape).</li>
<li>Calculate the position x<sub>0</sub> of a user-defined probability Pr(X &#8804; x<sub>0</sub>) that is the possibility of a variable X being in an interval (-&#8734, x<sub>0</sub>] from the probability distribution.
<br>In the curve, the left area to the red-line indicates this possibility value, and the intersection of the red line and horizontal axis (X-axis) is the x<sub>0</sub>.</li>
<li>Calculate the probability Pr(&#956 &#8211; n &#215 &#963 < X &#8804; &#956 + n &#215 &#963) that is the possibility of a variable X being in an interval (&#956 &#8211; n &#215 &#963, &#956 + n &#215 &#963]
<br>In the curve, the blue area indicates this possibility value.</li>
</ul>
<p><b>Draw a Simulated-based Normal Distribution</b></p>
<ul>
<li>Generate and download random numbers of normal distribution using a user-defined sample size.</li>
<li>Draw histogram of the generated random numbers.</li>
<li>Calculate the Mean(&#956) and Standard Deviation(&#963) of the generated random numbers.</li>
<li>Calculate the position x<sub>0</sub> of a user-defined probability Pr(X &#8804; x<sub>0</sub>) that is the possibility of a variable X being in an interval (-&#8734, x<sub>0</sub>] from the probability distribution of the generated random numbers.</li>
</ul>
<p><b>Draw a User Data-based Normal Distribution</b></p>
<ul>
<li>Upload your data using Manual Input or from CSV/TXT files.</li>
<li>Draw histogram and density plots of your data.</li>
<li>Calculate the Mean(&#956) and Standard Deviation(&#963) of your data.</li>
<li>Calculate the position x<sub>0</sub> of a user-defined probability Pr(X &#8804; x<sub>0</sub>) that is the possibility of a variable X being in an interval (-&#8734, x<sub>0</sub>] from the probability distribution of your data.</li>
</ul>

<i><h4>Case Example</h4>
Suppose we wanted to see the shape of N(0, 1) and wanted to know 1. at which point x<sub>0</sub> when Pr(X < x<sub>0</sub>) = 0.025, and 2. what is the probability between means +/- 1SD</i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
)
	),


hr(),

source("ui_N.R", local=TRUE)$value,

hr()
),

##########----------##########----------##########
tabPanel("Exponential",

headerPanel("Exponential Distribution"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> Functionalities</b></h4>
<ul>
<li> Draw an Exponential Distribution with E(Rate); Rate indicates the rate of change</li>
<li> Get the probability distribution of x<sub>0</sub> that Pr(X &#8804; x<sub>0</sub>) = left to the red-line</li>
<li> Get the probability distribution from simulation numbers in Simulation-based tab</li>
<li> Download the random number in Simulation-based tab</li>
<li> Get the mean, SD, and Pr(X &#8804; x<sub>0</sub>) of simulated numbers</li>
<li> Get the probability distribution of your data which can be roughly compared to E(Rate)</li>
</ul>

<h4><i>Case Example</i></h4>
<i>Suppose we wanted to see the shape of E(2), and wanted to know at which point x<sub>0</sub> when Pr(X < x<sub>0</sub>)= 0.05 </i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>

"

)
),

hr(),

source("ui_E.R", local=TRUE)$value,

hr()
),


##########----------##########----------##########
tabPanel("Gamma",

headerPanel("Gamma Distribution"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> Functionalities</b></h4>
<ul>
<li> Draw a Gamma Distribution with Gamma(&#945, &#952); &#945 controls the shape, 1/&#952 controls the change of rate</li>
<li> Get the probability distribution of x<sub>0</sub> that Pr(X &#8804; x<sub>0</sub>) = left to the red-line</li>
<li> Get the probability distribution from simulation numbers in Simulation-based tab</li>
<li> Download the random number in Simulation-based tab</li>
<li> Get the mean, SD, and Pr(X &#8804; x<sub>0</sub>) of simulated numbers</li>
<li> Get the probability distribution of your data which can be roughly compared to  Gamma(&#945, &#952)</li>
</ul>

<i><h4>Case Example</h4>
Suppose we wanted to see the shape of Gamma(9,0.5), and wanted to know at which point x<sub>0</sub> when Pr(X < x<sub>0</sub>)= 0.05 </i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
)
),

hr(),

source("ui_G.R", local=TRUE)$value,

hr()
),


##########----------##########----------##########
tabPanel("Beta",

headerPanel("Beta Distribution"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> Functionalities</b></h4>
<ul>
<li> Draw a Beta Distribution with Beta(&#945, &#946); &#945, &#946 controls the shape
<li> Get the probability distribution of x<sub>0</sub> that Pr(X &#8804; x<sub>0</sub>) = left to the red-line</li>
<li> Get the probability distribution from simulation numbers in Simulation-based tab</li>
<li> Download the random number in Simulation-based tab</li>
<li> Get the mean, SD, and Pr(X &#8804; x<sub>0</sub>) of simulated numbers</li>
<li> Get the probability distribution of your data which can be roughly compared to Beta(&#945, &#946)</li>
</ul>

<h4><i>Case Example</i></h4>
<i>Suppose we wanted to see the shape of Beta(12, 12), and wanted to know at which point x<sub>0</sub> when Pr(X < x<sub>0</sub>)= 0.05 </i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
)
),

hr(),

source("ui_B.R", local=TRUE)$value,

hr()
),


##########----------##########----------##########
tabPanel("T",

headerPanel("Student's T Distribution"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> Functionalities</b></h4>
<ul>
<li> Draw a T Distribution with T(v); v is the degree of freedom related to your sample size and control the shape</li>
<li> Get the probability distribution of x<sub>0</sub> that Pr(X &#8804; x<sub>0</sub>) = left to the red-line</li>
<li> Get the probability distribution from simulation numbers in Simulation-based tab</li>
<li> Download the random number in Simulation-based tab</li>
<li> Get the mean, SD, and Pr(X &#8804; x<sub>0</sub>) of simulated numbers</li>
<li> Get the probability distribution of your data which can be roughly compared to T(v)</li>
</ul>

<h4><i>Case Example</i></h4>
<i>Suppose we wanted to see the shape of T(4) and wanted to know at which point x<sub>0</sub> when Pr(X < x<sub>0</sub>)= 0.025 </i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
)
),

hr(),

source("ui_T.R", local=TRUE)$value,

hr()
),


##########----------##########----------##########
tabPanel("Chi",

headerPanel("Chi-Squared Distribution"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> Functionalities</b></h4>
<ul>
<li> Draw a Chi-Squared Distribution with Chi(v); v is the degree of freedom related to your sample size and control the shape</li>
<li> Get the probability distribution of x<sub>0</sub> that Pr(X &#8804; x<sub>0</sub>) = left to the red-line</li>
<li> Get the probability distribution from simulation numbers in Simulation-based tab</li>
<li> Download the random number in Simulation-based tab</li>
<li> Get the mean, SD, and Pr(X &#8804; x<sub>0</sub>) of simulated numbers</li>
<li> Get the probability distribution of your data which can be roughly compared to Chi(v)</li>
</ul>

<h4><i>Case Example</i></h4>
<i>Suppose we wanted to see the shape of Chi(4), and wanted to know at which point x<sub>0</sub> when Pr(X < x<sub>0</sub>)= 0.05 </i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
)
),

hr(),

source("ui_Chi.R", local=TRUE)$value,

hr()
),

##########----------##########----------##########
tabPanel("F",

headerPanel("F Distribution"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> Functionalities</b></h4>
<ul>
<li> Draw a F Distribution with F(df<sub>1</sub>, df<sub>2</sub>) ; df<sub>1</sub> and df<sub>2</sub> are the degree of freedom related to your sample size and control the shape
<li> Get the probability distribution of x<sub>0</sub> that Pr(X &#8804; x<sub>0</sub>) = left to the red-line
<li> Get the probability distribution from simulation numbers in Simulation-based tab
<li> Download the random number in Simulation-based tab
<li> Get the mean, SD, and Pr(X &#8804; x<sub>0</sub>) of simulated numbers
<li> Get the probability distribution of your data which can be roughly compared to F(df<sub>1</sub>, df<sub>2</sub>)
</ul>

<h4><i>Case Example</i></h4>
<i>Suppose we wanted to see the shape of F(100, 10), and wanted to know at which point x<sub>0</sub> when Pr(X < x<sub>0</sub>)= 0.05 </i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
)
),

hr(),

source("ui_F.R", local=TRUE)$value,

hr()
),

##########----------##########----------##########
tabstop(),
tablink()

#navbarMenu("",icon=icon("link"))

))

