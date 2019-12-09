##----------#----------#----------#----------
##
## 5MFSrctabtest UI
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------
#----------  Panel 5: R,C independent ----------##
   sidebarLayout(
      sidebarPanel(

    h4(tags$b("Step 1. Data Preparation")),

    p(tags$b("Give names to Columns (No space)")), 
        tags$textarea(id = "cn5",rows = 5,
        "Smear+\nSmear-Culture+\nSmear-Culture-"
      ),
    p(tags$b("Give names to Rows (No space)")), 
        tags$textarea(id = "rn5",rows = 5,
        "Penicillin\nSpectinomycin-low\nSpectinomycin-high"
      ),
        p(br()), 

    p(tags$b("Input R*C Values by Column-order")),
      tags$textarea(id="x5", rows=10, 
      "40\n10\n15\n30\n20\n40\n130\n70\n45"),
      p("Note: No Missing Value"),

    p(tags$i("Example here was the response from patient after the drug treatment.")),

        hr(),

    h4(tags$b("Hypothesis")),

   p(tags$b("Null hypothesis")), 
   p("Case-Control (Row) is significantly associate with Grouped Factors (Column)"),
    
   p(tags$b("Alternative hypothesis")), 
   p("Case-Control (Row) has no significant association with Grouped Factors (Column)"),     

    p(tags$i("In this setting,  we wanted to know if there was relationship between drug treatment and response."))
   

    ),


    mainPanel(

    h4(tags$b("Output 1. Contingency Table")), p(br()), 

    tabsetPanel(

    tabPanel("Table Preview", p(br()),

        p(tags$b("Data Table")),
        tableOutput("dt5"),

        p(tags$b("Expected Table")),
        tableOutput("dt5.0")
        ),
    tabPanel("Percentage Table", p(br()),

        p(tags$b("Cell-Total %")),
        tableOutput("dt5.3"),

        p(tags$b("Cell-Row %")),
        tableOutput("dt5.1"),

        p(tags$b("Cell-Column %")),
        tableOutput("dt5.2")
        ),

    tabPanel("Percentage Plot", p(br()),

      plotOutput("makeplot5", width = "1000px", height = "400px")
      )
    ),

    hr(),

    h4(tags$b("Output 2. Test Results")), p(br()), 

    tableOutput("c.test5"),

     HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then Case-Control (Row) is significantly associated with Grouped Factors (Column) (Accept alternative hypothesis)
    <li> P Value >= 0.05, then Case-Control (Row) are not associated with Grouped Factors (Column). (Accept null hypothesis)
    </ul>"
  ),

     p(tags$i("In this default setting, we conclude that there was significant relationship between drug treatment and response. (P < 0.001)"))

        )
      )
    