if (!require("shinyWidgets")) {install.packages("shinyWidgets")}; library("shinyWidgets")

shinyUI(

tagList(
source("../0tabs/font.R",local=TRUE, encoding="UTF-8")$value,

navbarPage(

title = "Continuous Probability Distribution",
collapsible = TRUE,
id = "navibar",

##########----------##########----------##########
tabPanel("Normal",

headerPanel("Normal Distribution"),
#switchInput(
#   inputId = "explain_on_off",
#   label = "Explainations", 
#   labelWidth = "150px"#,
   #size = "mini"
#),

#switchInput(
#   inputId = "explain_on_off",
#   label = "<i class=\"fa fa-book\"></i>"
#),



#condiPa 1
conditionalPanel(
condition = "input.explain_on_off",
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

<i><h4>Case Example</h4>
Suppose we wanted to see the shape of N(0, 1), and wanted to know 1. at which point x0 when Pr(X < x0)= 0.025, and 2. what is the probability between means+/-1SD area  </i>

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
)
),

hr(),

source("ui_F.R", local=TRUE)$value,

hr()
),

##########----------##########----------##########

source("../0tabs/stop.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/help.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/home.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/onoff.R",local=TRUE, encoding="UTF-8")$value


))
)



