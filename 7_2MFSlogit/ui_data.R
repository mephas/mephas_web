#****************************************************************************************************************************************************
sidebarLayout(

sidebarPanel(
  tags$head(tags$style("#strnum {overflow-y:scroll; max-height: 200px; background: white};")),
  tags$head(tags$style("#strfac {overflow-y:scroll; max-height: 100px; background: white};")),
  tags$head(tags$style("#fsum {overflow-y:scroll; max-height: 100px; background: white};")),

h4(tags$b("Training Set Preparation")),

tabsetPanel(

tabPanel("Example data", p(br()),

  #selectInput("edata", tags$b("Use example data"),
  #      choices =  c("Breast Cancer"),
  #      selected = "Breast Cancer")

    shinyWidgets::radioGroupButtons(
   inputId = "edata",
   label = tags$b("Use example data"),
   choices =  c("Breast Cancer"),
   selected = "Breast Cancer",
   checkIcon = list(
    yes = tags$i(class = "fa fa-check-square", 
    style = "color: steelblue"),
   no = tags$i(class = "fa fa-square-o", 
  style = "color: steelblue"))
)
  ),

tabPanel.upload(file ="file", header="header", col="col", sep="sep", quote="quote")
  ),

hr(),

h4(tags$b("Change the types of some variable?")),
uiOutput("factor1"),
uiOutput("factor2"),

h4(tags$b("Change the referential level for categorical variable?")),

uiOutput("lvl"),

p(tags$b("2. Input the referential level, each line for one variable")),

tags$textarea(id='ref',""),
hr(),

uiOutput("rmrow"),

hr(),

#h4(tags$b(actionLink("Model","Build Model")))
#h4(tags$b("Build Model in the Next Tab"))
p(br()),
actionButton("Model", "Go to build Model >>",class="btn btn-primary",icon("location-arrow")),p(br()),
hr()

),

##########----------##########----------##########
mainPanel(
h4(tags$b("Output 1. Data Information")),
p(tags$b("Data Preview")),
DT::DTOutput("Xdata"),

p(tags$b("1. Numeric variable information list")),
verbatimTextOutput("strnum"),

p(tags$b("2. Categorical variable information list")),
verbatimTextOutput("strfac"),


hr(),
h4(tags$b("Output 2. Descriptive Results")),

tabsetPanel(

tabPanel("Basic Descriptives", br(),

p(tags$b("1. For numeric variable")),

DT::DTOutput("sum"),

p(tags$b("2. For categorical variable")),
verbatimTextOutput("fsum"),

downloadButton("download2", "Download Results (Categorical variables)")
),

tabPanel("Logit Plot",br(),

HTML("<p><b>Logit plot</b>: to roughly show the relation between any two numeric variable."),
hr(),

uiOutput('tx'),
uiOutput('ty'),
p(tags$b("3. Change the labels of X and Y axes")),
tags$textarea(id = "xlab", rows = 1, "X"),
tags$textarea(id = "ylab", rows = 1, "Y"),

plotly::plotlyOutput("p1")
),

tabPanel("Histogram and Density Plot", p(br()),

HTML("<p><b>Histogram</b>: to roughly show the probability distribution of a variable by depicting the frequencies of observations occurring in certain ranges of values.</p>"),
HTML("<p><b>Density plot</b>: to show the distribution of a variable</p>"),
hr(),

uiOutput('hx'),
p(tags$b("Histogram")),
plotly::plotlyOutput("p2"),
sliderInput("bin", "The number of bins in the histogram", min = 0, max = 100, value = 0),
p("When the number of bins is 0, plot will use the default number of bins "),
p(tags$b("Density plot")),
plotly::plotlyOutput("p21"))
))
##########----------##########----------##########
)
