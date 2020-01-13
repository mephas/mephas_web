##----------#----------#----------#----------
##
## 8MFSpcapls UI
##
##		>pca
##
## Language: EN
## 
## DT: 2019-05-04
##
##----------#----------#----------#----------
sidebarLayout(

sidebarPanel(
h4("Model's configuration"),

#checkboxInput("scale1", "Scale the data (X)", FALSE),

numericInput("nc", "Number of components in PCR:", 4, min = 2, max = NA),
#helpText("If data are complete, 'pca' uses Singular Value Decomposition; if there are some missing values, it uses the NIPALS algorithm."),

hr(),
h4("Figure's configuration"),
numericInput("c1", "Component at x-axis", 1, min = 1, max = NA),
numericInput("c2", "Component at y-axis", 2, min = 1, max = NA),
helpText("x and y must be different"),
p(br()),
checkboxInput("frame", "Add group circle in the plot", FALSE)


),

mainPanel(

h4("Browse Data"), p(br()),
dataTableOutput("table.z"),

hr(),
#p("Please make sure both X and Y have been prepared. If Error happened, please check your X and Y data."),
actionButton("pca1", "Show the results", style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),

h4("Results"),
tabsetPanel(
tabPanel("Explained and cumulative variance",p(br()),
  verbatimTextOutput("fit")),

tabPanel("New components derived", p(br()),
  dataTableOutput("comp"),
  downloadButton("downloadData", "Download")
  )
  ),

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

tabPanel("Plot of the loadings of two components" ,p(br()),
plotOutput("pca.bp", width = "400px", height = "400px")),

tabPanel("Plot of the explained variance" ,p(br()),
plotOutput("pca.plot", width = "400px", height = "400px"))

)
)

)