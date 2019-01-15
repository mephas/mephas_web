##----------#----------#----------#----------
##
## 2MFSttest UI
##
##    >Panel 2
##
## Language: JP
## 
## DT: 2019-01-09
##
##----------#----------#----------#----------

sidebarLayout(

sidebarPanel(
  
    h4("データ挿入"),

    tabsetPanel(
      ##-------input data-------##
    tabPanel("手入力", p(br()),

    helpText("欠損値はNAと表示されます"),
        tags$textarea(id = "x1",rows = 10,"4.2\n5.3\n7.6\n6.7\n6.3\n3.5\n5.8\n6.3\n3.2\n4.6\n5.5\n5.2\n4.6\n4.8\n4.5\n5.3\n4.3\n4.3\n6.2\n6.7"),
        ## disable on chrome
        tags$textarea(id = "x2",rows = 10,"6.6\n6.9\n6.9\n8.4\n7.8\n6.6\n8.6\n5.5\n4.6\n6.1\n7.1\n4.0\n6.5\n5.6\n8.1\n5.8\n7.9\n6.4\n6.5\n7.4"),

    helpText("サンプルの名称変更"),
    tags$textarea(id = "cn2", rows = 2, "X\nY")
        ),

      ##-------csv file-------##
      tabPanel(
        "アップロード CSV ファイル",
        p(br()),
        
        fileInput('file', "CSV ファイルを指定してください",
          accept = c(
            'text/csv',
            'text/comma-separated-values,text/plain',
            '.csv'
            )
          ),
        checkboxInput('header2', 'ヘッダー', TRUE), #p
        radioButtons("sep2", "区切り",
                     choices = c(Comma = ',',
                                 Semicolon = ';',
                                 Tab = '\t'),
                     selected = ',')
        )
      ),

    hr(),

    h4("仮説"),

    tags$b("帰無仮説"),
    HTML("<p> &#956&#8321 = &#956&#8322: XとYの人口平均は等しい </p>"),
    
    radioButtons("alt.t2", #p
      label = "対立仮説",
      choiceNames = list(
        HTML("&#956&#8321 &#8800 &#956&#8322: XとYの人口平均は等しくありません"),
        HTML("&#956&#8321 < &#956&#8322: Xの母集団平均がYより小さい"),
        HTML("&#956&#8321 > &#956&#8322: Xの母集団平均がYより大きい")
        ),
      choiceValues = list("two.sided", "less", "greater")
      )
    ),

  mainPanel(

    h4("データの記述統計"),

    tabsetPanel(

      tabPanel("データ表示",p(br()), 

        dataTableOutput("table2")),

      tabPanel("記述統計",p(br()), 
        
        splitLayout(
          tableOutput("bas2"),
          tableOutput("des2"),
          tableOutput("nor2")
          )),

      tabPanel("箱ヒゲ図",p(br()),     
        splitLayout(
          plotOutput("bp2",width = "400px",height = "400px",click = "plot_click2"),
           
           wellPanel(
              verbatimTextOutput("info2"), 
              hr(),
              
              helpText(
                HTML(
          "注:
          <ul> 
          <li> 外れ値が存在する場合は、外れ値が赤で強調表示される </li>
          <li> 赤の外れ値はシミュレートポイントをカバーしていない可能性がある </li>
          <li> 赤い外れ値は、横線の値のみを示す</li>  
          </ul>"
                  )
                )
              )              
           )),

      tabPanel("平均と標準偏差プロット", p(br()), 

        plotOutput("meanp2", width = "400px", height = "400px")),

      tabPanel("正規性のプロット", p(br()), 

        plotOutput("makeplot2", width = "600px", height = "600px"),
        sliderInput("bin2","ヒストグラムの棒幅",min = 0.01,max = 5,value = 0.2))

      ),

    hr(),
    h4(tags$b("検定結果")),
    tableOutput("var.test"),
    helpText("P値<0.05の場合は、 'Welch Two Sample t-test'に進んでください。"),
    tableOutput("t.test2")
    
    )
  )