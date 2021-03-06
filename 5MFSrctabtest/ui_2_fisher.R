#****************************************************************************************************************************************************2. fisher
sidebarLayout(
sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")),

  p(tags$b("1. Give 2 names to each category of factor shown as column names")),
  tags$textarea(id="cn4", rows=2, "High salt\nLow salt"),

    p(tags$b("2. Give 2 names to case-control shown as row names")), 
  tags$textarea(id="rn4", rows=2, "CVD\nNon CVD"), p(br()),

  p(tags$b("3. Input 4 values in row-order")),
  p("Data points can be separated by , ; /Enter /Tab"),
  tags$textarea(id="x4", rows=4, 
    "5\n30\n2\n23"),

  p("Note: No Missing Value"),
conditionalPanel(
    condition = "input.explain_on_off",
  p(tags$i("The case-control was CVD patients or not. Factor categories were a high salt diet or not.")),
  p(tags$i("Of 35 people who died from CVD, 5 were on a high-salt diet before they die; of 25 people who died from other causes, 2 were on a high-salt diet."))
  ),

  hr(),

   h4(tags$b("Step 2. Choose Hypothesis")),

   p(tags$b("Null hypothesis")), 
   p("Case-Control (Row) do not significantly associate with Grouped Factors (Column)"),

    radioButtons("yt4", label = "Alternative hypothesis", 
        choiceNames = list(
          HTML("Case-Control (Row) has a significant association with Grouped Factors (Column); odds ratio of Group 1 is significantly different from Group 2"),
          HTML("The odds ratio of Group 1 is higher than Group 2"),
          HTML("The odds ratio of Group 2 is higher than Group 1")
          ),
        choiceValues = list("two.sided", "greater", "less")
        ),
    conditionalPanel(
    condition = "input.explain_on_off",
      p(tags$i("In this example, we wanted to determine if there was an association between the cause of death and a high-salt diet."))
      )

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
      plotly::plotlyOutput("makeplot4"),
      p(tags$b("Percentages in the columns")),
      plotly::plotlyOutput("makeplot4.1")
      )
    ),

    hr(),

    h4(tags$b("Output 2. Test Results")), p(br()), 

    DT::DTOutput("c.test4"),

     HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then Case-Control (Row) is significantly associated with Grouped Factors (Column) (Accept the alternative hypothesis)</li>
    <li> P Value >= 0.05, then Case-Control (Row) is not associated with Grouped Factors (Column). (Accept the null hypothesis)</li>
    </ul>"
  ),
conditionalPanel(
    condition = "input.explain_on_off",
     p(tags$i("In this default setting, two expected values < 5, so we used the Fisher exact test. From the test result, we concluded that no significant association was found between the cause of death and high salt diet" ))
)
        )
      )
    