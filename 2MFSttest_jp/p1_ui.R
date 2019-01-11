##----------#----------#----------#----------
##
## 2MFSttest UI
##
##    >Panel 1
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
  
  tabPanel("手入力", p(br()),

  helpText(HTML('間違った値はNAと表示されます')),

      tags$textarea(
        id = "x", #p
        rows = 10,
        "4.2\n5.3\n7.6\n6.7\n6.3\n3.5\n5.8\n6.3\n3.2\n4.6\n5.5\n5.2\n4.6\n4.8\n4.5\n5.3\n4.3\n4.3\n6.2\n6.7"
        ),

      helpText("サンプルの名称変更"),
      tags$textarea(id = "cn", rows = 1, "X") ), #tabPanel(


    tabPanel(HTML("アップロード .csv"), p(br()),

        ##-------csv file-------##   
        fileInput('file', HTML(".csvファイルを指定してください"),
                  accept = c("text/csv",
                          "text/comma-separated-values,text/plain",
                          ".csv")),
        #helpText("The columns of X are not suggested greater than 500"),
        # Input: Checkbox if file has header ----
        checkboxInput("header", "Header", TRUE),

             # Input: Select separator ----
        radioButtons("sep", "Separator",
                     choices = c(Comma = ',',
                                 Semicolon = ';',
                                 Tab = '\t'),
                     selected = ',')

      ) 
    ),

hr(),

  h4("パラメータ変数"),
  numericInput('mu', HTML("特定の値, &#956&#8320"), 7), #p

  h4("仮説"),

  tags$b("帰無仮説"),
  HTML("<p> &#956 = &#956&#8320: xの平均は is &#956&#8320 </p>"),
  
  radioButtons(
    "alt", 
    label = "代替仮説",
    choiceNames = list(
      HTML("&#956 &#8800 &#956&#8320: xの平均は &#956&#8320　ではない"),
      HTML("&#956 < &#956&#8320: xの平均は &#956&#8320　より小さい"),
      HTML("&#956 > &#956&#8320: xの平均は &#956&#8320　より大きい")
      ),
    choiceValues = list("two.sided", "less", "greater"))

    ),


mainPanel(

  h4("Data Description"),

  tabsetPanel(

    tabPanel("Data display", p(br()),  

      dataTableOutput("table")),

    tabPanel("記述統計", p(br()), 

      splitLayout(
        tableOutput("bas"), 
        tableOutput("des"), 
        tableOutput("nor"))  ),

    tabPanel("箱ヒゲ図", p(br()), 
      splitLayout(
        plotOutput("bp", width = "400px", height = "400px", click = "plot_click1"),

      wellPanel(
        verbatimTextOutput("info1"), hr(),

        helpText(
          HTML(
            "注:
            <ul>
            <li> 外れ値は赤い点として表示されます </li>
            </ul>"
            )
          )
        )
      ) ),

    tabPanel("平均と標準偏差プロット", p(br()), 

      plotOutput("meanp", width = "400px", height = "400px")),

    tabPanel("Plots of normality", p(br()), 

      plotOutput("makeplot", width = "900px", height = "300px"), 
      sliderInput("bin","ヒストグラムの棒幅",min = 0.01,max = 5,value = 0.2))
  ),

  hr(),
  h4("検定結果"),
  tableOutput("t.test")

 )

)
