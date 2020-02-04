#****************************************************************************************************************************************************2.np2

sidebarLayout(

sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")),

  p(tags$b("1. Give names to your data (Required)")),

  tags$textarea(id="cn2", rows=2, "Group1\nGroup2"), p(br()),

  p(tags$b("2. Input data")),

  tabsetPanel(
  ##-------input data-------##
  tabPanel("Manual input", p(br()),
        conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("The example shown here was the Depression Rating Scale factor measurements of 19 patients from two groups of patients."))
      ),

    p(tags$b("Please follow the example to input your data")),
  p("Data points can be separated by , ; /Enter /Tab /Space"),
    p(tags$b("Group 1")),
    tags$textarea(id="x1",
    rows=10,
    "1.83\n0.50\n1.62\n2.48\n1.68\n1.88\n1.55\n3.06\n1.30\nNA"
    ),

    p(tags$b("Group 2")),## disable on chrome
    tags$textarea(id="x2",
      rows=10,
      "0.80\n0.83\n1.89\n1.04\n1.45\n1.38\n1.91\n1.64\n0.73\n1.46"
      ),

    p("Missing values are input as NAs to ensure 2 sets have equal length; otherwise, there will be error")
    ),

  tabPanel.upload.num(file ="file2", header="header2", col="col2", sep="sep2")

        ),

  hr(),

    h4(tags$b("Step 2. Choose Hypothesis")),

    p(tags$b("Null hypothesis")),

    HTML("<p> m&#8321 = m&#8322: the medians of two group are equal </p>
          <p> Or, the distribution of values for each group are equal </p>"),

radioButtons("alt.wsr2", label = "Alternative hypothesis",
  choiceNames = list(
    HTML("m&#8321 &#8800 m&#8322: the population medians of each group are not equal"),
    HTML("m&#8321 < m&#8322: the population median of Group 2 is greater"),
    HTML("m&#8321 > m&#8322: the population median of Group 1 is greater")),
  choiceValues = list("two.sided", "less", "greater")),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("In this default setting, we wanted to know if the Depression Rating Scale from two groups of patients were different."))
      ),
    hr(),


  h4(tags$b("Step 3. Decide P Value method")),
  radioButtons("alt.md2",
    label = "What is the data like", selected = "c",
    choiceNames = list(
      HTML("Approximate normal distributed P value: sample size is large"),
      HTML("Asymptotic normal distributed P value: sample size is large"),
      HTML("Exact P value: sample size is small (< 50)")
      ),
    choiceValues = list("a", "b", "c")),
      conditionalPanel(
    condition = "input.explain_on_off",
      p(tags$i("The sample sizes in each group were 9 and 10, so we used the exact p value."))
      )

  ),

mainPanel(

  h4(tags$b("Output 1. Descriptive Results")),

  tabsetPanel(

    tabPanel("Data Preview", p(br()),

      DT::DTOutput("table2")
      ),

    tabPanel("Basic Descriptives", p(br()),

        DT::DTOutput("bas2")#,

      #p(br()),
      #  downloadButton("download2b", "Download Results")
      ),

    tabPanel("Box-Plot", p(br()),
        plotly::plotlyOutput("bp2"),#, click = "plot_click2"

        #verbatimTextOutput("info2"),
        hr(),
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
          </ul>"),
      p(tags$b("Histogram")),
      plotly::plotlyOutput("makeplot2"),
      sliderInput("bin2", "The number of bins in histogram",min = 0,max = 100,value = 0),
      p("When the number of bins is 0, plot will use the default number of bins"),
      p(tags$b("Density plot")),
      plotly::plotlyOutput("makeplot2.1")
      )
    ),
  hr(),

  h4(tags$b("Output 2. Test Results")),
  tags$b('Results of Wilcoxon Rank-Sum Test'), p(br()),

  DT::DTOutput("mwu.test.t"), p(br()),

  HTML(
    "<b> Explanations </b>
    <ul>
    <li> P Value < 0.05, then the population medians of 2 groups are significantly different. (Accept alternative hypothesis)</li>
    <li> P Value >= 0.05, no significant differences between the medians of 2 groups. (Accept null hypothesis)</li>
    </ul>"
  ),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("From the default settings, we concluded that there was no significant differences in 2 groups Rating scale (P=0.44)."))
    )#,


 # downloadButton("download2.1", "Download Results")

  )
)
