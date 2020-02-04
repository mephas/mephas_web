source("../tab/tab.R")
source("../tab/panel.R")
tagList(

source("../tab/font.R",local=TRUE, encoding="UTF-8")$value,
#tags$head(includeScript("../0tabs/navtitle.js")),
tags$head(
  tags$link(rel = "shortcut icon", href = "../www/favicon.ico"),
  tags$link(rel = "icon", type = "image/png", sizes = "96x96", href = "../www/favicon-96x96.ico"),
  tags$link(rel = "icon", type = "image/png", sizes = "32x32", href = "../www/favicon-32x32.png"),
  tags$link(rel = "icon", type = "image/png", sizes = "16x16", href = "../www/favicon-16x16.png")
),
tags$style(type="text/css", "body {padding-top: 70px;}"),
#source("../0tabs/onoff.R", local=TRUE)$value,
tabOF(),

navbarPage(
theme = shinythemes::shinytheme("cerulean"),
#title = a("Test for Contingency Table", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
title = "Analysis of Variance",
collapsible = TRUE,
#id="navbar", 
position="fixed-top",

##########----------##########----------##########
tabPanel("One-way and Multiple Comparison",

headerPanel("One-way ANOVA to Compare Means from Multiple Factor Groups and Multiple Comparison Post-Hoc Correction for Specific Groups"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. Functionalities  </b></h4>
<ul>
<li> To determine if the means differ significantly among the factor groups</li>
<li> To determine if the means differ significantly among pairs, given that one-way ANOVA finds significant differences among factor groups.</li>

</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data contain several separate factor groups shown in 2 vectors</li>
<li> One vector is the observed values; one vector is to mark your values in different factor groups</li>
<li> The separate factor groups are independent and identically approximately normally distributed</li>
<li> Each mean of the factor group follows a normal distribution with the same variance and can be compared</li>
</ul>

<h4><i>Case Example</i></h4>
<i>Suppose we want to find whether passive smoking had a measurable effect on the incidence of cancer. In a study, we studied 6 group of smokers: nonsmokers (NS), passive smokers (PS), non-inhaling smokers (NI), light smokers (LS), moderate smokers (MS), and heavy smokers (HS).
The study measured the forced mid-expiatory flow (FEF). We wanted to the know the FEF differences among the 6 groups.
</i>


<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
)
),

hr(),
source("ui_1.R", local=TRUE)$value,
hr(),
source("ui_1m.R", local=TRUE)$value,
hr()

),

##########----------##########----------##########

tabPanel("Two-way and Multiple Comparison",

headerPanel("Two-way ANOVA to Compare Means from Multiple Groups and Multiple Comparison Post-Hoc Correction for Specific Groups"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. Functionalities  </b></h4>
<ul>
<li> To determine if the means differ significantly among the Factor1 after controlling for Factor2</li>
<li> To determine if the means differ significantly among the Factor2 after controlling for Factor1</li>
<li> To determine if the Factor1 and Factor2 have interaction to effect the outcomes</li>
<li> To determine if the means differ significantly among which pairs, given that two-way ANOVA finds significant differences among groups.</li>

</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data contain several separate factor groups (or 2 vectors)</li>
<li> The separate factor groups/sets are independent and identically approximately normally distributed</li>
<li> Each mean of the factor group follows a normal distribution with the same variance and can be compared</li>
</ul>

<h4><i>Case Example</i></h4>
<i>Suppose we were interested in the effects of sex and 3 dietary groups on SPB.
The 3 dietary groups included strict vegetarians (SV), lactovegentarians (LV), and normal (NOR) people, and we tested the SBP.
The effects of sex and and dietary group might be related (interact) with each other.
We wanted to know the effect of dietary group and sex on the SPB and whether the two factors were related with each other.
</i>


<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
)
),

hr(),
source("ui_2.R", local=TRUE)$value,
hr(),
source("ui_2m.R", local=TRUE)$value,
hr()
),
#

##########----------##########----------##########
tabPanel("Non-parametric Methods",

headerPanel("Kruskal-Wallis Non-parametric Test to Compare Multiple Samples and Multiple Comparison Post-Hoc Correction for Specific Groups"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<b>This method compares ranks of the observed data, rather than mean and SD. An alternative to one-way ANOVA without assumption on the data distribution</b>

<h4><b> 1. Functionalities  </b></h4>
<ul>
<li> To determine if the means differ significantly among the factor groups</li>
<li> To determine if the means differ significantly among pairs, given that one-way ANOVA finds significant differences among groups.</li>

</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data contain several separate factor groups shown in two vectors</li>
<li> One vector is the observed values; one vector is to mark your values in different factor groups</li>
<li> The separate factor groups are independent and identically without distribution assumption</li>
</ul>

<h4><i>Case Example</i></h4>
<i>Suppose we want to find whether passive smoking had a measurable effect on the incidence of cancer. In a study, we studied 6 group of smokers: nonsmokers (NS), passive smokers (PS), non-inhaling smokers (NI), light smokers (LS), moderate smokers (MS), and heavy smokers (HS).
The study measured the forced mid-expiatory flow (FEF).
We wanted to the know the FEF differences among the 6 groups.
</i>


<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
)
),
hr(),
source("ui_np1.R", local=TRUE)$value,
hr(),
source("ui_np1m.R", local=TRUE)$value,
hr()
),

##########----------##########----------##########

tabstop(),
tablink()
#navbarMenu("",icon=icon("link"))


))
#)
