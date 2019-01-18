##----------#----------#----------#----------
##
## 5MFSrctabtest UI
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------

shinyUI(
tagList(
#shinythemes::themeSelector(),
source("../0tabs/font.R",local=TRUE, encoding="UTF-8")$value,
navbarPage(
 
  title = "Contingency Table of Counts",

##---------- Panel 1 ----------
tabPanel("Chi-square Test (R x C Table)",

titlePanel("Chi-square Test"),

HTML("
<b> Notes </b>

<ul>

<li> R x C contingency table is a table with R rows (R categories) and C columns (C categories)
<li> To determine whether there is significant relationship between two discrete variables, where one variable has R categories and the other has C categories

</ul>

<b> Assumptions </b>

<ul>

<li> No more than 1/5 of the cells have expected values < 5
<li> No cell has an expected value < 1

</ul>

  "),

p(br()),
sidebarLayout(

sidebarPanel(

  h4("Configurations"),
  numericInput("r", "How many rows, R", value = 2, min = 2, max = 9, step = 1, width = "50%"),
  verticalLayout(
  tags$b("Row names"), 
  tags$textarea(id="rn", rows=4, cols = 30, "R1\nR2"),
  helpText("Row names must be corresponding to number of rows")),
  numericInput("c", "How many columns, C", value = 2, min = 2, max = 9, step = 1, width = "50%"),
  verticalLayout(
  tags$b("Column names"),
  tags$textarea(id="cn", rows=4, cols = 30, "C1\nC2"),
  helpText("Column names must be corresponding to number of columns")),
  hr(),

  h4("Input Data"),
  helpText("Input your values by column, i.e., the second column follows the first column"),
  tags$textarea(id="x", rows=10, "10\n20\n30\n35")
    ),

mainPanel(

h4("Results of the Chi-Square Test"), 
tableOutput("c.test"),
hr(),

h4("Contingency Table Description"),
tabsetPanel(

tabPanel("Contingency table", p(br()),
  dataTableOutput("ct")
  ),

tabPanel("Percentages", p(br()),
  h4("Percentages for rows"), tableOutput("prt"),
  h4("Percentages for columns"), tableOutput("pct"),
  h4("Percentages for total"), tableOutput("pt")
  ),

tabPanel("Expected value in each cell",p(br()),
  tableOutput("c.e")
  ),

tabPanel("Barplot of frequency (counts)",p(br()),
  plotOutput("makeplot", width = "800px", height = "400px")
  )
  )
  )
)
),


##---------- Panel 2 ----------

tabPanel("Test for Trend (2 x K Table)",

titlePanel("Test for Trend"),


p("To determine whether an increasing or decreasing trend in proportions"),

p(br()),
sidebarLayout(

sidebarPanel(

h4("Data Preparation"),

  tabsetPanel(
  ##-------input data-------## 
  tabPanel("Manual input", p(br()),
    helpText("Missing value is input as NA"),
    tags$textarea(id="suc", rows=10, "320\n1206\n1011\n463\n220"),
    tags$textarea(id="fail", rows=10, "1422\n4432\n2893\n1092\n406")), 
    helpText("Case data are input left, while control data are input right"),

  ##-------csv file-------##   
  tabPanel("Upload .csv", p(br()),
    fileInput('file2', 'Choose .csv File', accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    checkboxInput('header', 'Header', TRUE),
    radioButtons('sep', 'Separator', c(Comma=',', Semicolon=';', Tab='\t'), ',')))),

  mainPanel(

h4("Results of the Test for Trend, Case out of Total"), 
tableOutput("tr.test"),
hr(),

  h4("Contingency Table Description"),
  tabsetPanel(
    tabPanel("Contingency Table",p(br()),
      dataTableOutput("ct.tr"),
      helpText("Note: Percentage = Case/Total")
      ),

    tabPanel("Barplot of Case Percentage",p(br()),
    plotOutput("makeplot.tr", width = "800px", height = "400px")
      )
    )
  )
  )
),

##---------- Panel 3 ----------

tabPanel("Kappa Statistic (K x K Table)",

titlePanel("Kappa Statistic"),

p("To qualify the degree of association. This is particularly true in reliability studies, where the researcher want to qualify the reproducibility of the same variable measured more than once."),

sidebarLayout(
sidebarPanel(

h4("Configurations"),
  numericInput("r.k", "How many raters in both survey, R", value = 2, min = 2, max = 9, step = 1, width = "50%"),
  verticalLayout(
  tags$b("Rater names"), 
  tags$textarea(id="rater", rows=4, cols = 30, "Yes\nNo")),

h4("Input Data"),
  tabPanel("Manually input values",
  tags$textarea(id="k", rows=10, "136\n69\n92\n240")),
  helpText("Input the counts by column, for example, the second column follows the first column")

  ),

mainPanel(

  h4("Results of the Kappa Statistic, k"), tableOutput("k.test"),
  tags$b("Notes"),
  HTML("
  <ul>
  <li> k > 0.75 denotes excellent reproducibility </li>
  <li> 0.4 < k < 0.75 denotes good  reproducibility</li>
  <li> 0 < k < 0.4 denotes marginal reproducibility </li>
  </ul>" ),

  hr(),
  h4("Contingency table"), dataTableOutput("kt"),
  HTML("
    <b> Notes</b>
    <ul>
    <li> Row is the rater of measurement-A, while column is measurement-B
    <li> The last row is the sum of above rows
    </ul>
    ")
  )

)),
##---------- other panels ----------

source("../0tabs/home.R",local=TRUE)$value,
source("../0tabs/stop.R",local=TRUE)$value


))
)

