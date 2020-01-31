#****************************************************************************************************************************************************2.prop2
    sidebarLayout(
      sidebarPanel(

    h4(tags$b("Step 1. Data Preparation")),
     p(tags$b("You can change groups names")),
        tags$textarea(id = "gn",
          rows = 5,
        "~20\n20-24\n25-29\n30-34\n34~"
      ),

      p(tags$b("You can change success / events names")),
        tags$textarea(id = "ln3",
          rows = 2,
        "Cancer\nNo-Cancer"
      ),
        p(br()), 

        p(tags$b("How many success / events in every group, x")),
        tags$textarea(id = "xx", rows = 5,
        "320\n1206\n1011\n463\n220"        
        ),

        p(tags$b("How many trials / samples in every group, n > x")),     
        tags$textarea(id = "nn", rows = 5,
        "1742\n5638\n3904\n1555\n626"
        ),

    p("Note: No Missing Value"),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("In this example, we had 5 age groups of people as shown in n, and we record the number of people who had cancer in x."))
    ),

        hr(),

    h4(tags$b("Hypothesis")),

     p(tags$b("Null hypothesis")), 

      p("The probability/proportion are equal over the groups"),
      
      p(tags$b("Alternative hypothesis")), 
       p("The probability/proportions are not equal"),          
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("In this example,  we wanted to know if the probability to have cancer were different among different age groups."))
    )
   

    ),

      mainPanel(

      h4(tags$b("Output 1. Data Preview")), p(br()), 

      tabsetPanel(
        tabPanel("Table",p(br()),
          
        p(tags$b("Data Table")),

        DT::DTOutput("n.t")

          ),
        tabPanel("Percentage Plot",p(br()),
          plotly::plotlyOutput("makeplot3", width = "80%")

          )
        ),

      hr(),

      h4(tags$b("Output 2. Test Results")), p(br()), 

      DT::DTOutput("n.test"),


     HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then the population proportion/rate are significantly different. (Accept alternative hypothesis)
    <li> P Value >= 0.05, then the population proportion/rate are NOT significantly different. (Accept null hypothesis)
    </ul>"
  ),
conditionalPanel(
    condition = "input.explain_on_off",
     p(tags$i("In this default setting, we concluded that the probability to have cancer were significantly different in different age groups. (P < 0.001)"))
     )

        )
      )
