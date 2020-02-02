#if (!require("shinyWidgets")) {install.packages("shinyWidgets")}; library("shinyWidgets")
#shinyUI(
tagList(

source("../0tabs/font.R",local=TRUE, encoding="UTF-8")$value,
tags$head(includeScript("../0tabs/navtitle.js")),
tags$style(type="text/css", "body {padding-top: 70px;}"),
source("../0tabs/onoff.R", local=TRUE)$value,

navbarPage(
theme = shinythemes::shinytheme("cerulean"),
title = a("Test for Contingency Table", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
collapsible = TRUE,
#id="navbar", 
position="fixed-top",
##########----------##########----------##########
tabPanel("2x2",

titlePanel("Chi-square Test for 2 Categories of Factor in Case-Control Status"),

conditionalPanel(
condition = "input.explain_on_off",
HTML("

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To determine if there is association between the case-control status (rows) and factor categories (columns)
<li> To determine if the proportions are the same in the 2 independent samples
<li> To determine if the proportions are homogeneity
<li> To get the percentage table and plot and expected value of each cell
</ul>

<h4><b> 2. About your count data, 4-cell 2 by 2 contingency table </b></h4>

<ul>
<li> You have 2 categories for case-control status (shown as row names)
<li> You have 2 categories for factor status (shown as column names)
<li> Every cells are independent with moderately large counts
</ul>

<i><h4>Case Example</h4>
Suppose we wanted to know the relation between OC user and MI.
In one study we investigated data of 5000 OC-users and 10000 non OC-user, and categorized them into myocardial infarction (MI) and non-MI patients groups.
Among 5000 OC-users, 13 developed MI; among 10000 non-OC-users, 7 developed MI.
We wanted to determine if OC use was significantly associated with higher MI incidence.
</h4></i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
)
),
hr(),

source("ui_1_chi.R", local=TRUE)$value,

hr()
),

##########----------##########----------##########
tabPanel("2x2(Exact)",

titlePanel("Fisher Exact Test for 2 Categories of Factor with Small Expected Counts in Case-Control Status "),

conditionalPanel(
condition = "input.explain_on_off",
HTML("
<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To determine if there is association between the case-control status (rows) and factor status (columns)
<li> To determine if the proportions are the same in the 2 dependent samples
<li> To determine if the proportions are homogeneity
<li> To get the percentage table and plot and expected value of each cell

</ul>

<h4><b> 2. About your count data, 2 by 2 contingency table </b></h4>

<ul>
<li> You have 2 categories for case-control status (shown as row names)
<li> You have 2 categories for factor status (shown as column names)
<li> Every cells are independent
<li> Expected value from your data are small
</ul>

<i><h4>Case Example</h4>
Suppose we wanted to know the relation between CVD and high salt diet.
In one study we investigated data of 35 CVD patients and 25 non-CVD patients, and categorized them into high salt diet and low salt diet.
Among 35 CVD patients, 5 had high-salt diet; among 25 non CVD patients, 2 had high-salt diet.
We wanted to determine if CVD was significantly associated with high salt diet.
</h4></i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
)
),
hr(),

source("ui_2_fisher.R", local=TRUE)$value,
hr()
),

##########----------##########----------##########
tabPanel("2x2(Paired)",

titlePanel("McNemar Test for 2 Categories of  of Factor with Matched Counts in Case-Control Status"),

conditionalPanel(
condition = "input.explain_on_off",
HTML("
<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To determine if the two factors on the matched samples were significantly different.
<li> To get the percentage table and plot and expected value of each cell
<li> To get the percentage table and plot and expected value of each cell


</ul>

<h4><b> 2. About your count data, 2 by 2 contingency table with paired counts </b></h4>

<ul>
<li> You have 2 categories for case-control outcome (shown in row and column names)
<li> You have 2 categories for factor status (shown in row and column names)
<li> Samples from your data are matched / paired data
<li> You know the <b>concordant pair</b>, a matched pair in which the outcome is the same for each member of the pair
<li> You know the <b>dis-concordant pair</b>, a matched pair in which the outcome differ for each member of the pair
</ul>

<h4><b> 3. Paired counts in 2 by 2 contingency table</b></h4>

<ul>
<li> Two pairs of patients were paired with similar age and clinical conditions. One group underwent treatment A and the other group underwent treatment B, and we recorded how many people became better and how many people became worse.
<li> For <b>concordant pair</b>, a matched pair in which two members all became better or worse
<li> For <b>dis-concordant pair</b>, a matched pair in which only one member became better or worse
</ul>


<i><h4>Case Example</h4>
Suppose we wanted to compare the effects of two treatment. We investigated two groups of patients, one group accepted treatment A and the other did treatment B.
Tow groups of patients were made into pair, and we made 621 pairs. In each pair one wad under treatment A and the other was under treatment B.
Among 621 patients, 510 pairs were better in both treatment A and B; 90 pairs did not change either in treatment A or treatment B.
In 16 pairs, only group after treatment A were better; in 5 pairs, only group after treatment B were better.
</h4></i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
)
),
hr(),

source("ui_3_mcnemar.R", local=TRUE)$value,

hr()
),

##########----------##########----------##########
tabPanel("2xC",

titlePanel("Chi-square Test for >2 Categories of Factor in Case-Control Status"),
conditionalPanel(
condition = "input.explain_on_off",
HTML("
<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To determine if there is association between the case-control status (rows) and factor status (columns)
<li> To determine if the population rate/proportion behind your multiple Groups data are significantly different
<li> To get the percentage table and plot and expected value of each cell

</ul>

<h4><b> 2. About your count data, 2 by C contingency table </b></h4>

<ul>
<li> You have 2 categories for case-control outcome (shown in row and column names)
<li> You have >2 categories for factor status (shown in row and column names)
<li> Your Groups data come from binomial distribution (the proportion of success)
<li> You know the whole sample and the number of specified events (the proportion of sub-group) from each Groups
<li> The multiple Groups are independent observations
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

source("ui_4_2cchi.R", local=TRUE)$value,

hr()
),

##########----------##########----------##########

tabPanel("RxC",

titlePanel("Chi-square Test for >2 Factor Categories of Factor in >2 Status"),

conditionalPanel(
condition = "input.explain_on_off",
HTML("
<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To determine if there is association between the case-control status (rows) and factor status (columns)
<li> To determine if the population rate/proportion behind your multiple Groups data are significantly different
<li> To get the percentage table and plot and expected value of each cell

</ul>

<h4><b> 2. About your count data, R by C contingency table </b></h4>

<ul>
<li> Your Groups data come from binomial distribution (the proportion of success)
<li> You know the whole sample and the number of specified events (the proportion of sub-group) from each Groups
<li> The multiple Groups are independent observations
</ul>

<i><h4>Case Example</h4>
Suppose we wanted to know the relation of 3 types of treatments (penicillin, Spectinomycin-low, and Spectinomycin-high) and patients response.
In one study, we enrolled 400 patients, 200 used Penicillin, 100 used Spectinomycin in low dose, and 100 patients used Spectinomycin in high dose.
Among 200 Penicillin users, 40 got Smear+, 30 got Smear-Culture+ and 130 were Smear-Culture-.
Among 100 Spectinomycin-low users, 10 got Smear+, 20 got Smear-Culture+ and 70 were Smear-Culture-.
Among 100 Spectinomycin-high users, 15 got Smear+, 40 got Smear-Culture+ and 45 were Smear-Culture-.
We wanted to know if the treatments had significant association with the response.
</h4></i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
)
),

hr(),
source("ui_5_rcchi.R", local=TRUE)$value,
hr()
),


##########----------##########----------##########

tabPanel("Kappa(2xK)",

titlePanel("Kappa Statistic for Reproducibility / Agreement of Two Raters"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To quantify the agreement from two raters or two rankings
<li> To get the percentage table and expected value of each cell
</ul>

<h4><b> 2. About your count data, 2 by K contingency table </b></h4>

<ul>
<li> the outcomes (e.g., Y/N answers, rankings, categories) from two raters or two measurements
</ul>

<i><h4>Case Example</h4>
Suppose we wanted to check the agreement of answers from two surveys.
In one survey, the ranking scores were given from 1 to 9, while in the other, the ranking scores were not.
We wanted to check if the two answers were reproducible or whether the two surveys had agreements.
</h4></i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
)
),

hr(),
source("ui_6_2kappa.R", local=TRUE)$value,

hr()

),

##########----------##########----------##########

tabPanel("Kappa(KxK)",

titlePanel("Kappa Statistic for Reproducibility of Repeated / Related Measurements"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<p> This method just uses a different type of data. It uses counts of concordant and dis-concordant shown in a K by K table.</p>

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To quantify the reproducibility of the same variables measured more than once
<li> To quantify the association between 2 measurements with same outcomes
<li> To get the percentage table and expected value of each cell

</ul>

<h4><b> 2. About your count data, K by K contingency table </b></h4>

<ul>
<li> You know the <b>concordant response</b>, repeated-measured responses in which the outcome are the same for every measurements
<li> You know the <b>dis-concordant response</b>, repeated-measured responses in which the outcome differ for every measurements
</ul>

<i><h4>Case Example</h4>
Suppose in one study, we made two surveys reflecting the same problems for a group of patients.
We wanted to know the percentage of concordant response in two surveys.
We knew that the final results were 136 replied YES to both surveys and 240 patients replied NO in both surveys.
69 people replied NO in survey1 and YES in survey2, and 92 people replied YES in survey1 and NO in survey2.
We wanted to know whether the surveys were good in concordant response.
</h4></i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
)
),

hr(),
source("ui_7_kappa.R", local=TRUE)$value,

hr()

),
##########----------##########----------##########

tabPanel("(2x2)xK",

titlePanel("Mantel-Haenszel Test for 2 Categories of Factor in Case-Control Status under K Confounding Strata"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To determine by controlling the stratum / confounding if there is association between the case-control status (rows) and factor status (columns)
<li> Two nominal variables are conditionally independent in K strata
<li> To get the percentage table and plot and expected value of each cell

</ul>

<h4><b> 2. About your count data, 2 x 2 contingency table under K strata </b></h4>

<ul>
<li> You have counts for several 2 x 2 contingency table
<li> Each  2 x 2 contingency table was under one factor stratum
</ul>

<i><h4>Case Example</h4>
Suppose we wanted to see the effect of passive smoking on cancer risk. One potential confounding was smoking by the participants themselves.
Because personal smoking is also related to both cancer risk and spouse smoking.
Thus, we controlled for personal active smoking before looking at the relationship between passive smoking and cancer risk.
We got two 2 x 2 table, one was from the active smoking group including 466 people, and the other was from non-active smoking group with 532 people. As shown in the inputed data.
We wanted to know if passive smoking significantly related to cancer risk after controlling for active smoking; or, whether the odds ratios were significantly different.
</h4></i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
)
),

hr(),
source("ui_8_mh.R", local=TRUE)$value,

hr()

),

##########----------##########----------##########

tabPanel("(RxC)xK",

titlePanel("Cochran-Mantel-Haenszel for >2 Categories of Factor in >2 Status under K Strata"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To determine by controlling the stratum / confounding if there is association between the case-control status (rows) and factor status (columns)
<li> Two nominal variables are conditionally independent in K strata
<li> To get the percentage table and plot and expected value of each cell

</ul>

<h4><b> 2. About your count data, R x C contingency table under K strata</b></h4>

<ul>
<li> You have counts for several R by C table
<li> Each  R x C contingency table was under one factor stratum

</ul>

<i><h4>Case Example</h4>
Suppose we wanted to know the relation between snoring and ages. A survey were did on 3513 individuals 30-60 years old, with 1843 women and 1670 men.
Considering gender might be the confounding variable in this study, we created 3 x 2 table in women strata and men strata.
We wanted to know if ages significantly related to snoring after controlling gender.
</h4></i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
)
),

hr(),
source("ui_9_cmh.R", local=TRUE)$value,

hr()

),

##########----------##########----------##########

tabPanel(tags$button(
				    id = 'close',
				    type = "button",
				    class = "btn action-button",
				    icon("power-off"),
				    style = "background:rgba(255, 255, 255, 0); display: inline-block; padding: 0px 0px;",
				    onclick = "setTimeout(function(){window.close();},500);")),
navbarMenu("",icon=icon("link"))


))

#)
