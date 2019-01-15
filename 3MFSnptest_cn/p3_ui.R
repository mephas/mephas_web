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

signtest.p<- sidebarLayout(

sidebarPanel(

  h4("假设检验"),
  tags$b("零假设"),
  p("m = 0: x和y之间的中值差值为零；x和y同样有效."),
 # p("m = 0: the difference of medians between X and Y is zero; X and Y are equally effective"),

  radioButtons("alt.ps", label = "备择假设", 
    choiceNames = list(
      HTML("m &#8800 0: x和y之间的中值的差异不是零；x和y不是同等有效."),
      HTML("m < 0: X的总体中位数较大，X更有效."),
      HTML("m > 0: Y的总体中位数较大，Y更有效.")),
      choiceValues = list("two.sided", "less", "greater")) 
  ),

mainPanel(
  h4('符号检验的结果'), 
  tableOutput("psign.test"), 
          helpText("Notes: 'Estimated.d' 表示中位数的估计差异.")
          )
)

##---------- 3.2 ----------

wstest.p <- sidebarLayout(
  sidebarPanel(

  #h4("Wilcoxon Signed-Rank Test"),
  #helpText("An alternative to the paired t-test for matched pairs, when the population cannot be assumed to be normally distributed. It can also be used to determine whether two dependent samples were selected from populations having the same distribution."),

  h4("假设检验"),
  tags$b("零假设"),
  p("m = 0: X和Y的中值之差不是零，配对值之差的分布是围绕零对称的"),

  radioButtons("alt.pwsr", label = "备择假设", 
    choiceNames = list(
      HTML("m &#8800 0: X和Y的中值之差不是零，配对值之差的分布在零附近不对称."),
      HTML("m < 0: Y的总体中位数较大."),
      HTML("m > 0: X的总体中位数较大.")),
    choiceValues = list("two.sided", "less", "greater")),

  h4("校正"),
  radioButtons("nap", label = "正态近似", 
    choices = list("样本量不很大" = FALSE,
                   "样本大小适中" = TRUE,
                   "样本量小" = TRUE), selected = FALSE),
  helpText("当样本量＞10时，可以应用正态近似")),

  mainPanel(h4('Wilcoxon符号秩检验的结果'), tableOutput("psr.test"), 
    helpText("当应用正态近似时，检验名称变成“具有连续性校正的Wilcoxon符号秩检验”")
    ) )

##---------- data ----------
psample <- sidebarLayout(  

sidebarPanel(

h4("数据准备"),

  tabsetPanel(
  ##-------input data-------## 
    tabPanel("手动输入", p(br()),
      helpText("缺失值请输入NA"),
    tags$textarea(id="y1", rows=10, "1.8\n3.3\n6.7\n1.4\n2.2\n1.6\n13.6\n2.8\n1.0\n2.8\n6.5\n6.8\n0.7\n0.9\n3.4\n3.3\n1.4\n0.9\n1.4\n1.8"),  ## disable on chrome
    tags$textarea(id="y2", rows=10, "8.7\n6.6\n6.0\n3.9\n1.6\n16.0\n14.1\n3.1\n4.0\n3.7\n3.1\n7.4\n6.0\n1.1\n3.0\n2.0\n5.0\n4.2\n5.0\n4.9"),
      helpText("改变样本的名称（可选)"),
    tags$textarea(id="cn3", rows=2, "X\nY\n(X-Y)")),

  ##-------csv file-------##   
    tabPanel("上传CSV文件", p(br()),
    fileInput('file3', '选择CSV文件', accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    checkboxInput('header3', '第一行为变量名', TRUE), #p
    radioButtons('sep3', '分隔符', c(Comma=',', Semicolon=';', Tab='\t'), ',')
    ) 
  )
),

mainPanel(

  h4("数据的描述统计"),

  tabsetPanel(

    tabPanel("数据显示", p(br()),  

      dataTableOutput("table3")),

    tabPanel("描述性统计量", p(br()), 

      splitLayout(
        tableOutput("bas3"), 
        tableOutput("des3"), 
        tableOutput("nor3"))  ),

    tabPanel("箱线图", p(br()), 

      splitLayout(
        plotOutput("bp3", width = "400px", height = "400px", click = "plot_click3"),

      wellPanel(
        verbatimTextOutput("info3"), hr(),

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

      plotOutput("makeplot3", width = "800px", height = "400px"),
      sliderInput("bin3", "直方图柱子的宽度", min = 0.01, max = 5, value = 0.2)
      )
    ))  )
