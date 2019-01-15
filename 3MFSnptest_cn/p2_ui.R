##----------#----------#----------#----------
##
## 3MFSnptest UI
##
##    >Panel 2
##
## Language: CN
## 
## DT: 2019-01-10
##
##----------#----------#----------#----------
##---------- Wilcoxon Rank-Sum Test ----------
wrtest<- sidebarLayout(

sidebarPanel(
##-------explanation-------##

h4("假设检验"),
tags$b("零假设"),

HTML("m&#8321 = m&#8322, 每个组的中位值相等"),

radioButtons("alt.mwt", label = "备择假设", 
  choiceNames = list(
    HTML("m&#8321 &#8800 m&#8322: 两组的中位值不相等，两组的值分布存在系统性差异."),
    HTML("m&#8321 < m&#8322: X的总体中位值更大"),
    HTML("m&#8321 > m&#8322: Y的总体中位值更大")),
  choiceValues = list("two.sided", "less", "greater")),

h4("校正"),
radioButtons("nap.mwt", label = "正态近似", 
  choices = list("样本量不很大" = FALSE,
                 "样本大小适中" = TRUE, 
                 "样本量小" = TRUE), selected = FALSE)),

mainPanel(
  h4("Wilcoxon秩和检验的结果"), tableOutput("mwu.test"), 
  helpText(HTML("<ul>
      <li> 'Estimated.diff' 表示中位数的估计差异.
      <li> 当应用正态近似时，测试名称变成“具有连续性校正的Wilcoxon符号秩检验” 
      </ul>" ))
  )

)

##---------- 2.2 ----------

mmtest<- sidebarLayout(
sidebarPanel(

h4("假设检验"),
tags$b("零假设"),
HTML("m&#8321 = m&#8322, 每个组的中值相等"),

radioButtons("alt.md", label = "备择假设", 
  choiceNames = list(
    HTML("m&#8321 &#8800 m&#8322: 每个组的总体中值不相等"),
    HTML("m&#8321 < m&#8322: X的总体中值更大"),
    HTML("m&#8321 > m&#8322: Y的总体中值更大")),
  choiceValues = list("two.sided", "less", "greater"))),

mainPanel(
  h4("Mood's中数检验的结果"), tableOutput("mood.test") 
  ) 
)

##---------- data ----------
twosample<- sidebarLayout(  
sidebarPanel(

h4("数据准备"),

  tabsetPanel(
  ##-------input data-------## 
  tabPanel("手动输入", p(br()),
    helpText("缺失值请输入NA"),
    tags$textarea(id="x1", rows=10, "1.8\n3.3\n6.7\n1.4\n2.2\n1.6\n13.6\n2.8\n1.0\n2.8\n6.5\n6.8\n0.7\n0.9\n3.4\n3.3\n1.4\n0.9\n1.4\n1.8"),  ## disable on chrome
    tags$textarea(id="x2", rows=10, "8.7\n6.6\n6.0\n3.9\n1.6\n16.0\n14.1\n3.1\n4.0\n3.7\n3.1\n7.4\n6.0\n1.1\n3.0\n2.0\n5.0\n4.2\n5.0\n4.9"),
    helpText("改变样本的名称（可选)"), tags$textarea(id="cn2", rows=2, "X\nY")),

  ##-------csv file-------##   
  tabPanel("上传CSV文件", p(br()),
    fileInput('file2', 'C选择CSV文件', accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    checkboxInput('header2', '第一行为变量名', TRUE), #p
    radioButtons('sep2', '分隔符', c(Comma=',', Semicolon=';', Tab='\t'), ',')) )
),

mainPanel(

  h4("数据的描述统计"),

  tabsetPanel(

    tabPanel("数据显示", p(br()),  

      dataTableOutput("table2")),

    tabPanel("描述性统计量", p(br()), 

      splitLayout(
        tableOutput("bas2"), 
        tableOutput("des2"), 
        tableOutput("nor2"))  ),

    tabPanel("箱线图", p(br()), 

      splitLayout(
        plotOutput("bp2", width = "400px", height = "400px", click = "plot_click2"),

      wellPanel(
        verbatimTextOutput("info2"), hr(),

        helpText(
          HTML(
            "注:
                <ul>
                <li> 图中的各个点是在同一水平线上随机地模拟和定位的 
                <li> 如果存在，异常值将以红色突出显示
                <li> 红色异常值可能不覆盖原本的模拟点
                <li> 红色异常值仅表示同一水平线上（横轴）上的值
                </ul>"
            )
          )
        )
        ) ),

    tabPanel("直方图", p(br()), 

      plotOutput("makeplot2", width = "800px", height = "400px"),
      sliderInput("bin2", "直方图柱子的宽度", min = 0.01, max = 5, value = 0.2)
      )
    ))  )