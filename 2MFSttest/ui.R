tagList(

source("../0tabs/font.R",local=TRUE, encoding="UTF-8")$value,
tags$head(includeScript("../0tabs/navtitle.js")),
tags$head(
  tags$link(rel = "shortcut icon", href = "../www/favicon.ico"),
  tags$link(rel = "icon", type = "image/png", sizes = "96x96", href = "../www/favicon-96x96.ico"),
  tags$link(rel = "icon", type = "image/png", sizes = "32x32", href = "../www/favicon-32x32.png"),
  tags$link(rel = "icon", type = "image/png", sizes = "16x16", href = "../www/favicon-16x16.png")
),
tags$style(type="text/css", "body {padding-top: 70px;}"),
source("../0tabs/onoff.R", local=TRUE)$value,

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

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To determine if your data is statistically significantly different from the specified mean from T test results
<li> To know the basic descriptive statistics about your data
<li> To know the descriptive statistics plot such as box-plot, mean-sd plot, QQ-plot, distribution histogram, and density distribution plot about your data to determine if your data is close to normal distribution
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data contain only 1 group of values (or a numeric vector)
<li> The values are independent observations and approximately normally distributed
</ul>

<i><h4>Case Example</h4>
Suppose we collected the age of 144 independent lymph node positive patients, and wanted to know whether the general age of lymph node positive patients was 50 years old
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
<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To determine if the means of two sets of your data are significantly different from each other from T test results
<li> To know the basic descriptive statistics about your data
<li> To know the descriptive statistics plot such as box-plot, mean-sd plot, QQ-plot, distribution histogram, and density distribution plot about your data to determine if your data is close to normal distribution

</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data contain 2 separate groups/sets (or 2 numeric vectors)
<li> The 2 separate groups/sets are independent and identically approximately normally distributed
</ul>

<i><h4>Case Example</h4>
Suppose we collected the age of 144 independent lymph node positive patients. Among them, 27 had Estrogen receptor (ER) positive, 114 had ER negative.
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

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To determine if the difference of the paired 2 samples are equal to 0
<li> To know the basic descriptive statistics about your data
<li> To know the descriptive statistics plot such as box-plot, mean-sd plot, QQ-plot, distribution histogram, and density distribution plot about your data to determine if your data is close to normal distribution

</ul>


<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data contain 2 separate groups/sets (or 2 numeric vectors)
<li> Two samples that have been matched or paired
<li> The differences of paired samples are approximately normally distributed
</ul>

<h4><b> 3. Examples for Matched or Paired Data </b></h4>
<ul>
<li>  One person's pre-test and post-test scores
<li>  When there are two samples that have been matched or paired
</ul>


<i><h4>Case Example</h4>
Suppose we collected the wanted to know whether a certain drug had effect on people's sleeping hour. We got 10 people and collected the sleeping hour data before and after taking the drug.
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
#source("../0tabs/stop.R",local=TRUE, encoding="UTF-8")$value,
#source("../0tabs/help.R",local=TRUE, encoding="UTF-8")$value,
#source("../0tabs/home.R",local=TRUE, encoding="UTF-8")$value,
#source("../0tabs/onoff.R",local=TRUE, encoding="UTF-8")$value
tabPanel(tags$button(
				    id = 'close',
				    type = "button",
				    class = "btn action-button",
				    icon("power-off"),
				    style = "background:rgba(255, 255, 255, 0); display: inline-block; padding: 0px 0px;",
				    onclick = "setTimeout(function(){window.close();},500);")),
navbarMenu("",icon=icon("link"))
)
)
