##----------#----------#----------#----------
##
## 6MFSanova UI
##
##		> P1
##
## Language: EN
## 
## DT: 2019-05-04
##
##----------#----------#----------#----------
sidebarLayout(

sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")), 

  p(tags$b("1. Give names to your Values and 2 Factors Group variables ")),

  tags$textarea(id = "cn", rows = 3, "SBP\nDiet\nSex"),p(br()),

  p(tags$b("2. Input data")),

tabsetPanel(
      ##-------input data-------##
    tabPanel("Manual Input", p(br()),

    p(tags$i("Example here was the full metastasis-free follow-up time (months) of 100 lymph node positive patients under 3 grades of the tumor and 2 levels of ER.")),

    p(tags$b("Please follow the example to input your data")),
  p("Data point can be separated by , ; /Enter /Tab"),

    p(tags$b("Sample Values")),
      tags$textarea(id = "x",rows = 10,
 "110.29\n110.79\n110.29\n110.87\n109.71\n109.85\n109.55\n110.37\n109.77\n109.97\n108.99\n110.05\n110.78\n109.41\n110.26\n110.16\n109.43\n110.05\n110.36\n110.02\n109.12\n110.2\n110.72\n109.99\n109.24\n110.16\n109.73\n110.71\n110.69\n111.05\n109.42\n110.13\n110.8\n109.74\n110.05\n109.23\n110.84\n110.03\n109.61\n109.75\n109.33\n110.02\n109.46\n110.75\n110.14\n109.24\n109.13\n109.43\n111.03\n109.65\n110.73\n109.83\n109.01\n110.36\n109.67\n109.57\n109.47\n110.78\n108.87\n109.04\n110.73\n110.2\n110.71\n110.34\n110.63\n108.63\n110.42\n109.06\n109.99\n109.67\n102.89\n103.99\n102.36\n101.88\n102.39\n101.41\n103.11\n102.2\n102.02\n101.49\n102.73\n103.05\n102.96\n104.27\n103.59\n101.46\n103.77\n102.8\n102.56\n102.51\n103.07\n102.19\n102.48\n102.75\n102.34\n103.16\n103.46\n102.14\n102.88\n102.52\n115.53\n115.32\n115.22\n115.56\n115.68\n115.3\n115.05\n115.79\n115.27\n115.35\n115.81\n115.66\n116.16\n115.49\n115.45\n115.99\n114.47\n116.69\n114.98\n116.38\n115.33\n116.58\n115.67\n115.34\n115.75\n115.67\n115.93\n115.27\n116.17\n115.71\n105.3\n105.57\n105.59\n105.72\n104.02\n105.95\n106.26\n103.9\n104.92\n104.06\n105.77\n104.92\n105.27\n104.78\n105.31\n105.36\n105.54\n105.2\n104.17\n105.37\n105.07\n104.67\n105.67\n104.84\n105.46\n105.9\n104.69\n106.1\n105.31\n104.83\n127.11\n127.14\n128.31\n129.25\n129.51\n129.17\n128.97\n127.75\n128.46\n130.18\n128.21\n128.44\n127.83\n128.07\n128.27\n128.41\n127.45\n128.46\n128.76\n128.63\n127.88\n128.69\n125.62\n128.92\n127.57\n128.78\n128.85\n128.41\n129.07\n127.59\n127.07\n128.78\n129.92\n127.46\n128.19\n127.37\n127.43\n129.07\n127.36\n126.17\n128.38\n128.3\n128.74\n127.94\n128.07\n129.86\n127.32\n127.14\n128.68\n128.35\n129.62\n126.94\n128.41\n129.63\n128.63\n119.75\n120.21\n120\n119.42\n121.13\n119.41\n120.13\n119.66\n120.2\n119.82\n119.57\n119.49\n119.23\n119.56\n119.34\n120.13\n119.48\n120.62\n119.93\n121.9\n119.66\n121.26\n119.8\n118.92\n120.36\n120.67\n119.16\n119.94\n118.35\n118.99\n118.76\n119.74\n119.52\n120.68\n119.23\n119.93\n120.66\n120.34\n119.88\n120.4\n120.79\n119.63\n118.95\n120.1\n119.42"
),
    p(tags$b("Factor 1")),
      tags$textarea(id = "f1",rows = 10,
"SV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM"
),
      p(tags$b("Factor 2")),
      tags$textarea(id = "f2",rows = 10,
"Male\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale"
),

    p("Missing value is input as NA to ensure 3 sets have equal length; otherwise, there will be error")

        ),
      ##-------csv file-------##
tabPanel("Upload Data", p(br()),

    p(tags$b("This only reads the first 3-column of your data")),
    p(tags$b("1st column is numeric values")),
    p(tags$b("2nd and 3rd columns are factors / group variables" )),
    fileInput('file', "Choose CSV/TXT file",
              accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
    #helpText("The columns of X are not suggested greater than 500"),
    p(tags$b("2. Show 1st row as header?")),
    checkboxInput("header", "Show Data Header?", TRUE),

    radioButtons("sep", 
      "Which Separator for Data?",
      choiceNames = list(
        HTML("Comma (,): CSV often use this"),
        HTML("One Tab (->|): TXT often use this"),
        HTML("Semicolon (;)"),
        HTML("One Space (_)")
        ),
      choiceValues = list(",", ";", " ", "\t")
      ),

    p("Correct Separator ensures data input successfully"),

    a(tags$i("Find some example data here"),href = "https://github.com/mephas/datasets")
    )
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

  p(tags$i("In this example, we wanted to know if the metastasis-free follow-up time was different with grade of the tumor under the controlling for ER"))
),

mainPanel(

  h4(tags$b("Output 1. Descriptive Results")),

    tabsetPanel(

    tabPanel("Data Preview", p(br()),
        DT::dataTableOutput("table",width = "700px")
        ),

    tabPanel("Descriptive Statistics", p(br()),
      p(tags$b("Descriptive statistics by group")),
      tableOutput("bas.t"),
      p(br()), 
      downloadButton("download2.1", "Download Results")
      ),

      tabPanel("Means plot",p(br()),
      checkboxInput('tick', 'Untick to change the group and x-axis', TRUE), #p
      plotOutput("meanp.a", width = "500px", height = "400px")
    ),

      tabPanel("Marginal means plot",p(br()),
      checkboxInput('tick2', 'Untick to change the x-axis', TRUE), #p
      plotOutput("mmean.a", width = "500px", height = "400px")
      )
    ),

    hr(),

  h4(tags$b("Output 2. ANOVA Table")), p(br()),

  p(tags$b("1. The categories in the Factor Groups")),
  tableOutput("level.t21"),
  tableOutput("level.t22"),

  p(tags$b("1. ANOVA Table")),
  checkboxInput('inter', 'Interaction', TRUE),
  tableOutput("anova"),p(br()),
  HTML(
  "<b> Explanations </b>
  <ul> 
    <li> DF<sub>Factor</sub> = [number of factor group categories] -1
    <li> DF<sub>Interaction</sub> = DF<sub>Factor1</sub> x DF<sub>Factor2</sub>  
    <li> DF<sub>Residuals</sub> = [number of sample values] - [number of factor1 group categories] x [number of factor2 group categories]
    <li> MS = SS/DF
    <li> F = MS<sub>Factor</sub> / MS<sub>Residuals</sub>
    <li> P Value < 0.05, then the population means are significantly different among factor groups. (Accept alternative hypothesis)
    <li> P Value >= 0.05, then there is NO significant differences in the factor groups. (Accept null hypothesis) 
  </ul>"
    ),

  p(tags$i("In this example, dietary types and sex both have effects on the SBP (P<0.001), and dietary types also significantly related with sex (P<0.001). ")),


  downloadButton("download2", "Download Results")
  )
)