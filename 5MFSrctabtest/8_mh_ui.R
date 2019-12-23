##----------#----------#----------#----------
##
## 5MFSrctabtest UI
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------
#----------  Panel 5: R,C,k independent ----------##
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

    tableOutput("dt8"),

    hr(),

    h4(tags$b("Output 2. Test Results")), p(br()), 

    tableOutput("c.test8"),

     HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, to control for personal smoking, passive smoking and cancer risk has no significant relation, the odds ratios are significantly different. (Accept alternative hypothesis)
    <li> P Value >= 0.05, to control for personal smoking, passive smoking and cancer risk has no significant relation. (Accept null hypothesis)
    </ul>"
  ),

     p(tags$i("In this default setting, we conclude that there was significant relationship between cancer risk and passive smoking, by controlling the personal actively smoking. (P < 0.001)"))
        )
      )
    