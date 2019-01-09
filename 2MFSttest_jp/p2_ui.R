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
  
    h4("データ挿入n"),

    tabsetPanel(
      ##-------input data-------##
    tabPanel("手入力", p(br()),

    helpText("間違った値はNAと表示されます"),
        tags$textarea(id = "x1",rows = 10,"4.2\n5.3\n7.6\n6.7\n6.3\n3.5\n5.8\n6.3\n3.2\n4.6\n5.5\n5.2\n4.6\n4.8\n4.5\n5.3\n4.3\n4.3\n6.2\n6.7"),
        ## disable on chrome
        tags$textarea(id = "x2",rows = 10,"6.6\n6.9\n6.9\n8.4\n7.8\n6.6\n8.6\n5.5\n4.6\n6.1\n7.1\n4.0\n6.5\n5.6\n8.1\n5.8\n7.9\n6.4\n6.5\n7.4"),

    helpText("サンプルの名称変更"),
    tags$textarea(id = "cn2", rows = 2, "X\nY")
        ),

      ##-------csv file-------##
      tabPanel(
        "アップロード .csv",
        p(br()),
        
        fileInput('file', ".csvファイルを指定してください",
          accept = c(
            'text/csv',
            'text/comma-separated-values,text/plain',
            '.csv'
            )
          ),
        checkboxInput('header2', 'Header', TRUE), #p
        radioButtons("sep2", "Separator",
                     choices = c(Comma = ',',
                                 Semicolon = ';',
                                 Tab = '\t'),
                     selected = ',')
        )
      ),

    hr(),

    h4("仮説"),

    tags$b("帰無仮説"),
    HTML("<p> &#956&#8321 = &#956&#8322: X and Y have equal population mean </p>"),
    
    radioButtons("alt.t2", #p
      label = "代替仮説",
      choiceNames = list(
        HTML("&#956&#8321 &#8800 &#956&#8322: the population means of X and Y are not equal"),
        HTML("&#956&#8321 < &#956&#8322: the population means of X is less than Y"),
        HTML("&#956&#8321 > &#956&#8322: the population means of X is greater than Y")
        ),
      choiceValues = list("two.sided", "less", "greater")
      )
    ),

  mainPanel(

    h4("Data Description"),

    tabsetPanel(

      tabPanel("Data display",p(br()), 

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
                <li> 外れ値は赤い点として表示されます </li>
                </ul>"
                  )
                )
              )              
           )),

      tabPanel("平均と標準偏差プロット", p(br()), 

        plotOutput("meanp2", width = "400px", height = "400px")),

      tabPanel("Plots of normality", p(br()), 

        plotOutput("makeplot2", width = "600px", height = "600px"),
        sliderInput("bin2","ヒストグラムの棒幅",min = 0.01,max = 5,value = 0.2))

      ),

    hr(),
    h4(tags$b("検定結果")),
    tableOutput("var.test"),
    helpText("When P value<0.05, please go to the 'Welch Two Sample t-test'"),
    tableOutput("t.test2")
    
    )
  )