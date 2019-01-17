##----------#----------#----------#----------
##
## 1MFSdistribution UI
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
      theme="mephas_cn.css",
      title = "概率分布",
      
      ##---------- Panel 1 ---------
      
      tabPanel("连续型随机变量",
               
               ###---------- 1.1 ---------
               
               titlePanel("正态分布（高斯分布）"),
               
               tags$b("参数"), 
               tags$ul(
                 tags$li(HTML("&#956: 平均值表示位置")),
                 tags$li(HTML("&#963: 标准差表示变动"))
               ),
               
               splitLayout(
                 
                 wellPanel(style = "background-color: #ffffff;",
                           h4(tags$b("正态分布（基于数学）")),
                           
                           hr(),
                           tags$b("参数设置"),
                           fluidRow(
                             column(3, numericInput("xlim", "x轴的范围", value = 5, min = 1, max = 20)),
                             column(3, numericInput("ylim", "y轴的范围", value = 0.5, min = 0.1, max = 1)),
                             column(3, numericInput("pr", "线左边的面积, Pr(X <= value)", value = 0.025, min = 0, max = 1, step = 0.05))),
                           
                           fluidRow(
                             column(3, numericInput("mu", HTML("平均值 (&#956) "), value = 0, min = -100, max = 100)),
                             column(3, numericInput("sigma", HTML("标准差 (&#963)"), value = 1, min = 0.1, max = 10)),
                             column(3, numericInput("n", HTML("N倍标准差中间的面积"), value = 1, min = 0, max = 10))),
                           p(br()),
                           plotOutput("norm.plot", click = "plot_click", width = "400px", height = "300px"),
                           hr(),  
                           verbatimTextOutput("info"),
                           p(br()),
                           helpText("x的位置和蓝色区域的面积(%)"),
                           tableOutput("xs")
                 ),
                 wellPanel(
                   
                   h4(tags$b("正态分布（模拟的样本）")),
                   
                   hr(),
                   tags$b("参数设置"),
                   
                   fluidRow(
                     column(3, numericInput("bin", "直方图中柱的宽度", value = 0.1, min = 0.01, max = 5, step = 0.1))),
                   fluidRow(
                     column(6, sliderInput("size", "样本量的大小", min = 0, max = 10000, value = 1000))),
                   
                   plotOutput("norm.plot2", click = "plot_click2", width = "400px", height = "300px"),
                   
                   hr(),
                   verbatimTextOutput("info2"),
                   p(br()),
                   helpText("样本均值和标准差"),
                   tableOutput("sum"),
                   verbatimTextOutput("data")
                   #>tags$b("The first 100 simulated values"),
                   #>dataTableOutput("table1")
                 )
               ),
               
               ###---------- 1.2 ---------
               
               titlePanel("指数分布"),
               
               tags$b("参数"), 
               tags$ul(
                 tags$li(HTML("r: 率或逆尺度参数"))),
               
               splitLayout(
                 
                 wellPanel(style = "background-color: #ffffff;",
                           h4(tags$b("指数分布（基于数学）")),
                           
                           hr(),
                           tags$b("参数设置"),
                           fluidRow(
                             column(3, numericInput("e.xlim", "x轴的范围", value = 5, min = 1, max = 10, step = 0.5)),
                             column(3, numericInput("e.ylim", "y轴的范围", value = 2.5, min = 0.1, max = 3, step = 0.1)),
                             column(3, numericInput("e.pr", "线左边的面积", value = 0.5, min = 0, max = 1, step = 0.01))),
                           fluidRow(
                             column(5, sliderInput("r", HTML("参数"), min = 0, max = 10, value =1, step = 0.1))),
                           
                           plotOutput("e.plot", click = "plot_click9", width = "400px", height = "300px"),
                           hr(),
                           verbatimTextOutput("e.info"),
                           p(br()),
                           helpText("x的位置"),
                           tableOutput("e")),
                 wellPanel(
                   h4(tags$b("指数分布（模拟的样本）")),
                   
                   hr(),
                   tags$b("参数设置"),
                   
                   fluidRow(
                     column(3, numericInput("e.bin", "直方图中柱的宽度", value = 0.1, min = 0.01, max = 5, step = 0.1))),
                   
                   fluidRow(
                     column(6, sliderInput("e.size", "样本量的大小", min = 0, max = 10000, value = 1000))),
                   
                   plotOutput("e.plot2", click = "plot_click10", width = "400px", height = "300px"),
                   hr(),
                   verbatimTextOutput("e.info2"),
                   p(br()),
                   helpText("样本均值和标准差"),
                   tableOutput("e.sum")
                   #>tags$b("The first 100 simulated values"),
                   #>dataTableOutput("table5")
                 )
               ),
               
               ###---------- 1.3 ---------
               
               titlePanel("伽马分布"),
               tags$b("参数"), 
               tags$ul(
                 tags$li(HTML("&#945: 形状参数")),
                 tags$li(HTML("&#952: 尺度参数"))
               ),
               tags$b("注"), 
               tags$ul(
                 tags$li(HTML("&#946=1/&#952: 率参数")),
                 tags$li(HTML("平均值是 &#945*&#952"))
               ),
               
               splitLayout(
                 
                 wellPanel(style = "background-color: #ffffff;",
                           h4(tags$b("伽马分布（基于数学）")),
                           
                           hr(),
                           tags$b("参数设置"),
                           fluidRow(
                             column(3, numericInput("g.xlim", "x轴的范围", value = 5, min = 1, max = 20, step = 0.5)),
                             column(3, numericInput("g.ylim", "y轴的范围", value = 0.5, min = 0, max = 1.5, step = 0.1)),
                             column(3, numericInput("g.pr", "线左边的面积", value = 0.5, min = 0, max = 1, step = 0.01))),
                           fluidRow(
                             column(5, sliderInput("g.shape", HTML("&#945, 形状"), min = 0, max = 10, value =0.5, step = 0.1)),
                             column(5, sliderInput("g.scale", HTML("&#952, 尺度"), min = 0, max = 10, value =1, step = 0.1))),
                           
                           plotOutput("g.plot", click = "plot_click11", width = "400px", height = "300px"),
                           hr(),
                           verbatimTextOutput("g.info"),
                           p(br()),
                           helpText("x的位置"),
                           tableOutput("g")),
                 
                 wellPanel(
                   h4(tags$b("伽马分布（模拟的样本）")),
                   
                   hr(),
                   tags$b("设置"),
                   
                   fluidRow(
                     column(3, numericInput("g.bin", "直方图中柱的宽度", value = 0.1, min = 0.01, max = 5, step = 0.1))),
                   
                   fluidRow(
                     column(6, sliderInput("g.size", "样本量的大小", min = 0, max = 10000, value = 1000))),
                   
                   plotOutput("g.plot2", click = "plot_click12", width = "400px", height = "300px"),
                   hr(),
                   verbatimTextOutput("g.info2"),
                   p(br()),
                   helpText("样本均值和标准差"),
                   tableOutput("g.sum")
                   #>tags$b("The first 100 simulated values"),
                   #>dataTableOutput("table5")
                 )
               )
      ),
      
      ##---------- Panel 2 ---------
      
      tabPanel("正态分布的衍生分布",
               
               ###---------- 2.1 ---------
               
               titlePanel("学生氏t分布"),
               
               tags$b("参数"), 
               tags$ul(
                 tags$li(HTML("v: 自由度"))
               ),
               
               tags$b("注"),
               tags$ul(
                 tags$li(HTML("当v非常大时，t分布近似于标准正态分布."))), 
               
               splitLayout(
                 wellPanel(style = "background-color: #ffffff;",
                           h4(tags$b("学生氏t分布（基于数学）")),
                           
                           hr(),
                           tags$b("参数设置"),
                           fluidRow(
                             column(3, numericInput("t.xlim", "x轴的范围", value = 5, min = 1, max = 10, step = 0.5)),
                             column(3, numericInput("t.ylim", "y轴的范围", value = 0.5, min = 0.1, max = 1, step = 0.1)),
                             column(3, numericInput("t.pr", "线左边的面积", value = 0.025, min = 0, max = 1, step = 0.01))),
                           sliderInput("t.df", HTML("自由度 (v):"), min = 0.01, max = 50, value =4, width ="50%"),
                           
                           plotOutput("t.plot", click = "plot_click3", width = "400px", height = "300px"),
                           hr(),
                           verbatimTextOutput("t.info"),
                           p(br()),
                           helpText("x的位置（蓝色曲线是标准正态分布）"),
                           tableOutput("t")),
                 wellPanel(
                   h4(tags$b("学生氏t分布（模拟的样本）")),
                   
                   hr(),
                   tags$b("参数设置"),
                   fluidRow(
                     column(3, numericInput("t.bin", "直方图中柱的宽度", value = 0.1, min = 0.01, max = 5, step = 0.1))),
                   fluidRow(
                     column(6, sliderInput("t.size", "样本量的大小", min = 0, max = 10000, value = 1000))),
                   
                   plotOutput("t.plot2", click = "plot_click4", width = "400px", height = "300px"),      
                   hr(),
                   verbatimTextOutput("t.info2"),
                   p(br()),
                   helpText("样本均值和标准差"),
                   tableOutput("t.sum")
                   #>tags$b("The first 100 simulated values"),
                   #>dataTableOutput("table2")
                 )
               ),
               
               ###---------- 2.2 ---------
               
               titlePanel("卡方分布"),
               
               tags$b("参数"), 
               tags$ul(
                 tags$li(HTML("v: 自由度"))),
               
               tags$b("注"),
               tags$ul(
                 tags$li(HTML("平均值 = v; 方差 = 2v"))),
               
               splitLayout(
                 wellPanel(style = "background-color: #ffffff;",
                           h4(tags$b("卡方分布（数学）")),
                           
                           hr(),
                           tags$b("参数设置"),
                           fluidRow(
                             column(3, numericInput("x.xlim", "x轴的范围", value = 5, min = 1, max = 10, step = 0.5)),
                             column(3, numericInput("x.ylim", "y轴的范围", value = 0.75, min = 0.1, max = 1, step = 0.1)),
                             column(3, numericInput("x.pr", "线左边的面积", value = 0.5, min = 0, max = 1, step = 0.01))),
                           fluidRow(
                             column(6, sliderInput("x.df", HTML("自由度 (v):"), min = 0, max = 10, value =1))),
                           
                           plotOutput("x.plot", click = "plot_click5", width = "400px", height = "300px"),
                           hr(),
                           verbatimTextOutput("x.info"),
                           p(br()),
                           helpText("x的位置"),
                           tableOutput("xn")),
                 wellPanel(
                   h4(tags$b("卡方分布样本（模拟的样本）")),
                   
                   hr(),
                   tags$b("设置"),
                   fluidRow(
                     column(3, numericInput("x.bin", "直方图中柱的宽度", value = 0.1, min = 0.01, max = 5, step = 0.1))),
                   fluidRow(
                     column(6, sliderInput("x.size", "样本量的大小", min = 0, max = 10000, value = 1000))),
                   
                   plotOutput("x.plot2", click = "plot_click6", width = "400px", height = "300px"),
                   hr(),    
                   verbatimTextOutput("x.info2"),
                   p(br()),
                   helpText("样本均值和标准差"),
                   tableOutput("x.sum")
                   #>tags$b("The first 100 simulated values"),
                   #>dataTableOutput("table3")
                 )
               ),
               
               ###---------- 2.3 ---------
               
               titlePanel("F分布"),
               
               tags$b("参数"), 
               tags$ul(
                 tags$li(HTML("u: 第一组的自由度")),
                 tags$li(HTML("v: 第二组的自由度"))),
               
               splitLayout(
                 wellPanel(style = "background-color: #ffffff;",
                           h4(tags$b("F分布（基于数学）")),
                           
                           hr(),
                           tags$b("参数设置"),
                           fluidRow(
                             column(3, numericInput("f.xlim", "x轴的范围", value = 5, min = 1, max = 10, step = 0.5)),
                             column(3, numericInput("f.ylim", "y轴的范围", value = 2.5, min = 0.1, max = 3, step = 0.1)),
                             column(3, numericInput("f.pr", "线左边的面积", value = 0.5, min = 0, max = 1, step = 0.01))),
                           fluidRow(
                             column(5, sliderInput("df11", HTML("第一组的自由度 (u):"), min = 0, max = 200, value =100)),
                             column(5, sliderInput("df21", HTML("第二组的自由度 (v):"), min =0, max = 200, value =100))),
                           
                           plotOutput("f.plot", click = "plot_click7", width = "400px", height = "300px"),
                           hr(),
                           verbatimTextOutput("f.info"),
                           p(br()),
                           helpText("x的位置"),
                           tableOutput("f")),
                 wellPanel(
                   h4(tags$b("F分布（模拟的样本）")),
                   
                   hr(),
                   tags$b("参数设置"),
                   
                   fluidRow(
                     column(3, numericInput("f.bin", "直方图中柱的宽度", value = 0.1, min = 0.01, max = 5, step = 0.1))),
                   
                   fluidRow(
                     column(6, sliderInput("f.size", "样本量的大小", min = 0, max = 10000, value = 1000))),
                   
                   plotOutput("f.plot2", click = "plot_click8", width = "400px", height = "300px"),
                   hr(),   
                   verbatimTextOutput("f.info2"),
                   p(br()),
                   helpText("样本均值和标准差"),
                   tableOutput("f.sum")
                   #>tags$b("The first 100 simulated values"),
                   #>dataTableOutput("table4")
                 )
               )
      ),
      
      ##---------- Panel 3 ---------
      
      tabPanel("离散型随机变量",
               
               titlePanel("二项分布，泊松分布"),
               
               tags$b("注"),
               tags$ul(
                 tags$li("蓝色曲线是标准正态分布"),
                 tags$li("二项分布的均值 ＝ np，  方差＝ npq"),
                 tags$li("泊松分布的均值 ＝ 方差＝ 参数")),
               
               splitLayout(
                 
                 ###---------- 3.1 ---------
                 
                 wellPanel(style = "background-color: #ffffff;",
                           h4(tags$b("二项分布")),
                           hr(),
                           tags$b("参数设置"),
                           
                           fluidRow(
                             column(3, numericInput("m", "试验总次数", value = 10, min = 1 , max = 1000)),
                             column(3, numericInput("p", "成功的概率", value = 0.5, min = 0, max = 1, step = 0.1)),
                             column(3, numericInput("xlim.b", "x轴的范围", value = 20, min = 1, max = 100)),
                             column(3, numericInput("k", "成功的次数(x0)", value = 0, min =  0, max = 1000))),
                           
                           hr(),  
                           plotOutput("b.plot", width = "400px", height = "400px"),
                           helpText("概率 X=x0 为"),
                           tableOutput("b.k")
                           #>dataTableOutput("bino")
                 ),
                 
                 ###---------- 3.2 ---------
                 
                 wellPanel(style = "background-color: #ffffff;",
                           h4(tags$b("泊松分布")),
                           hr(),
                           tags$b("参数设置"),
                           
                           fluidRow(
                             column(3, numericInput("k2", "出现次数", value = 10, min =  0, max = 1000)),
                             column(3, numericInput("lad", "参数", value = 5, min = 0, max = 1000)),
                             column(3, numericInput("x0", "X = x0", value = 0, min =  0, max = 1000)),
                             column(3, numericInput("xlim2", "x轴的范围", value = 20, min = 1, max = 100))),
                           
                           hr(),  
                           plotOutput("p.plot", width = "400px", height = "400px"),
                           helpText("概率 X=x0 为"),
                           tableOutput("p.k")
                           #>dataTableOutput("poi")
                 )
               )
      ),
      
      ##---------- other panels ----------
      
      source("../0tabs/home_cn.R",local=TRUE)$value,
      source("../0tabs/stop_cn.R",local=TRUE)$value
      
    ))
)



