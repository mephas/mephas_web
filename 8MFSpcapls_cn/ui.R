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
#shinythemes::themeSelector(),
navbarPage(
 
  title = "多变量统计",

  tabPanel("数据集",

    titlePanel("上传变量"),

#helpText("Before user's data is uploaded, the example data (mtcars) is being shown ."),
  sidebarLayout(
    sidebarPanel(##-------csv file-------##   
    # Input: Select a file as variable----
    fileInput('file.x', "上传 .csv 格式的预测器（x）的数据集",
              multiple = TRUE,
              accept = c("text/csv",
                       "text/comma-separated-values,text/plain",
                       ".csv")),
    helpText("x的列不建议大于500."),
    # Input: Checkbox if file has header ----
    checkboxInput("header.x", "标题行", TRUE),

    fluidRow(

    column(4, 
       # Input: Select separator ----
    radioButtons("sep.x", "分隔符",
                 choices = c(Comma = ',',
                             Semicolon = ';',
                             Tab = '\t'),
                 selected = ',')),

    column(4,
    # Input: Select quotes ----
    radioButtons("quote.x", "引号",
                 choices = c(None = "",
                             "Double Quote" = '"',
                             "Single Quote" = "'"),
                 selected = '"'))
    ),

    # Input: Select a file as response----
    fileInput('file.y', "上传 .csv 格式的响应数据集（Y）",
              multiple = TRUE,
              accept = c("text/csv",
                       "text/comma-separated-values,text/plain",
                       ".csv")),
    helpText("Y的列可以不止一个"),
    # Input: Checkbox if file has header ----
    checkboxInput("header.y", "标题行", TRUE),

    fluidRow(

    column(4, 
       # Input: Select separator ----
    radioButtons("sep.y", "分隔符",
                 choices = c(Comma = ',',
                             Semicolon = ';',
                             Tab = '\t'),
                 selected = ',')),

    column(4,
    # Input: Select quotes ----
    radioButtons("quote.y", "引号",
                 choices = c(None = "",
                             "Double Quote" = '"',
                             "Single Quote" = "'"),
                 selected = '"'))
    )

    ),


    mainPanel(
      h4(tags$b("显示数据")), 
      dataTableOutput("table"),
      hr(),  
      h4(tags$b("记述统计")),
      uiOutput('x'),
      verbatimTextOutput("sum"),

      hr(),  
      h4(tags$b("散点图（Y-X）")), 
      fluidRow(
        column(6, HTML('</br>'), uiOutput('ty')),
        column(6, HTML('</br>'), uiOutput('tx'))),
      plotOutput("p1", width = "400px", height = "400px"),

      hr(),  
      h4(tags$b("直方图")), 
      HTML('</br>'), uiOutput('hx'),
      plotOutput("p2", width = "400px", height = "400px"),
      sliderInput("bin", "直方图中桶的宽度", min = 0.01, max = 5, value = 0.7)
      
  )

  )),
 

## 1. PCA ---------------------------------------------------------------------------------
tabPanel("主成分分析(PCA)",

titlePanel("主成分分析(PCA)"),

sidebarLayout(

sidebarPanel(
  h3("模型的设置"),
  numericInput("nc", "主成分分析中的主元个数:", 4, min = 2, max = 20),
  helpText("如果数据是完整的，“PCA”使用奇异值分解；如果有一些缺失值，使用NIPALS算法."),
  
  h3("图形设置"),
  numericInput("c1", "X轴分量", 1, min = 1, max = 20),
  numericInput("c2", "y轴分量", 2, min = 1, max = 20)

),

mainPanel(
  h3("结果"),
  #h4(tags$b("PCA output")), ,
  
  h4(tags$b("解释的和累积的方差")), verbatimTextOutput("fit"),

  h4(tags$b("新主成分主元")), dataTableOutput("comp"),

  downloadButton("下载数据", "新主成分主元"),

  hr(),

  h3("作图"),

  h4(tags$b("解释的方差")),
  plotOutput("pca.plot", width = "500px", height = "500px"),

  h4(tags$b("个别要素图")),
  plotOutput("pca.ind", width = "500px", height = "500px"),

  h4(tags$b("变量相关圆图")),
  plotOutput("pca.var", width = "500px", height = "500px"),

  h4(tags$b("前两个主元的双图")),
  plotOutput("pca.bp", width = "500px", height = "500px")

  )
)
), #penal tab end

## 2.  PLS, ---------------------------------------------------------------------------------
tabPanel("偏最小二乘法(PLS)",

titlePanel("偏最小二乘法(PLS)"),

sidebarLayout(
sidebarPanel(
  h3("模型的设置"),
  numericInput("nc.pls", "成分维数:", 4, min = 2, max = 20),

  h3("图形设置"),
  numericInput("c1.pls", "X轴分量", 1, min = 1, max = 20),
  numericInput("c2.pls", "y轴分量", 2, min = 1, max = 20)
),

mainPanel(
  h3("结果"),
  #h4(tags$b("PLS output")), verbatimTextOutput("fit.pls"),
  h4(tags$b("预测器（X）的新PLS成分")), dataTableOutput("comp.x"),
  downloadButton("downloadData.pls.x", "下载新成分"),
  h4(tags$b("响应变量（Y）的新PLS成分")), dataTableOutput("comp.y"),
  downloadButton("downloadData.pls.y", "下载新成分"),
  hr(),

  h3("作图"),
  h4(tags$b("个别要素图")),
  plotOutput("pls.ind", width = "900px", height = "500px"),

  h4(tags$b("变量相关圆图")),
  plotOutput("pls.var", width = "500px", height = "500px")
)

)),

## 3. SPLS, ---------------------------------------------------------------------------------
tabPanel("稀疏偏最小二乘法(SPLS)",

titlePanel("稀疏偏最小二乘法(SPLS)"),

sidebarLayout(
sidebarPanel(
  h3("模型的设置"),
  numericInput("nc.spls", "成分维数:", 4, min = 2, max = 20),
  numericInput("x.spls", "x负载中保持的变量数:", 10, min = 2, max = 20),
  numericInput("y.spls", "y负载中保持的变量数:", 5, min = 2, max = 20),

  h3("图形设置"),
  numericInput("c1.spls", "X轴分量", 1, min = 1, max = 20),
  numericInput("c2.spls", "y轴分量", 2, min = 1, max = 20)
),

mainPanel(
  h3("结果"),
  #h4(tags$b("PLS output")), verbatimTextOutput("fit.pls"),
  h4(tags$b("预测器（X）的新PLS成分")), dataTableOutput("comp.sx"),
  downloadButton("downloadData.spls.x", "下载新成分"),
  h4(tags$b("响应变量（Y）的新PLS成分")), dataTableOutput("comp.sy"),
  downloadButton("downloadData.spls.y", "下载新成分"),
  hr(),

  h3("作图"),
  h4(tags$b("个别要素图")),
  plotOutput("spls.ind", width = "900px", height = "500px"),

  h4(tags$b("变量相关圆图")),
  plotOutput("spls.var", width = "500px", height = "500px"),

  h4(tags$b("荷载图")),
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

#  h3("Model's configuration"),
  
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
#  h3("Results"),
  #plotOutput("plot.ela", width = "500px", height = "500px"),
#  verbatimTextOutput("ela")
  #h3("Cross-validated lambda"),
  #verbatimTextOutput("lambda"),
  #helpText("Lambda is merely suggested to be put into the model.")

#  )
#)
#)

##----------

tabPanel((a("主页",
 #target = "_blank",
 style = "margin-top:-30px;",
 href = paste0("https://pharmacometrics.info/mephas/", "index_cn.html")))),

tabPanel(
      tags$button(
      id = 'close',
      type = "button",
      class = "btn action-button",
      onclick = "setTimeout(function(){window.close();},500);",  # close browser
      "停止"))

))
)
  


