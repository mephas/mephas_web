#****************************************************************************************************************************************************3.npp

sidebarLayout(

sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")),
  p(tags$b("1. Give names to your data (Required)")),

  tags$textarea(id="cn3", rows=3, "Before\nAfter\nAfter-Before"), p(br()),


  p(tags$b("2. Input data")),

  tabsetPanel(

  tabPanel("Manual Input", p(br()),
        conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("The example shown here was the Depression Rating Scale factor measurements of 9 patients Before and After treatment. "))
      ),

    p(tags$b("Please follow the example to input your data")),
    p("Data point can be separated by , ; /Enter /Tab /Space"),
    p(tags$b("Data be copied from CSV (one column) and pasted in the box")), 
      
    p(tags$b("Before")),
    tags$textarea(id="y1",
      rows=10,
    "1.83\n0.50\n1.62\n2.48\n1.68\n1.88\n1.55\n3.06\n1.30"
    ),

    p(tags$b("After")),
    tags$textarea(id="y2",
      rows=10,
      "0.88\n0.65\n0.59\n2.05\n1.06\n1.29\n1.06\n3.14\n1.29"
      ),

    p("Missing values are input as NAs to ensure 2 sets have equal length; otherwise, there will be error")

),

tabPanel.upload.num(file ="file3", header="header3", col="col3", sep="sep3")

    ),

  hr(),

  h4(tags$b("Step 2. Choose Hypothesis")),

  p(tags$b("Null hypothesis")),
  HTML("<p>  m = 0: the difference of medians between X and Y is not zero </p>
        <p>  Or, the distribution of the differences in paired values is symmetric around zero</p> "),

  radioButtons("alt.wsr3", label = "Alternative hypothesis",
    choiceNames = list(
      HTML("m &#8800 0: the difference of medians between X and Y is not zero; the distribution of the differences in paired values is not symmetric around zero"),
      HTML("m < 0: the population median of Y is greater"),
      HTML("m > 0: the population median of X is greater")),
    choiceValues = list("two.sided", "less", "greater")),
      conditionalPanel(
    condition = "input.explain_on_off",
      p(tags$i("In this example, we wanted to know if there was a significant difference on the scale after the treatment. "))
        ),
hr(),

h4(tags$b("Step 3. Decide P Value method")),
radioButtons("alt.md3",
    label = "What is the data like", selected = "c",
    choiceNames = list(
      HTML("Approximate normal distributed P value: sample size is large"),
      HTML("Asymptotic normal distributed P value: sample size is large"),
      HTML("Exact P value: sample size is small (< 50)")
      ),
    choiceValues = list("a", "b", "c")),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("In this example, we had only 9 people. So we chose the exact P value"))
    )

  ),

mainPanel(

  h4(tags$b("Output 1. Descriptive Results")),

  tabsetPanel(

    tabPanel("Data Preview", p(br()),

      DT::DTOutput("table3")
      ),

    tabPanel("Basic Descriptives", p(br()),

        DT::DTOutput("bas3")
  ),

    tabPanel("Box-Plot of the Difference", p(br()),

        plotly::plotlyOutput("bp3"),#click = "plot_click3"

        verbatimTextOutput("info3"), hr(),

          HTML(
          "Notes:
          <ul>
            <li> The band inside the box is the median</li>
            <li> The box measures the difference between 75th and 25th percentiles</li>
            <li> Outliers will be in red, if existing</li>
          </ul>"

          )
      ),

    tabPanel("Histogram", p(br()),
            HTML(
          "Notes:
          <ul>
            <li> Histogram: to roughly assess the probability distribution of a given variable by depicting the frequencies of observations occurring in certain ranges of values</li>
            <li> Density Plot: to estimate the probability density function of the data</li>
          </ul>"
            ),
      p(tags$b("Histogram")),
      plotly::plotlyOutput("makeplot3"),
      sliderInput("bin3", "The number of bins in histogram",min = 0,max = 100,value = 0),
      p("When the number of bins is 0, plot will use the default number of bins"),
      p(tags$b("Density plot")),
      plotly::plotlyOutput("makeplot3.1")

      )
    ),

    hr(),

  h4(tags$b("Output 2. Test Results")),p(br()),
  tags$b('Results of Wilcoxon Signed-Rank Test'),
    DT::DTOutput("psr.test.t"),
      HTML(
    "<b> Explanations </b>
    <ul>
    <li> P Value < 0.05, then the Before and After are significantly different. (Accept the alternative hypothesis)</li>
    <li> P Value >= 0.05, then the Before and After are NOT significantly different. (Accept the null hypothesis)</li>
    </ul>"
  ),
      conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("From the default settings, we concluded that there was no significant difference after the treatment. (P=0.46)"))
    )


)
)
