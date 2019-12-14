##----------#----------#----------#----------
##
## 5MFSrctabtest UI
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------
##---------- 1. Fisher test 2,2 ----------
sidebarLayout(
sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")),

  p(tags$b("1. Give names to factor categories in column")),
  tags$textarea(id="cn4", rows=2, "High salt\nLow salt"),

    p(tags$b("2. Give names to case-control in rows")), 
  tags$textarea(id="rn4", rows=2, "CVD\nNon CVD"), p(br()),

  p(tags$b("3. Input 4 Values in row-order")),
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
        tableOutput("dt4"),

        p(tags$b("Expected Value")),
        tableOutput("dt4.0")
        ),

    tabPanel("Percentage Table", p(br()),

        p(tags$b("Cell/Total %")),
        tableOutput("dt4.3"),

        p(tags$b("Cell/Row-Total %")),
        tableOutput("dt4.1"),

        p(tags$b("Cell/Column-Total %")),
        tableOutput("dt4.2")
        ),

    tabPanel("Percentage Plot", p(br()),

      plotOutput("makeplot4", width = "1000px", height = "400px")
      )
    ),

    hr(),

    h4(tags$b("Output 2. Test Results")), p(br()), 

    tableOutput("c.test4"),

     HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then Case-Control (Row) is significantly associated with Grouped Factors (Column) (Accept alternative hypothesis)
    <li> P Value >= 0.05, then Case-Control (Row) are not associated with Grouped Factors (Column). (Accept null hypothesis)
    </ul>"
  ),

     p(tags$i("In this default setting, two expected values < 5, so we used Fisher exact test. From the test result, we concluded that no significant association was found between the cause of death and high salt diet" ))

        )
      )
    