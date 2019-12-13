##----------#----------#----------#----------
##
## 6MFSanova UI
##
##		> P2
##
## Language: EN
## 
## DT: 2019-05-04
##
##----------#----------#----------#----------
sidebarLayout(
sidebarPanel(
  h4("Hypotheses"),
  tags$b("Null hypothesis 1"),
  HTML("<p>The population means of the first factor are equal. </p>"),
  tags$b("Null hypothesis 2"),
  HTML("<p>The population means of the second factor are equal.</p>"),
  tags$b("Null hypothesis 3"),
  HTML("<p>There is no interaction between the two factors.</p>"),
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
        id = "x", #p
        rows = 10,
        "0.55\n3.22\n1.08\n1.99\n0.93\n2.98\n2.93\n2.41\n1.98\n1.94\n2.27\n2.69\n2.23\n3.87\n1.43\n3.6\n1.51\n1.7\n2.79\n2.96\n4.67\n5.37\n1.77\n3.52\n5.62\n4.22\n3.33\n3.91\n4.85\n3.4"
        )),

      verticalLayout(
      tags$b("Factor 1"), 
      tags$textarea(
        id = "f1", #p
        rows = 10,
        "A1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3"
        )),

      verticalLayout(
      tags$b("Factor 2"), 
      tags$textarea(
        id = "f2", #p
        rows = 10,
        "T1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2"
        ))
      ),
      
  helpText("Change the names of sample (optinal)"),
  tags$textarea(id = "cn", rows = 3, "X\nFactor1\nFactor2") #p
      ), #tabPanel(

    ##-------csv file-------##
    tabPanel(
      "Upload .csv",
      p(br()),
      fileInput(
        'file', 'Choose .csv', #p
        accept = c(
          'text/csv',
          'text/comma-separated-values,text/plain',
          '.csv'
          )
        ),
      checkboxInput('header', 'Header', TRUE), #p
      radioButtons('sep', 'Separator', #p
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

  h3(tags$b("ANOVA Table")),
  checkboxInput('inter', 'Interaction', TRUE), #p
  tableOutput("anova"),p(br()),
  downloadButton("download2", "Download Results"),

  hr(),

  h4("Descriptive Statistics"),
  tabsetPanel(
  tabPanel("Data display", p(br()),
  dataTableOutput("table")
  ),

  tabPanel('Basic statistics',p(br()),
  numericInput("grp", 'Choose the factor', 2, 2, 3, 1),
  verbatimTextOutput("bas")
      ),

  tabPanel("Means plot",p(br()),
  checkboxInput('tick', 'Untick to change the group and x-axis', TRUE), #p
  plotOutput("meanp.a", width = "500px", height = "300px")
    ),

  tabPanel("Marginal means plot",p(br()),
    checkboxInput('tick2', 'Untick to change the x-axis', TRUE), #p
  plotOutput("mmean.a", width = "500px", height = "300px")
    )
    )
  )
)