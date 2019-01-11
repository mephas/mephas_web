##----------#----------#----------#----------
##
## 3MFSnptest UI
##
##    >Panel 2
##
## Language: EN
## 
## DT: 2019-01-10
##
##----------#----------#----------#----------
##---------- 2.1 ----------
wrtest<- sidebarLayout(

sidebarPanel(
##-------explanation-------##

h4("仮説"),
tags$b("帰無仮説"),

HTML("<p> m&#8321 = m&#8322: 各グループの中央値は等しい。 各グループの値の分布は等しい </p>"),

radioButtons("alt.mwt", label = "対立仮説", 
  choiceNames = list(
    HTML("m&#8321 &#8800 m&#8322: 各グループの母集団中央値は等しくない。 グループの値の分布に体系的な違いがある"),
    HTML("m&#8321 < m&#8322: Xの母集団中央値が大きい"),
    HTML("m&#8321 > m&#8322: Yの母集団中央値が大きい")),
  choiceValues = list("two.sided", "less", "greater")),

h4("補正"),
radioButtons("nap.mwt", label = "正規近似", 
  choices = list("標本サイズは大きくない" = FALSE,
                 "標本は中程度の大きさ" = TRUE, 
                 "小さい標本サイズ" = TRUE), selected = FALSE)),

mainPanel(
  h4("ウィルコクソン順位和検定の結果"), tableOutput("mwu.test"), 
  helpText(HTML("<ul>
      <li> 'Estimated.diff'は中央値の推定差を示します
      <li> 正規近似が適用されると、検定の名前は '連続性補正付きWilcoxon符号付き順位検定'になる </li>  
      </ul>" ))
  )

)

##---------- 2.2 ----------

mmtest<- sidebarLayout(
sidebarPanel(

h4("仮説"),
tags$b("帰無仮説"),
HTML("<p>m&#8321 = m&#8322, 各グループの値の中央値は等しい </p>"),

radioButtons("alt.md", label = "対立仮説", 
  choiceNames = list(
    HTML("m&#8321 &#8800 m&#8322: 各グループの母集団中央値が等しくない"),
    HTML("m&#8321 < m&#8322: Xの母集団中央値がより大きい"),
    HTML("m&#8321 > m&#8322: Yの母集団中央値がより大きい")),
  choiceValues = list("two.sided", "less", "greater"))),

mainPanel(
  h4("ムード中央値検定の結果"), tableOutput("mood.test") 
  ) 
)

##---------- data ----------
twosample<- sidebarLayout(  
sidebarPanel(

h4("データ挿入"),

  tabsetPanel(
  ##-------input data-------## 
  tabPanel("手入力", p(br()),
    helpText("違った値はNAと表示される"),
    tags$textarea(id="x1", rows=10, "1.8\n3.3\n6.7\n1.4\n2.2\n1.6\n13.6\n2.8\n1.0\n2.8\n6.5\n6.8\n0.7\n0.9\n3.4\n3.3\n1.4\n0.9\n1.4\n1.8"),  ## disable on chrome
    tags$textarea(id="x2", rows=10, "8.7\n6.6\n6.0\n3.9\n1.6\n16.0\n14.1\n3.1\n4.0\n3.7\n3.1\n7.4\n6.0\n1.1\n3.0\n2.0\n5.0\n4.2\n5.0\n4.9"),
    helpText("サンプルの名称変更"), tags$textarea(id="cn2", rows=2, "X\nY")),

  ##-------csv file-------##   
  tabPanel("アップロード .csv", p(br()),
    fileInput('file2', '.csvファイルを指定', accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    checkboxInput('header2', 'ヘッダー', TRUE), #p
    radioButtons('sep2', '区切り', c(Comma=',', Semicolon=';', Tab='\t'), ',')) )
),

mainPanel(

  h4("データの説明"),

  tabsetPanel(

    tabPanel("データ表示", p(br()),  

      dataTableOutput("table2")),

    tabPanel("記述統計", p(br()), 

      splitLayout(
        tableOutput("bas2"), 
        tableOutput("des2"), 
        tableOutput("nor2"))  ),

    tabPanel("箱ヒゲ図", p(br()), 

      splitLayout(
        plotOutput("bp2", width = "400px", height = "400px", click = "plot_click2"),

      wellPanel(
        verbatimTextOutput("info2"), hr(),

      helpText(
        HTML("注:
                    <ul> 
                    <li> 外れ値が存在する場合は、外れ値が赤で強調表示される </li>
                    <li> 赤の外れ値はシミュレートポイントをカバーしていない可能性がある </li>
                    <li> 赤い外れ値は、横線の値のみを示す</li>  
                    </ul>"))
      ))
           ),

    tabPanel("ヒストグラム", p(br()), 

      plotOutput("makeplot2", width = "800px", height = "400px"),
      sliderInput("bin2", "ヒストグラムの棒幅", min = 0.01, max = 5, value = 0.2)
      )
    ))  )