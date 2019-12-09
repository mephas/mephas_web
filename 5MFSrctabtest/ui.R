##----------#----------#----------#----------
##
## 5MFSrctabtest UI
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------

shinyUI(
tagList(
#shinythemes::themeSelector(),
source("../0tabs/font.R",local=TRUE, encoding="UTF-8")$value,

##########----------##########----------##########

navbarPage(
 
  title = "Test for Contingency Table",

##---------- Panel 1 ----------
tabPanel("2 by 2",

titlePanel("Chi-square Test for Two Independent Samples (in Case-Control Study)"),

HTML("
    <h4><b> 1. Goals </b></h4>
    <ul>
      <li> To determine if  there is association between the case-control status (rows) and factor status (columns)
      <li> To determine if the proportions are the same in the 2 independent samples 
      <li> To determine if the proportions are homogeneity
    </ul>

    <h4><b> 2. About your Data, 2 by 2 contingency table </b></h4>

      <ul>
      <li> You have 2 categories for case-control status (shown as row names)
      <li> You have 2 categories for factor status (shown as column names)
      <li> Samples from 2 categories of factors are independent data
      </ul>

    <h4> If all applicable, please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
  
      "),
hr(),

source("chi_ui.R", local=TRUE)$value,

hr()
    ),

##---------- Panel 2 ----------
tabPanel("Small 2 by 2",

titlePanel("Fisher Exact Test for Two Samples with Small Expected Values"),

HTML("
    <h4><b> 1. Goals </b></h4>
    <ul>
      <li> To determine if  there is association between the case-control status (rows) and factor status (columns)
      <li> To determine if the proportions are the same in the 2 dependent samples 
      <li> To determine if the proportions are homogeneity
    </ul>

    <h4><b> 2. About your Data, 2 by 2 contingency table </b></h4>

      <ul>
      <li> You have 2 categories for case-control status (shown as row names)
      <li> You have 2 categories for factor status (shown as column names)
      <li> Samples from 2 categories of factors are matched / paried data
      <li> Expected value from your data are too small
      </ul>

    <h4> If all applicable, please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
  
      "),
hr(),

source("fisher_ui.R", local=TRUE)$value,
hr()
    ),

##---------- Panel 3 ----------
tabPanel("Paired 2 by 2",

titlePanel("McNemar Test for Two Matched Samples"),

HTML("
    <h4><b> 1. Goals </b></h4>
    <ul>
      <li> To determine if the two factors on the matched samples were significantly different.
    </ul>

    <h4><b> 2. About your Data, 2 by 2 contingency table with paired samples </b></h4>

      <ul>
      <li> You have 2 categories for case-control outcome (shown in row and column names)
      <li> You have 2 categories for factor status (shown in row and column names)
      <li> Samples from your data are matched / paired data
      <li> You know the <b>concordant pair</b>, a matched pair in which the outcome is the same for each member of the pair
      <li> You know the <b>dis-concordant pair</b>, a matched pair in which the outcome differ for each member of the pair
      </ul>

  <h4><b> 3. Paired samples in 2 by 2 contingency table</b></h4>

    <ul>
      <li> Two pairs of patients were paired with similar age and clinical conditions. One group underwent treatment A and the other group underwent treatment B, and we recorded how many people became better and how many people became worse. 
      <li> For <b>concordant pair</b>, a matched pair in which two members all became better or worse 
      <li> For <b>dis-concordant pair</b>, a matched pair in which only one member became better or worse
    </ul>


    <h4> If all applicable, please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
  
      "),
hr(),

source("mcnemar_ui.R", local=TRUE)$value,

hr()
    ),

##---------- Panel 4 ----------
tabPanel("2 by C",

titlePanel("Chi-square Test for Multiple Independent Samples (C-sample) (in Case-Control Study)"),

HTML("
    <h4><b> 1. Goals </b></h4>
    <ul>
      <li> To determine if there is association between the case-control status (rows) and factor status (columns)
      <li> To determine if the population rate/proportion behind your multiple Groups data are significantly different </ul>

    <h4><b> 2. About your Data, 2 by C contingency table </b></h4>

      <ul>
      <li> Your Groups data come from binomial distribution (the proportion of success)
      <li> You know the whole sample and the number of specified events (the proportion of sub-group) from each Groups
      <li> The multiple Groups are independent observations
      </ul>

    <h4> If all applicable, please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
  
      "),
hr(),

source("2cchi_ui.R", local=TRUE)$value,

hr()
    ),

##---------- Panel 5 ----------


tabPanel("R by C",

titlePanel("Chi-square Test for Independent Multiple Samples (C-sample) in More than Two Status (R-status)"),

HTML("
    <h4><b> 1. Goals </b></h4>
    <ul>
      <li> To determine if there is association between the case-control status (rows) and factor status (columns)
      <li> To determine if the population rate/proportion behind your multiple Groups data are significantly different </ul>

    <h4><b> 2. About your Data, R by C contingency table </b></h4>

      <ul>
      <li> Your Groups data come from binomial distribution (the proportion of success)
      <li> You know the whole sample and the number of specified events (the proportion of sub-group) from each Groups
      <li> The multiple Groups are independent observations
      </ul>

    <h4> If all applicable, please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
  
      "),

hr(),
source("rcchi_ui.R", local=TRUE)$value,
hr()
),


##---------- Panel 5 ----------

tabPanel("K by K",

titlePanel("Kappa Statistic for Reproducibility of Repeated Measurements"),

HTML("
    <h4><b> 1. Goals </b></h4>
    <ul>
      <li> To quantify the reproducibility of the same variables measured more than once
      <li> To quantify the association between 2 measurements with same outcomes
    </ul>

    <h4><b> 2. About your Data, K by K contingency table </b></h4>

      <ul>
      <li> You know the <b>concordant response</b>, repeated-measured responses in which the outcome are the same for every measurements
      <li> You know the <b>dis-concordant response</b>, repeated-measured responses in which the outcome differ for every measurements
      </ul>

    <h4> If all applicable, please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
  
      "),

hr(),
source("kappa_ui.R", local=TRUE)$value,

hr()

)

##########----------##########----------##########

,
##---------- other panels ----------

source("../0tabs/home.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/stop.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/help5.R",local=TRUE, encoding="UTF-8")$value


))
)

