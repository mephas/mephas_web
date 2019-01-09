##----------#----------#----------#----------
##
## 2MFSttest UI
##
##    >Panel 2
##
## Language: EN
## 
## DT: 2019-01-08
##
##----------#----------#----------#----------
sidebarLayout(

sidebarPanel(
  
  h4("导入数据"),

  tabsetPanel(
    ##-------input data-------##
    tabPanel("手动输入", p(br()),
    
      helpText("如有缺失值，请输入NA"),

      tags$textarea(id = "x1",rows = 10,"4.2\n5.3\n7.6\n6.7\n6.3\n3.5\n5.8\n6.3\n3.2\n4.6\n5.5\n5.2\n4.6\n4.8\n4.5\n5.3\n4.3\n4.3\n6.2\n6.7"),
      ## disable on chrome
      tags$textarea(id = "x2",rows = 10,"6.6\n6.9\n6.9\n8.4\n7.8\n6.6\n8.6\n5.5\n4.6\n6.1\n7.1\n4.0\n6.5\n5.6\n8.1\n5.8\n7.9\n6.4\n6.5\n7.4"),

  helpText("改变样本的名称（可选)"),
  tags$textarea(id = "cn2", rows = 2, "X\nY")
      ),

    ##-------csv file-------##
    tabPanel("上传 .csv", p(br()),
      
      fileInput('file2','选择 .csv', #p
        accept = c(
          'text/csv',
          'text/comma-separated-values,text/plain',
          '.csv'
          )
        ),
      checkboxInput('header2', '标题', TRUE), #p
      radioButtons("sep2", "分隔",
                   choices = c(Comma = ',',
                               Semicolon = ';',
                               Tab = '\t'),
                   selected = ',')
      )
    ),

  hr(),

  h4("假设检验"),

  tags$b("零假设"),
  HTML("<p> &#956&#8321 = &#956&#8322: X and Y have equal population mean </p>"),
  
  radioButtons("alt.t2", #p
    label = "备则假设",
    choiceNames = list(
      HTML("&#956&#8321 &#8800 &#956&#8322: X组和Y组的总体均值相等"),
      HTML("&#956&#8321 < &#956&#8322: X组的总体均值小于Y组"),
      HTML("&#956&#8321 > &#956&#8322: X组的总体均值大于Y组")
      ),
    choiceValues = list("two.sided", "less", "greater")
    )
  ),

mainPanel(

  h4("数据描述"),

  tabsetPanel(

    tabPanel("数据显示", p(br()),  

      dataTableOutput("table2")),

    tabPanel("描述性统计量", p(br()), 
      
      splitLayout(
        tableOutput("bas2"),
        tableOutput("des2"),
        tableOutput("nor2")
        )),

    tabPanel("箱线图", p(br()), 
      splitLayout(
        plotOutput("bp2",width = "400px",height = "400px",click = "plot_click2"),
         
         wellPanel(
            verbatimTextOutput("info2"), 
            hr(),
            
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
         )),

    tabPanel("均值和标准偏差图", p(br()), 

      plotOutput("meanp2", width = "400px", height = "400px")),

    tabPanel("正态性图", p(br()), 

      plotOutput("makeplot2", width = "600px", height = "600px"),
      sliderInput("bin2","The width of bins in histogram",min = 0.01,max = 5,value = 0.2))

    ),

  hr(),
  h4("检验结果"),
  tableOutput("var.test"),
  helpText("当P值小于0.05, 请参考 'Welch Two Sample t-test'的结果"),
  tableOutput("t.test2")
  
  )
)