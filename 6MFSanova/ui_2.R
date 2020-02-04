#****************************************************************************************************************************************************2. 2-way

sidebarLayout(

sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")),

  p(tags$b("1. Give names to your Values and 2 Factors Group variables ")),

  tags$textarea(id = "cn", rows = 3, "SBP\nDiet\nSex"),p(br()),

  p(tags$b("2. Input data")),

tabsetPanel(
      ##-------input data-------##
    tabPanel("Manual Input", p(br()),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("Example here was the full metastasis-free follow-up time (months) of 100 lymph node positive patients under 3 grades of the tumor and 2 levels of ER."))
    ),

    p(tags$b("Please follow the example to input your data")),
  p("Data point can be separated by , ; /Enter /Tab"),

    p(tags$b("Sample Values")),
      tags$textarea(id = "x",rows = 10,
"128.97\n118.76\n128.41\n115.33\n128.07\n110.71\n109.42\n102.20\n110.80\n106.10\n110.20\n116.58\n102.89\n129.92\n129.07\n116.16\n115.71\n102.19\n130.18\n102.73\n109.67\n120.10\n120.20\n110.42\n103.99\n110.05\n109.12\n115.27\n115.30\n119.16\n110.84\n109.47\n104.92\n120.21\n103.11\n119.42\n110.78\n119.56\n120.13\n129.86\n109.74\n116.69\n105.31\n129.51\n127.07\n104.69\n109.99\n119.74\n115.49\n129.63"
),
    p(tags$b("Factor 1")),
      tags$textarea(id = "f1",rows = 10,
"NORM\nNORM\nNORM\nLV\nNORM\nSV\nSV\nSV\nSV\nLV\nSV\nLV\nSV\nNORM\nNORM\nLV\nLV\nSV\nNORM\nSV\nSV\nNORM\nNORM\nSV\nSV\nSV\nSV\nLV\nLV\nNORM\nSV\nSV\nLV\nNORM\nSV\nNORM\nSV\nNORM\nNORM\nNORM\nSV\nLV\nLV\nNORM\nNORM\nLV\nSV\nNORM\nLV\nNORM"
),
      p(tags$b("Factor 2")),
      tags$textarea(id = "f2",rows = 10,
"Male\nFemale\nMale\nMale\nMale\nMale\nMale\nFemale\nMale\nFemale\nMale\nMale\nFemale\nMale\nMale\nMale\nMale\nFemale\nMale\nFemale\nMale\nFemale\nFemale\nMale\nFemale\nMale\nMale\nMale\nMale\nFemale\nMale\nMale\nFemale\nFemale\nFemale\nFemale\nMale\nFemale\nFemale\nMale\nMale\nMale\nFemale\nMale\nMale\nFemale\nMale\nFemale\nMale\nMale"
        ),

    p("Missing value is input as NA to ensure 3 sets have equal length; otherwise, there will be error")

        ),
tabPanel.upload(file ="file", header="header", col="col", sep="sep", quote = "quote")

),
hr(),
  h4(tags$b("Hypothesis")),
  p(tags$b("Null hypothesis")),
  p("1. The population means under the first factor are equal."),
  p("2. The population means under the second factor are equal"),
  p("3. There is no interaction between the two factors"),
  p(tags$b("Alternative hypothesis")),
  p("1. The first factor effects."),
  p("2. The second factor effects"),
  p("3. There is interaction between the two factors"),
  conditionalPanel(
    condition = "input.explain_on_off",
  p(tags$i("In this example, we wanted to know if the metastasis-free follow-up time was different with grade of the tumor under the controlling for ER"))
  )
),

mainPanel(

  h4(tags$b("Output 1. Descriptive Results")),

    tabsetPanel(

    tabPanel("Data Preview", p(br()),
  DT::DTOutput("table"),
  p(tags$b("The categories in the Factor 1")),
  DT::DTOutput("level.t21"),
  p(tags$b("The categories in the Factor 2")),
  DT::DTOutput("level.t22")
        ),

    tabPanel("Descriptive Statistics", p(br()),
      radioButtons("bas.choice",
      "Descriptive statistics by:",
      choiceNames = list(
        HTML("1. Factor1"),
        HTML("2. Factor2"),
        HTML("3. Both factor1 and factor2")
        ),
      choiceValues = list("A", "B", "C")
      ),

      DT::DTOutput("bas.t")
      ),

      tabPanel("Means plot",p(br()),
      #checkboxInput('tick', 'Tick to change the factor group', FALSE), #p
  shinyWidgets::prettySwitch(
   inputId = "tick",
   label = "Change the factor groups", 
   status = "info",
   fill = TRUE
),
      plotly::plotlyOutput("meanp.a")
    ),

      tabPanel("Marginal means plot",p(br()),
      #checkboxInput('tick2', 'Tick to change the factor group', FALSE), #p
  shinyWidgets::prettySwitch(
   inputId = "tick2",
   label = "Change the factor groups", 
   status = "info",
   fill = TRUE
),
      plotly::plotlyOutput("mmean.a")
      )
    ),

    hr(),

  h4(tags$b("Output 2. ANOVA Table")), p(br()),

  #checkboxInput('inter', 'Interaction', TRUE),
  shinyWidgets::prettySwitch(
   inputId = "inter",
   label = "Add interaction", 
   value = TRUE,
   status = "info",
   fill = TRUE
),
  DT::DTOutput("anova"),p(br()),
  HTML(
  "<b> Explanations </b>
  <ul>
    <li> DF<sub>Factor</sub> = [number of factor group categories] -1</li>
    <li> DF<sub>Interaction</sub> = DF<sub>Factor1</sub> x DF<sub>Factor2</sub></li>
    <li> DF<sub>Residuals</sub> = [number of sample values] - [number of factor1 group categories] x [number of factor2 group categories]</li>
    <li> MS = SS/DF</li>
    <li> F = MS<sub>Factor</sub> / MS<sub>Residuals</sub></li>
    <li> P Value < 0.05, then the population means are significantly different among factor groups. (Accept alternative hypothesis)</li>
    <li> P Value >= 0.05, then there is NO significant differences in the factor groups. (Accept null hypothesis) </li>
  </ul>"
    ),

    conditionalPanel(
    condition = "input.explain_on_off",
  p(tags$i("In this example, dietary types and sex both have effects on the SBP (P<0.001), and dietary types also significantly related with sex (P<0.001). "))#,
  ),

      hr(),
    HTML("<p><b>When P < 0.05,</b> if you want to find which pairwise factor groups are significantly different, please continue with <b>Multiple Comparison</b></p>")

  )
)
