##----------#----------#----------#----------
##
## 5MFSrctabtest UI
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------
#----------  Panel 6: k,k independent ----------##
   sidebarLayout(
      sidebarPanel(

    h4(tags$b("Step 1. Data Preparation")),

    p(tags$b("1. Give outcome / measurement names to Columns and Rows")), 
    tags$textarea(id="cn6", rows=2, "Yes\nNo"), 

    p(tags$b("2. Give factor / treatment names")), 
    tags$textarea(id="rn6", rows=2, "Survey1\nSurvey2"),p(br()),

  
  p(tags$b("3. Input 4 Values by Column")),
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
        tableOutput("dt6"),

        p(tags$b("Expected Table")),
        tableOutput("dt6.0")
        ),
    tabPanel("Percentage Table", p(br()),

        p(tags$b("Cell/Total %")),
        tableOutput("dt6.3"),

        p(tags$b("Cell/Row-Total %")),
        tableOutput("dt6.1"),

        p(tags$b("Cell/Column-Total %")),
        tableOutput("dt6.2")
        ),

    tabPanel("Percentage Plot", p(br()),

      plotOutput("makeplot6", width = "500px", height = "400px")
      )
    ),

    hr(),

    h4(tags$b("Output 2. Test Results")), p(br()), 

    tableOutput("c.test6"),

     HTML(
    "<b> Explanations and Guidelines for Evaluating Kappa </b> 
    <ul>
      <li> <b>Cohen's Kappa Statistic > 0.75</b>: <b>excellent</b> reproducibility </li>
      <li> <b>0.4 <= Cohen's Kappa Statistic <= 0.75</b>: <b>good</b> reproducibility</li>
      <li> <b>0 <= Cohen's Kappa Statistic < 0.4</b>: <b>marginal</b> reproducibility </li>
    </ul>

  "
  ),

     p(tags$i("In this default setting, we concluded that the response from Survey1 and Survey2 had excellent reproducibility. "))

        )
      )
    