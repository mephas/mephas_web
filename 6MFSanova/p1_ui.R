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
  h4("Hypotheses"),
  tags$b("Null hypothesis"),
  p("All group means are equal"),

  tags$b("Alternative hypothesis"),
  p("At least two of the group means are not the same"),
  hr(),
  ##----Import data----##
  h4("Data Preparation"),

  tabsetPanel(
    ##-------input data-------##s
    tabPanel(
      "Manual input",
      p(br()),
      helpText("Please input the values and factors' name (missing value is input as NA)"),

      splitLayout(

        verticalLayout(
        tags$b("Values"),
        tags$textarea(
        id = "x1",
        rows = 10,
        "0.55\n3.22\n1.08\n1.99\n0.93\n2.98\n2.93\n2.41\n1.98\n1.94\n2.27\n2.69\n2.23\n3.87\n1.43\n3.6\n1.51\n1.7\n2.79\n2.96\n4.67\n5.37\n1.77\n3.52\n5.62\n4.22\n3.33\n3.91\n4.85\n3.4"
        )),

      verticalLayout(
      tags$b("Factors"), 
      tags$textarea(
        id = "f11", #p
        rows = 10,
        "A1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3"
        ))
      )
      ,

  helpText("Change the names of sample (optinal)"),
  tags$textarea(id = "cn1", rows = 2, "X\nA")),

              ##-------csv file-------##
    tabPanel(
      "Upload .csv",
      p(br()),
      fileInput(
        'file1', 'Choose .csv', #p
          accept = c(
          'text/csv',
          'text/comma-separated-values,text/plain',
          '.csv'
          )
        ),
      checkboxInput('header1', 'Header', TRUE), #p
      radioButtons('sep1', 'Separator', #p
        c(
          Comma = ',',
          Semicolon = ';',
          Tab = '\t'
          ),
        ','
        ))
    )
  ),

mainPanel(
  h4("ANOVA Table"),
  tableOutput("anova1"),p(br()),
  downloadButton("download1", "Download Results"),

  hr(),

  h4("Data Description"),
  tabsetPanel(
    tabPanel("Data Display",p(br()),
    dataTableOutput("table1")
      ),

    tabPanel('Basic Statistics',p(br()),
    verbatimTextOutput("bas1")),

    tabPanel("Marginal means plot",p(br()),
      plotOutput("mmean1", width = "500px", height = "300px")
      )
    )
  )
)