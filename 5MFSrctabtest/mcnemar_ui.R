##----------#----------#----------#----------
##
## 5MFSrctabtest UI
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------

#----------  Panel 2: 2,2 paired dependent ----------##
 sidebarLayout(
sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")),

  p(tags$b("1. Give outcome / measurement names to Columns and Rows")), 
  tags$textarea(id="cn2", rows=2, "Better\nNo-change"), 

  p(tags$b("2. Give factor / treatment names")), 
  tags$textarea(id="rn2", rows=2, "Treatment-A\nTreatment-B"),p(br()),

  
  p(tags$b("3. Input 4 Values by Column")),
  tags$textarea(id="x2", rows=4, 
    "510\n5\n16\n90"),

  p("Note: No Missing Value"),
  
  p(tags$i("Example here was 621 pairs of patients, one group underwent treatment A and the other underwent treatment B. Patients were paired with similar age and clinical conditions. ")),
  p(tags$i("Among 621 patients, 510 pairs were better in both treatment A and B; 90 pairs did not change either in treatment A or treatment B. (Concordant Pair) ")),
  p(tags$i("In 16 pairs, only group after treatment A were better; in 5 pairs, only group after treatment B were better. (Dis-concordant Pair) ")),

  hr(),

   h4(tags$b("Hypothesis")),

   p(tags$b("Null hypothesis")), 
   p("The factors have no significant differences"),
    
   p(tags$b("Alternative hypothesis")), 
   p("The factors have significant differences on the paired samples "),

   p(tags$i("In this example, we wanted to determine if whether the treatments had significant differences for the matched pair.")),
      
  hr(),

    h4(tags$b("Step 2. Check the Rule of Five")),
    radioButtons("yt2", label = "Yates-correction on P Value", 
        choiceNames = list(
          HTML("Do: no value in the Expected Table (Right) <5 "),
          HTML("Not do: some value in the Expected Table (Right) <5")
          ),
        choiceValues = list(TRUE, FALSE)
        )
   
    ),

    mainPanel(

    h4(tags$b("Output 1. Contingency Table")), p(br()), 

    tabsetPanel(

    tabPanel("Table Preview", p(br()),

        p(tags$b("Data Table")),
        tableOutput("dt2"),

        p(tags$b("Expected Table")),
        tableOutput("dt2.0")
        ),
    
    tabPanel("Percentage Table", p(br()),

        p(tags$b("Cell-Total %")),
        tableOutput("dt2.3"),

        p(tags$b("Cell-Row %")),
        tableOutput("dt2.1"),

        p(tags$b("Cell-Column %")),
        tableOutput("dt2.2")
        ),

    tabPanel("Percentage Plot", p(br()),

      plotOutput("makeplot2", width = "800px", height = "400px")
      )
    ),

    hr(),

    h4(tags$b("Output 2. Test Results")), p(br()), 

    tableOutput("c.test2"),

     HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then the factors have significant differences on the paired samples. (Accept alternative hypothesis)
    <li> P Value >= 0.05, then the factors have no significant differences. (Accept null hypothesis)
    </ul>"
  ),

     p(tags$i("In this default setting, we concluded that two treatments had significantly different effect on the paired patients. (P = 0.03)"))

        )
      )
    