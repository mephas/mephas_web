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

    tableOutput("dt7"),

    hr(),

    h4(tags$b("Output 2. Test Results")), p(br()), 

    tableOutput("c.test7"),

     HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, to control for personal smoking, passive smoking and cancer risk has no significant relation, the odds ratios are significantly different. (Accept alternative hypothesis)
    <li> P Value >= 0.05, to control for personal smoking, passive smoking and cancer risk has no significant relation. (Accept null hypothesis)
    </ul>"
  ),

     p(tags$i("In this default setting, we conclude that there was significant relationship between the prevalence of habitual snoring and age, by controlling the gender. (P < 0.001)"))
        )
      )
    