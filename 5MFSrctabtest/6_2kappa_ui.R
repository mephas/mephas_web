##----------#----------#----------#----------
##
## 5MFSrctabtest UI
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------
#----------  Panel 9: k,k independent ----------##
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
      <li> Cohen’s kappa takes into account disagreement between the two raters, but not the degree of disagreement.
      <li> The weighted kappa is calculated using a predefined table of weights which measure the degree of disagreement between the two raters, the higher the disagreement the higher the weight.
    </ul>

  "
  ),

     p(tags$i("In this default setting, we concluded that the response from Survey1 and Survey2 did not have such good reproducibility "))

        )
      )
    