##----------------------------------------------------------------
##
## Chi-square test  ui EN
##
## 2018-11-30
## 
##----------------------------------------------------------------

shinyUI(
tagList(
#shinythemes::themeSelector(),
navbarPage(
 
  title = "Contingency Table of Counts",

## 1. Chi-square test for 2 by 2 table ---------------------------------------------------------------------------------
tabPanel("Chi-square Test (R x C Table)",

titlePanel("Chi-square Test"),

tags$b("Introduction"),

p("R x C contingency table is a table with R rows (R categories) and C columns (C categories)."),
p(" To determine whether there is significant relationship between two discrete variables, where one variable has R categories and the other has C categories. "),

tags$b("Assumptions"),
tags$ul(
  tags$li("No more than 1/5 of the cells have expected values < 5"),
  tags$li("No cell has an expected value < 1")
  ),

p(br()),
sidebarLayout(

sidebarPanel(

  helpText("Configurations of the table"),
  numericInput("r", "How many rows, R", value = 2, min = 2, max = 9, step = 1, width = "50%"),
  verticalLayout(
  tags$b("Row names"), 
  tags$textarea(id="rn", rows=4, cols = 30, "R1\nR2"),
  helpText("Row names must be corresponding to number of rows")),
  numericInput("c", "How many columns, C", value = 2, min = 2, max = 9, step = 1, width = "50%"),
  verticalLayout(
  tags$b("Column names"),
  tags$textarea(id="cn", rows=4, cols = 30, "C1\nC2"),
  helpText("Column names must be corresponding to number of columns"))
  
  ),

mainPanel(
  wellPanel(
  h4(tags$b("Input Data")),
  helpText("Input your values by column, for example, the second column follows the first column"),
  tabPanel("Manually input values",
  tags$textarea(id="x", rows=10, "10\n20\n30\n35"))),
  hr(),
  h4("Display of the Contingency table"), dataTableOutput("ct"),
  hr(),
  h3(tags$b("Results of the Chi-Square Test")), tableOutput("c.test"),
  tags$b("Expected value in each cell"),
  tableOutput("c.e"),
  #tags$b("Interpretation"), p("The meaning"),
  hr(),
  h3(tags$b("Percentages")),
  h4("Percentages for rows"), tableOutput("prt"),
  h4("Percentages for columns"), tableOutput("pct"),
  h4("Percentages for total"), tableOutput("pt"),
  hr(),
  h3(tags$b('Barplot of frequency (counts)')), plotOutput("makeplot", width = "600px", height = "300px")))),

## 2. Chi-square test for Test for Trend ---------------------------------------------------------------------------------
tabPanel("Test for Trend (2 x K Table)",

titlePanel("Test for Trend"),

tags$b("Introduction"),

p("To determine whether an increasing or decreasing trend in proportions."),

p(br()),
sidebarLayout(

sidebarPanel(
helpText("Two ways of importing your data sets"),

  tabsetPanel(
  ##-------input data-------## 
  tabPanel("Manually input values", p(br()),
    helpText("Missing value is input NA"),
    tags$textarea(id="suc", rows=10, "320\n1206\n1011\n463\n220"),
    tags$textarea(id="fail", rows=10, "1422\n4432\n2893\n1092\n406")), 
    helpText("Case data are input left, while control data are input right"),

  ##-------csv file-------##   
  tabPanel("Upload .csv file", p(br()),
    fileInput('file2', 'Choose .csv File', accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    #checkboxInput('header', 'Header', TRUE),
    radioButtons('sep', 'Separator', c(Comma=',', Semicolon=';', Tab='\t'), ',')))),

  mainPanel(
  h4("Display of the Contingency table"), dataTableOutput("ct.tr"),
  helpText("Note: Percentage is Case/Total"),
  hr(),
  h3(tags$b("Results of the Test for Trend, Case out of Total")), tableOutput("tr.test"),
  #tags$b("Interpretation"), p("The meaning"),
  hr(),
  h3(tags$b('Barplot of Case Percentage')), plotOutput("makeplot.tr", width = "600px", height = "300px"))
  )),

## 3. Goodness-of-Fit Test, kappa ---------------------------------------------------------------------------------
tabPanel("Kappa Statistic (K x K Table)",

titlePanel("Kappa Statistic"),

tags$b("Introduction"),

p("To qualify the degree of association. This is particularly true in reliability studies, where the researcher want to qualify the reproducibility of the same variable measured more than once."),

sidebarLayout(
sidebarPanel(

helpText("Configurations of the table"),
  numericInput("r.k", "How many raters in both survey, R", value = 2, min = 2, max = 9, step = 1, width = "50%"),
  verticalLayout(
  tags$b("Rater names"), 
  tags$textarea(id="rater", rows=4, cols = 30, "Yes\nNo"))),

mainPanel(
  h4(tags$b("Input Data")),
  helpText("Input the counts by column, for example, the second column follows the first column"),
  tabPanel("Manually input values",
  tags$textarea(id="k", rows=10, "136\n69\n92\n240")),
  hr(),
  h4("Display of the Contingency table"), dataTableOutput("kt"),
  helpText("Row is the rater of measurement-A, while Column is measurement-B"),
  hr(),
  h3(tags$b("Results of the Kappa Statistic, k")), tableOutput("k.test"),
  tags$b("Notes"),
  HTML("
  <ul>
  <li> k > 0.75 denotes excellent reproducibility </li>
  <li> 0.4 < k < 0.75 denotes good  reproducibility</li>
  <li> 0 < k < 0.4 denotes marginal reproducibility </li>
  </ul>" )

  #tags$b("Interpretation"), p("The meaning")
  )

))
,
  tabPanel(
      tags$button(
      id = 'close',
      type = "button",
      class = "btn action-button",
      onclick = "setTimeout(function(){window.close();},500);",  # close browser
      "Stop App")
),
tabPanel(
     tags$button(
     id = 'close',
     type = "button",
     class = "btn action-button",
     onclick ="window.open('https://pharmacometrics.info/mephas/index_jp.html')","top"))

))
)

