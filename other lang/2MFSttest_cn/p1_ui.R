##----------#----------#----------#----------
##
## 2MFSttest UI
##
##    >Panel 1
##
## Language: CN
## 
## DT: 2019-01-08
##
##----------#----------#----------#----------
sidebarLayout(

sidebarPanel(
   
  h4("数据准备"),

  tabsetPanel(
  
    tabPanel("手动输入", p(br()),

      helpText("缺失值请输入NA"),

      tags$textarea(
        id = "x", #p
        rows = 10,
        "4.2\n5.3\n7.6\n6.7\n6.3\n3.5\n5.8\n6.3\n3.2\n4.6\n5.5\n5.2\n4.6\n4.8\n4.5\n5.3\n4.3\n4.3\n6.2\n6.7"
        ),

      helpText("改变样本的名称（可选)"),
      tags$textarea(id = "cn", rows = 1, "X") ), #tabPanel(


    tabPanel("上传CSV文件", p(br()),

        ##-------csv file-------##   
        fileInput('file', "选择CSV文件",
                  accept = c("text/csv",
                          "text/comma-separated-values,text/plain",
                          ".csv")),
        #helpText("The columns of X are not suggested greater than 500"),
        # Input: Checkbox if file has header ----
        checkboxInput("header", "第一行为变量名", TRUE),

             # Input: Select separator ----
        radioButtons("sep", "分隔符",
                     choices = c(Comma = ',',
                                 Semicolon = ';',
                                 Tab = '\t'),
                     selected = ',')

      ) 
    ),

hr(),

  h4("参数设置"),
  numericInput('mu', HTML("待比较的指定的平均值, &#956&#8320"), 7), #p

  h4("假设检验"),

  tags$b("零假设"),
  HTML("<p> &#956 = &#956&#8320，X的总体平均值是 &#956&#8320 </p>"),
  
  radioButtons(
    "alt", 
    label = "备择假设",
    choiceNames = list(
      HTML("&#956 &#8800 &#956&#8320: X组的总体平均值不是 &#956&#8320"),
      HTML("&#956 < &#956&#8320: X组的总体平均值小于 &#956&#8320"),
      HTML("&#956 > &#956&#8320: X组的总体平均值大于 &#956&#8320")
      ),
    choiceValues = list("two.sided", "less", "greater"))

    ),


mainPanel(

  h4("数据的描述统计"),

  tabsetPanel(

    tabPanel("数据显示", p(br()),  

      dataTableOutput("table")),

    tabPanel("描述性统计量", p(br()), 

      splitLayout(
        tableOutput("bas"), 
        tableOutput("des"), 
        tableOutput("nor"))  ),

    tabPanel("箱线图", p(br()), 
      splitLayout(
        plotOutput("bp", width = "400px", height = "400px", click = "plot_click1"),

      wellPanel(
        verbatimTextOutput("info1"), hr(),

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

    tabPanel("均值和标准偏差图", p(br()), 

      plotOutput("meanp", width = "400px", height = "400px")),

    tabPanel("正态性图", p(br()), 

      plotOutput("makeplot", width = "900px", height = "300px"), 
      sliderInput("bin","直方图柱子的宽度",min = 0.01,max = 5,value = 0.2))
  ),

  hr(),
  h4("检验结果"),
  tableOutput("t.test")

 )

)
