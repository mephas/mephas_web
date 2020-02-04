#****************************************************************************************************************************************************2.t2
sidebarLayout(

sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")),

  p(tags$b("1. Give names to your groups (Required)")),

  tags$textarea(id = "cn2", rows = 2, "Age.positive\nAge.negative"), p(br()),

    p(tags$b("2. Input data")),

    tabsetPanel(
      ##-------input data-------##
      tabPanel("Manual Input", p(br()),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("Example here was the AGE of 27 lymph node positive patients with Estrogen receptor (ER) positive (Group.1-Age.positive); and 117 patients with ER negative (Group.2-Age.negative)"))
    ),

    p(tags$b("Please follow the example to input your data")),
  p("Missing values can be separated by , ; /Enter /Tab /Space"),

        p(tags$b("Group 1")),
        tags$textarea(id = "x1",rows = 10,
"47\n45\n31\n38\n44\n49\n48\n44\n47\n45\n37\n43\n49\n32\n41\n38\n37\n44\n45\n46\n26\n49\n48\n45\n46"
),
        p(tags$b("Group 2")),
        tags$textarea(id = "x2",rows = 10,
"50\n42\n50\n43\n47\n38\n41\n48\n47\n36\n42\n42\n45\n44\n32\n46\n50\n38\n43\n40\n42\n46\n41\n46\n48"
), 

    p("Missing values are input as NAs to ensure 2 sets have equal length; otherwise, there will be error")

        ),
tabPanel.upload.num(file ="file2", header="header2", col="col2", sep="sep2")

        ),

    hr(),

  h4(tags$b("Choose Hypothesis")),

  h4(tags$b("Step 2. Equivalence of Variance")),
  p("Before doing the T test, we need to check the equivalence of variance and then decide which T test to use"),
  p(tags$b("Null hypothesis")),
  HTML("<p> v1 = v2: Group 1 and Group 2 have equal population variances </p>"),

    radioButtons("alt.t22", #p
      label = "Alternative hypothesis",
      choiceNames = list(
        HTML("v1 &#8800 v2: the population variances of Group 1 and Group 2 are not equal"),
        HTML("v1 < v2: the population variances of Group 1 is less than Group 2"),
        HTML("v1 > v2: the population variances of Group 1 is greater than Group 2")
        ),
      choiceValues = list("two.sided", "less", "greater")),
    hr(),

  h4(tags$b("Step 3. T Test")),

  p(tags$b("Null hypothesis")),
  HTML("<p> &#956&#8321 = &#956&#8322: Group 1 and Group 2 have equal population means </p>"),

    radioButtons("alt.t2", #p
      label = "Alternative hypothesis",
      choiceNames = list(
        HTML("&#956&#8321 &#8800 &#956&#8322: the population means of Group 1 and Group 2 are not equal"),
        HTML("&#956&#8321 < &#956&#8322: the population means of Group 1 is less than Group 2"),
        HTML("&#956&#8321 > &#956&#8322: the population means of Group 1 is greater than Group 2")
        ),
      choiceValues = list("two.sided", "less", "greater")),
    conditionalPanel(
    condition = "input.explain_on_off",
      p(tags$i("In this default settings, we wanted to know if the ages of patients with ER positive was significantly different from patients with ER negative"))
    )


    ),

  mainPanel(

  h4(tags$b("Output 1. Descriptive Results")),

    tabsetPanel(

    tabPanel("Data Preview", p(br()),

      DT::DTOutput("table2")),

    tabPanel("Basic Descriptives", p(br()),

          DT::DTOutput("bas2")
      ),

      tabPanel("Box-Plot",p(br()),

      plotly::plotlyOutput("bp2"), #,click = "plot_click2"

        #verbatimTextOutput("info2"),
        hr(),

          HTML(
          "<b> Explanations </b>
          <ul>
            <li> The band inside the box is the median</li>
            <li> The box measures the difference between 75th and 25th percentiles</li>
            <li> Outliers will be in red, if existing</li>
          </ul>"
            )
         ),

      tabPanel("Mean and SD Plot", p(br()),

        plotly::plotlyOutput("meanp2")),

    tabPanel("Distribution Plots", p(br()),
HTML(
"<b> Explanations </b>
<ul>
<li> Normal Q–Q Plot: to compare randomly generated, independent standard normal data on the vertical axis to a standard normal population on the horizontal axis. The linearity of the points suggests that the data are normally distributed.</li>
<li> Histogram: to roughly assess the probability distribution of a given variable by depicting the frequencies of observations occurring in certain ranges of values</li>
<li> Density Plot: to estimate the probability density function of the data</li>
</ul>"
),
        p(tags$b("Normal Q-Q plot")),
        plotly::plotlyOutput("makeplot2"),
        #plotOutput("makeplot2.2"),
        p(tags$b("Histogram")),
        plotly::plotlyOutput("makeplot2.3"),
        sliderInput("bin2","The number of bins in histogram",min = 0,max = 100,value = 0),
        p("When the number of bins is 0, plot will use the default number of bins"),
        p(tags$b("Density plot")),
        plotly::plotlyOutput("makeplot2.4")

         )

      ),

    hr(),
    h4(tags$b("Output 2. Test Result 1")),

    tags$b("Check the equivalence of 2 variances"),

    DT::DTOutput("var.test"),

    HTML(
    "<b> Explanations </b>
    <ul>
    <li> P value < 0.05, then refer to the <b>Welch Two-Sample t-test</b></li>
    <li> P Value >= 0.05, then refer to <b>Two-Sample t-test</b></li>
    </ul>"
  ),

    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("In this example, P value of F test was about 0.15 (>0.05), indicating the equal variance in the data. Thus, we should refer to the results from 'Two-Sample t-test'"))
    ),

    hr(),
    h4(tags$b("Output 3. Test Result 2")),

    tags$b("Decide the T Test"),

    DT::DTOutput("t.test2"),
    p(br()),

      HTML(
    "<b> Explanations </b>
    <ul>
    <li> P Value < 0.05, then the population means of the Group 1 IS significantly different from Group 2. (Accept the alternative hypothesis)</li>
    <li> P Value >= 0.05, then there are NO significant differences between Group 1 and Group 2. (Accept the null hypothesis)</li>
    </ul>"
  ),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("In this example, we concluded that the age of lymph node positive population with ER positive was not significantly different from ER negative (P=0.55, from 'Two-Sample t-test')"))
    )
    )
  )
