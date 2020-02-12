if (!require("shiny")) {install.packages("shiny")}; library("shiny")
if (!require("ggplot2")) {install.packages("ggplot2")}; library("ggplot2")
#if (!require("reshape")) {install.packages("reshape")}; library("reshape")
#if (!require("psych")) {install.packages("psych")}; library("psych")
#if (!require("DT")) {install.packages("DT")}; library("DT")
#if (!require("plotly")) {install.packages("plotly")}; library("plotly")
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
theme = shinythemes::shinytheme("cerulean"),
#title = a("Parametric T Test for Means", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
title = "Parametric T Test for Means",
collapsible = TRUE,
#id="navbar", 
position="fixed-top",

##########----------##########----------##########
tabPanel( "One Sample",

headerPanel("One-Sample T-Test"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"

<h4><b> 1. Functionalities  </b></h4>
<ul>
<li> To determine if your data is statistically significantly different from the specified mean from T-test results</li>
<li> To understand the basic descriptive statistics about your data</li>
<li> To understand the descriptive statistics plot such as box-plot, mean-sd plot, QQ-plot, distribution histogram, and density distribution plot about your data to determine if your data is close to a normal distribution</li>
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data contain only 1 group of values (or a numeric vector)</li>
<li> The values are independent observations and approximately normally distributed</li>
</ul>

<i><h4>Case Example</h4>
Suppose we collected the age of 50 independent lymph node-positive patients and wanted to know whether the general age of lymph node-positive patients was 50 years old
</h4></i>


<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
)
),

hr(),

source("ui_1.R", local=TRUE)$value,

hr()


),


##########----------##########----------##########
tabPanel("Two Samples",

headerPanel("Independent Two-Sample T-Test"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. Functionalities  </b></h4>
<ul>
<li> To determine if the means of two sets of your data are significantly different from each other from T test results</li>
<li> To know the basic descriptive statistics about your data</li>
<li> To know the descriptive statistics plot such as box-plot, mean-sd plot, QQ-plot, distribution histogram, and density distribution plot about your data to determine if your data is close to normal distribution</li>

</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data contain 2 separate groups/sets (or 2 numeric vectors)</li>
<li> The 2 separate groups/sets are independent and identically approximately normally distributed</li>
</ul>

<i><h4>Case Example</h4>
Suppose we collected the age of 50 independent lymph node-positive patients. Among them, 25 had Estrogen receptor (ER) positive, 25 had ER negative.
We wanted to know if the ages of patients with ER positive was significantly different from patients with ER negative in general. Or, whether ER is related to age.
</h4></i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>

"
)
),

hr(),

source("ui_2.R", local=TRUE)$value,

hr()

),


##########----------##########----------##########
tabPanel("Paired Samples",

headerPanel("Dependent T-Test for Paired Samples"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<b>In paired case, we compare the differences of 2 groups to zero. Thus, it becomes a one-sample test problem.</b>

<h4><b> 1. Functionalities  </b></h4>
<ul>
<li> To determine if the difference of the paired 2 samples are equal to 0</li>
<li> To know the basic descriptive statistics about your data</li>
<li> To know the descriptive statistics plot such as box-plot, mean-sd plot, QQ-plot, distribution histogram, and density distribution plot about your data to determine if your data is close to normal distribution</li>

</ul>


<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data contain 2 separate groups/sets (or 2 numeric vectors)</li>
<li> Two samples that have been matched or paired</li>
<li> The differences of paired samples are approximately normally distributed</li>
</ul>

<h4><b> 3. Examples for Matched or Paired Data </b></h4>
<ul>
<li>  One person's pre-test and post-test scores</li>
<li>  When there are two samples that have been matched or paired</li>
</ul>


<h4><i>Case Example</i></h4>
<i>Suppose we collected the wanted to know whether a certain drug had effect on people's sleeping hour. We got 10 people and collected the sleeping hour data before and after taking the drug.
This was a paired case. We wanted to know whether the sleeping hours before and after the drug would be significantly different; or, whether the difference before and after were significantly different from 0</i>


<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>

"
)
),

hr(),

source("ui_p.R", local=TRUE)$value,
hr()

),

##########----------##########----------##########
tabstop(),
tablink()
#navbarMenu("",icon=icon("link"))
)
)
