##'
##' MFSrctabtest includes test for counts data:
##' (1) chi-square test for 2x2, 2xC, RxC table,
##' (2) kappa test for 2xk, kxk table,
##' and (3) 2xC and RxC table under K confounding categories
##'
##' @title MEPHAS: Test for Contingency Table (Hypothesis Testing)
##'
##' @return The web-based GUI and interactive interfaces
##'
##' @import shiny
##' @import ggplot2
##'
##' @importFrom psych cohen.kappa
##' @importFrom stats mantelhaen.test
##'
##' @examples
##' # mephas::MFSrctabtest()
##' ## or,
##' # library(mephas)
##' # MFSrctabtest()
##' # not run

##' @export
MFSrctabtest <- function(){

requireNamespace("shiny")
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
ui <- tagList(

##########----------##########----------##########

navbarPage(

title = "Test for Contingency Table",

##########----------##########----------##########
tabPanel("2x2",

titlePanel("Chi-square Test for 2 Categories of Factor in Case-Control Status"),

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
"),
hr(),

#source("1_chi_ui.R", local=TRUE)$value
#****************************************************************************************************************************************************1.chi
sidebarLayout(
sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")),

  p(tags$b("1. Give 2 names to each categories of factor shown as column names")),
  tags$textarea(id="cn1", rows=2, "Developed-MI\nNo MI"),

    p(tags$b("2. Give 2 names to case-control shown as row names")), 
  tags$textarea(id="rn1", rows=2, "OC user\nNever OC user"), p(br()),

  p(tags$b("3. Input 4 values in row-order")),
  p("Data point can be separated by , ; /Enter /Tab"),
  tags$textarea(id="x1", rows=4, 
    "13\n4987\n7\n9993"),

  p("Note: No Missing Value"),

  p(tags$i("The case-control was OC user and non-OC user and factor categories were developed MI or not.")),
  p(tags$i("Among 5000 OC-users, 13 developed MI; among 10000 non-OC-users, 7 developed MI.")),

  hr(),

   h4(tags$b("Hypothesis")),

   p(tags$b("Null hypothesis")), 
   p("Case-Control (Row) has no significantly associate with Grouped Factors (Column)"),
    
   p(tags$b("Alternative hypothesis")), 
   p("Case-Control (Row) is significant association with Grouped Factors (Column)"),

  p(tags$i("In this example, we wanted to determine if OC use was significantly associated with higher MI incidence.")),

hr(),

  h4(tags$b("Step 2. Decide P Value method")),
    radioButtons("yt1", label = "Yates-correction on P Value", 
        choiceNames = list(
          HTML("Do: no Expected Value <5, but Expected Value not so large  "),
          HTML("Not do: I have quite large sample")
          ),
        choiceValues = list(TRUE, FALSE)
        )
    ),

    mainPanel(

    h4(tags$b("Output 1. Contingency Table")), p(br()), 

    tabsetPanel(

    tabPanel("Table Preview", p(br()),

        p(tags$b("2 x 2 Contingency Table with Total Number")),
        DT::DTOutput("dt1"),

        p(tags$b("Expected Value")),
        DT::DTOutput("dt1.0")
        ),

    tabPanel("Percentage Table", p(br()),

        p(tags$b("Cell/Total %")),
        DT::DTOutput("dt1.3"),

        p(tags$b("Cell/Row-Total %")),
        DT::DTOutput("dt1.1"),

        p(tags$b("Cell/Column-Total %")),
        DT::DTOutput("dt1.2")
        ),

    tabPanel("Percentage Plot", p(br()),
      p(tags$b("Percentages in the rows")),
      plotOutput("makeplot1", width = "80%"),
      p(tags$b("Percentages in the columns")),
      plotOutput("makeplot1.1", width = "80%"),
      )
    ),

    hr(),

    h4(tags$b("Output 2. Test Results")), p(br()), 

    DT::DTOutput("c.test1"),

     HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then Case-Control (Row) is significantly associated with Grouped Factors (Column) (Accept alternative hypothesis)
    <li> P Value >= 0.05, then Case-Control (Row) are not associated with Grouped Factors (Column). (Accept null hypothesis)
    </ul>"
  ),

     p(tags$i("In this default setting, we concluded that using OC and MI development had significant association. (P = 0.01) Because the minimum expected value was 6.67, Yates-correction on P Value was done." ))

        )
      ),

hr()
),

##########----------##########----------##########
tabPanel("2x2(Exact)",

titlePanel("Fisher Exact Test for 2 Categories of Factor with Small Expected Counts in Case-Control Status "),

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
"),
hr(),

#source("2_fisher_ui.R", local=TRUE)$value
#****************************************************************************************************************************************************2. fisher
sidebarLayout(
sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")),

  p(tags$b("1. Give 2 names to each categories of factor shown as column names")),
  tags$textarea(id="cn4", rows=2, "High salt\nLow salt"),

    p(tags$b("2. Give 2 names to case-control shown as row names")), 
  tags$textarea(id="rn4", rows=2, "CVD\nNon CVD"), p(br()),

  p(tags$b("3. Input 4 values in row-order")),
  p("Data point can be separated by , ; /Enter /Tab"),
  tags$textarea(id="x4", rows=4, 
    "5\n30\n2\n23"),

  p("Note: No Missing Value"),

  p(tags$i("The case-control was CVD patients or not and factor categories were high salt diet or not.")),
  p(tags$i("Of 35 people who died form CVD, 5 were on a high-salt diet before they dies; of 25 people who died from other causes, 2 were on a high-salt diet.")),

  hr(),

   h4(tags$b("Step 2. Choose Hypothesis")),

   p(tags$b("Null hypothesis")), 
   p("Case-Control (Row) do not significantly associate with Grouped Factors (Column)"),

    radioButtons("yt4", label = "Alternative hypothesis", 
        choiceNames = list(
          HTML("Case-Control (Row) has significant association with Grouped Factors (Column); odds ratio of Group 1 is significant different from Group 2"),
          HTML("Odds ratio of Group 1 is higher than Group 2"),
          HTML("Odds ratio of Group 2 is higher than Group 1")
          ),
        choiceValues = list("two.sided", "greater", "less")
        ),
      p(tags$i("In this example, we wanted to determine if there was association between cause of death and high-salt diet."))

    ),

    mainPanel(

    h4(tags$b("Output 1. Contingency Table")), p(br()), 

    tabsetPanel(

    tabPanel("Table Preview", p(br()),

        p(tags$b("2 x 2 Contingency Table with Total Number")),
        DT::DTOutput("dt4"),

        p(tags$b("Expected Value")),
        DT::DTOutput("dt4.0")
        ),

    tabPanel("Percentage Table", p(br()),

        p(tags$b("Cell/Total %")),
        DT::DTOutput("dt4.3"),

        p(tags$b("Cell/Row-Total %")),
        DT::DTOutput("dt4.1"),

        p(tags$b("Cell/Column-Total %")),
        DT::DTOutput("dt4.2")
        ),

    tabPanel("Percentage Plot", p(br()),
      p(tags$b("Percentages in the rows")),
      plotOutput("makeplot4", width = "80%"),
      p(tags$b("Percentages in the columns")),
      plotOutput("makeplot4.1", width = "80%")
      )
    ),

    hr(),

    h4(tags$b("Output 2. Test Results")), p(br()), 

    DT::DTOutput("c.test4"),

     HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then Case-Control (Row) is significantly associated with Grouped Factors (Column) (Accept alternative hypothesis)
    <li> P Value >= 0.05, then Case-Control (Row) are not associated with Grouped Factors (Column). (Accept null hypothesis)
    </ul>"
  ),

     p(tags$i("In this default setting, two expected values < 5, so we used Fisher exact test. From the test result, we concluded that no significant association was found between the cause of death and high salt diet" ))

        )
      ),
hr()
),

##########----------##########----------##########
tabPanel("2x2(Paired)",

titlePanel("McNemar Test for 2 Categories of  of Factor with Matched Counts in Case-Control Status"),

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
"),
hr(),

#source("3_mcnemar_ui.R", local=TRUE)$value
#****************************************************************************************************************************************************3. mcnemar

sidebarLayout(
sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")),

  p(tags$b("1. Give 2 names to each shared categories of outcome shown in column name and row name")),
  tags$textarea(id="cn2", rows=2, "Better\nNo-change"), 

  p(tags$b("2. Give 2 factor / treatment names shown in row name and column name")), 
  tags$textarea(id="rn2", rows=2, "Treatment-A\nTreatment-B"),p(br()),

  
  p(tags$b("3. Input 4 values in row-order")),
  p("Data point can be separated by , ; /Enter /Tab"),
  tags$textarea(id="x2", rows=4, 
    "510\n16\n5\n90"),
  p("Note: No Missing Value"),
  
  p(tags$i("Example here was 621 pairs of patients, one group underwent treatment A and the other underwent treatment B. Patients were paired with similar age and clinical conditions. ")),
  p(tags$i("Among 621 patients, 510 pairs were better in both treatment A and B; 90 pairs did not change either in treatment A or treatment B. (Concordant Pair) ")),
  p(tags$i("In 16 pairs, only group after treatment A were better; in 5 pairs, only group after treatment B were better. (Dis-concordant Pair) ")),

  hr(),

   h4(tags$b("Hypothesis")),

   p(tags$b("Null hypothesis")), 
   p("The factors have no significant differences"),
    
   p(tags$b("Alternative hypothesis")), 
   p("The factors have significant differences on the paired samples "),

   p(tags$i("In this example, we wanted to determine if whether the treatments had significant differences for the matched pair.")),
      
  hr(),

  h4(tags$b("Step 2. Decide P Value method")),
    radioButtons("yt2", label = "Yates-correction on P Value", 
        choiceNames = list(
          HTML("Do: no Expected Value <5, but Expected Value not so large  "),
          HTML("Not do: I have quite large sample")
          ),
        choiceValues = list(TRUE, FALSE)
        )
   
    ),

    mainPanel(

    h4(tags$b("Output 1. Contingency Table")), p(br()), 

    tabsetPanel(

    tabPanel("Table Preview", p(br()),

        p(tags$b("2 x 2 Contingency Table with Total Number")),
        DT::DTOutput("dt2"),

        p(tags$b("Expected Value")),
        DT::DTOutput("dt2.0")
        ),
    
    tabPanel("Percentage Table", p(br()),

        p(tags$b("Cell/Total %")),
        DT::DTOutput("dt2.3"),

        p(tags$b("Cell/Row-Total %")),
        DT::DTOutput("dt2.1"),

        p(tags$b("Cell/Column-Total %")),
        DT::DTOutput("dt2.2")
        ),

    tabPanel("Percentage Plot", p(br()),
      plotOutput("makeplot2", width = "80%")
      )
    ),

    hr(),

    h4(tags$b("Output 2. Test Results")), p(br()), 

    DT::DTOutput("c.test2"),

     HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then the factors have significant differences on the paired samples. (Accept alternative hypothesis)
    <li> P Value >= 0.05, then the factors have no significant differences. (Accept null hypothesis)
    </ul>"
  ),

     p(tags$i("In this default setting, we concluded that two treatments had significantly different effect on the paired patients. (P = 0.03)"))

        )
      ),

hr()
),

##########----------##########----------##########
tabPanel("2xC",

titlePanel("Chi-square Test for >2 Categories of Factor in Case-Control Status"),

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
"),
hr(),

#source("4_2cchi_ui.R", local=TRUE)$value
#****************************************************************************************************************************************************4. 2 c chi
   sidebarLayout(
      sidebarPanel(

    h4(tags$b("Step 1. Data Preparation")),

  p(tags$b("2. Give names to each categories of factor shown as column names")),
        tags$textarea(id = "cn3",rows = 5,
        "~20\n20-24\n25-29\n30-34\n34~"
      ),
    p(tags$b("2. Give 2 names to case-control shown as row names")), 
        tags$textarea(id = "rn3",rows = 2,
        "Cancer\nNo-Cancer"
      ),

        p(br()), 

        p(tags$b("3. How many Cases in every Group")),
        p("Data point can be separated by , ; /Enter /Tab"),
        tags$textarea(id = "x3", rows = 5,
        "320\n1206\n1011\n463\n220"        
        ),

        p(tags$b("4. How many Controls in every Group")), 
        p("Data point can be separated by , ; /Enter /Tab"),
        tags$textarea(id = "x33", rows = 5,
        "1422\n4432\n2893\n1092\n406"
        ),

    p("Note: No Missing Value"),

    p(tags$i("In this example, we had 5 age groups of people as shown in different ages, and we record the number of people who had cancer and who did not have cancer.")),

        hr(),

    h4(tags$b("Hypothesis")),

   p(tags$b("Null hypothesis")), 
   p("Case-Control (Row) do not significantly associate with Grouped Factors (Column)"),
    
   p(tags$b("Alternative hypothesis")), 
   p("Case-Control (Row) has significant association with Grouped Factors (Column)"),     

    p(tags$i("In this setting,  we wanted to know if there was any relation between cancer and ages."))
   

    ),


    mainPanel(

    h4(tags$b("Output 1. Contingency Table")), p(br()), 

    tabsetPanel(

    tabPanel("Table Preview", p(br()),

        p(tags$b("2 x C Contingency Table with Total Number")),
        DT::DTOutput("dt3"),

        p(tags$b("Expected Value")),
        DT::DTOutput("dt3.0")
        ),
    tabPanel("Percentage Table", p(br()),

        p(tags$b("Cell/Total %")),
        DT::DTOutput("dt3.3"),

        p(tags$b("Cell/Row-Total %")),
        DT::DTOutput("dt3.1"),

        p(tags$b("Cell/Column-Total %")),
        DT::DTOutput("dt3.2")
        ),

    tabPanel("Percentage Plot", p(br()),
      plotOutput("makeplot3", width = "80%")
      )
    ),

    hr(),

    h4(tags$b("Output 2. Test Results")), p(br()), 

    DT::DTOutput("c.test3"),

     HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then Case-Control (Row) is significantly associated with Grouped Factors (Column) (Accept alternative hypothesis)
    <li> P Value >= 0.05, then Case-Control (Row) are not associated with Grouped Factors (Column). (Accept null hypothesis)
    </ul>"
  ),

     p(tags$i("In this default setting, we conclude that there was significant relation between cancer and ages. (P < 0.001)"))

        )
      ),

hr()
),

##########----------##########----------##########

tabPanel("RxC",

titlePanel("Chi-square Test for >2 Factor Categories of Factor in >2 Status"),

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
"),

hr(),
#source("5_rcchi_ui.R", local=TRUE)$value
#****************************************************************************************************************************************************5. r c chi

   sidebarLayout(
      sidebarPanel(

    h4(tags$b("Step 1. Data Preparation")),

  p(tags$b("1. Give names to each categories of factor1 shown as column names")),
        tags$textarea(id = "cn5",rows = 5,
        "Smear+\nSmear-Culture+\nSmear-Culture-"
      ),
    p(tags$b("2. Give names to each categories of factor2 shown as row names")), 
        tags$textarea(id = "rn5",rows = 5,
        "Penicillin\nSpectinomycin-low\nSpectinomycin-high"
      ),
        p(br()), 

    p(tags$b("3. Input R*C values in row-order")),
      p("Data point can be separated by , ; /Enter /Tab"),
      tags$textarea(id="x5", rows=10, 
      "40\n30\n130\n10\n20\n70\n15\n40\n45"),
      p("Note: No Missing Value"),

    p(tags$i("Row were different drug treatment and columns were different response")),
  p(tags$i("Among 200 Penicillin users, 40 got Smear+, 30 got Smear-Culture+ and others were Smear-Culture-.")),
  p(tags$i("Among 100 Spectinomycin-low users, 10 got Smear+, 20 got Smear-Culture+ and others were Smear-Culture-.")),
  p(tags$i("Among 100 Spectinomycin-high users, 15 got Smear+, 40 got Smear-Culture+ and others were Smear-Culture-.")),

        hr(),

    h4(tags$b("Hypothesis")),

   p(tags$b("Null hypothesis")), 
   p("Case-Control (Row) is significantly associate with Grouped Factors (Column)"),
    
   p(tags$b("Alternative hypothesis")), 
   p("Case-Control (Row) has no significant association with Grouped Factors (Column)"),     

    p(tags$i("In this setting,  we wanted to know if there was relationship between drug treatment and response."))
   

    ),


    mainPanel(

    h4(tags$b("Output 1. Contingency Table")), p(br()), 

    tabsetPanel(

    tabPanel("Table Preview", p(br()),
    

        p(tags$b("R x C Contingency Table with Total Number")),
        DT::DTOutput("dt5"),

        p(tags$b("Expected Value")),
        DT::DTOutput("dt5.0")
        ),
    tabPanel("Percentage Table", p(br()),

        p(tags$b("Cell/Total %")),
        DT::DTOutput("dt5.3"),

        p(tags$b("Cell/Row-Total %")),
        DT::DTOutput("dt5.1"),

        p(tags$b("Cell/Column-Total %")),
        DT::DTOutput("dt5.2")
        ),

    tabPanel("Percentage Plot", p(br()),

      plotOutput("makeplot5", width = "80%")
      )
    ),

    hr(),

    h4(tags$b("Output 2. Test Results")), p(br()), 

    DT::DTOutput("c.test5"),

     HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then Case-Control (Row) is significantly associated with Grouped Factors (Column) (Accept alternative hypothesis)
    <li> P Value >= 0.05, then Case-Control (Row) are not associated with Grouped Factors (Column). (Accept null hypothesis)
    </ul>"
  ),

     p(tags$i("In this default setting, we conclude that there was significant relationship between drug treatment and response. (P < 0.001)"))

        )
      ),
hr()
),


##########----------##########----------##########

tabPanel("Kappa(2xK)",

titlePanel("Kappa Statistic for Reproducibility / Agreement of Two Raters"),

HTML("
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
"),

hr(),
#source("6_2kappa_ui.R", local=TRUE)$value
#****************************************************************************************************************************************************6. 2k kappa

   sidebarLayout(
      sidebarPanel(

    h4(tags$b("Step 1. Data Preparation")),

    p(tags$b("1. Give 2 related raters / ranking names shown in the column names")), 
    tags$textarea(id="cn9", rows=2, "Survey1\nSurvey2"),p(br()),

  
  p(tags$b("2. Input K values in 1st rater")),
  p("Data point can be separated by , ; /Enter /Tab"),
  tags$textarea(id="x9", rows=10, 
    "1\n2\n3\n4\n5\n6\n7\n8\n9"),
  p(br()),

  p(tags$b("3. Input K values in 2nd rater")),
  p("Data point can be separated by , ; /Enter /Tab"),
  tags$textarea(id="x99", rows=10, 
    "1\n3\n1\n6\n1\n5\n5\n6\n7"),

    p("Note: No Missing Value, two groups have equal length"),
    p(tags$i("Example here showed the Survey1 and Survey2.
      In this setting, we wanted to know the agreement in two rankings."))
   

    ),


    mainPanel(

    h4(tags$b("Output 1. Contingency Table")), p(br()), 

    tabsetPanel(

    tabPanel("Table Preview", p(br()),
    p(tags$b("2 x K Contingency Table with Total Number")),
    DT::DTOutput("dt9")
    ),

    tabPanel("Agreement Table", p(br()),
    DT::DTOutput("dt9.0")
    ),
    tabPanel("Weight Table", p(br()),
    DT::DTOutput("dt9.1")
    )
    ),

    hr(),

    h4(tags$b("Output 2. Test Results")), p(br()), 

    DT::DTOutput("c.test9"),

     HTML(
    "<b> Explanations and Guidelines for Evaluating Kappa </b> 
    <ul>
      <li> <b>Cohen's Kappa Statistic > 0.75</b>: <b>excellent</b> reproducibility </li>
      <li> <b>0.4 <= Cohen's Kappa Statistic <= 0.75</b>: <b>good</b> reproducibility</li>
      <li> <b>0 <= Cohen's Kappa Statistic < 0.4</b>: <b>marginal</b> reproducibility </li>
      <li> Cohen's kappa takes into account disagreement between the two raters, but not the degree of disagreement.
      <li> The weighted kappa is calculated using a predefined table of weights which measure the degree of disagreement between the two raters, the higher the disagreement the higher the weight.
    </ul>

  "
  ),

     p(tags$i("In this default setting, we concluded that the response from Survey1 and Survey2 did not have such good reproducibility "))

        )
      ),

hr()

),

##########----------##########----------##########

tabPanel("Kappa(KxK)",

titlePanel("Kappa Statistic for Reproducibility of Repeated / Related Measurements"),

HTML("
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
"),

hr(),
#source("7_kappa_ui.R", local=TRUE)$value
#****************************************************************************************************************************************************7. kk kappa

   sidebarLayout(
      sidebarPanel(

    h4(tags$b("Step 1. Data Preparation")),

    p(tags$b("1. Give K rator / measurement names shown in the column names and row names")), 
    tags$textarea(id="cn6", rows=2, "Yes\nNo"), 

    p(tags$b("2. Give 2 related experiment / repeated measurement names shown in the column names and row names")), 
    tags$textarea(id="rn6", rows=2, "Survey1\nSurvey2"),p(br()),

  
  p(tags$b("3. Input K*K values in row-order")),
  p("Data point can be separated by , ; /Enter /Tab"),
  tags$textarea(id="x6", rows=4, 
    "136\n92\n69\n240"),
      p("Note: No Missing Value"),
    p(tags$i("Example here was the response from Survey 1 and Survey 2.")),
        hr(),

    h4(tags$b("Hypothesis")),

   p(tags$b("Null hypothesis")), 
   p("Case-Control (Row) do not significantly associate with Grouped Factors (Column)"),
    
   p(tags$b("Alternative hypothesis")), 
   p("Case-Control (Row) has significant association with Grouped Factors (Column)"),     

    p(tags$i("In this setting,  we wanted to know the reproducibility of the surveys."))
   

    ),


    mainPanel(

    h4(tags$b("Output 1. Contingency Table")), p(br()), 

    tabsetPanel(

    tabPanel("Table Preview", p(br()),

        p(tags$b("K x K Contingency Table with Total Number")),
        DT::DTOutput("dt6")
        ),
    tabPanel("Agreement Table", p(br()),
        DT::DTOutput("dt6.0")
        ),
    tabPanel("Weight Table", p(br()),
        DT::DTOutput("dt6.1")
        )
    ),

    hr(),

    h4(tags$b("Output 2. Test Results")), p(br()), 

    DT::DTOutput("c.test6"),

     HTML(
    "<b> Explanations and Guidelines for Evaluating Kappa </b> 
    <ul>
      <li> <b>Cohen's Kappa Statistic > 0.75</b>: <b>excellent</b> reproducibility </li>
      <li> <b>0.4 <= Cohen's Kappa Statistic <= 0.75</b>: <b>good</b> reproducibility</li>
      <li> <b>0 <= Cohen's Kappa Statistic < 0.4</b>: <b>marginal</b> reproducibility </li>
      <li> Cohen's kappa takes into account disagreement between the two raters, but not the degree of disagreement.
      <li> The weighted kappa is calculated using a predefined table of weights which measure the degree of disagreement between the two raters, the higher the disagreement the higher the weight.

    </ul>

  "
  ),

     p(tags$i("In this default setting, we concluded that the response from Survey1 and Survey2 didn't have so good reproducibility, just marginally reproducible. "))

        )
      ),

hr()

),
##########----------##########----------##########

tabPanel("(2x2)xK",

titlePanel("Mantel-Haenszel Test for 2 Categories of Factor in Case-Control Status under K Confounding Strata"),

HTML("
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
"),

hr(),
#source("8_mh_ui.R", local=TRUE)$value
#****************************************************************************************************************************************************8. mh

   sidebarLayout(
      sidebarPanel(

    h4(tags$b("Step 1. Data Preparation")),

  p(tags$b("1. Give 2 names to each categories of factor shown as column names")),
        tags$textarea(id = "cn8",rows = 2,
        "Passive Smoker\nNon-Passive-Smoker"
      ),
    p(tags$b("2. Give 2 names to case-control shown as row names")), 
        tags$textarea(id = "rn8",rows = 2,
        "Cancer (Case)\nNo Cancer (Control)"
      ),
  p(tags$b("3. Give names to each categories confounding shown as row names")),
        tags$textarea(id = "kn8",rows = 4,
        "No-Active Smoker\nActive Smoker"
      ),
        p(br()), 

    p(tags$b("3. Input 2*2*K values in row-order")),
      p("Data point can be separated by , ; /Enter /Tab"),
      tags$textarea(id="x8", rows=10, 
      "120\n111\n80\n115\n161\n117\n130\n124"),
      p("Note: No Missing Value"),

    p(tags$i("Example here was 2 sets of 2 by 2 table. One is the case-control table for active smoker; the other is case-control table for non-active smoker.")),

        hr(),

    h4(tags$b("Step 2. Choose Hypothesis")),

   p(tags$b("Null hypothesis")), 
   p("Case-Control (Row) has no significant association with Grouped Factors (Column) in each stratum / confounding group"),
    
   radioButtons("alt8", label = "Alternative hypothesis", 
        choiceNames = list(
          HTML("Case-Control (Row) has significant association with Grouped Factors (Column); odds ratio is significant different in each stratum"),
          HTML("Odds ratio of Stratum 1 is higher than Stratum 2"),
          HTML("Odds ratio of Stratum 2 is higher than Stratum 1")
          ),
        choiceValues = list("two.sided", "greater", "less")
        ),
   hr(),

  h4(tags$b("Step 3. Decide P Value method")),
  radioButtons("md8", 
    label = "What is the data like", 
    choiceNames = list(
      HTML("Asymptotic normal P value: sample size is not large (>= 15)"),
      HTML("Approximate to normal distribution: sample size is quite large (maybe > 40)"),
      HTML("Exact P value: sample size is small (< 15)")
      ), 
    choiceValues = list("a", "b", "c")),

    p(tags$i("In this setting,  we wanted to know if the odds ratio for lung cancer (case) in passive smoker are different with non-passive-smoker, controlling for personal active smoking."))
   
    ),


    mainPanel(

    h4(tags$b("Output 1. Contingency Table")), p(br()), 

    p(tags$b("K layers 2 x 2 Contingency Table")),
    p("The first 2 rows indicated 2 x 2 contingency table in the first stratum, and followed by 2 x 2 table from the second stratum. "),

    DT::DTOutput("dt8"),

    hr(),

    h4(tags$b("Output 2. Test Results")), p(br()), 

    DT::DTOutput("c.test8"),

     HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, to control for personal smoking, passive smoking and cancer risk has no significant relation, the odds ratios are significantly different. (Accept alternative hypothesis)
    <li> P Value >= 0.05, to control for personal smoking, passive smoking and cancer risk has no significant relation. (Accept null hypothesis)
    </ul>"
  ),

     p(tags$i("In this default setting, we conclude that there was significant relationship between cancer risk and passive smoking, by controlling the personal actively smoking. (P < 0.001)"))
        )
      ),

hr()

),

##########----------##########----------##########

tabPanel("(RxC)xK",

titlePanel("Cochran-Mantel-Haenszel for >2 Categories of Factor in >2 Status under K Strata"),

HTML("
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
"),

hr(),
#source("9_cmh_ui.R", local=TRUE)$value
#****************************************************************************************************************************************************9. cmh

   sidebarLayout(
      sidebarPanel(

    h4(tags$b("Step 1. Data Preparation")),


  p(tags$b("1. Give 2 names to each categories of factor shown as column names")),
        tags$textarea(id = "cn7",rows = 4,
        "Snoring\nNon-Snoring"
      ),
    p(tags$b("2. Give 2 names to case-control shown as row names")), 
        tags$textarea(id = "rn7",rows = 4,
        "30-39\n40-49\n50-60"
      ),
    p(tags$b("3. Give names to each categories of factor shown as row names")), 
        tags$textarea(id = "kn7",rows = 4,
        "Women\nMen"
      ),
        p(br()), 

    p(tags$b("3. Input R*C*K values in row order")),
      p("Data point can be separated by , ; /Enter /Tab"),
      tags$textarea(id="x7", rows=10, 
      "196\n603\n223\n486\n103\n232\n118\n348\n313\n383\n232\n206"),
      p("Note: No Missing Value"),

    p(tags$i("Example here was the prevalence of habitual snoring by age and sex group.")),

        hr(),

    h4(tags$b("Hypothesis")),

   p(tags$b("Null hypothesis")), 
   p("Case-Control (Row) has no significant association with Grouped Factors (Column) in each stratum / confounding group"),
    
   p(tags$b("Alternative hypothesis")), 
   p("Case-Control (Row) has significant association with Grouped Factors (Column); odds ratio is significant different in each stratum"),     

    p(tags$i("In this setting,  we wanted to know if the prevalence of habitual snoring has relation with age, controlling for gender."))
   

    ),


    mainPanel(

    h4(tags$b("Output 1. Contingency Table")), p(br()), 

    p(tags$b("K layers R x C Contingency Table")),
    p("The first R rows indicated R x C contingency table in the first stratum, and followed by R x C table from the second stratum. "),

    DT::DTOutput("dt7"),

    hr(),

    h4(tags$b("Output 2. Test Results")), p(br()), 

    DT::DTOutput("c.test7"),

     HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, to control for personal smoking, passive smoking and cancer risk has no significant relation, the odds ratios are significantly different. (Accept alternative hypothesis)
    <li> P Value >= 0.05, to control for personal smoking, passive smoking and cancer risk has no significant relation. (Accept null hypothesis)
    </ul>"
  ),

     p(tags$i("In this default setting, we conclude that there was significant relationship between the prevalence of habitual snoring and age, by controlling the gender. (P < 0.001)"))
        )
      ),

hr()

),

##########----------##########----------##########
tabPanel((a("Help Pages Online",
            target = "_blank",
            style = "margin-top:-30px; color:DodgerBlue",
            href = paste0("https://mephas.github.io/helppage/")))),
tabPanel(
  tags$button(
    id = 'close',
    type = "button",
    class = "btn action-button",
    style = "margin-top:-8px; color:Tomato; background-color: #F8F8F8  ",
    onclick = "setTimeout(function(){window.close();},500);",  # close browser
    "Stop and Quit"))

))

##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########

server <- function(input, output) {

#source("p1_server.R", local=TRUE)$value
#****************************************************************************************************************************************************

T1 = reactive({ # prepare dataset
  x <- as.numeric(unlist(strsplit(input$x1, "[,;\n\t ]")))
  validate(need(length(x)==4, "Please input 4 values"))
  x <- matrix(x,2,2, byrow=TRUE)

  validate(need(length(unlist(strsplit(input$cn1, "[\n]")))==2, "Please input correct column names"))
  validate(need(length(unlist(strsplit(input$rn1, "[\n]")))==2, "Please input correct row names"))

  rownames(x) = unlist(strsplit(input$rn1, "[\n]"))
  colnames(x) = unlist(strsplit(input$cn1, "[\n]"))
  return(x)
  })

output$dt1 = DT::renderDT({
  addmargins(T1(), 
    margin = seq_along(dim(T1())), 
    FUN = list(Total=sum), quiet = TRUE)},
    #class="row-border", 
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE)
  )

output$dt1.0 = DT::renderDT({
  res = chisq.test(T1())
  exp = res$expected
  return(exp)}, 
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt1.1 = DT::renderDT({prop.table(T1(), 1)},
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt1.2 = DT::renderDT({prop.table(T1(), 2)}, 
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt1.3 = DT::renderDT({prop.table(T1())}, 
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


output$makeplot1 <- renderPlot({  #shinysession 
  x <- as.data.frame(T1())
  mx <- reshape(x, varying = list(names(x)), times = names(x), ids = row.names(x), direction = "long")
  ggplot(mx, aes(x = mx[,"time"], y = mx[,2], fill = mx[,"id"]))+geom_bar(stat = "identity", position = position_dodge()) + ylab("Counts") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
})

output$makeplot1.1 <- renderPlot({  #shinysession 
  x <- as.data.frame(T1())
  mx <- reshape(x, varying = list(names(x)), times = names(x), ids = row.names(x), direction = "long")
  ggplot(mx, aes(x = mx[,"id"], y = mx[,2], fill = mx[,"time"]))+geom_bar(stat = "identity", position = position_dodge()) + ylab("Counts") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
})

output$c.test1 = DT::renderDT({
    x = as.matrix(T1())
    if (input$yt1 == TRUE){
    res = chisq.test(x=x, y=NULL,correct = TRUE)
    res.table = t(data.frame(X_statistic = res$statistic,                            
                              Degree_of_freedom = res$parameter,
                              P_value = res$p.value))
  }
  else{
    res = chisq.test(x=x, y=NULL,correct = FALSE)
    res.table = t(data.frame(X_statistic = res$statistic,                            
                              Degree_of_freedom = res$parameter,
                              P_value = res$p.value))
  }
    colnames(res.table) <- c(res$method)
    rownames(res.table) <- c("Chi-Square", "Degree of freedom", "P Value")
    return(res.table)
    }, 
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


#source("p2_server.R", local=TRUE)$value
#****************************************************************************************************************************************************

T2 = reactive({ # prepare dataset
  x <- as.numeric(unlist(strsplit(input$x2, "[,;\n\t ]")))
  validate(need(length(x)==4, "Please input 4 values"))

  x <- matrix(x,2,2, byrow=TRUE)
  validate(need(length(unlist(strsplit(input$cn2, "[\n]")))==2, "Please input correct column names"))
  validate(need(length(unlist(strsplit(input$rn2, "[\n]")))==2, "Please input correct row names"))

  rn = unlist(strsplit(input$rn2, "[\n]"))
  cn = unlist(strsplit(input$cn2, "[\n]"))
  rownames(x) <- paste(rn[1], cn)
  colnames(x) <- paste(rn[2], cn)
  return(x)
  })

output$dt2 = DT::renderDT({
  addmargins(T2(), 
    margin = seq_along(dim(T2())), 
    FUN = list(Total=sum), quiet = TRUE)},  
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt2.0 = DT::renderDT({
  res = chisq.test(T2())
  exp = res$expected
  return(exp)}, 
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt2.1 = DT::renderDT({prop.table(T2(), 1)}, 
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt2.2 = DT::renderDT({prop.table(T2(), 2)}, 
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt2.3 = DT::renderDT({prop.table(T2())}, 
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


output$makeplot2 <- renderPlot({  #shinysession 
  x <- as.data.frame(T2())
  mx <- reshape(x, varying = list(names(x)), times = names(x), ids = row.names(x), direction = "long")
  ggplot(mx, aes(x = mx[,"time"], y = mx[,2], fill = mx[,"id"]))+geom_bar(stat = "identity", position = position_dodge()) + ylab("Counts") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
  })

output$c.test2 = DT::renderDT({
    x = as.matrix(T2())
    if (input$yt2 == TRUE){
    res = mcnemar.test(x=x,correct = TRUE)
    res.table = t(data.frame(X_statistic = res$statistic,                            
                              Degree_of_freedom = res$parameter,
                              P_value = res$p.value))
  }
  else{
    res = mcnemar.test(x=x, correct = FALSE)
    res.table = t(data.frame(X_statistic = res$statistic,                            
                              Degree_of_freedom = res$parameter,
                              P_value = res$p.value))
  }
    colnames(res.table) <- c(res$method)
    rownames(res.table) <- c("McNemar Chi-Square", "Degree of freedom", "P Value")
    return(res.table)
    }, 
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


#source("p4_server.R", local=TRUE)$value
#****************************************************************************************************************************************************

T4 = reactive({ # prepare dataset
  x <- as.numeric(unlist(strsplit(input$x4, "[,;\n\t ]")))
  validate(need(length(x)==4, "Please input 4 values"))

  x <- matrix(x,2,2, byrow=TRUE)

  validate(need(length(unlist(strsplit(input$cn4, "[\n]")))==2, "Please input correct column names"))
  validate(need(length(unlist(strsplit(input$rn4, "[\n]")))==2, "Please input correct row names"))

  rownames(x) = unlist(strsplit(input$rn4, "[\n]"))
  colnames(x) = unlist(strsplit(input$cn4, "[\n]"))
  return(x)
  })

output$dt4 = DT::renderDT({
  addmargins(T4(), 
    margin = seq_along(dim(T4())), 
    FUN = list(Total=sum), quiet = TRUE)},  
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt4.0 = DT::renderDT({
  res = chisq.test(T4())
  exp = res$expected
  return(exp)}, 
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt4.1 = DT::renderDT({prop.table(T4(), 1)}, 
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt4.2 = DT::renderDT({prop.table(T4(), 2)}, #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt4.3 = DT::renderDT({prop.table(T4())}, #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


output$makeplot4 <- renderPlot({  #shinysession 
  x <- as.data.frame(T4())
  mx <- reshape(x, varying = list(names(x)), times = names(x), ids = row.names(x), direction = "long")
  ggplot(mx, aes(x = mx[,"time"], y = mx[,2], fill = mx[,"id"]))+geom_bar(stat = "identity", position = position_dodge()) + ylab("Counts") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
  })
output$makeplot4.1 <- renderPlot({  #shinysession 
  x <- as.data.frame(T4())
  mx <- reshape(x, varying = list(names(x)), times = names(x), ids = row.names(x), direction = "long")
  ggplot(mx, aes(x = mx[,"id"], y = mx[,2], fill = mx[,"time"]))+geom_bar(stat = "identity", position = position_dodge()) + ylab("Counts") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
 })

output$c.test4 = DT::renderDT({
    x = as.matrix(T4())
    res = fisher.test(x=x, y=NULL,alternative = input$yt4)
    res.table = t(data.frame(odds_ratio = res$estimate,                           
                            P_value = res$p.value,
                            CI = paste0("(", res$conf.int[1],",",res$conf.int[2], ")")
))
    colnames(res.table) <- c(res$method)
    rownames(res.table) <- c("Odds Ratio (Group 1 vs Group 2)","P Value", "95% Confidence Interval")
    return(res.table)
    }, 
   #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


#source("p3_server.R", local=TRUE)$value
#****************************************************************************************************************************************************

T3 = reactive({ # prepare dataset
  X <- as.numeric(unlist(strsplit(input$x3, "[,;\n\t ]")))
  Y <- as.numeric(unlist(strsplit(input$x33, "[,;\n\t ]")))
  validate(need(length(X)==length(Y), "Please input two groups of data with equal length"))
  x <- rbind(X,Y)
  x <- as.matrix(x)
  validate(need(length(unlist(strsplit(input$cn3, "[\n]")))==ncol(x), "Please input correct column names"))
  validate(need(length(unlist(strsplit(input$rn3, "[\n]")))==2, "Please input correct row names"))

  rownames(x) = unlist(strsplit(input$rn3, "[\n]"))
  colnames(x) = unlist(strsplit(input$cn3, "[\n]"))
  return(x)
  })

output$dt3 = DT::renderDT({
  addmargins(T3(), 
    margin = seq_along(dim(T3())), 
    FUN = list(Total=sum), quiet = TRUE)},  
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt3.0 = DT::renderDT({
  res = chisq.test(T3())
  exp = res$expected
  return(exp)}, 
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt3.1 = DT::renderDT({prop.table(T3(), 1)}, 
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt3.2 = DT::renderDT({prop.table(T3(), 2)}, 
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt3.3 = DT::renderDT({prop.table(T3())},
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


output$makeplot3 <- renderPlot({  #shinysession 
  x <- as.data.frame(T3())
  mx <- reshape(x, varying = list(names(x)), times = names(x), ids = row.names(x), direction = "long")
  ggplot(mx, aes(x = mx[,"time"], y = mx[,2], fill = mx[,"id"]))+geom_bar(stat = "identity", position = position_dodge()) + ylab("Counts") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
  #plot2 = ggplot(mx, aes(x = mx[,"id"], y = mx[,2], fill = mx[,"time"]))+geom_bar(stat = "identity", position = position_dodge()) + ylab("Counts") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
# grid.arrange(plot1, plot2, ncol=2)
 }) 

output$c.test3 = DT::renderDT({
    x = as.matrix(T3())

    res = chisq.test(x=x, y=NULL,correct = TRUE)
    res.table = t(data.frame(X_statistic = res$statistic,                            
                              Degree_of_freedom = res$parameter,
                              P_value = res$p.value))

    colnames(res.table) <- c(res$method)
    rownames(res.table) <- c("Chi-Square", "Degree of freedom", "P Value")
    return(res.table)
    }, 
   #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


#source("p5_server.R", local=TRUE)$value
#****************************************************************************************************************************************************

T5 = reactive({ # prepare dataset
  x <- as.numeric(unlist(strsplit(input$x5, "[,;\n\t ]")))
  r <- length(unlist(strsplit(input$rn5, "[\n]")))
  c <- length(unlist(strsplit(input$cn5, "[\n]")))

  validate(need(length(x)==r*c, "Please input enough values"))

  x <- matrix(x,r,c, byrow=TRUE)

  validate(need(length(unlist(strsplit(input$cn5, "[\n]")))==c, "Please input correct column names"))
  validate(need(length(unlist(strsplit(input$rn5, "[\n]")))==r, "Please input correct row names"))

  rownames(x) = unlist(strsplit(input$rn5, "[\n]"))
  colnames(x) = unlist(strsplit(input$cn5, "[\n]"))
  return(x)
  })

output$dt5 = DT::renderDT({
  addmargins(T5(), 
    margin = seq_along(dim(T5())), 
    FUN = list(Total=sum), quiet = TRUE)},  
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt5.0 = DT::renderDT({
  res = chisq.test(T5())
  exp = res$expected
  return(exp)}, 
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt5.1 = DT::renderDT({prop.table(T5(), 1)}, 
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt5.2 = DT::renderDT({prop.table(T5(), 2)}, 
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt5.3 = DT::renderDT({prop.table(T5())}, 
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


output$makeplot5 <- renderPlot({  #shinysession 
  x <- as.data.frame(T5())
  mx <- reshape(x, varying = list(names(x)), times = names(x), ids = row.names(x), direction = "long")
  ggplot(mx, aes(x = mx[,"time"], y = mx[,2], fill = mx[,"id"]))+geom_bar(stat = "identity", position = position_dodge()) + ylab("Counts") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
  #plot2 = ggplot(mx, aes(x = mx[,"id"], y = mx[,2], fill = mx[,"time"]))+geom_bar(stat = "identity", position = position_dodge()) + ylab("Counts") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
 })

output$c.test5 = DT::renderDT({
    x = as.matrix(T5())

    res = chisq.test(x=x, y=NULL,correct = FALSE)
    res.table = t(data.frame(X_statistic = res$statistic,                            
                              Degree_of_freedom = res$parameter,
                              P_value = res$p.value))
    colnames(res.table) <- c(res$method)
    rownames(res.table) <- c("Chi-Square", "Degree of freedom", "P Value")
    return(res.table)
    }, 
    #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


#source("p6_server.R", local=TRUE)$value
#****************************************************************************************************************************************************

T6 = reactive({ # prepare dataset
  rn = unlist(strsplit(input$rn6, "[\n]"))
  cn = unlist(strsplit(input$cn6, "[\n]"))

  x <- as.numeric(unlist(strsplit(input$x6, "[,;\n\t ]")))
  validate(need(length(x)==length(cn)*length(cn), "Please input enough values"))
  x <- matrix(x,length(cn),length(cn), byrow=TRUE)

  validate(need(length(cn)==ncol(x), "Please input correct names"))
  validate(need(length(rn)==2, "Please input correct names"))

  rownames(x) <- paste0(rn[1], " : ",cn)
  colnames(x) <- paste0(rn[2], " : ",cn)
  return(x)
  })

output$dt6 = DT::renderDT({
  addmargins(T6(), 
    margin = seq_along(dim(T6())), 
    FUN = list(Total=sum), quiet = TRUE)},
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt6.0 = DT::renderDT({
   x = as.matrix(T6())
  res = round(cohen.kappa(x)$agree,6)
    return(res)
}, 
#class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt6.1 = DT::renderDT({
   x = as.matrix(T6())
  res = round(cohen.kappa(x)$weight,6)
    return(res)
}, 
#class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


output$c.test6 = DT::renderDT({
    x = as.matrix(T6())
    res = cohen.kappa(x)
    res.table = res[["confid"]]
    colnames(res.table) =c("95% CI Low", "Kappa Estimate", "95% CI High")
    return(res.table)
    }, 
    #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


#source("p7_server.R", local=TRUE)$value
#****************************************************************************************************************************************************

rn <- reactive({unlist(strsplit(input$rn7, "[\n]"))})
cn <- reactive({unlist(strsplit(input$cn7, "[\n]"))})
kn <- reactive({unlist(strsplit(input$kn7, "[\n]"))})

T7 = reactive({ # prepare dataset
  #validate(need(length(cn())==2, "Please input enough names"))
  #validate(need(length(rn())==2, "Please input enough names"))

  x <- as.numeric(unlist(strsplit(input$x7, "[,;\n\t ]")))
  validate(need(length(x)==length(cn())*length(rn())*length(kn()), "Please input enough values"))
  x <- aperm(
    array(x,dim=c(length(cn()),length(rn()),length(kn())), 
    dimnames = list(groups=cn(), status=rn(), confound=kn())),
    perm=c(2,1,3))
  return(x)
  })

output$dt7 = DT::renderDT({
  T <- T7()[,,1]
  for (i in 2:length(kn())){
    T <- rbind.data.frame(T, T7()[,,i])
  }
  T
  k <- length(kn())
  n <- length(rn())
  dm <- dimnames(T7())
  rownames(T) <- paste0(rep(dm[[3]], each=n), " : ", dm[[1]])
  colnames(T)<- cn()
  return(T)
  }, 
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$c.test7 = DT::renderDT({
    x =T7()
    #dimnames(x) = list(status=rn(), groups=cn(), confound=kn())
    res <- mantelhaen.test(x)

    res.table = t(data.frame(X_statistic = res$statistic[1], 
                              #estimate=res$estimate[1],                           
                              #Degree_of_freedom = res$parameter,
                              P_value = res$p.value))
    colnames(res.table) <- c(res$method)
    rownames(res.table) <- c("Mantel-Haenszel Chi-Square", "P Value")
    return(res.table)
    }, 
    #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


#source("p8_server.R", local=TRUE)$value
#****************************************************************************************************************************************************

rn8 <- reactive({unlist(strsplit(input$rn8, "[\n]"))})
cn8 <- reactive({unlist(strsplit(input$cn8, "[\n]"))})
kn8 <- reactive({unlist(strsplit(input$kn8, "[\n]"))})

T8 = reactive({ # prepare dataset
  x <- as.numeric(unlist(strsplit(input$x8, "[,;\n\t ]")))
  validate(need(length(x)==4*length(kn8()), "Please input enough values"))
  validate(need(length(cn8())==2, "Please input enough names"))
  validate(need(length(rn8())==2, "Please input enough names"))
  x <- aperm(
    array(x,dim=c(2,2, length(kn8())), 
    dimnames = list(status=rn8(), groups=cn8(),confound=kn8())),
    perm=c(2,1,3)
    )
  return(x)
  })

output$dt8 = DT::renderDT({
  T <- T8()[,,1]
  for (i in 2:length(kn8())){
    T <- rbind.data.frame(T, T8()[,,i])
  }
  T
  k <- length(kn8())
  n <- length(rn8())
  dm <- dimnames(T8())
  rownames(T) <- paste0(rep(dm[[3]], rep(2,k)), " : ",dm[[2]])
  colnames(T)<- cn8()
  return(T)
  }, 
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$c.test8 = DT::renderDT({
    x <- T8()
    if (input$md8=="a"){
      res <- mantelhaen.test(x, alternative=input$alt8, correct=TRUE, exact=FALSE)
    }
    if (input$md8=="b"){
      res <- mantelhaen.test(x, alternative=input$alt8, correct=FALSE, exact=FALSE)
    }
    if (input$md8=="c"){
      res <- mantelhaen.test(x, alternative=input$alt8, correct=TRUE, exact=TRUE)
    }

    res.table = t(data.frame(X_statistic = res$statistic,
                              estimate=res$estimate,
                              #Degree_of_freedom = res$parameter,
                              P_value = res$p.value,
                              CI = paste0("(",round(res$conf.int[1], digits = 4),", ",round(res$conf.int[2], digits = 4), ")")))
  
    colnames(res.table) <- c(res$method)
    rownames(res.table) <- c("Mantel-Haenszel Chi-Square", "Estimated Odds Ratio", "P Value", "95% Confidence Interval")
    return(res.table)
    }, 
    #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


#source("p9_server.R", local=TRUE)$value
#****************************************************************************************************************************************************

T9 = reactive({ # prepare dataset
  x1 <- as.numeric(unlist(strsplit(input$x9, "[,;\n\t ]")))
  x2 <- as.numeric(unlist(strsplit(input$x99, "[,;\n\t ]")))
  validate(need(length(x1)==length(x2), "Please input two groups of data with equal length"))
  x <- data.frame(x1=x1,x2=x2)

  validate(need(length(unlist(strsplit(input$cn9, "[\n]")))==2, "Please input correct column names"))

  colnames(x) <- unlist(strsplit(input$cn9, "[\n]"))
  rownames(x) <- paste0("Rater", 1:nrow(x))
  return(x)
  })

output$dt9 = DT::renderDT({T9()}, 
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt9.0 =  DT::renderDT({
    x = T9()
    res = as.data.frame(cohen.kappa(x)$agree)[,3]
    res.table <- round(matrix(res, nrow=nrow(x), ncol=nrow(x)),6)
    rownames(res.table) <- paste0("Rater", 1:nrow(x))
    colnames(res.table) <- paste0("Rater", 1:nrow(x))
    return(res.table)
    }, 
    #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt9.1 =  DT::renderDT({
    x = T9()
    res = as.data.frame(round(cohen.kappa(x)$weight,6))
    return(res)
    }, 
    #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$c.test9 = DT::renderDT({
    x = as.matrix(T9())
    res = cohen.kappa(x)
    res.table = res[["confid"]]
    colnames(res.table) =c("95% CI Low", "Kappa Estimate", "95% CI High")
    return(res.table)
    }, 
    #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })

}

##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########

app <- shinyApp(ui = ui, server = server)

runApp(app, quiet = TRUE)

}
