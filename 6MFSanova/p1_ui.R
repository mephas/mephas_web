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

  p(tags$b("Give names to your Values and Group (No space)")),

  tags$textarea(id = "cn1", rows = 2, "Age\nTreatment"),p(br()),

tabsetPanel(
      ##-------input data-------##
    tabPanel("Manual Input", p(br()),

    p(tags$i("Example here was the AGE of 27 lymph node positive patients with Estrogen receptor (ER) positive (Group.1-Age.positive); and 117 patients with ER negative (Group.2-Age.negative)")),

    p(tags$b("Please follow the example to input your data")),

    p(tags$b("Value")),
      tags$textarea(id = "x1",rows = 10,
"-0.26511961\n-0.54637316\n-1.04903701\n-1.31832074\n-0.25564373\n0.07848303\n0.49900123\n-0.28738851\n-0.89865420\n-0.77317795"
),
    p(tags$b("Group")),
      tags$textarea(id = "f11",rows = 10,
    "T1\nT2\nT1\nT2\nT1\nT2\nT1\nT2\nT1\nT2"
),
    #p(tags$b("Group Label")),
    #  tags$textarea(id = "label",rows = 4,
    #"A1\nA2\nA3"
#),
    p("Missing value is input as NA to ensure 2 sets have equal length; otherwise, there will be error")

        ),
      ##-------csv file-------##
tabPanel("Upload Data", p(br()),

    ##-------csv file-------##
    fileInput('file1', "Choose CSV/TXT file",
              accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
    #helpText("The columns of X are not suggested greater than 500"),
    # Input: Checkbox if file has header ----
    checkboxInput("header1", "Show Data Header?", TRUE),

         # Input: Select separator ----
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

    a("Find some example data here",
      href = "https://github.com/mephas/datasets")
    )
)

),

mainPanel(

  h4(tags$b("Output 1. Descriptive Results")),

    tabsetPanel(

    tabPanel("Data Preview", p(br()),

        dataTableOutput("table1"),
        p(tags$b("The Label for the Group Value")),
        tableOutput("label1")
        ),

    tabPanel("Descriptive Statistics", p(br()),
      p(tags$b("Descriptive statistics by group")),
      tableOutput("bas1"),

         HTML(
          "Notes:
          <ul>
            <li> If Skew.2SE > 1, then skewness is significantly different than zero
            <li> If Kurt.2SE > 1, then kurtosis is significantly different than zero
            <li> Normtest.W: the statistic of a Shapiro-Wilk test of normality
            <li> Normtest.p: p value the statistic of a Shapiro-Wilk test of normality
            <li> Normtest.p < 0.05, then data significantly different from normality
          </ul>"
          ),

         p(br()), 
        downloadButton("download1.1", "Download Results")
      ),

    tabPanel("Marginal Means Plot",p(br()),

      plotOutput("mmean1", width = "500px", height = "300px")
      )
    ),

    hr(),

  h4(tags$b("Output 2. ANOVA Results")), p(br()),

  h4(tags$b("1. Hypothesis")),
  p(tags$b("Null hypothesis")),
  p("The means from each group are equal"),
  p(tags$b("Alternative hypothesis")),
  p("At least two groups have significant different means"),
  p(tags$i("In this default settings, we wanted to know if the ages of patients with ER positive was significantly different from patients with ER negative")),
  p(br()),
  h4(tags$b("2. ANOVA Table")),

  tableOutput("anova1"),p(br()),
  downloadButton("download1", "Download Results")
  )
)