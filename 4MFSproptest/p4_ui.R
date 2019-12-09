##----------#----------#----------#----------
##
## 4MFSprop UI
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------
##---------- Panel 4: 2, K table ----------
 sidebarLayout(
      sidebarPanel(

    h4(tags$b("Step 1. Data Preparation")),

    p(tags$b("Give names to success / event (no space)")), 
        tags$textarea(id = "rn4",rows = 2,
        "Cancer\nNo-Cancer"
      ),

  p(tags$b("Give names to trials / samples (no space)")), 
        tags$textarea(id = "cn4",rows = 5,
        "~20\n20-24\n25-29\n30-34\n34~"
      ),
        p(br()), 

        p(tags$b("How many success / event in every Group, x")),
        tags$textarea(id = "x4", rows = 5,
        "320\n1206\n1011\n463\n220"        
        ),

        p(tags$b("How many trials / samples totally in every Group, n>x")),     
        tags$textarea(id = "x44", rows = 5,
        "1742\n5638\n3904\n1555\n626"
        ),

    p("Note: No Missing Value and n > x"),

    p(tags$i("In this example, we have 5 age groups of people as shown in n, and we record the number of people who have cancer in x.")),

        hr(),

   h4(tags$b("Step 2. What is the order that you want to test for your samples")),

    p(tags$b("Order of the columns (same length with your sample)")),
    tags$textarea(id = "xs", rows = 5,
        "1\n2\n3\n4\n5"        
    ),

    hr(),

    h4(tags$b("Hypothesis")),

   p(tags$b("Null hypothesis")), 
   p("There is no variation in for the sample proportion"),
    
   p(tags$b("Alternative hypothesis")), 
   p("The proportion / rate / probabilities vary with score"),     

    p(tags$i("In this setting,  We want to know if the rate to have cancer have tendency among different ages."))
   

    ),

    mainPanel(

    h4(tags$b("Output 1. Contingency Table")), p(br()), 

    tabsetPanel(

    tabPanel("Table", p(br()),

        p(tags$b("Data Table")),
        tableOutput("dt4"),

        p(tags$b("Cell-Column %")),
        tableOutput("dt4.2")
        ),

    tabPanel("Percentage Plot", p(br()),

      plotOutput("makeplot4", width = "600px", height = "300px")
      )
    ),

    hr(),

    h4(tags$b("Output 2. Test Results")), p(br()), 

    tableOutput("c.test4"),

     HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then Case-Control (Row) is significantly associated with Grouped Factors (Column) (Accept alternative hypothesis)
    <li> P Value >= 0.05, then Case-Control (Row) are not associated with Grouped Factors (Column). (Accept null hypothesis)
    </ul>"
  ),

     p(tags$i("In this default setting, we conclude that the proportion of cancer varies among different ages. (P = 0.01)"))

        )
      )
    