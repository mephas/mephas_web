##----------#----------#----------#----------
##
## 3MFSnptest UI
##
##    >Panel 1
##
## Language: CN
## 
## DT: 2019-01-09
##
##----------#----------#----------#----------
##---------- Sign Test ----------
signtest<-sidebarLayout(


sidebarPanel(

h4("假设检验"),

  tags$b("零假设"),
HTML("<p> m = m&#8320: 总体X的中位值等于指定值.</p>"),

radioButtons("alt.st", label = "备择假设", 
  choiceNames = list(
  HTML("m &#8800 m&#8320: 总体X的中位值不等于指定值"),
  HTML("m < m&#8320: 总体X的中位值小于指定值"),
  HTML("m > m&#8320: 总体X的中位值大于指定值")),
  choiceValues = list("two.sided", "less", "greater"))),

  mainPanel(
    h4('符号检验的结果'), 
    tableOutput("sign.test")
    )  
  )

##---------- Wilcoxon Signed-Rank Test ----------

wstest<-sidebarLayout(

sidebarPanel(

h4("假设检验"),

tags$b("零假设"),
HTML("<p> m = m&#8320: 总体X的中位值等于指定值；数据集的分布与指定值相同</p>"),

radioButtons("alt.wsr", label = "备择假设", 
  choiceNames = list(
  HTML("m &#8800 m&#8320: 总体X的中位值不等于指定值"),
  HTML("m < m&#8320: 总体X的中位值小于指定值"),
  HTML("m > m&#8320: 总体X的中位值大于指定值")),
choiceValues = list("two.sided", "less", "greater")),

helpText("校正"),
radioButtons("nap.wsr", label = "正态近似", 
  choices = list("样本量不很大" = FALSE,
                 "样本大小适中" = TRUE, 
                 "样本量小" = TRUE), selected = FALSE),
helpText("当样本量＞10时，可以应用正态近似.")),

  mainPanel(
    h4('Wilcoxon符号秩检验的结果'), 
    tableOutput("ws.test"), 
    helpText("当应用正态近似时，测试名称变成“具有连续性校正的Wilcoxon符号秩检验”")
  )
)

##---------- data ----------
onesample<- sidebarLayout(  

sidebarPanel(

h4("数据准备"),

  tabsetPanel(
  ##-------input data-------## 
  tabPanel("手动输入", p(br()),
      helpText("缺失值请输入NA"),

    tags$textarea(id="a", rows=10, "1.8\n3.3\n6.7\n1.4\n2.2\n1.6\n13.6\n2.8\n1.0\n2.8\n6.5\n6.8\n0.7\n0.9\n3.4\n3.3\n1.4\n0.9\n1.4\n1.8"),
      helpText("改变样本的名称（可选)"),
    tags$textarea(id="cn", rows=2, "X")
    ),

  ##-------csv file-------##   
  tabPanel("上传CSV文件", p(br()),
    fileInput('file', '选择CSV文件', 
      accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    checkboxInput('header', '第一行为变量名', TRUE), #p
    radioButtons('sep', '分隔符', c(Comma=',', Semicolon=';', Tab='\t'), ',')) 
  ),

  hr(),
  h4("参数设置"),
  numericInput("med", HTML("待比较的指定的中位值, m&#8320"), 4)#p),
  ),

mainPanel(

  h4("Descriptive Statistics"),

  tabsetPanel(

    tabPanel("Data display", p(br()),  

      dataTableOutput("table")),

    tabPanel("Basic descriptives", p(br()), 

      splitLayout(
        tableOutput("bas"), 
        tableOutput("des"), 
        tableOutput("nor"))  ),

    tabPanel("Boxplot", p(br()), 

      splitLayout(
        plotOutput("bp", width = "400px", height = "400px", click = "plot_click"),

      wellPanel(
        verbatimTextOutput("info"), hr(),

        helpText(
          HTML(
            "Notes:
            <ul>
            <li> Points are simulated and located randomly in the same horizontal line 
            <li> Outliers will be highlighted in red, if existing
            <li> The red outlier may not cover the simulated point
            <li> The red outlier only indicates the value in horizontal line
            </ul>"
            )
          )
        )
        ) ),

    tabPanel("Histogram", p(br()), 

      plotOutput("makeplot", width = "800px", height = "400px"),
      sliderInput("bin", "The width of bins in histogram", min = 0.01, max = 5, value = 0.2)
      )
    )
  )
)



