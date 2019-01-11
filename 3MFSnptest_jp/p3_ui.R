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

signtest.p<- sidebarLayout(

sidebarPanel(

  h4("仮説"),
  tags$b("帰無仮説"),
 # p("m = 0: the difference of medians between X and Y is zero; X and Y are equally effective"),

  radioButtons("alt.ps", label = "対立仮説", 
    choiceNames = list(
      HTML("m &#8800 0: XとYの中央値の差はない。 XとYは等しく効果的ではない"),
      HTML("m < 0: Xの母集団中央値は大きい。 Xがより効果的である"),
      HTML("m > 0: Yの母集団中央値は大きい。 Yがより効果的である")),
      choiceValues = list("two.sided", "less", "greater")) 
  ),

mainPanel(
  h4('符号検定の検定結果'), 
  tableOutput("psign.test"), 
  helpText("Notes: 'Estimated.d' denotes the estimated differences of medians")
          )
)

##---------- 3.2 ----------

wstest.p <- sidebarLayout(
  sidebarPanel(

  #h4("Wilcoxon Signed-Rank Test"),
  #helpText("An alternative to the paired t-test for matched pairs, when the population cannot be assumed to be normally distributed. It can also be used to determine whether two dependent samples were selected from populations having the same distribution."),

  h4("仮説"),
  tags$b("帰無仮説"),
  p("m = 0: XとYの中央値の差はゼロではない。 対になった値の差の分布はゼロを中心に対称です。"),

  radioButtons("alt.pwsr", label = "対立仮説", 
    choiceNames = list(
      HTML("m &#8800 0: XとYの中央値の差はゼロではありません。 対になった値の差の分布は、ゼロを中心に対称ではありません。"),
      HTML("m < 0: Yの母集団中央値がより大きい"),
      HTML("m > 0: Xの母集団中央値がより大きい")),
    choiceValues = list("two.sided", "less", "greater")),

  h4("補正"),
  radioButtons("nap", label = "正規近似", 
  choices = list("標本は大きくない" = FALSE,
                 "標本は中程度の大きさ" = TRUE, 
                 "小さい標本サイズ" = TRUE), selected = FALSE),
helpText("標本サイズが１０より大きい場合、通常の近似値が適用可能です")),

  mainPanel(h4('ウィルコクソンの符号順位検定の検定結果'), tableOutput("psr.test"), 
    helpText("正規近似が適用されると、検定の名前は '連続性補正付きWilcoxon符号付き順位検定'になります")
    ) )

##---------- data ----------
psample <- sidebarLayout(  

sidebarPanel(

h4("データ挿入"),

  tabsetPanel(
  ##-------input data-------## 
  tabPanel("手入力", p(br()),
    helpText("違った値はNAと表示されます"),
    tags$textarea(id="y1", rows=10, "1.8\n3.3\n6.7\n1.4\n2.2\n1.6\n13.6\n2.8\n1.0\n2.8\n6.5\n6.8\n0.7\n0.9\n3.4\n3.3\n1.4\n0.9\n1.4\n1.8"),  ## disable on chrome
    tags$textarea(id="y2", rows=10, "8.7\n6.6\n6.0\n3.9\n1.6\n16.0\n14.1\n3.1\n4.0\n3.7\n3.1\n7.4\n6.0\n1.1\n3.0\n2.0\n5.0\n4.2\n5.0\n4.9"),
    helpText("サンプルの名称変更"), 
    tags$textarea(id="cn3", rows=2, "X\nY\n(X-Y)")),

  ##-------csv file-------##   
  tabPanel("アップロード .csv", p(br()),
    fileInput('file3', '.csvファイルを指定してください', accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    checkboxInput('header3', 'Header', TRUE), #p
    radioButtons('sep3', 'Separator', c(Comma=',', Semicolon=';', Tab='\t'), ',')
    ) 
  )
),

mainPanel(

  h4("Data Description"),

  tabsetPanel(

    tabPanel("Data display", p(br()),  

      dataTableOutput("table3")),

    tabPanel("記述統計", p(br()), 

      splitLayout(
        tableOutput("bas3"), 
        tableOutput("des3"), 
        tableOutput("nor3"))  ),

    tabPanel("箱ヒゲ図", p(br()), 

      splitLayout(
        plotOutput("bp3", width = "400px", height = "400px", click = "plot_click3"),

      wellPanel(
        verbatimTextOutput("info3"), hr(),

      helpText(
        HTML("注:
                    <ul> 
                    <li> 外れ値が存在する場合は、外れ値が赤で強調表示されます。 </li>
                    <li> 赤の外れ値はシミュレートポイントをカバーしていない可能性があります。 </li>
                    <li> 赤い外れ値は、横線の値のみを示します。</li>  
                    </ul>"))
        )
        ) ),

    tabPanel("Histogram", p(br()), 

      plotOutput("makeplot3", width = "800px", height = "400px"),
      sliderInput("bin3", "The width of bins in histogram", min = 0.01, max = 5, value = 0.2)
      )
    ))  )
