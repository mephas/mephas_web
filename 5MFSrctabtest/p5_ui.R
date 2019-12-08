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

##########----------##########----------##########

navbarPage(
 
  title = "Chi-Square Test for Contingency Table",
##---------- Panel 1 ----------
tabPanel("2 by 2",

titlePanel("Chi-square Test for Case-Control Status and Two Independent Samples"),

HTML("
    <h4><b> 1. Goals </b></h4>
    <ul>
      <li> To determine if the population are the same in the 2 independent samples </ul>

    <h4><b> 2. About your Data </b></h4>

      <ul>
      <li> You have 2 categories for case-control status (usually as row names)
      <li> You have 2 samples for 2 factor status (usually shown as column names)
      <li> 2 samples are independent data
      </ul>

    <h4> If all applicable, please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
  
      "),
hr(),
 sidebarLayout(
      sidebarPanel(

        h4(tags$b("Step 1. Data Preparation")),

        p(tags$b("How many cases in Group 1 , x")),
        tags$textarea(id = "x1",
          rows = 5,
        "320\n1206\n1011\n463\n220"        
        ),

        p(tags$b("How many cases in Group 1 , x")),
        tags$textarea(id = "x1",
          rows = 5,
        "320\n1206\n1011\n463\n220"        
        ),

        p(tags$b("How many controls in every factors, n")),     
        tags$textarea(id = "yy",
          rows = 5,
        "1742\n5638\n3904\n1555\n626"
        ),

         p(tags$b("You can change Row names (no space)")),
        tags$textarea(id = "ln3",
          rows = 2,
        "Case\nControl"
      ),

        p(tags$b("You can change Column names (no space)")),
        tags$textarea(id = "gn",
          rows = 5,
        "~20\n20-24\n25-29\n30-34\n34~"
      ),

    p("Note: No Missing Value and n > x"),

    p(tags$i("In this example, we have 5 age groups of people as shown in n, and we record the number of people who have cancer in x.")),

        hr(),

    h4(tags$b("Step 2. Choose Hypotheses and Parameters")),

     h4(tags$b("1. Hypotheses")),
     p(tags$b("Null hypothesis")), 

      p("The probability/proportion are equal over the Groups"),
      
      p(tags$b("Alternative hypothesis")), 
       p("The probability/proportions are not equal"),          

    p(tags$i("In this setting,  We want to know if the probability to have cancer are different among different age groups ."))
   

    ),

      mainPanel(

      h4(tags$b("Output 1. Data Preview")), p(br()), 

      p(tags$b("Data Table")),

      tableOutput("n.t"),

      p(tags$b("Percentage Plot")),

      plotOutput("makeplot3", width = "600px", height = "300px"),

      hr(),

      h4(tags$b("Output 2. Test Results")), p(br()), 

      tableOutput("n.test"),


     HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then the population proportion/rate are significantly different. (Accept alternative hypothesis)
    <li> P Value >= 0.05, then the population proportion/rate are NOT significantly different. (Accept null hypothesis)
    </ul>"
  ),

     p(tags$i("In this default setting, we conclude that the probability to have cancer are significantly different in different age groups. (P < 0.001)"))

        )
      )
    ),

tabPanel("2 by C",

titlePanel("Chi-square Test for Case-Control Status"),

HTML("
    <h4><b> 1. Goals </b></h4>
    <ul>
      <li> To determine if the population rate/proportion behind your multiple Groups data are significantly different </ul>

    <h4><b> 2. About your data </b></h4>

      <ul>
      <li> Your Groups data come from binomial distribution (the proportion of success)
      <li> You know the whole sample and the number of specified events (the proportion of sub-group) from each Groups
      <li> The multiple Groups are independent observations
      </ul>

    <h4> If all applicable, please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
  
      "),
hr(),
 sidebarLayout(
      sidebarPanel(

        h4(tags$b("Step 1. Data Preparation")),

        p(tags$b("How many cases in every factors, x")),
        tags$textarea(id = "xx",
          rows = 5,
        "320\n1206\n1011\n463\n220"        
        ),

        p(tags$b("How many controls in every factors, n")),     
        tags$textarea(id = "yy",
          rows = 5,
        "1742\n5638\n3904\n1555\n626"
        ),

         p(tags$b("You can change Row names (no space)")),
        tags$textarea(id = "ln3",
          rows = 2,
        "Case\nControl"
      ),

        p(tags$b("You can change Column names (no space)")),
        tags$textarea(id = "gn",
          rows = 5,
        "~20\n20-24\n25-29\n30-34\n34~"
      ),

    p("Note: No Missing Value and n > x"),

    p(tags$i("In this example, we have 5 age groups of people as shown in n, and we record the number of people who have cancer in x.")),

        hr(),

    h4(tags$b("Step 2. Choose Hypotheses and Parameters")),

     h4(tags$b("1. Hypotheses")),
     p(tags$b("Null hypothesis")), 

      p("The probability/proportion are equal over the Groups"),
      
      p(tags$b("Alternative hypothesis")), 
       p("The probability/proportions are not equal"),          

    p(tags$i("In this setting,  We want to know if the probability to have cancer are different among different age groups ."))
   

    ),

      mainPanel(

      h4(tags$b("Output 1. Data Preview")), p(br()), 

      p(tags$b("Data Table")),

      tableOutput("n.t"),

      p(tags$b("Percentage Plot")),

      plotOutput("makeplot3", width = "600px", height = "300px"),

      hr(),

      h4(tags$b("Output 2. Test Results")), p(br()), 

      tableOutput("n.test"),


     HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then the population proportion/rate are significantly different. (Accept alternative hypothesis)
    <li> P Value >= 0.05, then the population proportion/rate are NOT significantly different. (Accept null hypothesis)
    </ul>"
  ),

     p(tags$i("In this default setting, we conclude that the probability to have cancer are significantly different in different age groups. (P < 0.001)"))

        )
      )
    ),

##---------- Panel 2 ----------


tabPanel("R by C",

titlePanel("Chi-square Test for R by C Table"),

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

hr(),
sidebarLayout(

sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")),

  numericInput("r", "How many Rows for your data, R", 
    value = 2, min = 2, max = 9, step = 1, width = "50%"),

  p(tags$b("You can change Row names")), 
  tags$textarea(id="rn", rows=3, "R1\nR2"),

  numericInput("c", "How many Columns for your data, C", 
    value = 2, min = 2, max = 9, step = 1, width = "50%"),

  p(tags$b("You can change Column names")),
  tags$textarea(id="cn", rows=3, "C1\nC2"),

  p(tags$b("Input Data")),
  helpText("Input by Column, i.e., the second column follows the first column"),
  tags$textarea(id="x", rows=10, 
    "10\n20\n30\n35")
    ),

mainPanel(

h4(tags$b("Output 1. Data Preview")), p(br()), 

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
  ),

hr(),

tableOutput("c.test"),
hr(),
h4(tags$b("Output 1. Data Preview")), p(br()), 
 
h4("Contingency Table Description"),

  )
)
),


##---------- Panel 2 ----------

tabPanel("2 x K ",

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

tabPanel("K by K",

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

))

##########----------##########----------##########

,
##---------- other panels ----------

source("../0tabs/home.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/stop.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/help5.R",local=TRUE, encoding="UTF-8")$value


))
)

