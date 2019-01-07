
##--------------------------------------------------
##
## MFSttest JP
##
## 2018-11-28
##
##---------------------------------------------------

shinyUI(

tagList(
# shinythemes::themeSelector(),
navbarPage(
  #theme = shinytheme("cosmo"),
  title = "平均値の差の検定",

  ## 1. One sample -----------------------------------------------------------------
  tabPanel(
    "一群",
    headerPanel("一群のt検定"),

    tags$b("注"),
    HTML(
      "
      <ul>
      <li> X は説明変数 </li>
      <li> &#956 は母集団の平均値 </li>
      <li> &#956&#8320 は特定の値 </li>
      </ul>
      "
      ),

    tags$b("前提"),
    HTML(
      "
      <ul>
      <li> 母集団は連続した数値で、正規分布に従う </li>
      <li> それぞれのxは独立しており正規分布に近い </li>
      <li> データはランダムに抽出されています </li>
      "
      ),

    sidebarLayout(
      sidebarPanel(
        ##----Configuration----
        helpText("パラメータ変数"),
        numericInput('mu', HTML("特定の値, &#956&#8320"), 7), #p

        helpText("仮説"),
        tags$b("帰無仮説"),
        HTML("<p> &#956 = &#956&#8320: xの平均は &#956&#8320 </p>"),
        radioButtons(
          "alt.pt", #p
          label = "代替仮説",
          choiceNames = list(
            HTML("&#956 &#8800 &#956&#8320: xの平均は &#956&#8320　ではない"),
            HTML("&#956 < &#956&#8320: xの平均は &#956&#8320　より小さい"),
            HTML("&#956 > &#956&#8320: xの平均は &#956&#8320　より大きい")
            ),
          choiceValues = list("two.sided", "less", "greater")
          ),
        hr(),

        ##----Import data----##
        helpText("データ挿入"),

        tabsetPanel(
          ##-------input data-------##s
          tabPanel(
            "手入力",
            p(br()),
            helpText("間違った値はNAと表示されます"),
            tags$textarea(
              id = "x", #p
              rows = 10,
              "4.2\n5.3\n7.6\n6.7\n6.3\n3.5\n5.8\n6.3\n3.2\n4.6\n5.5\n5.2\n4.6\n4.8\n4.5\n5.3\n4.3\n4.3\n6.2\n6.7"
              ),
        helpText("Change the names of sample (optinal)"),
        tags$textarea(id = "cn", rows = 1, "X") #p
            ), #tabPanel(

          ##-------csv file-------##
          tabPanel(
            "アップロード .csv ファイルのみ",
            p(br()),
            fileInput(
              'ファイル', '.csv ファイルを指定してください ', #p
              accept = c(
                'text/csv',
                'text/comma-separated-values,text/plain',
                '.csv'
                )
              ),
            checkboxInput('header', 'Header', TRUE), #p
            radioButtons('sep', 'Separator', #p
              c(
                Comma = ',',
                Semicolon = ';',
                Tab = '\t'
                ),
              ','
              )
            ) #tabPanel(
          ),

        hr(),
        h4("データ"),
        
        dataTableOutput("table"),
        hr(),
        h4("パラメータ設定"),
        sliderInput("bin", "ヒストグラムの棒幅",min = 0.01,max = 5,value = 0.2) #p
        ),

      mainPanel(
        h3(tags$b("検定結果")),
        tableOutput("t.test"), 
        #tags$b('Interpretation'), p("NULL"),

        hr(),
        h3(tags$b('記述統計')),
        splitLayout(
          tableOutput("bas"), 
          tableOutput("des"), 
          tableOutput("nor")
          ),
        hr(),
        h3(tags$b("平均と標準偏差プロット")),
        plotOutput("meanp", width = "600px", height = "300px"),

        hr(),
        h3(tags$b("箱ヒゲ図")),
        splitLayout(
          plotOutput(
            "bp",
            width = "400px",
            height = "400px",
            click = "plot_click"
            ),
          wellPanel(
            verbatimTextOutput("info"), 
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
          ),
        hr(),
        h3(tags$b('正規確率プロット')),
        plotOutput("makeplot", width = "900px", height = "300px")
        )
      )
    ),
  ##

  ## 2. Two independent samples ---------------------------------------------------------------------------------
  tabPanel(
    "独立二群",

    headerPanel("二群のt検定"),

    tags$b("前提として"),
    tags$ul(
      tags$li("比較される2つの集団は、正規分布に従うべきである"),
      tags$li("XとYは、比較される2つの集団から独立してサンプリングされるべきである"),
      tags$li("比較される2つの集団は、同じ分散を有するべきである")
      ),

    tags$b("注"),
    HTML(
      "
      <ul>
      <li> The independent observations are designated X and Y</li>
      <li> &#956&#8321 = the population mean of X; &#956&#8322 = the population mean of Y </li>
      </ul>"
      ),

    sidebarLayout(
      sidebarPanel(
        helpText("仮説"),
        tags$b("帰無仮説"),
        HTML("<p> &#956&#8321 = &#956&#8322: XとYの平均は等しい </p>"),
        radioButtons("alt.t2", #p
          label = "帰無仮説",
          choiceNames = list(
            HTML("&#956&#8321 &#8800 &#956&#8322: XとYの平均は等しい"),
            HTML("&#956&#8321 < &#956&#8322: Xの平均はYの平均より小さい"),
            HTML("&#956&#8321 > &#956&#8322: Xの平均はYの平均より大きい")
            ),
          choiceValues = list("two.sided", "less", "greater")
          ),

        hr(),
        # for seperate
        helpText("データ挿入方法"),

        tabsetPanel(
          ##-------input data-------##
          tabPanel(
            "手入力",
            p(br()),
            helpText("誤った値はNAと表示されます"),
            tags$textarea(id = "x1",rows = 10,"4.2\n5.3\n7.6\n6.7\n6.3\n3.5\n5.8\n6.3\n3.2\n4.6\n5.5\n5.2\n4.6\n4.8\n4.5\n5.3\n4.3\n4.3\n6.2\n6.7"),
            ## disable on chrome
            tags$textarea(id = "x2",rows = 10,"6.6\n6.9\n6.9\n8.4\n7.8\n6.6\n8.6\n5.5\n4.6\n6.1\n7.1\n4.0\n6.5\n5.6\n8.1\n5.8\n7.9\n6.4\n6.5\n7.4"),

            helpText("サンプルの名称変更 "),
        tags$textarea(id = "cn2", rows = 2, "X\nY")
            ),

          ##-------csv file-------##
          tabPanel(
            "アップロード .csv ファイルのみ",
            p(br()),
            fileInput('file2','.csv ファイルを選択', #p
              accept = c(
                'text/csv',
                'text/comma-separated-values,text/plain',
                '.csv'
                )
              ),
            checkboxInput('header2', 'Header', TRUE), #p
            radioButtons('sep2','Separator', #p
              c(
                Comma = ',',
                Semicolon = ';',
                Tab = '\t'
                ),
                ','
              )
            )
          ),
        hr(),
        h4("データ"),

        dataTableOutput("table2"),
        hr(),
        h4("数値"),
        sliderInput("bin2","ヒストグラムの棒幅",min = 0.01,max = 5,value = 0.2)
        ),

      mainPanel(
        h3(tags$b("検定結果")),
        tableOutput("var.test"),
        helpText("When P value<0.05, please go to the 'Welch Two Sample t-test'"),
        tableOutput("t.test2"),
        #tags$b('Interpretation'), p("NULL"),

        hr(),
        h3(tags$b('記述統計')),
        splitLayout(
          tableOutput("bas2"),
          tableOutput("des2"),
          tableOutput("nor2")
          ),

        hr(),
        h3(tags$b("平均と標準偏差プロット")),
        plotOutput("meanp2", width = "600px", height = "300px"),

        hr(),
        h3(tags$b("箱ヒゲ図")),
        splitLayout(
          plotOutput("bp2",width = "400px",height = "400px",click = "plot_click"),
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
          ),
        hr(),
        h3(tags$b('Plots of normality')),
        plotOutput("makeplot2", width = "600px", height = "600px")
        )
      )
    ),
  ##

  ## 3. Two paried samples ---------------------------------------------------------------------------------
  tabPanel(
    "関連した二群",

    headerPanel("関連した二組のt検定"),

    helpText("A typical example of the repeated measures t-test would be where subjects are tested prior to a treatment, say for high blood pressure, and the same subjects are tested again after treatment with a blood-pressure lowering medication."),

    tags$b("前提として"),
    tags$ul(
      tags$li("The differences of paired samples are approximately normally distributed."),
      tags$li("The differences of paired samples are numeric and continuous and based on the normal distribution"),
      tags$li("The data collection process was random without replacement.")
      ),

    tags$b("注"),
    HTML(
      "
      <ul>
      <li> The dependent observations are designated X and Y </li>
      <li> &#916 is the underlying mean differences between X and Y</li>
      </ul>"
      ),

    sidebarLayout(
      sidebarPanel(
        helpText("仮説"),
        tags$b("帰無仮説"),
        HTML("<p> &#916 = 0: XとYは等しい効果 </p>"),
        radioButtons("alt.pt",
          label = "帰無仮説",
          choiceNames = list(
            HTML("&#916 &#8800 0: XとYの人口の平均は等しい"),
            HTML("&#916 < 0: Xの人口の平均はYの平均より小さい"),
            HTML("&#916 > 0: Xの人口の平均はYの平均より大きい")
            ),
          choiceValues = list("two.sided", "less", "greater")
          ),

        hr(),
        helpText("データインポート"),

        tabsetPanel(
          ##-------input data-------##
          tabPanel(
            "手入力",
            p(br()),
            

            helpText("誤った値はNAと表示されます"),
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
          tabPanel(".csv　ファイルアップロード",
            p(br()),
            fileInput(
              'file.p',
              '.csv ファイルを選んでください',
              accept = c(
                'text/csv',
                'text/comma-separated-values,text/plain',
                '.csv'
              )
            ),
            checkboxInput('header.p', 'Header', TRUE), #p
            radioButtons('sep.p','Separator',
              c(
                Comma = ',',
                Semicolon = ';',
                Tab = '\t'
                ),
              ','
              )
            )
          ),

        hr(),
        h4("データ"),
        dataTableOutput("table.p"),
        hr(),
        h4("数値"),
        sliderInput("bin.p","ヒストグラムの棒幅",min = 0.01,max = 5,value = 0.2)
        ),

      mainPanel(
        h3(tags$b("検定結果")),
        tableOutput("t.test.p"),
        #tags$b('Interpretation'), p("NULL"),

        hr(),
        h3(tags$b('記述統計')),
        splitLayout(
          tableOutput("bas.p"),
          tableOutput("des.p"),
          tableOutput("nor.p")
          ),

        hr(),
        h3(tags$b("平均と標準偏差プロット")),
        plotOutput("meanp.p", width = "600px", height = "300px"),

        hr(),
        h3(tags$b("差の箱ヒゲ図")),
        splitLayout(
          plotOutput("bp.p",width = "400px",height = "400px",click = "plot_click"),
          wellPanel(
            verbatimTextOutput("info.p"), hr(),
            helpText(
              HTML(
                "注:
                <ul>
                <li> 外れ値は赤い点として表示されます </li>
                </ul>"
                )
              )
            )
          ),
        hr(),
        h3(tags$b('Plots of normality of the difference')),
        plotOutput("makeplot.p", width = "900px", height = "300px")
        )
      )
    )
    ##
,
tabPanel(
      tags$button(
      id = 'close',
      type = "button",
      class = "btn action-button",
      onclick = "setTimeout(function(){window.close();},500);",  # close browser
      "停止")
),
tabPanel(
     tags$button(
     id = 'close',
     type = "button",
     class = "btn action-button",
     onclick ="window.open('https://pharmacometrics.info/mephas/index_jp.html')","トップ"))

  )
)
)
