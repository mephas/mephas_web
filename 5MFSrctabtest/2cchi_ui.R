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

  p(tags$b("Give names to Columns (No space)")), 
        tags$textarea(id = "cn3",rows = 5,
        "~20\n20-24\n25-29\n30-34\n34~"
      ),
  p(tags$b("Give names to Rows (No space)")), 
        tags$textarea(id = "rn3",rows = 2,
        "Cancer\nNo-Cancer"
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

    p("Note: No Missing Value"),

    p(tags$i("In this example, we had 5 age groups of people as shown in different ages, and we record the number of people who had cancer in x.")),

        hr(),

    h4(tags$b("Hypothesis")),

   p(tags$b("Null hypothesis")), 
   p("Case-Control (Row) significantly associate with Grouped Factors (Column)"),
    
   p(tags$b("Alternative hypothesis")), 
   p("Case-Control (Row) has no significant association with Grouped Factors (Column)"),     

    p(tags$i("In this setting,  we wanted to know if there was any relation between cancer and ages."))
   

    ),


    mainPanel(

    h4(tags$b("Output 1. Contingency Table")), p(br()), 

    tabsetPanel(

    tabPanel("Table Preview", p(br()),

        p(tags$b("Data Table")),
        tableOutput("dt3"),

        p(tags$b("Expected Table")),
        tableOutput("dt3.0")
        ),
    tabPanel("Percentage Table", p(br()),

        p(tags$b("Cell-Total %")),
        tableOutput("dt3.3"),

        p(tags$b("Cell-Row %")),
        tableOutput("dt3.1"),

        p(tags$b("Cell-Column %")),
        tableOutput("dt3.2")
        ),

    tabPanel("Percentage Plot", p(br()),

      plotOutput("makeplot3", width = "1000px", height = "400px")
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

     p(tags$i("In this default setting, we conclude that there was significant relation between cancer and ages. (P < 0.001)"))

        )
      )
    