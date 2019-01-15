##----------#----------#----------#----------
##
## 1MFSdistribution UI
##
## Language: JP
## 
## DT: 2019-01-08
##
##----------#----------#----------#----------

shinyUI(
  
tagList(
#shinythemes::themeSelector(),
navbarPage(
  
  title = "確率分布",

##---------- Panel 1 ---------

tabPanel("離散確率分布",

###---------- 1.1 ---------

titlePanel("正規分布 (ガウス分布)"),

tags$b("パラメータ"), 
tags$ul(
  tags$li(HTML("&#956: 平均")),
  tags$li(HTML("&#963: 標準偏差"))
  ),

splitLayout(

  wellPanel(style = "background-color: #ffffff;",
    h4(tags$b("正規分布 (理論上)")),

    hr(),
    tags$b("パラメータ設定"),
    fluidRow(
      column(3, numericInput("xlim", "X軸の範囲", value = 5, min = 1, max = 20)),
      column(3, numericInput("ylim", "Y軸の範囲", value = 0.5, min = 0.1, max = 1)),
      column(3, numericInput("pr", HTML('線分の左側の確率, Pr(X <= value)'), value = 0.025, min = 0, max = 1, step = 0.05))),

    fluidRow(
      column(3, numericInput("mu", HTML("平均 (&#956)"), value = 0, min = -100, max = 100)),
      column(3, numericInput("sigma", HTML("標準偏差 (&#963)"), value = 1, min = 0.1, max = 10)),
      column(3, numericInput("n", HTML("標準偏差＊Nの範囲"), value = 1, min = 0, max = 10))),
    p(br()),
    plotOutput("norm.plot", click = "plot_click", width = "400px", height = "300px"),
    hr(),  
    verbatimTextOutput("info"),
    p(br()),
    helpText("青い色の部分の割合（％）"),
    tableOutput("xs")
    ),

  wellPanel(

    h4(tags$b("分布例 (シミュレーション)")),

    hr(),
    tags$b("パラメータ設定"),

    fluidRow(
      column(3, numericInput("bin", "ヒストグラムの棒幅", value = 0.1, min = 0.01, max = 5, step = 0.1))),
    fluidRow(
      column(6, sliderInput("size", "データサイズ", min = 0, max = 10000, value = 1000))),

    plotOutput("norm.plot2", click = "plot_click2", width = "400px", height = "300px"),

    hr(),
    verbatimTextOutput("info2"),
    p(br()),
    helpText("標準偏差と平均"),
    tableOutput("sum"),
    verbatimTextOutput("data")
    #>tags$b("The first 100 simulated values"),
    #>dataTableOutput("table1")
    )
  ),

###---------- 1.2 ---------

titlePanel("指数分布"),

tags$b("パラメータ"), 
tags$ul(
  tags$li(HTML("r: 母数"))),

splitLayout(

  wellPanel(style = "background-color: #ffffff;",
    h4(tags$b("指数分布 (理論上)")),
    
    hr(),
    tags$b("パラメータ設定"),
    fluidRow(
      column(3, numericInput("e.xlim", "X軸の範囲", value = 5, min = 1, max = 10, step = 0.5)),
      column(3, numericInput("e.ylim", "Y軸の範囲", value = 2.5, min = 0.1, max = 3, step = 0.1)),
      column(3, numericInput("e.pr", "直線の左側の範囲", value = 0.5, min = 0, max = 1, step = 0.01))),
    fluidRow(
      column(5, sliderInput("r", HTML("パラメータ"), min = 0, max = 10, value =1, step = 0.1))),

    plotOutput("e.plot", click = "plot_click9", width = "400px", height = "300px"),
    hr(),
    verbatimTextOutput("e.info"),
    p(br()),
    helpText("直線のx座標"),
    tableOutput("e")),

  wellPanel(
    h4(tags$b("サンプル指数分布 (シミュレーション)")),

    hr(),
    tags$b("パラメータ設定"),
    
    fluidRow(
      column(3, numericInput("e.bin", "ヒストグラムの棒幅", value = 0.1, min = 0.01, max = 5, step = 0.1))),

    fluidRow(
      column(6, sliderInput("e.size", "サンプルサイズ", min = 0, max = 10000, value = 1000))),
    
    plotOutput("e.plot2", click = "plot_click10", width = "400px", height = "300px"),
    hr(),
    verbatimTextOutput("e.info2"),
    p(br()),
    helpText("サンプルの標準偏差と平均"),
    tableOutput("e.sum")
    #>tags$b("The first 100 simulated values"),
    #>dataTableOutput("table5")
    )
  ),

###---------- 1.3 ---------

titlePanel("ガンマ分布"),
tags$b("パラメータ"), 
tags$ul(
  tags$li(HTML("&#945: 形状母数")),
  tags$li(HTML("&#952: 尺度母数"))
  ),
tags$b("注"), 
tags$ul(
  tags$li(HTML("&#946=1/&#952: 倍率パラメータ")),
  tags$li(HTML("平均 &#945*&#952"))
  ),

splitLayout(

  wellPanel(style = "background-color: #ffffff;",
    h4(tags$b("ガンマ分布 (理論上)")),
    
    hr(),
    tags$b("パラメータ設定"),
    fluidRow(
      column(3, numericInput("g.xlim", "X軸の範囲", value = 5, min = 1, max = 20, step = 0.5)),
      column(3, numericInput("g.ylim", "Y軸の範囲", value = 0.5, min = 0, max = 1.5, step = 0.1)),
      column(3, numericInput("g.pr", "直線の左側の範囲", value = 0.5, min = 0, max = 1, step = 0.01))),
    fluidRow(
      column(5, sliderInput("g.shape", HTML("&#945, 形状"), min = 0, max = 10, value =0.5, step = 0.1)),
      column(5, sliderInput("g.scale", HTML("&#952, 尺度"), min = 0, max = 10, value =1, step = 0.1))),

    plotOutput("g.plot", click = "plot_click11", width = "400px", height = "300px"),
    hr(),
    verbatimTextOutput("g.info"),
    p(br()),
    helpText("直線のx座標"),
    tableOutput("g")),

  wellPanel(
    h4(tags$b("サンプルのガンマ分布 (シミュレーション)")),

    hr(),
    tags$b("パラメータ設定"),
    
    fluidRow(
      column(3, numericInput("g.bin", "ヒストグラムの棒幅", value = 0.1, min = 0.01, max = 5, step = 0.1))),

    fluidRow(
      column(6, sliderInput("g.size", "サンプルサイズ", min = 0, max = 10000, value = 1000))),
    
    plotOutput("g.plot2", click = "plot_click12", width = "400px", height = "300px"),
    hr(),
    verbatimTextOutput("g.info2"),
    p(br()),
    helpText("サンプルの標準偏差と平均"),
    tableOutput("g.sum")
    #>tags$b("The first 100 simulated values"),
    #>dataTableOutput("table5")
    )
)
),

##---------- Panel 2 ---------

tabPanel("正規分布からの派生分布",

###---------- 2.1 ---------

titlePanel("スチューデントのt分布"),

tags$b("パラメータ"), 
tags$ul(
  tags$li(HTML("v: 自由度"))
  ),

tags$b("注"),
tags$ul(
  tags$li(HTML("もしVが極端に大きいとT分布は正規分布に近づく"))), 

splitLayout(
  wellPanel(style = "background-color: #ffffff;",
    h4(tags$b("スチューデントのt分布 (理論上)")),

    hr(),
    tags$b("パラメータ設定"),
    fluidRow(
      column(3, numericInput("t.xlim", "X軸の範囲", value = 5, min = 1, max = 10, step = 0.5)),
      column(3, numericInput("t.ylim", "Y軸の範囲", value = 0.5, min = 0.1, max = 1, step = 0.1)),
      column(3, numericInput("t.pr", "直線の左側の確率", value = 0.025, min = 0, max = 1, step = 0.01))),
    sliderInput("t.df", HTML("自由度 (v):"), min = 0.01, max = 50, value =4, width ="50%"),
    
    plotOutput("t.plot", click = "plot_click3", width = "400px", height = "300px"),
    hr(),
    verbatimTextOutput("t.info"),
    p(br()),
    helpText("直線のx座標 (青の曲線は正規分布)"),
    tableOutput("t")),

  wellPanel(
    h4(tags$b("スチューデントのt分布 (シミュレーション)")),

    hr(),
    tags$b("パラメータ設定"),
    fluidRow(
      column(3, numericInput("t.bin", "ヒストグラムの棒幅", value = 0.1, min = 0.01, max = 5, step = 0.1))),
    fluidRow(
      column(6, sliderInput("t.size", "サンプルサイズ", min = 0, max = 10000, value = 1000))),

    plotOutput("t.plot2", click = "plot_click4", width = "400px", height = "300px"),      
    hr(),
    verbatimTextOutput("t.info2"),
    p(br()),
    helpText("サンプルの標準偏差と平均"),
    tableOutput("t.sum")
    #>tags$b("The first 100 simulated values"),
    #>dataTableOutput("table2")
    )
  ),

###---------- 2.2 ---------

titlePanel("カイ二乗分布"),

tags$b("パラメータ"), 
tags$ul(
  tags$li(HTML("v: 自由度"))),

tags$b("注"),
tags$ul(
  tags$li(HTML("平均 = v; 分散 = 2v"))),

splitLayout(
  wellPanel(style = "background-color: #ffffff;",
    h4(tags$b("カイ二乗分布 (理論上)")),
   
    hr(),
    tags$b("パラメータ設定"),
    fluidRow(
      column(3, numericInput("x.xlim", "X軸の範囲", value = 5, min = 1, max = 10, step = 0.5)),
      column(3, numericInput("x.ylim", "Y軸の範囲", value = 0.75, min = 0.1, max = 1, step = 0.1)),
      column(3, numericInput("x.pr", "直線の左側の確率", value = 0.5, min = 0, max = 1, step = 0.01))),
    fluidRow(
      column(6, sliderInput("x.df", HTML("自由度 (v):"), min = 0, max = 10, value =1))),
    
    plotOutput("x.plot", click = "plot_click5", width = "400px", height = "300px"),
    hr(),
    verbatimTextOutput("x.info"),
    p(br()),
    helpText("直線のx座標"),
    tableOutput("xn")),
  
  wellPanel(
    h4(tags$b("カイ二乗分布 (シミュレーション)")),

    hr(),
    tags$b("パラメータ設定"),
    fluidRow(
      column(3, numericInput("x.bin", "ヒストグラムの棒幅", value = 0.1, min = 0.01, max = 5, step = 0.1))),
    fluidRow(
      column(6, sliderInput("x.size", "サンプルサイズ", min = 0, max = 10000, value = 1000))),
   
    plotOutput("x.plot2", click = "plot_click6", width = "400px", height = "300px"),
    hr(),    
    verbatimTextOutput("x.info2"),
    p(br()),
    helpText("サンプルの標準偏差と平均"),
    tableOutput("x.sum")
    #>tags$b("The first 100 simulated values"),
    #>dataTableOutput("table3")
    )
  ),

###---------- 2.3 ---------

titlePanel("F分布"),

tags$b("パラメータ"), 
tags$ul(
  tags$li(HTML("u: 第一自由度")),
  tags$li(HTML("v: 第二自由度"))),

splitLayout(
  wellPanel(style = "background-color: #ffffff;",
    h4(tags$b("F分布 (理論上)")),
    
    hr(),
    tags$b("パラメータ設定"),
    fluidRow(
      column(3, numericInput("f.xlim", "x軸の範囲", value = 5, min = 1, max = 10, step = 0.5)),
      column(3, numericInput("f.ylim", "y軸の範囲", value = 2.5, min = 0.1, max = 3, step = 0.1)),
      column(3, numericInput("f.pr", "直線の左側の確率", value = 0.5, min = 0, max = 1, step = 0.01))),
    fluidRow(
      column(5, sliderInput("df11", HTML("第一自由度 (u):"), min = 0, max = 200, value =100)),
      column(5, sliderInput("df21", HTML("第二自由度 (v):"), min =0, max = 200, value =100))),

    plotOutput("f.plot", click = "plot_click7", width = "400px", height = "300px"),
    hr(),
    verbatimTextOutput("f.info"),
    p(br()),
    helpText("直線のx座標"),
    tableOutput("f")),
  wellPanel(
    h4(tags$b("サンプルのF分布 (シミュレーション)")),

    hr(),
    tags$b("パラメータ設定"),
    
    fluidRow(
      column(3, numericInput("f.bin", "ヒストグラムの棒幅", value = 0.1, min = 0.01, max = 5, step = 0.1))),

    fluidRow(
      column(6, sliderInput("f.size", "サンプルサイズ", min = 0, max = 10000, value = 1000))),
    
    plotOutput("f.plot2", click = "plot_click8", width = "400px", height = "300px"),
    hr(),   
    verbatimTextOutput("f.info2"),
    p(br()),
    helpText("サンプルの標準偏差と平均"),
    tableOutput("f.sum")
    #>tags$b("The first 100 simulated values"),
    #>dataTableOutput("table4")
    )
  )
),

##---------- Panel 3 ---------

tabPanel("離散確率変数",

titlePanel("二項分布, ポアソン分布"),

tags$b("注"),
tags$ul(
  tags$li("青の曲線は正規近似を表す"),
  tags$li("二項分布における平均はnp、分散はnpq"),
  tags$li("ポワソン分布における平均と分散はパラメータ")),

splitLayout(

###---------- 3.1 ---------

  wellPanel(style = "background-color: #ffffff;",
    h4(tags$b("二項分布")),
    hr(),
    tags$b("パラメータ設定"),

    fluidRow(
      column(3, numericInput("m", "試行回数", value = 10, min = 1 , max = 1000)),
      column(3, numericInput("p", "成功する確率", value = 0.5, min = 0, max = 1, step = 0.1)),
      column(3, numericInput("xlim.b", "X軸の範囲", value = 20, min = 1, max = 100)),
      column(3, numericInput("k", "成功回数 (x0とする)", value = 0, min =  0, max = 1000))),

    hr(),  
    plotOutput("b.plot", width = "400px", height = "400px"),
    helpText("成功する回数がx0となる時"),
    tableOutput("b.k")
    #>dataTableOutput("bino")
    ),

###---------- 3.2 ---------

  wellPanel(style = "background-color: #ffffff;",
    h4(tags$b("ポワソン分布")),
    hr(),
    tags$b("パラメータ設定"),

    fluidRow(
      column(3, numericInput("k2", "最大発生回数", value = 10, min =  0, max = 1000)),
      column(3, numericInput("lad", "パラメータ", value = 5, min = 0, max = 1000)),
      column(3, numericInput("x0", "発生回数", value = 0, min =  0, max = 1000)),
      column(3, numericInput("xlim2", "x軸の範囲", value = 20, min = 1, max = 100))),

    hr(),  
    plotOutput("p.plot", width = "400px", height = "400px"),
    helpText("発生確率"),
    tableOutput("p.k")
    #>dataTableOutput("poi")
    )
  )
),

##---------- other panels ----------


source("../0tabs/home_jp.R",local=TRUE,encoding="UTF-8")$value,
source("../0tabs/stop_jp.R",local=TRUE,encoding="UTF-8")$value


))
)
