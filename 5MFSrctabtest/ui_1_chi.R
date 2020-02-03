#****************************************************************************************************************************************************1.chi
sidebarLayout(
sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")),

  p(tags$b("1. Give 2 names to each category of factor shown as column names")),
  tags$textarea(id="cn1", rows=2, "Developed-MI\nNo MI"),

    p(tags$b("2. Give 2 names to case-control shown as row names")), 
  tags$textarea(id="rn1", rows=2, "OC user\nNever OC user"), p(br()),

  p(tags$b("3. Input 4 values in row-order")),
  p("Data points can be separated by , ; /Enter /Tab"),
  tags$textarea(id="x1", rows=4, 
    "13\n4987\n7\n9993"),

  p("Note: No Missing Value"),
  conditionalPanel(
    condition = "input.explain_on_off",
  p(tags$i("The case-control was OC user and non-OC users. Factor categories were developed MI or not.")),
  p(tags$i("Among 5000 OC-users, 13 developed MI; among 10000 non-OC-users, 7 developed MI."))
  ),

  hr(),

   h4(tags$b("Hypothesis")),

   p(tags$b("Null hypothesis")), 
   p("Case-Control (Row) has no significantly associated with Grouped Factors (Column)"),
    
   p(tags$b("Alternative hypothesis")), 
   p("Case-Control (Row) is a significant association with Grouped Factors (Column)"),
conditionalPanel(
    condition = "input.explain_on_off",
  p(tags$i("In this example, we wanted to determine if OC use was significantly associated with higher MI incidence."))
  ),

hr(),

  h4(tags$b("Step 2. Decide the P Value method")),
    radioButtons("yt1", label = "Yates-correction on P Value", 
        choiceNames = list(
          HTML("Do: no Expected Value <5, but Expected Value not so large  "),
          HTML("Not do: There is a quite large sample")
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
      plotly::plotlyOutput("makeplot1", width = "80%"),
      p(tags$b("Percentages in the columns")),
      plotly::plotlyOutput("makeplot1.1", width = "80%")
      )
    ),

    hr(),

    h4(tags$b("Output 2. Test Results")), p(br()), 

    DT::DTOutput("c.test1"),

     HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then Case-Control (Row) is significantly associated with Grouped Factors (Column) (Accept the alternative hypothesis)</li>
    <li> P Value >= 0.05, then Case-Control (Row) is not associated with Grouped Factors (Column). (Accept the null hypothesis)</li>
    </ul>"
  ),
conditionalPanel(
    condition = "input.explain_on_off",
     p(tags$i("In this default setting, we concluded that using OC and MI development had a significant association. (P = 0.01) Because the minimum expected value was 6.67, Yates-correction on P Value was done." ))
)
        )
      )
    