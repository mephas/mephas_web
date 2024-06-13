#if (!require("Hmisc")) {install.packages("Hmisc")};library("Hmisc")
if (!requireNamespace("shiny", quietly = TRUE)) {install.packages("shiny")}; require("shiny",quietly = TRUE)
if (!requireNamespace("ggplot2",quietly = TRUE)) {install.packages("ggplot2")}; require("ggplot2",quietly = TRUE)

#if (!require("DT")) {install.packages("DT")}; library("DT")
if (!requireNamespace("plotly",quietly = TRUE)) {install.packages("plotly")}; require("plotly",quietly = TRUE)
#if (!require("shinyWidgets")) {install.packages("shinyWidgets")}; library("shinyWidgets")

source("../tab/tab.R")
source("../tab/panel.R")
source("../tab/func.R")

tagList(

includeCSS("../www/style.css"),
stylink(),
tabOF(),

##########--------------------##########--------------------##########

navbarPage(
#theme = shinythemes::shinytheme("cerulean"),
#title = a("Test for Binomial Proportions", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
title = "Test for Binomial Proportions",
collapsible = TRUE,
#id="navbar", 
position="fixed-top",

##########----------##########----------##########

tabPanel("One Sample",

headerPanel("Chi-square Test and Exact Binomial Method for One Proportion"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. Functionalities</b></h4>
<ul>
<li> To determine if the population rate/proportion behind your data is significantly different from the specified rate/proportion</li>
<li> To determine how compatible the sample rate/proportion with a population rate/proportion</li>
<li> To determine the probability of success in a Bernoulli experiment</li>
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data come from binomial distribution (the proportion of success)</li>
<li> You know the whole sample and the number of specified events (the proportion of sub-group)</li>
<li> You have a specified proportion (p<sub>0</sub>)</li>
</ul>

<h4><i>Case Example</i></h4>
<i>Suppose that in the general population, 20% of women who had infertility. Suppose a treatment may affect infertility. 200 women who were trying to get pregnant accepted the treatment.
Among 40 women who got the treatment, 10 were still infertile. We wanted to know if there was a significant difference in the rate of infertility among treated women compared to 20% of the general infertile rate. 
</h4></i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>    
" 
)
),

hr(),

source("ui_1.R", local=TRUE, encoding = "utf-8")$value,
hr()

),

##########----------##########----------##########
tabPanel("Two Samples",

headerPanel("Chi-square Test for Two Independent Proportions"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. Functionalities  </b></h4>
<ul>
<li> To determine if the population rate/proportion behind your 2 groups data are significantly different </ul></li>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your 2 groups data come from binomial distribution (the proportion of success)</li>
<li> You know the whole sample and the number of specified events (the proportion of sub-group) from 2 groups</li>
<li> The 2 groups are independent observations</li>
</ul>

<h4><i>Case Example</i></h4>
<i>Suppose all women in the study had at least on birth. We investigated 3220 breast cancer women as the case. Among them, 683 had at least one birth after 30 years old. 
Also, we investigated 10245 no breast cancer women as control. Among them, 1498 had at least one birth after 30 years old.
We wanted to know if the underlying probability of having first birth over 30 years old was different in breast cancer and non-breast cancer groups.
</h4></i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>    
"
)
),
hr(),

source("ui_2.R", local=TRUE, encoding = "utf-8")$value,
hr()


),

##########----------##########----------##########
tabPanel(">2 Samples",

headerPanel("Chi-square Test for More than Two Independent Proportions"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. Functionalities  </b></h4>
<ul>
<li> To determine if the population rate/proportion behind your multiple group data are significantly different</li>
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your group data come from binomial distribution (the proportion of success)</li>
<li> You know the whole sample and the number of specified events (the proportion of sub-group) from each group</li>
<li> The multiple groups are independent observations</li>
</ul>

<h4><i>Case Example</i></h4>
<i>Suppose we wanted to study the relationship between age at first birth and the development of breast cancer. Thus, we investigated 3220 breast cancer cases and 10254 no breast cancer cases.
Then, we categorize women into different age groups. 
We wanted to know if the probability of having cancer were different among different age groups; or if their ages related to breast cancer.
</i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>    
"
)
),
hr(),

source("ui_3.R", local=TRUE, encoding = "utf-8")$value,
hr()
),

##########----------##########----------##########
tabPanel("Trend in >2 Samples ",

headerPanel("Chi-square Test for Trend in Multiple Independent Samples"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. Functionalities  </b></h4>
<ul>
<li> To determine if the population rate/proportion behind your multiple group data vary </li>
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your group data come from binomial distribution (the proportion of success)</li>
<li> You know the whole sample and the number of specified events (the proportion of sub-group) from each group</li>
<li> The multiple groups are independent observations</li>
</ul>

<h4><i>Case Example</i></h4>
<i>Suppose we wanted to study the relationship between age at first birth and the development of breast cancer. Thus, we investigated 3220 breast cancer cases and 10254 no breast cancer cases.
Then, we categorize women into different age groups. 
In this example, we wanted to know if the rate of having cancer tended from small to large ages.
</i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>    
"
)
),
hr(),

source("ui_t.R", local=TRUE, encoding = "utf-8")$value,
hr()

),


##########----------##########----------##########

tablang("4MFSproptest"),
tabstop(),
tablink()
#navbarMenu("",icon=icon("link"))



))


