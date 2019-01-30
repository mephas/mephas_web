##----------#----------#----------#----------
##
## 8MFSpcapls UI
##
## Language: EN
## 
## DT: 2019-01-08
##
##----------#----------#----------#----------

shinyUI(

tagList(
source("../0tabs/font.R",local=TRUE, encoding="UTF-8")$value,

navbarPage(


title = "Principal Components",

#----------1. dataset panel----------

tabPanel("Dataset",

titlePanel("Data Preparation"),

sidebarLayout(
sidebarPanel(##-------csv file-------##   
# Input: Select a file as variable----
helpText("If no data set is uploaded, the example data is shown in the Data Display."),

selectInput("edata.x", "Choose data as X matrix", 
        choices =  c("Gene sample1","Gene sample2"), 
        selected = "Gene sample1"),

fileInput('file.x', "Upload .csv data set of X matrix (numeric predictors)",
  multiple = TRUE,
  accept = c("text/csv",
           "text/comma-separated-values,text/plain",
           ".csv")),
#helpText("The columns of X are not suggested greater than 500"),
# Input: Checkbox if file has header ----
checkboxInput("header.x", "Header", TRUE),

#fluidRow(

#column(4, 
# Input: Select separator ----
radioButtons("sep.x", "Separator",
     choices = c(Comma = ',',
                 Semicolon = ';',
                 Tab = '\t'),
     selected = ','),

#column(4,
# Input: Select quotes ----
radioButtons("quote.x", "Quote",
     choices = c(None = "",
                 "Double Quote" = '"',
                 "Single Quote" = "'"),
     selected = '"'),

hr(),
# Input: Select a file as response----
checkboxInput("add.y", "Add Y data (necessary in PLS and SPLS)", FALSE), 
selectInput("edata.y", "Choose data as Y matrix", 
        choices =  c("Y group","Y array", "Y matrix"), 
        selected = "Y group"),

fileInput('file.y', "Upload .csv data set of Y matrix (Group variable or numeric responder matrix)",
  multiple = TRUE,
  accept = c("text/csv",
           "text/comma-separated-values,text/plain",
           ".csv")),
helpText("The columns of Y can be one or more than one."),
# Input: Checkbox if file has header ----
checkboxInput("header.y", "Header", TRUE),

# Input: Select separator ----
radioButtons("sep.y", "Separator",
     choices = c(Comma = ',',
                 Semicolon = ';',
                 Tab = '\t'),
     selected = ','),

# Input: Select quotes ----
radioButtons("quote.y", "Quote",
     choices = c(None = "",
                 "Double Quote" = '"',
                 "Single Quote" = "'"),
     selected = '"')

),


mainPanel(
h4(("Data Display")), 
tags$head(tags$style(".shiny-output-error{color: blue;}")),
tabsetPanel(
  tabPanel("X matrix", p(br()),
    dataTableOutput("table.x")),

  tabPanel("Y matrix", p(br()),
    dataTableOutput("table.y"))
  ),

hr(),  
h4(("Basic Descriptives")),

tabsetPanel(

tabPanel("Continuous variables", p(br()),

uiOutput('cv'), 
actionButton("Bc", "Show descriptives"),p(br()),
tableOutput("sum"),
helpText(HTML(
"
Note:
<ul>
<li> nbr.: the number of </li>
</ul>
"
))),

tabPanel("Discrete variables", p(br()),

  uiOutput('dv'),
actionButton("Bd", "Show descriptives"),p(br()),
verbatimTextOutput("fsum")
  )
),

h4(("First Exploration of Variables")),  

tabsetPanel(
tabPanel("Scatter plot (with line) between two variables",
uiOutput('tx'),
uiOutput('ty'),
plotOutput("p1", width = "400px", height = "400px")
),
tabPanel("Bar plots",
fluidRow(
column(6,
uiOutput('hx'),
plotOutput("p2", width = "400px", height = "400px"),
sliderInput("bin", "The width of bins in the histogram", min = 10, max = 150, value = 1)),
column(6,
uiOutput('hxd'),
plotOutput("p3", width = "400px", height = "400px"))))
)
)

)),


## 1. PCA ---------------------------------------------------------------------------------
tabPanel("PCA",

titlePanel("Principal component analysis"),

sidebarLayout(

sidebarPanel(
h4("Model's configuration"),

checkboxInput("scale1", "Scale the data (X)", TRUE),

numericInput("nc", "Number of components in PCA:", 5, min = 2, max = NA),
helpText("If data are complete, 'pca' uses Singular Value Decomposition; if there are some missing values, it uses the NIPALS algorithm."),

hr(),
h4("Figure's configuration"),
numericInput("c1", "Component at x-axis", 1, min = 1, max = NA),
numericInput("c2", "Component at y-axis", 2, min = 1, max = NA),
helpText("x and y must be different"),
p(br()),
checkboxInput("frame", "Add group circle in the plot", FALSE)


),

mainPanel(

h4("Explained and cumulative variance"),
p(br()),
verbatimTextOutput("fit"),

hr(),
h4("Plots"),

tabsetPanel(

tabPanel("Plot of two components" ,p(br()),
plotOutput("pca.ind", width = "400px", height = "400px"),

radioButtons("type", "The shape of circle by group",
 choices = c(T = 't',
             Normal = "norm",
             Convex = "convex",
             Euclid = "euclid"),
 selected = 't')
),

#tabPanel("Plot of variables' correlation circle" ,p(br()),
#  plotOutput("pca.var", width = "400px", height = "400px")),

tabPanel("Plot of the loadings of two components" ,p(br()),
plotOutput("pca.bp", width = "400px", height = "400px")),

tabPanel("Plot of the explained variance" ,p(br()),
plotOutput("pca.plot", width = "400px", height = "400px"))

),

hr(),

h4("Data Display"), 
tabsetPanel(
tabPanel("Raw data" , p(br()),
dataTableOutput("table.z")),

tabPanel("New components", p(br()),
downloadButton("downloadData", "Download new components"), p(br()),
dataTableOutput("comp")
)
)
)
)
), #penal tab end

## 2.  PLS, ---------------------------------------------------------------------------------
tabPanel("PLS(R)",

titlePanel("Partial Least Squares (Regression)"),

sidebarLayout(
sidebarPanel(
h4("Model's configuration"),
checkboxInput("scale2", "Scale the data (X)", TRUE),
numericInput("nc.pls", "Number of Components", 4, min = 2, max = NA),

radioButtons("mtd.pls", "PLSR Algorithms",
 choices = c(
             "Kernel" = "kernelpls",
             "Wide kernel" = "widekernelpls",
             "SIMPLS" = "simpls",
             "Classical orthogonal scores"="oscorespls",
             "CPPLS" = "cppls"),
 selected = "kernelpls"),

radioButtons("val", "Validation method",
 choices = c("No validation" = 'none',
             "Cross validation" = "CV",
             "Leave-one-out validation" = "LOO"),
 selected = "CV"),


hr(),
h4("Figure's configuration"),
numericInput("c1.pls", "Component at x-axis", 1, min = 1, max = 20),
numericInput("c2.pls", "Component at y-axis", 2, min = 1, max = 20)

),

mainPanel(

h4("Explained and cumulative variance"),
p(br()),
verbatimTextOutput("pls.sum"),
hr(),

h4("Plots"),
tabsetPanel(
tabPanel("Plot of scores and loadings", p(br()),
plotOutput("pls.pbiplot", width = "500px", height = "500px"),
radioButtons("which", "Choose the elements in the figure",
 choices = c("X scores and loadings" = "x",
             "Y scores and loadings" = "y",
             "X and Y scores" = "scores",
             "X and Y loadings"= "loadings"),
 selected = "x")
),

tabPanel("Plot of X scores",p(br()),
plotOutput("pls.pscore", width = "500px", height = "500px")),

tabPanel("Plot of X loadings",p(br()),
plotOutput("pls.pload", width = "500px", height = "500px")),

tabPanel("Plot of coefficients",p(br()),
plotOutput("pls.pcoef", width = "500px", height = "500px")),

tabPanel("Plot of prediction",p(br()),
plotOutput("pls.pred", width = "500px", height = "500px"),
numericInput("snum", "Which component", 1, min = 1, max = NA)),

tabPanel("Plot of validation",p(br()),
plotOutput("pls.pval", width = "500px", height = "500px"))


),

hr(),
h4("Results"),

tabsetPanel(
  tabPanel("New components", p(br()),

(tags$b("1. New PLS components from predictors (X)")), p(br()),
dataTableOutput("comp.x"),
downloadButton("downloadData.pls.x", "Download1"),
p(br()),
(tags$b("2. New PLS components from responses (Y)")), p(br()),
dataTableOutput("comp.y"),
downloadButton("downloadData.pls.y", "Download2")

),

  tabPanel("Loadings", p(br()),
(tags$b("1. New PLS loadings from predictors (X)")), p(br()),
dataTableOutput("load.x"),
downloadButton("downloadData.pls.xload", "Download3"),
p(br()),
(tags$b("2. New PLS loadings from responses (Y)")), p(br()),
dataTableOutput("load.y"),
downloadButton("downloadData.pls.yload", "Download4")
    ),

  tabPanel("Coefficients and projects", p(br()),
(tags$b("1. Coefficients")), p(br()),
dataTableOutput("coef"),
downloadButton("downloadData.pls.coef", "Download5"),
p(br()),
(tags$b("2. Projects")), p(br()),
dataTableOutput("proj"),
downloadButton("downloadData.pls.proj", "Download6")

    ),

  tabPanel("Fittings and residuals", p(br()),
(tags$b("1. Fittings")), p(br()),
dataTableOutput("fit.pls"),
downloadButton("downloadData.pls.fit", "Download7"),
p(br()),
(tags$b("2. Residuals")), p(br()),
dataTableOutput("res.pls"),
downloadButton("downloadData.pls.res", "Download8")
    )

  )

)

)),

## 3. SPLS, ---------------------------------------------------------------------------------
tabPanel("SPLS",

titlePanel("Sparse Partial Least Squares"),

sidebarLayout(
sidebarPanel(
h4("Model's configuration"),
numericInput("nc.spls", "Number of components:", 4, min = 2, max = 20),
numericInput("x.spls", "Number of variables to keep in X-loadings:", 10, min = 2, max = 20),
numericInput("y.spls", "Number of variables to keep in Y-loadings:", 5, min = 2, max = 20),

h4("Figure's configuration"),
numericInput("c1.spls", "Component at x-axis", 1, min = 1, max = 20),
numericInput("c2.spls", "Component at y-axis", 2, min = 1, max = 20)
),

mainPanel(
h4("Results"),
#h4(tags$b("PLS output")), verbatimTextOutput("fit.pls"),
(tags$b("1. New PLS components from predictors (X)")), p(br()),dataTableOutput("comp.sx"),
downloadButton("downloadData.spls.x", "Download the new components"),
p(br()),
(tags$b("2. New PLS components from responses (Y)")), p(br()),dataTableOutput("comp.sy"),
downloadButton("downloadData.spls.y", "Download the new components"),
hr(),

h4("Plots"),
tabsetPanel(
tabPanel("Plot of individuals", p(br()),
plotOutput("spls.ind", width = "800px", height = "400px")),

tabPanel("Plot of variables' correlation circle",  p(br()),
plotOutput("spls.var", width = "400px", height = "400px")),

tabPanel("Plot of loadings", p(br()),
plotOutput("spls.load", width = "800px", height = "400px"))

)

))
),
#penal tab end

##----------------------------------------------------------------------
## 4. Regularization ---------------------------------------------------------------------------------
#tabPanel("Elastic net",

#titlePanel("Ridge, LASSO, and elastic net"),

#sidebarLayout(
#sidebarPanel(

#  h4("Model's configuration"),

#  sliderInput("alf", "Alpha parameter", min = 0, max = 1, value = 1),
#  helpText(HTML("
#  <ul>
#    <li>Alpha = 0: Ridge</li>
#    <li>Alpha = 1: LASSO</li>
#    <li>0 < Alpha < 1: Elastic net</li>
#  </ul>
#    ")),

#  radioButtons("family", "Response type",
#                 choices = c(Continuous =   "gaussian",
#                             Quantitative = "mgaussian",
#                             Counts = "poisson",
#                             Binary = "binomial",
#                             Multilevel = "multinomial",
#                             Survival = "cox"),
#                 selected = "mgaussian"),
#
#   numericInput("lamd", "Lambda parameter", min = 0, max = 100, value = 100)

#  ),

#mainPanel(
#  h4("Results"),
#plotOutput("plot.ela", width = "500px", height = "500px"),
#  verbatimTextOutput("ela")
#h4("Cross-validated lambda"),
#verbatimTextOutput("lambda"),
#helpText("Lambda is merely suggested to be put into the model.")

#  )
#)
#)

##---------- other panels ----------

source("../0tabs/home.R",local=TRUE)$value,
source("../0tabs/stop.R",local=TRUE)$value

))
)



