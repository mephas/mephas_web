#****************************************************************************************************************************************************3. mcnemar

sidebarLayout(
sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")),

  p(tags$b("1. Give 2 names to each shared categories of outcome shown in column name and row name")),
  tags$textarea(id="cn2", rows=2, "Better\nNo-change"), 

  p(tags$b("2. Give 2 factor/treatment names shown in row name and column name")), 
  tags$textarea(id="rn2", rows=2, "Treatment-A\nTreatment-B"),p(br()),

  
  p(tags$b("3. Input 4 values in row-order")),
  p("Data points can be separated by , ; /Enter /Tab"),
  tags$textarea(id="x2", rows=4, 
    "510\n16\n5\n90"),
  p("Note: No Missing Value"),
  conditionalPanel(
    condition = "input.explain_on_off",
  p(tags$i("The example shown here was 621 pairs of patients, one group underwent treatment A, and the other underwent treatment B. Patients were paired with similar age and clinical conditions. ")),
  p(tags$i("Among 621 patients, 510 pairs were better in both treatment A and B; 90 pairs did not change either in treatment A or treatment B. (Concordant Pair) ")),
  p(tags$i("In 16 pairs, only group after treatment A was better; in 5 pairs, only group after treatment B was better. (Dis-concordant Pair) "))
  ),

  hr(),

   h4(tags$b("Hypothesis")),

   p(tags$b("Null hypothesis")), 
   p("The factors have no significant differences"),
    
   p(tags$b("Alternative hypothesis")), 
   p("The factors have significant differences in the paired samples "),
   conditionalPanel(
    condition = "input.explain_on_off",
   p(tags$i("In this example, we wanted to determine if whether the treatments had significant differences for the matched pair."))
   ),
      
  hr(),

  h4(tags$b("Step 2. Decide the P Value method")),
    radioButtons("yt2", label = "Yates-correction on P Value", 
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
      plotly::plotlyOutput("makeplot2", width = "80%")
      )
    ),

    hr(),

    h4(tags$b("Output 2. Test Results")), p(br()), 

    DT::DTOutput("c.test2"),

     HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then the factors have significant differences in the paired samples. (Accept the alternative hypothesis)</li>
    <li> P Value >= 0.05, then the factors have no significant differences. (Accept the null hypothesis)</li>
    </ul>"
  ),
conditionalPanel(
    condition = "input.explain_on_off",
     p(tags$i("In this default setting, we concluded that two treatments had a significantly different effect on paired patients. (P = 0.03)"))
)
        )
      )
    