##----------#logistic data#----------#----------
sidebarLayout(

sidebarPanel(
  tags$head(tags$style("#strnum {overflow-y:scroll; height: 200px; background: white};")),
  tags$head(tags$style("#strfac {overflow-y:scroll; height: 100px; background: white};")),
  tags$head(tags$style("#fsum {overflow-y:scroll; height: 100px; background: white};")),

selectInput("edata", "Example Data", 
        choices =  c("Breast Cancer"), 
        selected = "Breast Cancer"),

h4(tags$b("Step 1. Upload Data File")), 
##-------csv file-------##   
p("We suggest the first variable is the dependent variable (Y) / outcome /response "),
fileInput('file', "Choose CSV/TXT file",
          accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
#helpText("The columns of X are not suggested greater than 500"),
# Input: Checkbox if file has header ----
p(tags$b("2. Show 1st row as column names?")),
checkboxInput("header", "Yes", TRUE),

p(tags$b("3. Use 1st column as row names? (No duplicates)")),
checkboxInput("col", "Yes", TRUE),

     # Input: Select separator ----
radioButtons("sep", "4. Which separator for data?",
  choiceNames = list(
    HTML("Comma (,): CSV often use this"),
    HTML("One Tab (->|): TXT often use this"),
    HTML("Semicolon (;)"),
    HTML("One Space (_)")
    ),
  choiceValues = list(",", ";", " ", "\t")
  ),

radioButtons("quote", "5. Which quote for characters?",
choices = c("None" = "",
           "Double Quote" = '"',
           "Single Quote" = "'"),
selected = '"'),

p("Correct separator and quote ensures data input successfully"),

a(tags$i("Find some example data here"),href = "https://github.com/mephas/datasets"),
hr(),

p(tags$b("Do you need to change the attribute or type of some variables?")),

p(tags$b("Choice 1. Change Numeric Variables (Numbers) into Categorical Variable (Factors)")), 

uiOutput("factor1"),

p(tags$b("Choice 2. Change Categorical Variable (Numeric Factors) into Numeric Variables (Numbers)")),

uiOutput("factor2"),

p(tags$b("Choice 3. Change the Base/Referential Level for Categorical Variable (Factors)")), 

uiOutput("lvl"),

p("2. Input the  Base/Referential Level, one line for one variable"),

tags$textarea(id='ref', column=40, "")


),


mainPanel(
h4(tags$b("Output 1. Data Information")),
p(tags$b("1. Data Preview")), 
DT::DTOutput("Xdata"),

p(tags$b("2. Continuous variable information list")),
verbatimTextOutput("strnum"),

p(tags$b("3. Factor/ Catrorical variable information list")),
verbatimTextOutput("strfac"),


hr(),   
h4(tags$b("Output 2. Basic Descriptives")),

tabsetPanel(

tabPanel("Basic Descriptives", p(br()),

p(tags$b("1. Continuous variables")),

DT::DTOutput("sum"),

p(tags$b("2. Categorical variables")),
verbatimTextOutput("fsum"),

downloadButton("download2", "Download Results (Categorical variables)")
),

tabPanel("Logit Plot",p(br()),

p("This is to show the relation between any two numeric variables"),

uiOutput('tx'),
uiOutput('ty'),

plotly::plotlyOutput("p1", width = "500px", height = "400px")
),

tabPanel("Histogram", p(br()),

p("This is to show the distribution of any numeric variable"),
uiOutput('hx'),
plotly::plotlyOutput("p2", width = "500px", height = "400px"),
sliderInput("bin", "The width of bins in the histogram", min = 0.01, max = 5, value = 1))

)

)

)