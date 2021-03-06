#****************************************************************************************************************************************************1.prop1
  sidebarLayout(

    sidebarPanel(

    h4(tags$b("Step 1. Data Preparation")),

    p(tags$b("Give names to your data")),
    tags$textarea(id = "ln", rows = 2, "Infertility\nfertility "), p(br()),
    
    p(tags$b("Please follow the example to input your data")),

      numericInput("x", "How many success/events, x", value = 10, min = 0, max = 100000, step = 1),
      numericInput("n", "How many trials/samples, n > x", value = 40, min = 1, max = 100000, step = 1),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("In the example, the number of events was 10 and the total sample size was 40."))
    ),
    hr(),

    h4(tags$b("Step 2. Specify Parameter")),

      numericInput('p', HTML("The specified rate / proportion / probability (0 < p<sub>0</sub> < 1) that you want to compare with"), value = 0.2, min = 0, max = 1, step = 0.1),
        conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("The infertility rate in general (20%) was what we wanted to compare."))
      ),

      hr(),

    h4(tags$b("Step 3. Choose Hypothesis")),

    p(tags$b("Null hypothesis")), 
    HTML("<p>p = p<sub>0</sub>: the probability/proportion is p<sub>0</sub></p>"),
    
    radioButtons("alt", 
      label = "Alternative hypothesis", 
      choiceNames = list(
        HTML("p &#8800 p<sub>0</sub>: the probability/proportion is not p<sub>0</sub>"),
        HTML("p < p<sub>0</sub>: the probability/proportion is less than p<sub>0</sub>"),
        HTML("p > p<sub>0</sub>: the probability/proportion is greater than p<sub>0</sub>")),
      choiceValues = list("two.sided", "less", "greater")
      ),
    conditionalPanel(
    condition = "input.explain_on_off",
   p(tags$i("In this example, we wanted to test if there was a significant difference in the rate of infertility among treated women compared to 20% the general infertile rate, so we used the first alternative hypothesis"))
   )

      ),

  mainPanel(

    h4(tags$b("Output 1. Proportion Plot")), p(br()), 

    plotly::plotlyOutput("makeplot"),

    hr(),

    h4(tags$b("Output 2. Test Results")), p(br()), 

    HTML("<b>1. Normal Theory Method with Yates' Continuity Correction, when np<sub>0</sub>(1-p<sub>0</sub>) >= 5</b>"), p(br()), 

    DT::DTOutput("b.test1"),

    HTML("<b>2. Exact Binomial Method, when np<sub>0</sub>(1-p<sub>0</sub>) < 5</b>"),  
    p(br()), 

    DT::DTOutput("b.test"),

     HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then the population proportion/rate IS significantly different from the specified proportion/rate. (Accept the alternative hypothesis)</li>
    <li> P Value >= 0.05, then the population proportion/rate IS NOT significantly different from the specified proportion/rate. (Accept the null hypothesis)</li>
    </ul>"
  ),
    conditionalPanel(
    condition = "input.explain_on_off",
  HTML("<i> From the default settings, we concluded that there was no significant difference in the rate of infertility among homozygous women compared to the general infertility rate (P = 0.55). In this case, np<sub>0</sub>(1-p<sub>0</sub>)=40*0.2*0.8 > 5, so the <b>Normal Theory Method</b> was preferable. </i>")
  )


    )
  )
