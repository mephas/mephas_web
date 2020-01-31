if (!require("shinyWidgets")) {install.packages("shinyWidgets")}; ("shinyWidgets")
shinyUI(

tagList(

source("../0tabs/font.R",local=TRUE, encoding="UTF-8")$value,

navbarPage(

title = "Test for Binomial Proportions",

##########----------##########----------##########

tabPanel("One Sample",

titlePanel("Chi-square Test and Exact Binomial Method for One Proportion"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To determine if the population rate/proportion behind your data is significantly different from the specified rate/proportion
<li> To determine how compatible the sample rate/proportion with a population rate/proportion
<li> To determine the probability of success in a Bernoulli experiment
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data come from binomial distribution (the proportion of success)
<li> You know the whole sample and the number of specified events (the proportion of sub-group)
<li> You have a specified proportion (p<sub>0</sub>)
</ul>

<i><h4>Case Example</h4>
Suppose that in the general population, 20% women who had infertility. Suppose a treatment may affect infertility. 200 women who were trying to get pregnant accepted the treatment.
Among 40 women who got the treatment, 10 were still infertile. We wanted to know if there was a significant difference in the rate of infertility among treated women compared to 20% the general infertile rate. 
</h4></i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>    
" 
)
),

hr(),

source("p1_ui.R", local=TRUE)$value,
hr()

),

##########----------##########----------##########
tabPanel("Two Samples",

titlePanel("Chi-square Test for Two Independent Proportions"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To determine if the population rate/proportion behind your 2 groups data are significantly different </ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your 2 groups data come from binomial distribution (the proportion of success)
<li> You know the whole sample and the number of specified events (the proportion of sub-group) from 2 groups
<li> The 2 groups are independent observations
</ul>

<i><h4>Case Example</h4>
Suppose all women in the study had at least on birth. We investigated 3220 breast cancer women as case. Among them, 683 had at least one birth after 30 years old. 
Also we investigated 10245 no breast cancer women as control. Among them, 1498 had at least one birth after 30 years old.
we wanted to know if the underlying probability of having first birth over 30 years old was different in breast cancer and non-breast cancer groups.
</h4></i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>    
"
)
),
hr(),

source("p2_ui.R", local=TRUE)$value,
hr()


),

##########----------##########----------##########
tabPanel(">2 Samples",

titlePanel("Chi-square Test for More than Two Independent Proportions"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To determine if the population rate/proportion behind your multiple groups data are significantly different </ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your groups data come from binomial distribution (the proportion of success)
<li> You know the whole sample and the number of specified events (the proportion of sub-group) from each groups
<li> The multiple groups are independent observations
</ul>

<i><h4>Case Example</h4>
Suppose we wanted to study the relationship between age at first birth and development of breast cancer. Thus, we investigated 3220 breast cancer cases and 10254 no breast cancer cases.
Then, we categorize women into different age groups. 
We wanted to know if the probability to have cancer were different among different age groups; or, if there age related to breast cancer.

</h4></i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>    
"
)
),
hr(),

source("p3_ui.R", local=TRUE)$value,
hr()
),

##########----------##########----------##########
tabPanel("Trend in >2 Samples ",

titlePanel("Chi-square Test for Trend in Multiple Independent Samples"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To determine if the population rate/proportion behind your multiple groups data vary 
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your groups data come from binomial distribution (the proportion of success)
<li> You know the whole sample and the number of specified events (the proportion of sub-group) from each groups
<li> The multiple groups are independent observations
</ul>

<i><h4>Case Example</h4>
Suppose we wanted to study the relationship between age at first birth and development of breast cancer. Thus, we investigated 3220 breast cancer cases and 10254 no breast cancer cases.
Then, we categorize women into different age groups. 
In this example, we wanted to know if the rate to have cancer had tendency from small to large ages.
</h4></i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>    
"
)
),
hr(),

source("p4_ui.R", local=TRUE)$value,
hr()

),


##########----------##########----------##########

source("../0tabs/stop.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/help.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/home.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/onoff.R",local=TRUE, encoding="UTF-8")$value



)))


