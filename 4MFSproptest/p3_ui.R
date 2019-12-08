##----------#----------#----------#----------
##
## 4MFSproptest UI
##
## Language: EN
## 
## DT: 2019-04-07
##
##----------#----------#----------#----------


##---------- 3. Chi-square test for 2 paired-independent sample ----------

    sidebarLayout(
      sidebarPanel(

    h4(tags$b("Step 1. Data Preparation")),

        p(tags$b("How many success / events in every Group, x")),
        tags$textarea(id = "xx", rows = 5,
        "320\n1206\n1011\n463\n220"        
        ),

        p(tags$b("How many trials / samples in every Group, n")),     
        tags$textarea(id = "nn", rows = 5,
        "1742\n5638\n3904\n1555\n626"
        ),

         p(tags$b("You can change success / events names (no space)")),
        tags$textarea(id = "ln3",
          rows = 2,
        "Cancer\nNo-Cancer"
      ),

        p(tags$b("You can change Groups names (no space)")),
        tags$textarea(id = "gn",
          rows = 5,
        "~20\n20-24\n25-29\n30-34\n34~"
      ),

    p("Note: No Missing Value and n > x"),

    p(tags$i("In this example, we have 5 age groups of people as shown in n, and we record the number of people who have cancer in x.")),

        hr(),

    h4(tags$b("Step 2. Hypotheses")),

     p(tags$b("Null hypothesis")), 

      p("The probability/proportion are equal over the Groups"),
      
      p(tags$b("Alternative hypothesis")), 
       p("The probability/proportions are not equal"),          

    p(tags$i("In this setting,  We want to know if the probability to have cancer are different among different age groups ."))
   

    ),

      mainPanel(

      h4(tags$b("Output 1. Data Preview")), p(br()), 

      p(tags$b("Data Table")),

      tableOutput("n.t"),

      p(tags$b("Percentage Plot")),

      plotOutput("makeplot3", width = "600px", height = "300px"),

      hr(),

      h4(tags$b("Output 2. Test Results")), p(br()), 

      tableOutput("n.test"),


     HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then the population proportion/rate are significantly different. (Accept alternative hypothesis)
    <li> P Value >= 0.05, then the population proportion/rate are NOT significantly different. (Accept null hypothesis)
    </ul>"
  ),

     p(tags$i("In this default setting, we conclude that the probability to have cancer are significantly different in different age groups. (P < 0.001)"))

        )
      )
