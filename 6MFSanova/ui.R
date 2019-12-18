##----------#----------#----------#----------
##
## 6MFSanova UI
##
## Language: EN
## 
## DT: 2019-04-07
##
##----------#----------#----------#----------
shinyUI(

tagList(
source("../0tabs/font.R",local=TRUE, encoding="UTF-8")$value,

##########----------##########----------##########
navbarPage(

title = "Analysis of Variance",

##---------- Panel 1 ----------
tabPanel("One-way",

headerPanel("One-way ANOVA (Overall F Test) to Compare Means from Multiple Factor Groups"),

HTML(
"
<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To determine if the means differ significantly among the factor groups 
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data contain several separate factor groups shown in two vectors
<li> One vector is the observed values; one vector is to mark your values in different factor groups
<li> The separate factor groups are independent and identically approximately normally distributed
<li> Each mean of the factor group follows a normal distribution with the same variance and can be compared
</ul> 

<i><h4>Case Example</h4>
Suppose we want to find whether passive smoking had a measurable effect on the incidence of cancer. In a study, we studied 6 group of smokers: nonsmokers (NS), passive smokers (PS), non-inhaling smokers (NI), light smokers (LS), moderate smokers (MS), and heavy smokers (HS).
NS,PS,LS,MS,and HS group had 200 people in each. NI group had 50 people. The study measured the forced mid-expiatory flow (FEF). 
We wanted to the know the FEF differences among the 6 groups.
</h4></i>


<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
),

hr(),

source("p1_ui.R", local=TRUE)$value,

hr()
),

##---------- Panel 2 ----------
tabPanel("Pairwise1",

headerPanel("Multiple Comparison Post-Hoc Correction for Specific Groups after One-way ANOVA"),

HTML(
"
<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To determine if the means differ significantly among pairs, given that one-way ANOVA finds significant differences among factor groups.
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data contain several separate factor groups (or 2 vectors)
<li> The separate factor groups/sets are independent and identically approximately normally distributed
<li> Each mean of the factor group follows a normal distribution with the same variance and can be compared
</ul> 

<i><h4>Case Example</h4>
Suppose we want to find whether passive smoking had a measurable effect on the incidence of cancer. In a study, we studied 6 group of smokers: nonsmokers (NS), passive smokers (PS), non-inhaling smokers (NI), light smokers (LS), moderate smokers (MS), and heavy smokers (HS).
NS,PS,LS,MS,and HS group had 200 people in each. NI group had 50 people. The study measured the forced mid-expiatory flow (FEF). 
We wanted to the know in which pairs of the 6 groups, FEF were significantly different 
</h4></i>


<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
),
hr(),
source("p3_ui.R", local=TRUE)$value,
hr()
),

##---------- Panel 3 ----------

tabPanel("Two-way",

headerPanel("Two-way ANOVA to Compare Means from Multiple Groups"),

HTML(
"
<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To determine if the means differ significantly among the Factor1 after controlling for Factor2 
<li> To determine if the means differ significantly among the Factor2 after controlling for Factor1 
<li> To determine if the Factor1 and Factor2 have interaction to effect the outcomes
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data contain several separate factor groups (or 2 vectors)
<li> The separate factor groups/sets are independent and identically approximately normally distributed
<li> Each mean of the factor group follows a normal distribution with the same variance and can be compared
</ul> 

<i><h4>Case Example</h4>
Suppose we were interested in the effects of sex and 3 dietary groups on SPB. 
The 3 dietary groups included 100 strict vegetarians (SV), 60 lactovegentarians (LV), and 100 normal (NOR) people, and we tested the SBP.
The effects of sex and and dietary group might be related (interact) with each other.
We wanted to know the effect of dietary group and sex on the SPB and whether the two factors were related with each other.
 </h4></i>


<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
),

hr(),

source("p2_ui.R", local=TRUE)$value,
hr()
),
#
##---------- Panel 4 ----------
tabPanel("Pairwise2",

headerPanel("Multiple Comparison Post-Hoc Correction for Specific Groups after Two-way ANOVA"),

HTML(
"

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To determine if the means differ significantly among which pairs, given that two-way ANOVA finds significant differences among groups.
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data contain several separate factor groups (or 2 vectors)
<li> The separate factor groups are independent and identically approximately normally distributed
<li> Each mean of the factor groups follows a normal distribution with the same variance and can be compared
</ul> 

<i><h4>Case Example</h4>
Suppose we were interested in the effects of sex and 3 dietary groups on SPB. 
The 3 dietary groups included 100 strict vegetarians (SV), 60 lactovegentarians (LV), and 100 normal (NOR) people, and we tested the SBP.
The effects of sex and and dietary group might be related (interact) with each other.
We wanted to know the pairwise effect of dietary group and sex on the SPB. For example, which two of dietary group had significant difference, and whether male and female had significant difference.
</h4></i>


<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
),
hr(),
source("p4_ui.R", local=TRUE)$value,
hr()
),

##---------- Panel 5 ----------
tabPanel("One-way (Non-parametric)",

headerPanel("Kruskal-Wallis Non-parametric Test to Compare Multiple Samples"),

HTML(
"
<b>This method compares ranks of the observed data, rather than mean and SD. An alternative to one-way ANOVA without assumption on the data distribution</b>

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To determine if the means differ significantly among the factor groups 
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data contain several separate factor groups shown in two vectors
<li> One vector is the observed values; one vector is to mark your values in different factor groups
<li> The separate factor groups are independent and identically without distribution assumption
</ul> 

<i><h4>Case Example</h4>
Suppose we want to find whether passive smoking had a measurable effect on the incidence of cancer. In a study, we studied 6 group of smokers: nonsmokers (NS), passive smokers (PS), non-inhaling smokers (NI), light smokers (LS), moderate smokers (MS), and heavy smokers (HS).
NS,PS,LS,MS,and HS group had 200 people in each. NI group had 50 people. The study measured the forced mid-expiatory flow (FEF). 
We wanted to the know the FEF differences among the 6 groups.
</h4></i>


<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
),
hr(),
source("p5_ui.R", local=TRUE)$value,
hr()
),

##---------- Panel 6 ----------
tabPanel("Pairwise3",

headerPanel("Multiple Comparison Post-Hoc Correction for Specific Groups after Kruskal-Wallis Non-parametric Test"),

HTML(
"

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To determine if the means differ significantly among pairs, given that one-way ANOVA finds significant differences among groups.
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data contain several separate factor groups (or 2 vectors)
<li> The separate factor groups are independent and identically approximately normally distributed
<li> Each mean of the factor groups follows a normal distribution with the same variance and can be compared
</ul> 

<i><h4>Case Example</h4>
Suppose we were interested in the effects of sex and 3 dietary groups on SPB. 
The 3 dietary groups included 100 strict vegetarians (SV), 60 lactovegentarians (LV), and 100 normal (NOR) people, and we tested the SBP.
The effects of sex and and dietary group might be related (interact) with each other.
We wanted to know the pairwise effect of dietary group and sex on the SPB. For example, which two of dietary group had significant difference, and whether male and female had significant difference.
</h4></i>


<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
),
hr(),
source("p6_ui.R", local=TRUE)$value,
hr()
),
##########----------##########----------##########

##---------- other panels ----------

source("../0tabs/stop.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/help6.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/home.R",local=TRUE, encoding="UTF-8")$value


)))

