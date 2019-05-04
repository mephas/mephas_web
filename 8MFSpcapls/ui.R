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


title = "Dimensional Analysis",

#----------1. dataset panel----------

tabPanel("Dataset",

titlePanel("Data Preparation"),

source("0data_ui.R", local=TRUE, encoding="UTF-8")$value

),


## 1. PCA ---------------------------------------------------------------------------------
tabPanel("PCA",

titlePanel("Principal Component Analysis"),

source("1pca_ui.R", local=TRUE, encoding="UTF-8")$value

), #penal tab end

## 2.  PLS, ---------------------------------------------------------------------------------
tabPanel("PLS(R)",

titlePanel("Partial Least Squares (Regression)"),

source("2pls_ui.R", local=TRUE, encoding="UTF-8")$value
),

## 3. SPLS, ---------------------------------------------------------------------------------
tabPanel("SPLS(R)",

titlePanel("Sparse Partial Least Squares (Regression)"),

source("3spls_ui.R", local=TRUE, encoding="UTF-8")$value
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

source("../0tabs/home.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/stop.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/help8.R",local=TRUE, encoding="UTF-8")$value

))
)



