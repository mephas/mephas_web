##----------#----------#----------#----------
##
## 7MFSreg UI
##
##    >data
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------
sidebarLayout(

sidebarPanel(

  tags$head(tags$style("#strnum {overflow-y:scroll; height: 200px; background: white};")),
  tags$head(tags$style("#strfac {overflow-y:scroll; height: 100px; background: white};")),
  tags$head(tags$style("#fsum {overflow-y:scroll; height: 100px; background: white};")),

selectInput("edata", "Example Data", 
        choices =  c("Birth weight"), 
        selected = "Birth weight"),

h4(tags$b("Step 1. Upload Data File (Training Data)")), 
##-------csv file-------##   
p("We suggested the first variable is the dependent variable (Y)"),
fileInput('file', "1. Choose CSV/TXT file",
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
    HTML("Comma (,): CSV often uses this"),
    HTML("One Tab (->|): TXT often uses this"),
    HTML("Semicolon (;)"),
    HTML("One Space (_)")
    ),
          choiceValues = list(",", "\t", ";", " ")
  ),

radioButtons("quote", "5. Which quote for characters?",
choices = c("None" = "",
           "Double Quote" = '"',
           "Single Quote" = "'"),
selected = '"'),

p("Correct separator and quote ensure the successful data input"),

a(tags$i("Find some example data here"),href = "https://github.com/mephas/datasets"),

hr(),

h4(tags$b("(Optional) Change the types of some variable?")),

#p(tags$b("Choice 1. Change Real-valued Variables into Categorical Variable")), 

uiOutput("factor1"),

#p(tags$b("Choice 2. Change Categorical Variable (Numeric Factors) into Numeric Variables (Numbers)")),

uiOutput("factor2"),

h4(tags$b("(Optional) Change the referential level for categorical variable?")), 

uiOutput("lvl"),

p(tags$b("2. Input the referential level, each line for one variable")),

tags$textarea(id='ref', column=40, "")


),


mainPanel(
h4(tags$b("Output 1. Data Information")),
p(tags$b("Data Preview")), 
p(br()),
DT::DTOutput("Xdata"),

p(tags$b("1. Numeric variable information list")),
verbatimTextOutput("strnum"),

p(tags$b("2. Categorical variable information list")),
verbatimTextOutput("strfac"),

hr(),   
h4(tags$b("Output 2. Basic Descriptives")),

tabsetPanel(

tabPanel("Basic Descriptives", p(br()),

p(tags$b("1. For numeric variable")),

DT::DTOutput("sum"),

p(tags$b("2. For categorical variable")),
verbatimTextOutput("fsum"),

downloadButton("download2", "Download Results (Categorical variable)")

),

tabPanel("Linear fitting plot",p(br()),

p("Linear fitting plot: to roughly show the linear relation between any two numeric variable. Grey area is confidence interval."),

uiOutput('tx'),
uiOutput('ty'),

plotOutput("p1", width = "500px", height = "400px")
),

tabPanel("Histogram", p(br()),

p("Histogram: to roughly assess the probability distribution of a given variable by depicting the frequencies of observations occurring in certain ranges of values"),
uiOutput('hx'),
plotOutput("p2", width = "500px", height = "400px"),
sliderInput("bin", "The width of bins in the histogram", min = 0, max = 10, value = 1))

)

)

)