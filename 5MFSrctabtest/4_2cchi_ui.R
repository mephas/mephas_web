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

  p(tags$b("2. Give names to each categories of factor shown as column names")),
        tags$textarea(id = "cn3",rows = 5,
        "~20\n20-24\n25-29\n30-34\n34~"
      ),
    p(tags$b("2. Give 2 names to case-control shown as row names")), 
        tags$textarea(id = "rn3",rows = 2,
        "Cancer\nNo-Cancer"
      ),

        p(br()), 

        p(tags$b("3. How many Cases in every Group")),
        p("Data point can be separated by , ; /Enter /Tab"),
        tags$textarea(id = "x3", rows = 5,
        "320\n1206\n1011\n463\n220"        
        ),

        p(tags$b("4. How many Controls in every Group")), 
        p("Data point can be separated by , ; /Enter /Tab"),
        tags$textarea(id = "x33", rows = 5,
        "1422\n4432\n2893\n1092\n406"
        ),

    p("Note: No Missing Value"),

    p(tags$i("In this example, we had 5 age groups of people as shown in different ages, and we record the number of people who had cancer and who did not have cancer.")),

        hr(),

    h4(tags$b("Hypothesis")),

   p(tags$b("Null hypothesis")), 
   p("Case-Control (Row) do not significantly associate with Grouped Factors (Column)"),
    
   p(tags$b("Alternative hypothesis")), 
   p("Case-Control (Row) has significant association with Grouped Factors (Column)"),     

    p(tags$i("In this setting,  we wanted to know if there was any relation between cancer and ages."))
   

    ),


    mainPanel(

    h4(tags$b("Output 1. Contingency Table")), p(br()), 

    tabsetPanel(

    tabPanel("Table Preview", p(br()),

        p(tags$b("2 x C Contingency Table with Total Number")),
        DT::DTOutput("dt3"),

        p(tags$b("Expected Value")),
        DT::DTOutput("dt3.0")
        ),
    tabPanel("Percentage Table", p(br()),

        p(tags$b("Cell/Total %")),
        DT::DTOutput("dt3.3"),

        p(tags$b("Cell/Row-Total %")),
        DT::DTOutput("dt3.1"),

        p(tags$b("Cell/Column-Total %")),
        DT::DTOutput("dt3.2")
        ),

    tabPanel("Percentage Plot", p(br()),
      plotOutput("makeplot3", width = "80%")
      )
    ),

    hr(),

    h4(tags$b("Output 2. Test Results")), p(br()), 

    DT::DTOutput("c.test3"),

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
    