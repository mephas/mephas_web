##----------#----------#----------#----------
##
## 2MFSttest UI
##
##    >Panel 3
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

            helpText("間違った値はNAと表示されます"),
            
            tags$textarea(id = "x1.p",rows = 10,
              "4.2\n5.3\n7.6\n6.7\n6.3\n3.5\n5.8\n6.3\n3.2\n4.6\n5.5\n5.2\n4.6\n4.8\n4.5\n5.3\n4.3\n4.3\n6.2\n6.7"
              ),
            ## disable on chrome
            tags$textarea(id = "x2.p",rows = 10,
              "6.6\n6.9\n6.7\n8.4\n7.8\n6.6\n8.6\n5.5\n4.6\n6.1\n7.1\n4.0\n6.5\n5.6\n8.1\n5.8\n7.9\n6.4\n6.5\n7.4"
              ),
            helpText("サンプルの名称変更"),
            tags$textarea(id = "cn.p", rows = 2, "X\nY\n(X-Y)")

            ),

          ##-------csv file-------##
          tabPanel("アップロード .csv",
            p(br()),
            
        fileInput('file', ".csvファイルを指定してください",

              accept = c(
                'text/csv',
                'text/comma-separated-values,text/plain',
                '.csv'
              )
            ),
            checkboxInput('header.p', 'Header', TRUE), #p
       
            radioButtons("sep.p", "Separator",
                         choices = c(Comma = ',',
                                     Semicolon = ';',
                                     Tab = '\t'),
                         selected = ',')
            )
          ),

        hr(),

        h4("仮説"),

        tags$b("帰無仮説"),
        HTML("<p> &#916 = 0: X and Y have equal effect </p>"),
        
        radioButtons(
          "alt.pt",
          label = "代替仮説",
          choiceNames = list(
            HTML("&#916 &#8800 0: the population mean of X and Y are not equal"),
            HTML("&#916 < 0: the population mean of X is less than Y"),
            HTML("&#916 > 0: the population mean of X is greater than Y")
            ),
          choiceValues = list("two.sided", "less", "greater")
          )

        ),

      mainPanel(

        h4('Data Description'),

        tabsetPanel(

          tabPanel("Data display", p(br()),  

            dataTableOutput("table.p")),

          tabPanel("記述統計s", p(br()), 
            
            splitLayout(
              tableOutput("bas.p"),
              tableOutput("des.p"),
              tableOutput("nor.p")
              )
            ),

          tabPanel("差の箱ヒゲ図", p(br()), 
            splitLayout(
              plotOutput("bp.p",width = "400px",height = "400px",click = "plot_click3"),
          
          wellPanel(
            verbatimTextOutput("info3"), hr(),
            
            helpText(
              HTML(
                "注:
                <ul>
                <li> 外れ値は赤い点として表示されます </li>
                </ul>"
                )
              )
            )
          )
          ),

          tabPanel("平均と標準偏差プロット", p(br()), 

            plotOutput("meanp.p", width = "400px", height = "400px")),

          tabPanel("Plots of normality", p(br()), 

            plotOutput("makeplot.p", width = "900px", height = "300px"),
            sliderInput("bin.p","ヒストグラムの棒幅",min = 0.01,max = 5,value = 0.2)
            )
          ),

          hr(),
          h4("検定結果"),
          tableOutput("t.test.p")
        )
      )