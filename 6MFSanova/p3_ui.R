##----------#----------#----------#----------
##
## 6MFSanova UI
##
##		> P3
##
## Language: EN
## 
## DT: 2019-05-04
##
##----------#----------#----------#----------
sidebarLayout(

sidebarPanel(
h4("Hypotheses"),
tags$b("Null hypothesis"),
HTML("<p>The population means of the factor are equal. </p>"),
hr(),

##----Import data----##
h4("Data Preparation"),

tabsetPanel(
  ##-------input data-------##s
  tabPanel(
    "Manual input",
    p(br()),
    helpText("Missing value is input as NA"),

    splitLayout(
    verticalLayout(
    tags$b("Values"), 
    tags$textarea(
      id = "xm", #p
      rows = 10,
      "0.55\n3.22\n1.08\n1.99\n0.93\n2.98\n2.93\n2.41\n1.98\n1.94\n2.27\n2.69\n2.23\n3.87\n1.43\n3.6\n1.51\n1.7\n2.79\n2.96\n4.67\n5.37\n1.77\n3.52\n5.62\n4.22\n3.33\n3.91\n4.85\n3.4"
      )),

    verticalLayout(
    tags$b("Factors"), 
    tags$textarea(
      id = "fm", #p
      rows = 10,
      "A1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3"
      ))
    ),

helpText("Change the names of sample (optinal)"),
tags$textarea(id = "cnm", rows = 2, "X\nA") #p
    ),

 ##-------csv file-------##
  tabPanel(
    "Upload .csv",
    p(br()),
    fileInput(
      'filem', 'Choose .csv', #p
      accept = c(
        'text/csv',
        'text/comma-separated-values,text/plain',
        '.csv'
        )
      ),
    checkboxInput('headerm', 'Header', TRUE), #p
    radioButtons('sepm', 'Separator', #p
      c(
        Comma = ',',
        Semicolon = ';',
        Tab = '\t'
        ),
      ','
      ) 
  ))
),

mainPanel(
h4("Results"),

tabsetPanel(

  tabPanel("Pairwise t-test", p(br()),
  radioButtons("method", "Choose one method", 
  c(Bonferroni = 'bonferroni',
    Holm = 'holm',
    Hochberg = 'hochberg',
    Hommel = 'hommel',
    FDR_Benjamini_Hochberg = 'BH',
    Benjamini_Yekutieli = 'BY'
    ), 
  "bonferroni"),
verbatimTextOutput("multiple")
    ),

  tabPanel("Tukey Honest Significant Differences", p(br()),
    verbatimTextOutput("hsd")
    )
  ),

h4("Data Display"),
dataTableOutput("tablem")

)
)