##----------#----------#----------#----------
##
## 8MFSpcapls UI
##
##    > PLS
##
## Language: CN
## 
## DT: 2019-01-08
##
##----------#----------#----------#----------
sidebarLayout(
sidebarPanel(
  h4("模型的设置"),
checkboxInput("scale2", "标准化 (X)", FALSE),
numericInput("nc.pls", "成分数目", 4, min = 2, max = NA),

radioButtons("mtd.pls", "PLSR 算法",
 choices = c(
             "Kernel" = "kernelpls",
             "Wide kernel" = "widekernelpls",
             "SIMPLS" = "simpls",
             "Classical orthogonal scores"="oscorespls",
             "CPPLS" = "cppls"),
 selected = "kernelpls"),

radioButtons("val", "Validation 方法",
 choices = c("No validation" = 'none',
             "Cross validation" = "CV",
             "Leave-one-out validation" = "LOO"),
 selected = "CV"),


hr(),
h4("图形设置"),
numericInput("c1.pls", "x 轴的变量", 1, min = 1, max = 20),
numericInput("c2.pls", "y 轴的变量", 2, min = 1, max = 20)

),

mainPanel(

h4("解释方差和累积方差"),
p(br()),
verbatimTextOutput("pls.sum"),
hr(),

h4("结果图"),
tabsetPanel(
tabPanel("scores 和 loadings 的图", p(br()),
plotOutput("pls.pbiplot", width = "500px", height = "500px"),
radioButtons("which", "选择图形结果",
 choices = c("X scores and loadings" = "x",
             "Y scores and loadings" = "y",
             "X and Y scores" = "scores",
             "X and Y loadings"= "loadings"),
 selected = "x")
),

tabPanel("X scores 的图",p(br()),
plotOutput("pls.pscore", width = "500px", height = "500px")),

tabPanel("X loadings 的图",p(br()),
plotOutput("pls.pload", width = "500px", height = "500px")),

tabPanel("系数参数图",p(br()),
plotOutput("pls.pcoef", width = "500px", height = "500px")),

tabPanel("预测结果图",p(br()),
plotOutput("pls.pred", width = "500px", height = "500px"),
numericInput("snum", "Which component", 1, min = 1, max = NA)),

tabPanel("Validation图",p(br()),
plotOutput("pls.pval", width = "500px", height = "500px"))


),

hr(),
h4("数据结果"),

tabsetPanel(
  tabPanel("主成份", p(br()),

(tags$b("1. 来自预测集 (X) 的主成分")), p(br()),
dataTableOutput("comp.x"),
downloadButton("downloadData.pls.x", "下载1"),
p(br()),
(tags$b("2. 来自反应集 (Y) 的主成分")), p(br()),
dataTableOutput("comp.y"),
downloadButton("downloadData.pls.y", "下载2")

),

  tabPanel("Loadings", p(br()),
(tags$b("1.来自预测集 (X) 的 loadings")), p(br()),
dataTableOutput("load.x"),
downloadButton("downloadData.pls.xload", "下载3"),
p(br()),
(tags$b("2. 来自反应集 (Y) 的 loadings")), p(br()),
dataTableOutput("load.y"),
downloadButton("downloadData.pls.yload", "下载4")
    ),

  tabPanel("Coefficients 和 projects", p(br()),
(tags$b("1. Coefficients")), p(br()),
dataTableOutput("coef"),
downloadButton("downloadData.pls.coef", "下载5"),
p(br()),
(tags$b("2. Projects")), p(br()),
dataTableOutput("proj"),
downloadButton("downloadData.pls.proj", "下载6")

    ),

  tabPanel("拟合和残差", p(br()),
(tags$b("1. Fittings")), p(br()),
dataTableOutput("fit.pls"),
downloadButton("downloadData.pls.fit", "下载7"),
p(br()),
(tags$b("2. Residuals")), p(br()),
dataTableOutput("res.pls"),
downloadButton("downloadData.pls.res", "下载8")
    )

  )

)

)