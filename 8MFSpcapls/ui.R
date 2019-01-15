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

navbarPage(
 

  title = "Principal Components",

#----------1. dataset panel----------

  tabPanel("Dataset",

  titlePanel("Data Preparation"),

  sidebarLayout(
    sidebarPanel(##-------csv file-------##   
    # Input: Select a file as variable----
    helpText("If no data set is uploaded, the example data is shown in the Data Display."),
  
    fileInput('file.x', "Upload .csv data set of X matrix (predictors)",
              multiple = TRUE,
              accept = c("text/csv",
                       "text/comma-separated-values,text/plain",
                       ".csv")),
    #helpText("The columns of X are not suggested greater than 500"),
    # Input: Checkbox if file has header ----
    checkboxInput("header.x", "Header", TRUE),

    fluidRow(

    column(4, 
       # Input: Select separator ----
    radioButtons("sep.x", "Separator",
                 choices = c(Comma = ',',
                             Semicolon = ';',
                             Tab = '\t'),
                 selected = ',')),

    column(4,
    # Input: Select quotes ----
    radioButtons("quote.x", "Quote",
                 choices = c(None = "",
                             "Double Quote" = '"',
                             "Single Quote" = "'"),
                 selected = '"'))
    ),

    # Input: Select a file as response----
    fileInput('file.y', "Upload .csv data set of Y matrix (responders)",
              multiple = TRUE,
              accept = c("text/csv",
                       "text/comma-separated-values,text/plain",
                       ".csv")),
    helpText("The columns of Y can be one or more than one."),
    # Input: Checkbox if file has header ----
    checkboxInput("header.y", "Header", TRUE),

    fluidRow(

    column(4, 
       # Input: Select separator ----
    radioButtons("sep.y", "Separator",
                 choices = c(Comma = ',',
                             Semicolon = ';',
                             Tab = '\t'),
                 selected = ',')),

    column(4,
    # Input: Select quotes ----
    radioButtons("quote.y", "Quote",
                 choices = c(None = "",
                             "Double Quote" = '"',
                             "Single Quote" = "'"),
                 selected = '"'))
    )

    ),


    mainPanel(
      h4(("Data Display")), 
      helpText("The first 5 rows and first 5 columns of X matrix"),
      tags$head(tags$style(".shiny-output-error{color: blue;}")),
      tableOutput("table.x"),
      helpText("The first 5 rows and first columns of Y matrix"),
      tableOutput("table.y"),
      hr(),  
      h4(("Basic Descriptives")),
      tags$b("Select the variables for descriptives"),

        fluidRow(
          column(6,
          uiOutput('cv'),
          actionButton("Bc", "Show descriptives"),
          tableOutput("sum"),
          helpText(HTML(
      "
      Note:
      <ul>
      <li> nbr.: the number of </li>
      </ul>
      "
      ))
          ),

          column(6,
          uiOutput('dv'),
          actionButton("Bd", "Show descriptives"),
          verbatimTextOutput("fsum")
          )),

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
  numericInput("nc", "Number of components in PCA:", 4, min = 2, max = 20),
  helpText("If data are complete, 'pca' uses Singular Value Decomposition; if there are some missing values, it uses the NIPALS algorithm."),
  
  h4("Figure's configuration"),
  numericInput("c1", "Component at x-axis", 1, min = 1, max = 20),
  numericInput("c2", "Component at y-axis", 2, min = 1, max = 20)

),

mainPanel(
  h4("Results"),
  #h4(tags$b("PCA output")), ,
  
  (tags$b("Explained and cumulative variance")), verbatimTextOutput("fit"),

  (tags$b("New PCA components")), dataTableOutput("comp"),

  downloadButton("downloadData", "Download new components"),

  hr(),

  h4("Plots"),

  (tags$b("Plot of the explained variance")),
  plotOutput("pca.plot", width = "500px", height = "500px"),

  (tags$b("Plot of individuals")),
  plotOutput("pca.ind", width = "500px", height = "500px"),

  (tags$b("Plot of variables' correlation circle")),
  plotOutput("pca.var", width = "500px", height = "500px"),

  (tags$b("Biplot of the first two components")),
  plotOutput("pca.bp", width = "500px", height = "500px")

  )
)
), #penal tab end

## 2.  PLS, ---------------------------------------------------------------------------------
tabPanel("PLS",

titlePanel("Partial Least Squares"),

sidebarLayout(
sidebarPanel(
  h4("Model's configuration"),
  numericInput("nc.pls", "Number of Components:", 4, min = 2, max = 20),

  h4("Figure's configuration"),
  numericInput("c1.pls", "Component at x-axis", 1, min = 1, max = 20),
  numericInput("c2.pls", "Component at y-axis", 2, min = 1, max = 20)
),

mainPanel(
  h4("Results"),
  #h4(tags$b("PLS output")), verbatimTextOutput("fit.pls"),
  (tags$b("New PLS components from predictors (X)")), dataTableOutput("comp.x"),
  downloadButton("downloadData.pls.x", "Download the new components"),
  (tags$b("New PLS components from responses (Y)")), dataTableOutput("comp.y"),
  downloadButton("downloadData.pls.y", "Download the new components"),
  hr(),

  h4("Plots"),
  (tags$b("Plot of individuals")),
  plotOutput("pls.ind", width = "900px", height = "500px"),

  (tags$b("Plot of variables' correlation circle")),
  plotOutput("pls.var", width = "500px", height = "500px")
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
  (tags$b("New PLS components from predictors (X)")), dataTableOutput("comp.sx"),
  downloadButton("downloadData.spls.x", "Download the new components"),
  (tags$b("New PLS components from responses (Y)")), dataTableOutput("comp.sy"),
  downloadButton("downloadData.spls.y", "Download the new components"),
  hr(),

  h4("Plots"),
  (tags$b("Plot of individuals")),
  plotOutput("spls.ind", width = "900px", height = "500px"),

  (tags$b("Plot of variables' correlation circle")),
  plotOutput("spls.var", width = "500px", height = "500px"),

  (tags$b("Plot of loadings")),
  plotOutput("spls.load", width = "900px", height = "500px")
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
  


