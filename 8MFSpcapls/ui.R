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

source("0data_ui.R", local=TRUE, encoding="UTF-8")$value

),


## 1. PCA ---------------------------------------------------------------------------------
tabPanel("PCA",

titlePanel("Principal component analysis"),

sidebarLayout(

sidebarPanel(
h4("Model's configuration"),

checkboxInput("scale1", "Scale the data (X)", FALSE),

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

source("pls_ui.R", local=TRUE, encoding="UTF-8")$value
),

## 3. SPLS, ---------------------------------------------------------------------------------
tabPanel("SPLS(R)",

titlePanel("Sparse Partial Least Squares (Regression)"),

sidebarLayout(
sidebarPanel(

h4("Whether to scale data"),
checkboxInput("sc.x", "Scale the predictors (X)", FALSE),
checkboxInput("sc.y", "Scale the responders (Y)", FALSE),
hr(),

h4("Cross-validation's configuration"),
helpText("Find the optimal number of component (K)"),
numericInput("cv1", "Minimum number of components", 2, min = 2, max = NA),
numericInput("cv2", "Maximum number of components", 4, min = 3, max = NA),
radioButtons("s.select", "Variables' selection method (SPLSR)",
 choices = c("PLS" = 'pls2',
             "SIMPLS" = "simpls"),
 selected = "pls2"),

radioButtons("s.fit", "Model fitting method (PLSR)",
 choices = c(
             "Kernel" = "kernelpls",
             "Wide kernel" = "widekernelpls",
             "SIMPLS" = "simpls",
             "Classical orthogonal scores"="oscorespls"),
 selected = "simpls"),

hr(),
h4("Model's configuration"),
helpText("Results from cross-validation can be used as references"),
numericInput("nc.spls", "Number of components", 2, min = 2, max = NA),
numericInput("eta", "Eta (0 to 1)", 0.5, min = 0, max = 1, step=0.1 ),
numericInput("kappa", "Kappa (0 to 0.5, default is 0.5)", 0.5, min = 0, max = 0.5, step=0.1),
checkboxInput("trace", "Show the process of variable selection", FALSE),


hr(),
h4("Figure's configuration"),
numericInput("c1.spls", "Component at x-axis", 1, min = 1, max = 20),
numericInput("c2.spls", "Component at y-axis", 2, min = 1, max = 20)
),

mainPanel(
h4("SPLS Results"),
tabsetPanel(
  tabPanel("Cross validation", p(br()),
  verbatimTextOutput("spls.cv")),

  tabPanel("SPLS", p(br()),
  verbatimTextOutput("spls") )
  ),

hr(),

h4("Plots"),
tabsetPanel(
tabPanel("Heatmap of cross-validated MSPE", p(br()),
plotOutput("heat.cv", width = "600px", height = "400px"))

#tabPanel("Plot of variables' correlation circle",  p(br())
#plotOutput("spls.var", width = "400px", height = "400px")
#),

#tabPanel("Plot of loadings", p(br())
#plotOutput("spls.load", width = "800px", height = "400px")
#)

),
hr(),

h4("Results"),
tabsetPanel(
  tabPanel("Selected vairbales (X)",p(br()),
    downloadButton("downloadData.s.sv", "Download1"), p(br()),
  dataTableOutput("s.sv") ),

  tabPanel("New components based on selected variables (X)",p(br()),
    downloadButton("downloadData.s.comp", "Download2"), p(br()),
  dataTableOutput("s.comp") ),

  tabPanel("Coefficients",p(br()),
    downloadButton("downloadData.s.cf", "Download3"), p(br()),
  dataTableOutput("s.cf") ),

  tabPanel("Projection",p(br()),
    downloadButton("downloadData.s.pj", "Download4"), p(br()),
  dataTableOutput("s.pj") ),

  tabPanel("Prediction", p(br()),
    downloadButton("downloadData.s.pd", "Download5"), p(br()),
  dataTableOutput("s.pd"))
  )
#(tags$b("1. New PLS components from predictors (X)")), p(br()),dataTableOutput("comp.sx"),
#downloadButton("downloadData.spls.x", "Download the new components"),
#p(br()),
#(tags$b("2. New PLS components from responses (Y)")), p(br()),dataTableOutput("comp.sy"),
#downloadButton("downloadData.spls.y", "Download the new components")

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



