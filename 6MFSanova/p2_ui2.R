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

  p(tags$b("1. Give names to your Values and Group")),

  tags$textarea(id = "cn2", rows = 3, "Time\nGrade\nER"),p(br()),

  p(tags$b("2. Input data")),

tabsetPanel(
      ##-------input data-------##
    tabPanel("Manual Input", p(br()),

    p(tags$i("Example here was the AGE of 27 lymph node positive patients with Estrogen receptor (ER) positive (Group.1-Age.positive); and 117 patients with ER negative (Group.2-Age.negative)")),

    p(tags$b("Please follow the example to input your data")),

    p(tags$b("Value")),
      tags$textarea(id = "x",rows = 10,
"7.75\n4.66\n8.74\n7.57\n7.3\n6.72\n7\n9.33\n3.44\n15.33\n5.49\n3.66\n1.61\n17.24\n0.96\n14.01\n17.66\n7.87\n2.81\n4.45\n16.15\n8.13\n15.31\n15.82\n1.61\n14.89\n13.35\n1.39\n13.75\n12.57\n8.93\n13.17\n2.61\n11.32\n1.21\n11.74\n12.5\n11.26\n11.92\n2.7\n12.47\n11.55\n11.2\n11.05\n11.14\n10.77\n11.04\n10.67\n6.57\n11.2\n1.97\n1.72\n2.34\n10.33\n2.48\n9.98\n11.55\n5.64\n5.32\n8.99\n2.3\n5.12\n8.3\n8.59\n2.22\n7.25\n6.79\n6.93\n0.94\n7.25\n7\n0.05\n0.65\n5.11\n5.29\n7.34\n5.74\n5.33\n3.92\n6.07\n0.35\n4.97\n11.65\n6.31\n6.14\n9.6\n9.46\n2.85\n9.33\n9.19\n1.97\n9.32\n8.56\n9.1\n4.22\n3.22\n8.24\n2.34\n9.89\n1.5"
),
    p(tags$b("Factor 1")),
      tags$textarea(id = "f1",rows = 10,
"Intermediate\nWell diff\nWell diff\nIntermediate\nPoorly diff\nIntermediate\nPoorly diff\nPoorly diff\nPoorly diff\nWell diff\nIntermediate\nPoorly diff\nIntermediate\nIntermediate\nIntermediate\nPoorly diff\nPoorly diff\nWell diff\nPoorly diff\nIntermediate\nWell diff\nWell diff\nPoorly diff\nPoorly diff\nPoorly diff\nIntermediate\nWell diff\nPoorly diff\nPoorly diff\nIntermediate\nPoorly diff\nIntermediate\nPoorly diff\nWell diff\nPoorly diff\nIntermediate\nIntermediate\nWell diff\nWell diff\nIntermediate\nIntermediate\nIntermediate\nWell diff\nWell diff\nIntermediate\nIntermediate\nPoorly diff\nPoorly diff\nWell diff\nWell diff\nPoorly diff\nPoorly diff\nPoorly diff\nWell diff\nPoorly diff\nIntermediate\nPoorly diff\nIntermediate\nIntermediate\nWell diff\nPoorly diff\nIntermediate\nIntermediate\nWell diff\nPoorly diff\nIntermediate\nPoorly diff\nPoorly diff\nPoorly diff\nPoorly diff\nIntermediate\nIntermediate\nPoorly diff\nWell diff\nWell diff\nIntermediate\nWell diff\nPoorly diff\nIntermediate\nIntermediate\nPoorly diff\nWell diff\nIntermediate\nWell diff\nIntermediate\nIntermediate\nWell diff\nIntermediate\nWell diff\nIntermediate\nPoorly diff\nIntermediate\nIntermediate\nPoorly diff\nIntermediate\nIntermediate\nWell diff\nWell diff\nPoorly diff\nIntermediate"
),
      p(tags$b("Factor 2")),
      tags$textarea(id = "f2",rows = 10,
"Positive\nPositive\nPositive\nPositive\nNegative\nPositive\nPositive\nNegative\nNegative\nPositive\nPositive\nPositive\nNegative\nNegative\nPositive\nPositive\nPositive\nPositive\nNegative\nPositive\nPositive\nPositive\nPositive\nPositive\nPositive\nPositive\nPositive\nPositive\nPositive\nPositive\nNegative\nPositive\nPositive\nPositive\nNegative\nNegative\nPositive\nPositive\nPositive\nPositive\nPositive\nNegative\nPositive\nNegative\nPositive\nPositive\nPositive\nPositive\nPositive\nPositive\nPositive\nNegative\nPositive\nPositive\nNegative\nPositive\nPositive\nPositive\nPositive\nPositive\nNegative\nPositive\nPositive\nPositive\nPositive\nPositive\nNegative\nPositive\nNegative\nPositive\nPositive\nPositive\nNegative\nPositive\nPositive\nPositive\nPositive\nPositive\nPositive\nPositive\nPositive\nPositive\nPositive\nPositive\nPositive\nPositive\nPositive\nPositive\nPositive\nPositive\nNegative\nPositive\nPositive\nNegative\nPositive\nPositive\nPositive\nPositive\nPositive\nPositive"
),

    p("Missing value is input as NA to ensure 3 sets have equal length; otherwise, there will be error")

        ),
      ##-------csv file-------##
tabPanel("Upload Data", p(br()),

    p(tags$b("This only reads the first 2-column of your data")),
    fileInput('file1', "Choose CSV/TXT file",
              accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
    #helpText("The columns of X are not suggested greater than 500"),
    p(tags$b("2. Show 1st row as header?")),
    checkboxInput("header1", "Show Data Header?", TRUE),

    radioButtons("sep1", 
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
  p("The means from each group are equal"),
  p(tags$b("Alternative hypothesis")),
  p("At least two groups have significant different means"),
  p(tags$i("In this default settings, we wanted to know if the ages of patients with ER positive was significantly different from patients with ER negative")),
  p(br()),
),

mainPanel(

  h4(tags$b("Output 1. Descriptive Results")),

    tabsetPanel(

    tabPanel("Data Preview", p(br()),
        DT::dataTableOutput("table1",width = "500px")
        ),

    tabPanel("Descriptive Statistics", p(br()),
      p(tags$b("Descriptive statistics by group")),
      tableOutput("bas1.t"),
         p(br()), 
        downloadButton("download1.1", "Download Results")
      ),

    tabPanel("Marginal Means Plot",p(br()),

      plotOutput("mmean1", width = "500px", height = "400px")
      )
    ),

    hr(),

  h4(tags$b("Output 2. ANOVA Table")), p(br()),

  tableOutput("anova1"),p(br()),
  HTML(
  "<b> Explanations </b>
  <ul> 
    <li> P Value < 0.05, then the population means are significantly different among groups. (Accept alternative hypothesis)
    <li> P Value >= 0.05, then there is NO significant differences in the groups. (Accept null hypothesis) 
  </ul>"
    ),

  downloadButton("download1", "Download Results")
  )
)