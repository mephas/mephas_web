#****************************************************************************************************************************************************1 way

sidebarLayout(

sidebarPanel(

h4(tags$b("COne-way ANOVA")),

  h4(tags$b("Step 1. Data Preparation")),

  p(tags$b("1. Give names to your Values and Factor Group ")),

  tags$textarea(id = "cn1", rows = 2, "FEF\nSmoke"),p(br()),

  p(tags$b("2. Input data")),

tabsetPanel(
      ##-------input data-------##
    tabPanel("Manual Input", p(br()),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("Example here was the FEF data from smokers and smoking groups. Detailed information can be found in the Output 1."))
    ),

    p(tags$b("Please follow the example to input your data")),
  p("Data point can be separated by , ; /Enter /Tab"),

    p(tags$b("Sample Values")),
      tags$textarea(id = "x1",rows = 10,
"3.53\n3.55\n3.50\n5.40\n3.43\n3.22\n2.94\n3.85\n2.91\n3.94\n3.50\n3.38\n4.15\n4.26\n3.71\n1.77\n2.11\n1.92\n3.65\n2.35\n3.26\n3.73\n2.36\n3.75\n3.21\n2.78\n2.95\n4.52\n3.41\n3.56\n2.48\n3.16\n2.11\n3.89\n2.10\n2.87\n2.77\n4.59\n3.66\n3.55\n2.49\n3.48\n3.28\n3.04\n3.49\n2.13\n3.56\n2.88\n2.30\n4.38"
),
    p(tags$b("Factor group")),
      tags$textarea(id = "f11",rows = 10,
"NS\nLS\nLS\nPS\nLS\nHS\nMS\nNS\nPS\nNI\nMS\nLS\nNI\nNS\nMS\nPS\nMS\nLS\nPS\nHS\nMS\nMS\nHS\nLS\nHS\nMS\nHS\nNS\nLS\nNS\nHS\nMS\nHS\nNS\nLS\nNI\nMS\nPS\nLS\nPS\nNI\nLS\nLS\nHS\nLS\nHS\nLS\nMS\nHS\nNS"
),

    p("Missing value is input as NA to ensure 2 sets have equal length; otherwise, there will be error")

        ),
tabPanel.upload(file ="file1", header="header1", col="col1", sep="sep1", quote = "quote1")

),
hr(),
  h4(tags$b("Hypothesis")),
  p(tags$b("Null hypothesis")),
  p("The means from each group are equal"),
  p(tags$b("Alternative hypothesis")),
  p("At least two factor groups have significant different means"),
  conditionalPanel(
    condition = "input.explain_on_off",
  p(tags$i("In this example, we wanted to know if the FEF values were different among the 6 smoking groups"))
  )

),

mainPanel(

  h4(tags$b("Output 1. Descriptive Results")),

    tabsetPanel(

    tabPanel("Data Preview", p(br()),
        DT::DTOutput("table1"),
        p(tags$b("The categories in the Factor Group")),
        DT::DTOutput("level.t1")
        ),

    tabPanel("Descriptive Statistics", p(br()),
      p(tags$b("Descriptive statistics by group")),
      DT::DTOutput("bas1.t")#,
         #p(br()),
        #downloadButton("download1.1", "Download Results")
      ),
    tabPanel("Box Plot",p(br()),

      plotly::plotlyOutput("mbp1"),
    HTML(
    "<b> Explanations </b>
    <ul>
      <li> The band inside the box is the median</li>
      <li> The box measures the difference between 75th and 25th percentiles</li>
      <li> Outliers will be in red, if existing</li>
    </ul>"

    )
      ),

    tabPanel("Mean and SD Plot",p(br()),

      plotly::plotlyOutput("mmean1")
      )
    ),

    hr(),

  h4(tags$b("Output 2. ANOVA Table")), p(br()),

  DT::DTOutput("anova1"),p(br()),
  HTML(
  "<b> Explanations </b>
  <ul>
    <li> DF<sub>Factor</sub> = [number of factor group categories] -1</li>
    <li> DF<sub>Residuals</sub> = [number of sample values] - [number of factor group categories]</li>
    <li> MS = SS/DF</li>
    <li> F = MS<sub>Factor</sub> / MS<sub>Residuals</sub> </li>
    <li> P Value < 0.05, then the population means are significantly different among factor groups. (Accept alternative hypothesis)</li>
    <li> P Value >= 0.05, then there is NO significant differences in the factor groups. (Accept null hypothesis) </li>
  </ul>"
    ),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("In this example, smoking groups showed significant, so we could conclude that FEF were significantly different among the 6 groups. "))
    ),
        #downloadButton("download1", "Download Results"),

    hr(),
    HTML("<p><b>When P < 0.05,</b> if you want to find which pairwise factor groups are significantly different, please continue with <b>Multiple Comparison</b></p>")



  )
)
