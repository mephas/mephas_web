##----------#----------#----------#----------
##
## 5MFSrctabtest UI
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------


##---------- Panel 3: 2, C table ----------

   sidebarLayout(
      sidebarPanel(

    h4(tags$b("Step 1. Data Preparation")),

    p(tags$b("Give names to case-control in the row (no space)")), 
        tags$textarea(id = "rn3",rows = 2,
        "Cancer\nNo-Cancer"
      ),

  p(tags$b("Give names to samples in the column (no space)")), 
        tags$textarea(id = "cn3",rows = 5,
        "~20\n20-24\n25-29\n30-34\n34~"
      ),
        p(br()), 

        p(tags$b("How many Cases in every Group")),
        tags$textarea(id = "x3", rows = 5,
        "320\n1206\n1011\n463\n220"        
        ),

        p(tags$b("How many Controls in every Group")),     
        tags$textarea(id = "x33", rows = 5,
        "1742\n5638\n3904\n1555\n626"
        ),

    p("Note: No Missing Value and n > x"),

    p(tags$i("In this example, we have 5 age groups of people as shown in n, and we record the number of people who have cancer in x.")),

        hr(),

    h4(tags$b("Hypothesis")),

   p(tags$b("Null hypothesis")), 
   p("Case-Control (Row) is significantly associate with Grouped Factors (Column)"),
    
   p(tags$b("Alternative hypothesis")), 
   p("Case-Control (Row) has no significant association with Grouped Factors (Column)"),     

    p(tags$i("In this setting,  We want to know if the probability to have cancer are different among different age groups ."))
   

    ),


    mainPanel(

    h4(tags$b("Output 1. Contingency Table")), p(br()), 

    tabsetPanel(

    tabPanel("Table", p(br()),

        p(tags$b("Data Table")),
        tableOutput("dt3"),

        p(tags$b("Cell-Total %")),
        tableOutput("dt3.3"),

        p(tags$b("Cell-Row %")),
        tableOutput("dt3.1"),

        p(tags$b("Cell-Column %")),
        tableOutput("dt3.2")
        ),

    tabPanel("Percentage Plot", p(br()),

      plotOutput("makeplot3", width = "600px", height = "300px")
      )
    ),

    hr(),

    h4(tags$b("Output 2. Test Results")), p(br()), 

    tableOutput("c.test3"),

     HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then Case-Control (Row) is significantly associated with Grouped Factors (Column) (Accept alternative hypothesis)
    <li> P Value >= 0.05, then Case-Control (Row) are not associated with Grouped Factors (Column). (Accept null hypothesis)
    </ul>"
  ),

     p(tags$i("In this default setting, we conclude that using OC and MI development have significant association. (P = 0.01)"))

        )
      )
    