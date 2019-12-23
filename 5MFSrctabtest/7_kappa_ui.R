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
        DT::dataTableOutput("dt6")
        ),
    tabPanel("Agreement Table", p(br()),
        DT::dataTableOutput("dt6.0")
        ),
    tabPanel("Weight Table", p(br()),
        DT::dataTableOutput("dt6.1")
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
      <li> Cohen’s kappa takes into account disagreement between the two raters, but not the degree of disagreement.
      <li> The weighted kappa is calculated using a predefined table of weights which measure the degree of disagreement between the two raters, the higher the disagreement the higher the weight.

    </ul>

  "
  ),

     p(tags$i("In this default setting, we concluded that the response from Survey1 and Survey2 didn't have so good reproducibility, just marginally reproducible. "))

        )
      )
    