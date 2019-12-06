##----------#----------#----------#----------
##
## 3MFSnptest UI
##
## Language: EN
## 
## DT: 2019-01-09
##
##----------#----------#----------#----------
source("p1_ui.R", local=TRUE,encoding = "UTF-8")
source("p2_ui.R", local=TRUE,encoding = "UTF-8")
source("p3_ui.R", local=TRUE,encoding = "UTF-8")

shinyUI(

tagList( 
source("../0tabs/font.R",local=TRUE, encoding="UTF-8")$value,

##########----------##########----------##########

navbarPage(

title = "Non-Parametric Test for Median",  

##---------- Panel 1 ----------
tabPanel("One Sample",

headerPanel("Sign Test or Wilcoxon Signed-Rank Test"),

HTML(
    "
    <h4><b> 1. Goal </b></h4>
    <ul>
      <li> To determine if the median of the population from which your data is drawn statistically significantly different from the specified median
      <li> To determine the distribution of you data is symmetric about the specified median
    </ul>

    <h4><b> 2. About your data </b></h4>

    <ul>
      <li> Your data contain only 1 group of values (or a vector)
      <li> The values are independent observations
      <li> No assumption on the distributional shape of your data
      <li> Your data may be not normally distributed
    </ul> 

    <h4><b> 3. Two choices of tests </b></h4>

    <ul>
      <li> <b>Sign Test:</b> lack some the statistical power 
      <li> <b>Wilcoxon Signed-Rank Test:</b> alternative to one-sample t-test, when the data cannot be assumed to be normally distributed
    </ul> 

    <h4> If all applicable, please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
    "
    ),

hr(),
##---------- 1.1 ----------
onesample,

hr(),

##---------- 1.2 ----------
h4(tags$b("Step 3. Choose Methods and Hypotheses")),

h4(tags$b("Choice 1. Sign Test")),

signtest,

hr(),

##---------- 1.3 ----------
h4(tags$b("Choice 2. Wilcoxon Signed-Rank Test")),

wstest

),

##---------- Panel 2 ----------

tabPanel("Two Samples",

headerPanel("Wilcoxon Rank-Sum Test (Mann-Whitney U Test), Mood's Median Test"),

HTML("

<p> To determine whether a randomly selected sample will be less than or greater than a second randomly selected sample. </p>

<b> Notations </b>
  <ul>
  <li> X is the first randomly selected sample, while Y is the second</li>
  <li> m&#8321 is the population median of X, or the 50 percentile of the underlying distribution of X </li>  
  <li> m&#8322 is the population median of Y, or the 50 percentile of the underlying distribution of Y </li> 
  </ul>

<b> Assumptions </b>  
  <ul>
  <li> All the observations from both groups are independent of each other, no paired or repeated data </li>
  <li> X and Y could be continuous (i.e., interval or ratio) and ordinal (i.e., at least, of any two observations, which is the greater) </li>  
  <li> X and Y are similar in distribution's shape </li> 
  </ul>

  "),
hr(),

##---------- 2.1 ----------
twosample,

hr(),

##---------- 2.2 ----------
h4("Wilcoxon Rank-Sum Test, Mann-Whitney U Test, Mann-Whitney-Wilcoxon Test, Wilcoxon-Mann-Whitney Test"),

HTML("

<p> Not require the assumption of normal distributions; nearly as efficient as the t-test on normal distributions. </p>

<b> Supplementary Assumptions  </b>

<ul>
<li> No outliers (to determine if the distributions of the two groups are similar in shape and spread)
<li> If outliers exist, the test is used for testing distributions (to determine if the distributions of the two groups are different in shape and spread)
</ul>

<p> Outliers will affect the spread of data  </p>
  "),

wrtest,
hr(),

##---------- 2.3 ----------
h4("Mood's Median Test"),

p("A special case of Pearson's chi-squared test. It has low power (efficiency) for moderate to large sample sizes. "),


mmtest

),

##---------- Panel 3 ----------

tabPanel("Paired Samples",    

headerPanel("Sign Test, Wilcoxon Signed-Rank Test"),

HTML("

<b> Assumptions </b>

<ul>
  <li> The observations of (X, Y) are paired and come from the same population 
  <li> X's and Y's could be continuous (i.e., interval or ratio) and ordinal 
  <li> D's are independent and come from the same population 
</ul>

<b> Notations </b>

<ul>
  <li> The paired observations are designated X and Y ,
  <li> D = X-Y, the differences between paired (X, Y) 
  <li> m is the population median of D, or the 50 percentile of the underlying distribution of the D. 
</ul>

<p> Given pairs of observations (such as weight pre- and post-treatment) for each subject, both test determine if one of the pair (such as pre-treatment) tends to be greater than (or less than) the other pair (such as post-treatment).</p>

"),

psample,

hr(),
##---------- 3.1 ----------

h4("Sign Test"),
p("The sign test makes very few assumptions about the nature of the distributions under test, but may lack the statistical power of the alternative tests."),

signtest.p,

hr(),
##---------- 3.2 ----------

h4("Wilcoxon Signed-Rank Test"),

HTML("

  <p> An alternative to the paired t-test for matched pairs, when the population cannot be assumed to be normally distributed. It can also be used to determine whether two dependent samples were selected from populations having the same distribution. </p>

  <b> Supplementary Assumptions </b>
  
  <ul>
    <li> The distribution of D's is symmetric
    <li> No ties in D's
  </ul>

  "),
  
helpText("Ties means the same values")

wstest.p

),
##########----------##########----------##########
##---------- other panels ----------

source("../0tabs/home.R",local=TRUE,encoding = "UTF-8")$value,
source("../0tabs/stop.R",local=TRUE,encoding = "UTF-8")$value,
source("../0tabs/help3.R",local=TRUE, encoding="UTF-8")$value

  
))
)

