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

HTML("<p> m&#8321 = m&#8322: the medians of each group are equal; the distribution of values for each group are equal </p>"),

radioButtons("alt.mwt", label = "対立仮説", 
  choiceNames = list(
    HTML("m&#8321 &#8800 m&#8322: the population medians of each group are not equal; there is systematic difference in the distribution of values for the groups"),
    HTML("m&#8321 < m&#8322: the population median of X is greater"),
    HTML("m&#8321 > m&#8322: the population median of Y is greater")),
  choiceValues = list("two.sided", "less", "greater")),

h4("補正"),
radioButtons("nap.mwt", label = "正規近似", 
  choices = list("Sample size is not large" = FALSE,
                 "Sample size is moderate large" = TRUE, 
                 "Small sample size" = TRUE), selected = FALSE)),

mainPanel(
  h4("Results of Wilcoxon Rank-Sum Test"), tableOutput("mwu.test"), 
  helpText(HTML("<ul>
      <li> 'Estimated.diff' denotes the estimated differences of medians
      <li> When normal approximation is applied, the name of test becomes 'Wilcoxon signed rank test with continuity correction' </li>  
      </ul>" ))
  )

)

##---------- 2.2 ----------

mmtest<- sidebarLayout(
sidebarPanel(

h4("仮説"),
tags$b("帰無仮説"),
HTML("m&#8321 = m&#8322, the medians of values for each group are equal"),

radioButtons("alt.md", label = "対立仮説", 
  choiceNames = list(
    HTML("m&#8321 &#8800 m&#8322: the population medians of each group are not equal"),
    HTML("m&#8321 < m&#8322: the population median of X is greater"),
    HTML("m&#8321 > m&#8322: the population median of Y is greater")),
  choiceValues = list("two.sided", "less", "greater"))),

mainPanel(
  h4("Results of Mood's Median Test"), tableOutput("mood.test") 
  ) 
)

##---------- data ----------
twosample<- sidebarLayout(  
sidebarPanel(

h4("データ挿入"),

  tabsetPanel(
  ##-------input data-------## 
  tabPanel("手入力", p(br()),
    helpText("違った値はNAと表示されます"),
    tags$textarea(id="x1", rows=10, "1.8\n3.3\n6.7\n1.4\n2.2\n1.6\n13.6\n2.8\n1.0\n2.8\n6.5\n6.8\n0.7\n0.9\n3.4\n3.3\n1.4\n0.9\n1.4\n1.8"),  ## disable on chrome
    tags$textarea(id="x2", rows=10, "8.7\n6.6\n6.0\n3.9\n1.6\n16.0\n14.1\n3.1\n4.0\n3.7\n3.1\n7.4\n6.0\n1.1\n3.0\n2.0\n5.0\n4.2\n5.0\n4.9"),
    helpText("サンプルの名称変更"), tags$textarea(id="cn2", rows=2, "X\nY")),

  ##-------csv file-------##   
  tabPanel("アップロード .csv", p(br()),
    fileInput('file2', '.csvファイルを指定してください', accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    checkboxInput('header2', 'Header', TRUE), #p
    radioButtons('sep2', 'Separator', c(Comma=',', Semicolon=';', Tab='\t'), ',')) )
),

mainPanel(

  h4("Data Description"),

  tabsetPanel(

    tabPanel("Data display", p(br()),  

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
                    <li> 外れ値が存在する場合は、外れ値が赤で強調表示されます。 </li>
                    <li> 赤の外れ値はシミュレートポイントをカバーしていない可能性があります。 </li>
                    <li> 赤い外れ値は、横線の値のみを示します。</li>  
                    </ul>"))
      ))
           ),

    tabPanel("Histogram", p(br()), 

      plotOutput("makeplot2", width = "800px", height = "400px"),
      sliderInput("bin2", "ヒストグラムの棒幅", min = 0.01, max = 5, value = 0.2)
      )
    ))  )