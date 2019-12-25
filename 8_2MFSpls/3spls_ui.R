##----------#----------#----------#----------
##
## 8MFSpcapls UI
##
##    > SPLS
##
## Language: EN
## 
## DT: 2019-05-04
##
##----------#----------#----------#----------
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
checkboxInput("trace", "Show the process of variable selection", FALSE)
),

mainPanel(

#--------------------------------------------------
h4("Browse Data"),
dataTableOutput("table.z3"),
hr(),
p("Please make sure both X and Y have been prepared. If Error happened, please check your X and Y data."),
actionButton("spls3", "Show the results", style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
#--------------------------------------------------
h4("Cross Validation Results"),
p(br()),
verbatimTextOutput("spls.cv"),

#--------------------------------------------------
h4("Results"),

tabsetPanel(
  tabPanel("SPLS", p(br()),
  verbatimTextOutput("spls") ),

  tabPanel("Selected variables (X)", p(br()),
    downloadButton("downloadData.s.sv", "Download"), p(br()),
  dataTableOutput("s.sv") ),

  tabPanel("New components based on selected variables (X)",p(br()),
    downloadButton("downloadData.s.comp", "Download"), p(br()),
  dataTableOutput("s.comp") ),

  #tabPanel("Coefficients",p(br()),
  #  downloadButton("downloadData.s.cf", "Download"), p(br()),
  #dataTableOutput("s.cf") ),

  tabPanel("Projection",p(br()),
    downloadButton("downloadData.s.pj", "Download"), p(br()),
  dataTableOutput("s.pj") ),

  tabPanel("Prediction", p(br()),
    downloadButton("downloadData.s.pd", "Download"), p(br()),
  dataTableOutput("s.pd"))
  ),

hr(),

#--------------------------------------------------
h4("Plots"),
tabsetPanel(
tabPanel("Heatmap of cross-validated MSPE", p(br()),
plotOutput("heat.cv", width = "600px", height = "400px")),

tabPanel("Coefficient path plot of SPLS",  p(br()),
numericInput("yn", "The N'th Y vector", 1, min = 1, max = NA),
#numericInput("c2.spls", "Component at y-axis", 2, min = 1, max = 20)
plotOutput("coef.var", width = "400px", height = "400px")
)
)


#(tags$b("1. New PLS components from predictors (X)")), p(br()),dataTableOutput("comp.sx"),
#downloadButton("downloadData.spls.x", "Download the new components"),
#p(br()),
#(tags$b("2. New PLS components from responses (Y)")), p(br()),dataTableOutput("comp.sy"),
#downloadButton("downloadData.spls.y", "Download the new components")

))