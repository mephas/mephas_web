##----------#----------#----------#----------
##
## 8MFSpcapls UI
##
## Language: CN
## 
## DT: 2019-01-08
##
##----------#----------#----------#----------

shinyUI(

tagList(
source("../0tabs/font.R",local=TRUE, encoding="UTF-8")$value,

navbarPage(


title = "多变量统计",

#----------1. dataset panel----------

tabPanel("数据集",

titlePanel("数据准备"),

source("0data_ui.R", local=TRUE, encoding="UTF-8")$value

),


## 1. PCA ---------------------------------------------------------------------------------
tabPanel("PCA",

titlePanel("主成分分析"),

sidebarLayout(

sidebarPanel(
h4("模型的设置"),
checkboxInput("scale1", "标准化 (X)", FALSE),

numericInput("nc", "主成分分析中的主元个数", 4, min = 2, max = NA),
helpText("如果数据是完整的，“PCA”使用奇异值分解；如果有一些缺失值，使用NIPALS算法."),

hr(),
h4("图形设置"),
numericInput("c1", "x轴分量", 1, min = 1, max = NA),
numericInput("c2", "y轴分量", 2, min = 1, max = NA),
helpText("x 和 y 需要不同"),
p(br()),
checkboxInput("frame", "增加分组圈", FALSE)


),

mainPanel(

h4("解释方差和累积方差"),
p(br()),
verbatimTextOutput("fit"),

hr(),
h4("结果图"),

tabsetPanel(

tabPanel("两个成分的关系图" ,p(br()),
plotOutput("pca.ind", width = "400px", height = "400px"),

radioButtons("type", "分组聚类方式",
 choices = c(T = 't',
             Normal = "norm",
             Convex = "convex",
             Euclid = "euclid"),
 selected = 't')
),

#tabPanel("Plot of variables' correlation circle" ,p(br()),
#  plotOutput("pca.var", width = "400px", height = "400px")),

tabPanel("两个成分的loading" ,p(br()),
plotOutput("pca.bp", width = "400px", height = "400px")),

tabPanel("解释方差的图" ,p(br()),
plotOutput("pca.plot", width = "400px", height = "400px"))

),

hr(),

h4("数据结果"), 
tabsetPanel(
tabPanel("原始数据" , p(br()),
dataTableOutput("table.z")),

tabPanel("新成分", p(br()),
downloadButton("downloadData", "下载"), p(br()),
dataTableOutput("comp")
)
)
)
)
), #penal tab end

## 2.  PLS, ---------------------------------------------------------------------------------
tabPanel("PLS(R)",

titlePanel("偏最小二乘（回归）"),

source("pls_ui.R", local=TRUE, encoding="UTF-8")$value
),

## 3. SPLS, ---------------------------------------------------------------------------------
tabPanel("SPLS(R)",

titlePanel("Sparse 偏最小二乘（回归）"),

sidebarLayout(
sidebarPanel(

h4("Whether to scale data"),
checkboxInput("sc.x", "标准化预测集 (X)", FALSE),
checkboxInput("sc.y", "标准化反应集 (Y)", FALSE),
hr(),

h4("交叉验证（Cross-validation）的参数"),
helpText("探索最优化的成分数目 (K)"),
numericInput("cv1", "成分范围数目的最小值", 2, min = 2, max = NA),
numericInput("cv2", "成分范围数目的最大值", 4, min = 3, max = NA),
radioButtons("s.select", "变量选择时的方法 (SPLSR)",
 choices = c("PLS" = 'pls2',
             "SIMPLS" = "simpls"),
 selected = "pls2"),

radioButtons("s.fit", "模型拟合时的算法 (PLSR)",
 choices = c(
             "Kernel" = "kernelpls",
             "Wide kernel" = "widekernelpls",
             "SIMPLS" = "simpls",
             "Classical orthogonal scores"="oscorespls"),
 selected = "simpls"),

hr(),
h4("模型的设置"),
helpText("参数的选择可以参考交叉验证的结果"),
numericInput("nc.spls", "成分的数目", 2, min = 2, max = NA),
numericInput("eta", "Eta (0 to 1)", 0.5, min = 0, max = 1, step=0.1 ),
numericInput("kappa", "Kappa (0 to 0.5, default is 0.5)", 0.5, min = 0, max = 0.5, step=0.1),
checkboxInput("trace", "显示变量选择的过程", FALSE)
),

mainPanel(
h4("SPLS 结果"),
tabsetPanel(
  tabPanel("交叉验证（Cross validation）", p(br()),
  verbatimTextOutput("spls.cv")),

  tabPanel("SPLS", p(br()),
  verbatimTextOutput("spls") )
  ),

hr(),

h4("结果图"),
tabsetPanel(
tabPanel("交叉验证的均方误（cross-validated MSPE）的热图", p(br()),
plotOutput("heat.cv", width = "600px", height = "400px")),

tabPanel("系数的路径图（Coefficient path plot）",  p(br()),
numericInput("yn", "反应集 Y 的第N列", 1, min = 1, max = NA),
#numericInput("c2.spls", "Component at y-axis", 2, min = 1, max = 20)
plotOutput("coef.var", width = "400px", height = "400px")
)

#tabPanel("Coefficients of SPLS", p(br()),
#  numericInput("xn1", "The N'th X vector", 1, min = 1, max = NA),
#  numericInput("xn2", "The N'th X vector", 2, min = 1, max = NA),
#  numericInput("xn3", "The N'th X vector", 3, min = 1, max = NA),
#  numericInput("xn4", "The N'th X vector", 4, min = 1, max = NA),
#plotOutput("coef.spls", width = "800px", height = "800px"))
#)

),
hr(),

h4("数据结果"),
tabsetPanel(
  tabPanel("选择的预测变量 (X)",p(br()),
    downloadButton("downloadData.s.sv", "下载1"), p(br()),
  dataTableOutput("s.sv") ),

  tabPanel("基于选择出的变量计算得到的主成分(X)",p(br()),
    downloadButton("downloadData.s.comp", "下载2"), p(br()),
  dataTableOutput("s.comp") ),

  tabPanel("系数 Coefficients",p(br()),
    downloadButton("downloadData.s.cf", "下载3"), p(br()),
  dataTableOutput("s.cf") ),

  tabPanel("Projection",p(br()),
    downloadButton("downloadData.s.pj", "下载5"), p(br()),
  dataTableOutput("s.pj") ),

  tabPanel("预测e", p(br()),
    downloadButton("downloadData.s.pd", "下载6"), p(br()),
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



