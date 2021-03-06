#****************************************************************************************************************************************************9. cmh

   sidebarLayout(
      sidebarPanel(

    h4(tags$b("Step 1. Data Preparation")),


  p(tags$b("1. Give 2 names to each category of factor shown as column names")),
        tags$textarea(id = "cn7",rows = 4,
        "Snoring\nNon-Snoring"
      ),
    p(tags$b("2. Give 2 names to case-control shown as row names")), 
        tags$textarea(id = "rn7",rows = 4,
        "30-39\n40-49\n50-60"
      ),
    p(tags$b("3. Give names to each category of factor shown as row names")), 
        tags$textarea(id = "kn7",rows = 4,
        "Women\nMen"
      ),
        p(br()), 

    p(tags$b("3. Input R*C*K values in row order")),
      p("Data point can be separated by , ; /Enter /Tab"),
      tags$textarea(id="x7", rows=10, 
      "196\n603\n223\n486\n103\n232\n118\n348\n313\n383\n232\n206"),
      p("Note: No Missing Value"),
conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("The example shown here was the prevalence of habitual snoring by age and sex group."))
    ),

        hr(),

    h4(tags$b("Hypothesis")),

   p(tags$b("Null hypothesis")), 
   p("Case-Control (Row) has no significant association with Grouped Factors (Column) in each stratum/confounding group"),
    
   p(tags$b("Alternative hypothesis")), 
   p("Case-Control (Row) has a significant association with Grouped Factors (Column); the odds ratio is significantly different in each stratum"),     
conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("In this setting,  we wanted to know if the prevalence of habitual snoring has a relation with age, controlling for gender."))
    )
   

    ),


    mainPanel(

    h4(tags$b("Output 1. Contingency Table")), p(br()), 

    p(tags$b("K layers R x C Contingency Table")),
    p("The first R rows indicated an R x C contingency table in the first stratum and followed by an R x C table from the second stratum. "),

    DT::DTOutput("dt7"),

    hr(),

    h4(tags$b("Output 2. Test Results")), p(br()), 

    DT::DTOutput("c.test7"),

     HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, by controlling the gender, the prevalence of habitual snoring and ages have a significant relation, the odds ratios are significantly different. (Accept the alternative hypothesis)</li>
    <li> P Value >= 0.05, by controlling the gender, the prevalence of habitual snoring and ages have no significant relation. (Accept the null hypothesis)</li>
    </ul>"
  ),
conditionalPanel(
    condition = "input.explain_on_off",
     p(tags$i("In this default setting, we conclude that there was a significant relationship between the prevalence of habitual snoring and ages, by controlling the gender. (P < 0.001)"))
        )
      )
    )
    