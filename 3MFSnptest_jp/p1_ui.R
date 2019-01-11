##----------#----------#----------#----------
##
## 3MFSnptest UI
##
##    >Panel 1
##
## Language: EN
## 
## DT: 2019-01-09
##
##----------#----------#----------#----------
##---------- Sign Test ----------
signtest<-sidebarLayout(


sidebarPanel(

h4("仮説"),

tags$b("帰無仮説"),
HTML("<p> m = m&#8320: 母集団の中央値は特定の値と等しい </p>"),

radioButtons("alt.st", label = "対立仮説", 
  choiceNames = list(
  HTML("m &#8800 m&#8320: 母集団の中央値は特定の値と異なる"),
  HTML("m < m&#8320: 母集団の中央値は特定の値より小さい"),
  HTML("m > m&#8320: 母集団の中央値は特定の値より大きい")),
choiceValues = list("two.sided", "less", "greater"))),

  mainPanel(
    h4('符号検定の検定結果'), 
    tableOutput("sign.test")
    )  
  )

##---------- Wilcoxon Signed-Rank Test ----------

wstest<-sidebarLayout(

sidebarPanel(

h4("仮説"),

tags$b("帰無仮説"),
HTML("<p> m = m&#8320: 母集団の中央値は指定された値と同じです。 データセットの分布はデフォルト値に対して対称です </p>"),

radioButtons("alt.wsr", label = "対立仮説", 
  choiceNames = list(
  HTML("m &#8800 m&#8320: Xの母集団中央値が指定された値と等しくありません。 または、データセットの分布がデフォルト値に対して対称的ではない"),
  HTML("m < m&#8320: Xの母集団中央値が指定された値より小さい"),
  HTML("m > m&#8320: Xの母集団中央値が指定された値より大きい")),
choiceValues = list("two.sided", "less", "greater")),

helpText("補正"),
radioButtons("nap.wsr", label = "正規近似", 
  choices = list("標本は大きくない" = FALSE,
                 "標本は中程度の大きさ" = TRUE, 
                 "小さい標本サイズ" = TRUE), selected = FALSE),
helpText("標本サイズが１０より大きい場合、通常の近似値が適用可能です")),

  mainPanel(
    h4('ウィルコクソンの符号順位検定の検定結果'), 
    tableOutput("ws.test"), 
    helpText("正規近似が適用されると、検定の名前は '連続性補正付きWilcoxon符号付き順位検定'になります")
  )
)

##---------- data ----------
onesample<- sidebarLayout(  

sidebarPanel(

h4("データ挿入"),

  tabsetPanel(
  ##-------input data-------## 
  tabPanel("手入力", p(br()),
    helpText("違った値はNAと表示されます"),

    tags$textarea(id="a", rows=10, "1.8\n3.3\n6.7\n1.4\n2.2\n1.6\n13.6\n2.8\n1.0\n2.8\n6.5\n6.8\n0.7\n0.9\n3.4\n3.3\n1.4\n0.9\n1.4\n1.8"),
    helpText("サンプルの名称変更"), 
    tags$textarea(id="cn", rows=2, "X")
    ),

  ##-------csv file-------##   
  tabPanel("アップロード .csv", p(br()),
    fileInput('file', '.csvファイルを指定してください', 
      accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    checkboxInput('header', 'Header', TRUE), #p
    radioButtons('sep', 'Separator', c(Comma=',', Semicolon=';', Tab='\t'), ',')) 
  ),

  hr(),
  h4("パラメータ変数"),
  numericInput("med", HTML("特定の値, m&#8320"), 4)#p),
  ),

mainPanel(

  h4("データの説明"),

  tabsetPanel(

    tabPanel("データの表示", p(br()),  

      dataTableOutput("table")),

    tabPanel("記述統計", p(br()), 

      splitLayout(
        tableOutput("bas"), 
        tableOutput("des"), 
        tableOutput("nor"))  ),

    tabPanel("箱ヒゲ図", p(br()), 

      splitLayout(
        plotOutput("bp", width = "400px", height = "400px", click = "plot_click"),

      wellPanel(
        verbatimTextOutput("info"), hr(),

      helpText(
        HTML("注:
                    <ul> 
                    <li> 外れ値が存在する場合は、外れ値が赤で強調表示されます。 </li>
                    <li> 赤の外れ値はシミュレートポイントをカバーしていない可能性があります。 </li>
                    <li> 赤い外れ値は、横線の値のみを示します。</li>  
                    </ul>"))
        )
        ) ),

    tabPanel("ヒストグラム", p(br()), 

      plotOutput("makeplot", width = "800px", height = "400px"),
      sliderInput("bin", "ヒストグラムの棒幅", min = 0.01, max = 5, value = 0.2)
      )
    )
  )
)



