#****************************************************************************************************************************************************

sidebarLayout(

sidebarPanel(

  tags$style(type='text/css', '#surv {background-color: rgba(0,0,255,0.10); color: blue;}'),
  tags$head(tags$style("#fsum {overflow-y:scroll; max-height: 200px; background: white};")),
  tags$head(tags$style("#strnum {overflow-y:scroll; max-height: 200px; background: white};")),
  tags$head(tags$style("#strfac {overflow-y:scroll; max-height: 200px; background: white};")),
  tags$head(tags$style("#kmat1 {overflow-y:scroll; max-height: 200px; background: white};")),

h4(tags$b("Training Set Preparation")),

tabsetPanel(

tabPanel("Example data", p(br()),

#selectInput("edata", tags$b("Use example data"),
#        choices =  c("Diabetes","NKI70"),
#        selected = "Diabetes")
#),

shinyWidgets::radioGroupButtons(
   inputId = "edata",
   label = tags$b("Use example data"),
   choices = c("Diabetes","NKI70"),
   selected = "Diabetes",
   checkIcon = list(
    yes = tags$i(class = "fa fa-check-square", 
    style = "color: steelblue"),
   no = tags$i(class = "fa fa-square-o", 
  style = "color: steelblue"))
)
),

tabPanel.upload(file ="file", header="header", col="col", sep="sep", quote="quote")

),
tags$i("Diabetes data has only one time duration variable, while Nki70 data has start.time and end.time."),
hr(),

h4(tags$b("Step 2. Create a Survival Object")),

#p(tags$b("1. Choose a Time Variable")),

uiOutput('c'),

  selectInput(
      "time", "Select survival time type",
      c("Right-censored time" = "A",
        "Left-truncated right-censored time" = "B"
        )),
  p("Right-censored time needs only 1 time duration / follow-up variable"),
  p("Left-truncated right-censored time needs start time and end time variables"),


conditionalPanel(
  condition = "input.time == 'A'",
  uiOutput('t')
  ),
conditionalPanel(
  condition = "input.time == 'B'",
  uiOutput('t1'),
  uiOutput('t2')
  ),

tags$i("Diabetes data has right-censored time, while Nki70 data has left-truncated right-censored time."),

hr(),
h4(tags$b("Step 3. Check the Survival Object")),
p(tags$b("Valid survival object example: Surv (time, status)")),
p(tags$b("or, Surv (time1, time2, status)")),
verbatimTextOutput("surv", placeholder = TRUE),


hr(),


h4(tags$b("(Optional) Change the types of some variable?")),

#p(tags$b("Choice 1. Change Numeric Variables (Numbers) into Categorical Variable (Factors)")),

uiOutput("factor1"),

#p(tags$b("Choice 2. Change Categorical Variable (Numeric Factors) into Numeric Variables (Numbers)")),

uiOutput("factor2"),

h4(tags$b("(Optional) Change the referential level for categorical variable?")),

uiOutput("lvl"),

p(tags$b("2. Input the referential level, each line for one variable")),

tags$textarea(id='ref', column=40, ""),

hr(),

h4(tags$b(actionLink("Non-Parametric Model","Build Non-Parametric Model"))),
h4(tags$b(actionLink("Semi-Parametric Model","Build Semi-Parametric Model"))),
h4(tags$b(actionLink("Parametric Model","Build Parametric Model")))
#h4(tags$b("Build Model in the Next Tab"))



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
h4(tags$b("Output 2. Descriptive Results")),

tabsetPanel(

tabPanel("Basic Descriptives", p(br()),

p(tags$b("1. For numeric variable")),

DT::DTOutput("sum"),

p(tags$b("2. For categorical variable")),
verbatimTextOutput("fsum"),


#downloadButton("download1", "Download Results (Continuous variables)"),
downloadButton("download2", "Download Results (Categorical variables)")

),

tabPanel("Survival Curves",  p(br()),
  radioButtons("fun1", "Choose one plot",
  choiceNames = list(
    HTML("1. Survival Probability"),
    HTML("2. Cumulative Events"),
    HTML("3. Cumulative Hazard")
    ),
  choiceValues = list("pct", "event","cumhaz")
  ),
plotOutput("km.a", width = "80%"),
verbatimTextOutput("kmat1")
     ),

tabPanel("Life Table",  p(br()),
  #p(tags$b("For all samples")),
DT::DTOutput("kmat")
#tags$head(tags$style("#kmat {overflow-y:scroll; max-height: 400px; background: white};"))
     ),

tabPanel("Histogram", p(br()),

p("This is to show the distribution of any numeric variable"),
uiOutput('hx'),
p(tags$b("Histogram")),
plotly::plotlyOutput("p2", width = "80%"),
sliderInput("bin", "The number of bins in the histogram", min = 0, max = 100, value = 0),
p("When the number of bins is 0, plot will use the default number of bins "),
p(tags$b("Density plot")),
plotly::plotlyOutput("p21", width = "80%"))

)

)

)
