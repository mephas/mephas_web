##----------#----------#----------#----------
##
## 8MFSpcapls UI
##
##    > PLS
##
## Language: JP
## 
## DT: 2019-01-08
##
##----------#----------#----------#----------
sidebarLayout(
sidebarPanel(
h4("モデルの設定"),
checkboxInput("scale2", "Scale the data (X)", FALSE),
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
h4("プロットの設定"),
numericInput("c1.pls", "x軸の要素", 1, min = 1, max = 20),
numericInput("c2.pls", "Y軸の要素", 2, min = 1, max = 20)

),

mainPanel(

h4("Explained and累積分散"),
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

tabPanel(" X scoresのプロット",p(br()),
plotOutput("pls.pscore", width = "500px", height = "500px")),

tabPanel("X loadingsのプロット",p(br()),
plotOutput("pls.pload", width = "500px", height = "500px")),

tabPanel("coefficientsのプロット",p(br()),
plotOutput("pls.pcoef", width = "500px", height = "500px")),

tabPanel("predictionのプロット",p(br()),
plotOutput("pls.pred", width = "500px", height = "500px"),
numericInput("snum", "Which component", 1, min = 1, max = NA)),

tabPanel("validationのプロット",p(br()),
plotOutput("pls.pval", width = "500px", height = "500px"))


),

hr(),
h4("結果"),

tabsetPanel(
  tabPanel("新しい要素", p(br()),

(tags$b("1. 新しい要素 from predictors (X)")), p(br()),
dataTableOutput("comp.x"),
downloadButton("downloadData.pls.x", "Download1"),
p(br()),
(tags$b("2. 新しい要素 from responses (Y)")), p(br()),
dataTableOutput("comp.y"),
downloadButton("downloadData.pls.y", "Download2")

),

  tabPanel("Loadings", p(br()),
(tags$b("1. 新しい PLS loadings from predictors (X)")), p(br()),
dataTableOutput("load.x"),
downloadButton("downloadData.pls.xload", "Download3"),
p(br()),
(tags$b("2. 新しい PLS loadings from responses (Y)")), p(br()),
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

)