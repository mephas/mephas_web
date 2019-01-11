##----------#----------#----------#----------
##
## 3MFSnptest UI
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

title = "非参数检验",  

## 1. One sample test ---------------------------------------------------------------------------------
tabPanel("单样本",

headerPanel("符号检验，威尔科克森(Wilcoxon)符号秩检验"),
p("两者都可用于测试一组数字的中值是否显著大于或小于指定值。"),

tags$b("前提假设"),
tags$ul(
  tags$li("每个观察是独立的，来自同一总体"),
  tags$li("X可以是连续的（即间隔或比率）和序数")),

tags$b("注释"),
HTML("
  <ul>
  <li> X是随机采集的样本.</li>
  <li> m是总体X的中位数，即X的分布的50百分位数.</li>
  <li> m&#8320 是指定值.</li>
  </ul>
  "),

helpText("参数设置"),
numericInput("med", HTML("指定值, m&#8320"), 4), #p

sidebarLayout(

sidebarPanel(

  ##-------explanation-------##
h4(tags$b("符号检验")),
helpText("符号检验对被检验的数据的分布性质基本不做出假设，但是其统计功效（statistical power）可能不如其他方法"),

helpText("假设检验"),
tags$b("零假设"),
HTML("<p> m = m&#8320: 总体X的中位值等于指定值.</p>"),

radioButtons("alt.st", label = "对立假设", 
  choiceNames = list(
  HTML("m &#8800 m&#8320: 总体X的中位值不等于指定值"),
  HTML("m < m&#8320: 总体X的中位值小于指定值"),
  HTML("m > m&#8320: 总体X的中位值大于指定值")),
choiceValues = list("two.sided", "less", "greater"))),

  mainPanel(h3(tags$b('检验结果')), 
    tableOutput("sign.test")
    )  ),

sidebarLayout(
  sidebarPanel(

h4(tags$b("威尔科克森(Wilcoxon)符号秩检验")),
helpText("当数据不能被假定为正态分布时,可以使用这个方法来替代一个样本t检验，来确定样本的中值是否等于指定的值"),

tags$b("补充假设"),
tags$ul(
  tags$li("X的分布是对称的"),
  tags$li("X中没有相同的值 (No ties)")),

helpText("假设检验"),
tags$b("零假设"),
HTML("<p> m = m&#8320: 总体X的中位值等于指定值；数据集的分布与指定值相同</p>"),

radioButtons("alt.wsr", label = "对立假设", 
  choiceNames = list(
  HTML("m &#8800 m&#8320: 总体X的中位值不等于指定值."),
  HTML("m < m&#8320: 总体X的中位值小于指定值."),
  HTML("m > m&#8320: 总体X的中位值大于指定值.")),
choiceValues = list("two.sided", "less", "greater")),

helpText("参数设置"),
radioButtons("nap.wsr", label = "正态近似", 
  choices = list("样本量不很大" = FALSE,
                 "样本大小适中" = TRUE, 
                 "样本量小" = TRUE), selected = FALSE),
helpText("当样本量＞10时，可以应用正态近似.")),

  mainPanel(h3(tags$b('检验结果')), 
    tableOutput("ws.test"), 
    helpText("当应用正态近似时，测试名称变成“具有连续性校正的Wilcoxon符号秩检验”")
  )
),

sidebarLayout(  
sidebarPanel(

helpText("导入数据"),

  tabsetPanel(
  ##-------input data-------## 
  tabPanel("手动输入", p(br()),
    helpText("如有缺失值，请输入NA"),
    tags$textarea(id="a", rows=10, "1.8\n3.3\n6.7\n1.4\n2.2\n1.6\n13.6\n2.8\n1.0\n2.8\n6.5\n6.8\n0.7\n0.9\n3.4\n3.3\n1.4\n0.9\n1.4\n1.8"),
    helpText("改变两个样本的名称（可选）"), tags$textarea(id="cn", rows=2, "X")),

  ##-------csv file-------##   
  tabPanel("上传 .csv 格式文件", p(br()),
    fileInput('file', '选择 .csv 格式文件', accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    checkboxInput('header', '标题行', TRUE), #p
    radioButtons('sep', '分隔符', c(Comma=',', Semicolon=';', Tab='\t'), ',')) ),

hr(),
h4("显示数据"), 

dataTableOutput("table"),
hr(),
h4("图形设置"), sliderInput("bin", "直方图中柱的宽度", min = 0.01, max = 5, value = 0.2)),

mainPanel(
  h3(tags$b('箱线图')), splitLayout(
    plotOutput("bp", width = "400px", height = "400px", click = "plot_click"),
    wellPanel(verbatimTextOutput("info"), hr(),
      helpText(HTML("注释:
                    <ul> 
                    <li> 如果存在，异常值将以红色突出显示. </li>
                    <li> 红色异常值可能不覆盖模拟点. </li>
                    <li> 红色异常值仅表示水平行同一横轴上的值.</li>  
                    </ul>")))),
  hr(),
  h3(tags$b('直方图')), plotOutput("makeplot", width = "600px", height = "300px"),
  hr(),
  h3(tags$b('记述统计')), 
  splitLayout(tableOutput("bas"), tableOutput("des"), tableOutput("nor"))) )

),

## 2 Two independent samples test ---------------------------------------------------------------------------------
tabPanel("两个独立样本",

headerPanel("Wilcoxon秩和检验（Mann-Whitney U检验）， 穆德(Mood's)中数检验"),

p("以确定随机选择的样本是否小于或大于第二随机选择的样本."),

tags$b("前提假设"),
tags$ul(
  tags$li("两组的观察结果相互独立，没有成对或重复的数据."),
  tags$li("X和Y可以是连续的（即间隔或比率）和序数（即至少两个任意观测值, 有一个更大）."),
  tags$li("X和Y分布形状相似.")),

tags$b("注释"),
HTML("<ul>
      <li> X是第一个随机选择的样本，而Y是第二个.</li>
      <li> m&#8321 是X的总体中位值, 即位于X的分布的百分之五十位的数.</li>  
      <li> m&#8322 是Y的总体中位值, 即位于Y的分布的百分之五十位的数.</li> 
      </ul>" ),

sidebarLayout(
sidebarPanel(
##-------explanation-------##
h4(tags$b("威尔科克森(Wilcoxon)秩和检验")),
h4(tags$b("Mann-Whitney U检验")),
p(tags$b("Mann-Whitney－Wilcoxon检验")),
p(tags$b("Wilcoxon Mann-Whitney检验")),

helpText("不需要假设正态分布，几乎与正态分布上的t检验一样有效."),

tags$b("补充假设"),
tags$ul(
  tags$li("无离群值"),
  tags$li("如果存在离群值，则该测试用于测试分布。")),
helpText("离群值会影响数据的传播."),

p(tags$b("无离群值"), "确定两组在形状和分布上的分布是否相似"),
p(tags$b("有离群值"), "确定两组在形状和分布上的分布是否不同"),

helpText("假设检验"),
tags$b("零假设"),
HTML("<p> m&#8321 = m&#8322: 每个组的中位值相等，每组的值分布相同.</p>"),

radioButtons("alt.mwt", label = "对立假设", 
  choiceNames = list(
    HTML("m&#8321 &#8800 m&#8322: 两组的中位值不相等，两组的值分布存在系统性差异."),
    HTML("m&#8321 < m&#8322: X的总体中位值更大"),
    HTML("m&#8321 > m&#8322: Y的总体中位值更大")),
  choiceValues = list("two.sided", "less", "greater")),

helpText("调整"),
radioButtons("nap.mwt", label = "正态近似", 
  choices = list("样本量不很大" = FALSE,
                 "样本大小适中" = TRUE, 
                 "样本量小" = TRUE), selected = FALSE)),

mainPanel(
  h3(tags$b("检验结果")), tableOutput("mwu.test"), 
  helpText(HTML("<ul>
      <li> 'Estimated.diff' 表示中位数的估计差异.
      <li> 当应用正态近似时，测试名称变成“具有连续性校正的Wilcoxon符号秩检验”.</li>  
      </ul>" ))
  )),

sidebarLayout(
sidebarPanel(

h4(tags$b("穆德(Mood's)中数检验")),
helpText("皮尔森卡方检验（Pearson's chi-squared test）的一个特例。它具有检测中到大样本的低功能（效率）."),

helpText("假设"),
tags$b("零假设"),
HTML("m&#8321 = m&#8322, 每个组的中值相等"),

radioButtons("alt.md", label = "对立假设", 
  choiceNames = list(
    HTML("m&#8321 &#8800 m&#8322: 每个组的总体中值不相等"),
    HTML("m&#8321 < m&#8322: X的总体中值更大"),
    HTML("m&#8321 > m&#8322: Y的总体中值更大")),
  choiceValues = list("two.sided", "less", "greater"))),

mainPanel(h3(tags$b("检验结果")), tableOutput("mood.test") 
  ) ),

# data input
sidebarLayout(  
sidebarPanel(

helpText("导入数据"),

  tabsetPanel(
  ##-------input data-------## 
  tabPanel("手动输入", p(br()),
    helpText("如有缺失值，请输入NA"),
    tags$textarea(id="x1", rows=10, "1.8\n3.3\n6.7\n1.4\n2.2\n1.6\n13.6\n2.8\n1.0\n2.8\n6.5\n6.8\n0.7\n0.9\n3.4\n3.3\n1.4\n0.9\n1.4\n1.8"),  ## disable on chrome
    tags$textarea(id="x2", rows=10, "8.7\n6.6\n6.0\n3.9\n1.6\n16.0\n14.1\n3.1\n4.0\n3.7\n3.1\n7.4\n6.0\n1.1\n3.0\n2.0\n5.0\n4.2\n5.0\n4.9"),
    helpText("改变两个样本的名称（可选）"), tags$textarea(id="cn2", rows=2, "X\nY")),

  ##-------csv file-------##   
  tabPanel("上传 .csv 格式文件", p(br()),
    fileInput('file2', '选择 .csv 格式文件', accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    checkboxInput('header2', '标题行', TRUE), #p
    radioButtons('sep2', '分隔符', c(Comma=',', Semicolon=';', Tab='\t'), ',')) ),

hr(),
h4("显示数据"), dataTableOutput("table2"),

hr(),
h4("图形设置"), sliderInput("bin2", "直方图中柱的宽度", min = 0.01, max = 5, value = 0.2)),

mainPanel(
  h3(tags$b('箱线图')), splitLayout(
    plotOutput("bp2", width = "400px", height = "400px", click = "plot_click2"),
    wellPanel(verbatimTextOutput("info2"), hr(),
      helpText(HTML("注释:
                    <ul> 
                    <li> 图中的各个点是在同一横轴上随机地模拟和定位的.</li>
                    <li> 如果存在，异常值将以红色突出显示. </li>
                    <li> 红色异常值可能不覆盖模拟点. </li>
                    <li> 红色异常值仅表示水平行同一横轴上的值.</li>  
                    </ul>")))),
  hr(),
  h3(tags$b('直方图')), plotOutput("makeplot2", width = "600px", height = "300px"),
  hr(),
  h3(tags$b('描述性统计量')), 
  splitLayout(tableOutput("bas2"), tableOutput("des2"), tableOutput("nor2")))  )),

  ## 3. Paired samples ---------------------------------------------------------------------------------
tabPanel("两个成对样本",    

headerPanel("符号检验与威尔科克森(Wilcoxon)符号秩检验"),

p("给定每位受试者的一对观察值（如治疗前和治疗后的体重），这两个检测都可以用来确定其中一个（如治疗前）是否倾向于大于（或小于）另一个（如治疗后）."),

tags$b("前提假设"),
tags$ul(
  tags$li("（x，y）的观测是成对的，来自同一总体."),
  tags$li("X和Y可以是连续的（即间隔或比率）和序数."),
  tags$li("D是独立的，来自同一总体.")),

tags$b("注释"),
tags$ul(
  tags$li("成对观测值被指定为x和y."),
  tags$li("D = X-Y, 成对（x，y）之间的差异."),
  tags$li("m 是D的总体中位数，或D的分布的百分之五十位的数.")),

sidebarLayout(

sidebarPanel(

  h4(tags$b("符号检验")),
  helpText("这种方法使用很少假设，并且具有非常普遍的适用性，但其统计效能可能不如其他方法."),
  
  helpText("假设检验"),
  tags$b("零假设"),
  p("m = 0: x和y之间的中值差值为零；x和y同样有效."),

  radioButtons("alt.ps", label = "对立假设", 
    choiceNames = list(
      HTML("m &#8800 0: x和y之间的中值的差异不是零；x和y不是同等有效."),
      HTML("m < 0: X的总体中位数较大，X更有效."),
      HTML("m > 0: Y的总体中位数较大，Y更有效.")),
      choiceValues = list("two.sided", "less", "greater")) ),

mainPanel(h3(tags$b('检验结果')), tableOutput("psign.test"), 
          helpText("Notes: 'Estimated.d' 表示中位数的估计差异.")
          )),

sidebarLayout(
  sidebarPanel(

  h4(tags$b("Wilcoxon符号秩检验")),
  helpText("此方法是当总体不能被假定为正态分布时，配对的t检验的替代方案。此方法也可以用于检验是否从具有相同分布的总体中选择两个相关样本."),
  
  tags$b("补充假设"),
  tags$ul(
    tags$li("D的分布是对称的."),
    tags$li("没有相同的D值 (No ties in D's).")),

  helpText("Ties意味着相同的价值"),

  helpText("假设"),
  tags$b("零假设"),
  p("m = 0: X和Y的中值之差不是零，配对值之差的分布是围绕零对称的."),

  radioButtons("alt.pwsr", label = "对立假设", 
    choiceNames = list(
      HTML("m &#8800 0: X和Y的中值之差不是零，配对值之差的分布在零附近不对称."),
      HTML("m < 0: Y的总体中位数较大."),
      HTML("m > 0: X的总体中位数较大.")),
    choiceValues = list("two.sided", "less", "greater")),

  helpText("Correction"),
  radioButtons("nap", label = "正态近似", 
    choices = list("样本量不很大" = FALSE,
                   "样本大小适中" = TRUE,
                   "样本量小" = TRUE), selected = FALSE),
  helpText("当样本量＞10时，可以应用正态近似.")),

  mainPanel(h3(tags$b('检验结果')), tableOutput("psr.test"), 
    helpText("当应用正态近似时，检验名称变成“具有连续性校正的Wilcoxon符号秩检验”.")
    ) ),

# data input
sidebarLayout(  
sidebarPanel(

helpText("导入数据"),

  tabsetPanel(
  ##-------input data-------## 
  tabPanel("手动输入", p(br()),
    helpText("如有缺失值，请输入NA"),
    tags$textarea(id="y1", rows=10, "1.8\n3.3\n6.7\n1.4\n2.2\n1.6\n13.6\n2.8\n1.0\n2.8\n6.5\n6.8\n0.7\n0.9\n3.4\n3.3\n1.4\n0.9\n1.4\n1.8"),  ## disable on chrome
    tags$textarea(id="y2", rows=10, "8.7\n6.6\n6.0\n3.9\n1.6\n16.0\n14.1\n3.1\n4.0\n3.7\n3.1\n7.4\n6.0\n1.1\n3.0\n2.0\n5.0\n4.2\n5.0\n4.9"),
    helpText("改变两个样本的名称（可选）"), tags$textarea(id="cn3", rows=2, "X\nY\n(X-Y)")),

  ##-------csv file-------##   
  tabPanel("上传 .csv 格式文件", p(br()),
    fileInput('file3', '选择 .csv 格式文件', accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    checkboxInput('header3', '标题行', TRUE), #p
    radioButtons('sep3', '分隔符', c(Comma=',', Semicolon=';', Tab='\t'), ',')) ),

hr(),
h4("显示数据"), dataTableOutput("table3"),

hr(),
h4("图形设置"), sliderInput("bin3", "直方图中柱的宽度", min = 0.01, max = 5, value = 0.2)),

mainPanel(
  h3(tags$b('箱线图')), splitLayout(
    plotOutput("bp3", width = "400px", height = "400px", click = "plot_click3"),
    wellPanel(verbatimTextOutput("info3"), hr(),
      helpText(HTML("Notes:
                    <ul> 
                    <li> Outliers will be highlighted in red, if existing. </li>
                    <li> The red outlier may not cover the simulated point. </li>
                    <li> The red outlier only indicates the value in horizontal line.</li>  
                    </ul>")))),
  hr(),
  h3(tags$b('直方图')), plotOutput("makeplot3", width = "600px", height = "300px"),
  hr(),
  h3(tags$b('描述性统计量')), 
  splitLayout(tableOutput("bas3"), tableOutput("des3"), tableOutput("nor3"))))

)
,
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

