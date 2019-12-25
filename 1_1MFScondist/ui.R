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

title = "Continuous Probability Distribution",

##---------- Panel 1 ---------
tabPanel("Normal",

headerPanel("Normal Distribution"),

HTML(
" 
<h4><b> What you can do on this page</b></h4>
<ul>
<li> Draw a Normal Distribution with N(&#956, &#963); &#956 is the location, and &#963 indicates the shape 
<li> Get the probability distribution of x0 that Pr(X less than x0) = left to the red-line and Pr(x1 less than X greater than x2) in the blue area
<li> Get the probability distribution from simulation numbers in Simulation-based tab
<li> Download the random number in Simulation-based tab
<li> Get the mean, SD, and Pr(X less than x0) of simulated numbers
<li> Get the probability distribution of your data which can be roughly compared to N(&#956, &#963)

</ul>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>

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

##---------- Panel 2 ---------
tabPanel("Exponential",

headerPanel("Exponential Distribution"), 

HTML(
" 
<h4><b> What you can do on this page</b></h4>
<ul>
<li> Draw an Exponential Distribution with E(Rate); Rate indicates the rate of change
<li> Get the probability distribution of x0 that Pr(X less than x0) = left to the red-line 
<li> Get the probability distribution from simulation numbers in Simulation-based tab
<li> Download the random number in Simulation-based tab
<li> Get the mean, SD, and Pr(X less than x0) of simulated numbers
<li> Get the probability distribution of your data which can be roughly compared to E(Rate)
</ul>

<i><h4>Case Example</h4>
Suppose we wanted to see the shape of E(2), and wanted to know at which point x0 when Pr(X < x0)= 0.05 </i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>

"

),

hr(),

source("p2_ui.R", local=TRUE)$value,

hr()
),

##---------- Panel 3 ---------
tabPanel("Gamma",

headerPanel("Gamma Distribution"), 

HTML(
" 
<h4><b> What you can do on this page</b></h4>    
<ul>
<li> Draw a Gamma Distribution with Gamma(&#945, &#952); &#945 controls the shape, 1/&#952 controls the change of rate
<li> Get the probability distribution of x0 that Pr(X less than x0) = left to the red-line 
<li> Get the probability distribution from simulation numbers in Simulation-based tab
<li> Download the random number in Simulation-based tab
<li> Get the mean, SD, and Pr(X less than x0) of simulated numbers
<li> Get the probability distribution of your data which can be roughly compared to  Gamma(&#945, &#952)  
</ul>

<i><h4>Case Example</h4>
Suppose we wanted to see the shape of Gamma(9,0.5), and wanted to know at which point x0 when Pr(X < x0)= 0.05 </i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
),

hr(),

source("p3_ui.R", local=TRUE)$value,

hr()
),

##---------- Panel 4 ---------
tabPanel("Beta",

headerPanel("Beta Distribution"), 

HTML(
" 
<h4><b> What you can do on this page</b></h4>    
<ul>
<li> Draw a Beta Distribution with Beta(&#945, &#946); &#945, &#946 controls the shape
<li> Get the probability distribution of x0 that Pr(X less than x0) = left to the red-line 
<li> Get the probability distribution from simulation numbers in Simulation-based tab
<li> Download the random number in Simulation-based tab
<li> Get the mean, SD, and Pr(X less than x0) of simulated numbers
<li> Get the probability distribution of your data which can be roughly compared to Beta(&#945, &#946)  
</ul>

<i><h4>Case Example</h4>
Suppose we wanted to see the shape of Beta(2, 2), and wanted to know at which point x0 when Pr(X < x0)= 0.05 </i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
),

hr(),

source("p4_ui.R", local=TRUE)$value,

hr()
),

##---------- Panel 5 ---------
tabPanel("T",

headerPanel("Student's T Distribution"), 

HTML(
" 
<h4><b> What you can do on this page</b></h4>    
<ul>
<li> Draw a T Distribution with T(v); v is the degree of freedom related to your sample size and control the shape 
<li> Get the probability distribution of x0 that Pr(X less than x0) = left to the red-line 
<li> Get the probability distribution from simulation numbers in Simulation-based tab
<li> Download the random number in Simulation-based tab
<li> Get the mean, SD, and Pr(X less than x0) of simulated numbers
<li> Get the probability distribution of your data which can be roughly compared to T(v)  </ul>

<i><h4>Case Example</h4>
Suppose we wanted to see the shape of T(4) and wanted to know at which point x0 when Pr(X < x0)= 0.025 </i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
),

hr(),

source("p5_ui.R", local=TRUE)$value,

hr()
),

##---------- Panel 6 ---------
tabPanel("Chi",

headerPanel("Chi-Squared Distribution"), 

HTML(
" 
<h4><b> What you can do on this page</b></h4>    
<ul>
<li> Draw a Chi-Squared Distribution with Chi(v); v is the degree of freedom related to your sample size and control the shape 
<li> Get the probability distribution of x0 that Pr(X less than x0) = left to the red-line 
<li> Get the probability distribution from simulation numbers in Simulation-based tab
<li> Download the random number in Simulation-based tab
<li> Get the mean, SD, and Pr(X less than x0) of simulated numbers
<li> Get the probability distribution of your data which can be roughly compared to Chi(v)</ul>

<i><h4>Case Example</h4>
Suppose we wanted to see the shape of Chi(4), and wanted to know at which point x0 when Pr(X < x0)= 0.05 </i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
),

hr(),

source("p6_ui.R", local=TRUE)$value,

hr()
),

##---------- Panel 7 ---------
tabPanel("F",

headerPanel("F Distribution"), 

HTML(
" 
<h4><b> What you can do on this page</b></h4>    
<ul>
<li> Draw a F Distribution with F(df1, df2) ; df1 and df2 are the degree of freedom related to your sample size and control the shape 
<li> Get the probability distribution of x0 that Pr(X less than x0) = left to the red-line 
<li> Get the probability distribution from simulation numbers in Simulation-based tab
<li> Download the random number in Simulation-based tab
<li> Get the mean, SD, and Pr(X less than x0) of simulated numbers
<li> Get the probability distribution of your data which can be roughly compared to F(df1, df2)  </ul>

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

##---------- other panels ----------


source("../0tabs/stop.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/help1.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/home.R",local=TRUE, encoding="UTF-8")$value


))
)


