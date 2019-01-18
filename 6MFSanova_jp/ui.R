##----------#----------#----------#----------
##
## 6MFSanova UI
##
## Language: JP
## 
## DT: 2019-01-08
##
##----------#----------#----------#----------
shinyUI(

tagList(
  source("../0tabs/font_jp.R",local=TRUE, encoding="UTF-8")$value,
navbarPage(

  title = "分散分析",

##---------- Panel 1 ----------
  tabPanel(
    "一元",

    headerPanel("一元配置分散分析"),

    tags$b("前提として"),
    tags$ul(
      tags$li("標本のデータは数値データであり連続である。正規分布に基づいているとする"),
      tags$li("データ収集方法は代替が無く、無作為に行われたものである"),
      tags$li("標本は、同じ分散を有する集団からのものである。")
      ),


    sidebarLayout(
      sidebarPanel(
        h4("仮説"),
        tags$b("帰無仮説"),
        HTML("<p>すべてのグループの平均は等しい</p>"),
        tags$b("対立仮説"),
        HTML("<p>グループの平均はすべて等しいわけではない</p>"),
        hr(),
        ##----Import data----##
        h4("データ挿入"),

        tabsetPanel(
          ##-------input data-------##s
          tabPanel(
            "手入力",
            p(br()),
            helpText("値と要素の名前を入力 (欠損値はNAと表示される)"),

            splitLayout(

              verticalLayout(
              tags$b("値"),
              tags$textarea(
              id = "x1",
              rows = 10,
              "0.55\n3.22\n1.08\n1.99\n0.93\n2.98\n2.93\n2.41\n1.98\n1.94\n2.27\n2.69\n2.23\n3.87\n1.43\n3.6\n1.51\n1.7\n2.79\n2.96\n4.67\n5.37\n1.77\n3.52\n5.62\n4.22\n3.33\n3.91\n4.85\n3.4"
              )),

            verticalLayout(
            tags$b("因子"), 
            tags$textarea(
              id = "f11", #p
              rows = 10,
              "A1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3"
              ))
            )
            ,

        helpText("サンプルの名称変更"),
        tags$textarea(id = "cn1", rows = 2, "X\nA")),

                    ##-------csv file-------##
          tabPanel(
            "アップロード CSV ファイル",
            p(br()),
            fileInput(
              'file1', 'CSV ファイルを指定', #p
                accept = c(
                'text/csv',
                'text/comma-separated-values,text/plain',
                '.csv'
                )
              ),
            checkboxInput('header1', 'ヘッダー', TRUE), #p
            radioButtons('sep1', '区切り', #p
              c(
                Comma = ',',
                Semicolon = ';',
                Tab = '\t'
                ),
              ','
              ))
          )
        ),

      mainPanel(
        h4("分散分析 テーブル"),
        tableOutput("anova1"),
        hr(),

        h4("データの記述統計"),
        tabsetPanel(
          tabPanel("データ表示",p(br()),
          dataTableOutput("table1")
            ),

          tabPanel('記述統計',p(br()),
          verbatimTextOutput("bas1")),

          tabPanel("周辺平均プロット",p(br()),
            plotOutput("mmean1", width = "500px", height = "300px")
            )
          )
        )
      )
    ),

##---------- Panel 2 ----------

  tabPanel(
    "二元",

    headerPanel("二元配置分散分析"),

    tags$b("前提として"),
    tags$ul(
      tags$li("標本から得られた集団は、正規分布に分布している、もしくはそれに近い"),
      tags$li("標本はそれぞれ独立する"),
      tags$li("母集団の分散は等しい"),
      tags$li("グループの標本サイズは同じ")

      ),

    sidebarLayout(
      sidebarPanel(
        helpText("仮説"),
        tags$b("帰無仮説　1"),
        HTML("<p>第1因子の母集団平均は等しい。 </p>"),
        tags$b("帰無仮説 2"),
        HTML("<p第２因子の母集団平均は等しい。</p>"),
        tags$b("帰無仮説 3"),
        HTML("<p>二つの因子の間に相関はない</p>"),
        hr(),
        ##----Import data----##
        h4("データ挿入"),

        tabsetPanel(
          ##-------input data-------##s
          tabPanel(
            "手入力",
            p(br()),
            helpText("欠損値はNAと表示される"),

            splitLayout(

            verticalLayout(
            tags$b("値"), 
            tags$textarea(
              id = "x", #p
              rows = 10,
              "0.55\n3.22\n1.08\n1.99\n0.93\n2.98\n2.93\n2.41\n1.98\n1.94\n2.27\n2.69\n2.23\n3.87\n1.43\n3.6\n1.51\n1.7\n2.79\n2.96\n4.67\n5.37\n1.77\n3.52\n5.62\n4.22\n3.33\n3.91\n4.85\n3.4"
              )),

            verticalLayout(
            tags$b("因子 1"), 
            tags$textarea(
              id = "f1", #p
              rows = 10,
              "A1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3"
              )),

            verticalLayout(
            tags$b("因子 2"), 
            tags$textarea(
              id = "f2", #p
              rows = 10,
              "T1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2"
              ))
            ),
            
        helpText("サンプルの名称変更"),
        tags$textarea(id = "cn", rows = 3, "X\nA\nB") #p
            ), #tabPanel(

          ##-------csv file-------##
          tabPanel(
            "アップロード CSV ファイル",
            p(br()),
            fileInput(
              'file', 'CSV ファイルを指定', #p
              accept = c(
                'text/csv',
                'text/comma-separated-values,text/plain',
                '.csv'
                )
              ),
            checkboxInput('header', 'ヘッダー', TRUE), #p
            radioButtons('sep', '区切り', #p
              c(
                Comma = ',',
                Semicolon = ';',
                Tab = '\t'
                ),
              ','
              )
            ))
        ),


      mainPanel(

        h3(tags$b("分散分析 テーブル")),
        checkboxInput('inter', 'Interaction', TRUE), #p
        tableOutput("anova"),

        hr(),

        h4("データの記述統計"),
        tabsetPanel(
        tabPanel("データ表示", p(br()),
        dataTableOutput("table")
        ),

        tabPanel('記述統計',p(br()),
        numericInput("grp", 'データ表示列で係数を選択', 2, 2, 3, 1),
        verbatimTextOutput("bas")
            ),

        tabPanel("平均プロット",p(br()),
        checkboxInput('tick', 'Untick to change the group and x-axis', TRUE), #p
        plotOutput("meanp.a", width = "500px", height = "300px")
          ),

        tabPanel("周辺平均プロット",p(br()),
          checkboxInput('tick2', 'Untick to change the x-axis', TRUE), #p
        plotOutput("mmean.a", width = "500px", height = "300px")
          )
          )
        )
      )
    ), ##

##---------- Panel 3 ----------

  tabPanel(
    "多重比較",
    headerPanel("多重比較"),

    tags$b("前提として"),
    tags$ul(
      tags$li("3つ以上のレベルの因子が存在する場合、有意な効果が見出されている"),
      tags$li("分散分析の後、目的変数の平均値はファクタによって大きく異なる場合がありますが、ファクタレベルのどのペアが互いに大きく異なるかは不明です")
      ),

    sidebarLayout(

        sidebarPanel(
        helpText("仮説"),
        tags$b("帰無仮説"),
        HTML("<p>因子の母集団平均は等しい。</p>"),
        hr(),
        
        ##----Import data----##
        h4("データ挿入"),

        tabsetPanel(
          ##-------input data-------##s
          tabPanel(
            "手入力",
            p(br()),
            helpText("欠損値はNAと表示される"),

            splitLayout(
            verticalLayout(
            tags$b("値"), 
            tags$textarea(
              id = "xm", #p
              rows = 10,
              "0.55\n3.22\n1.08\n1.99\n0.93\n2.98\n2.93\n2.41\n1.98\n1.94\n2.27\n2.69\n2.23\n3.87\n1.43\n3.6\n1.51\n1.7\n2.79\n2.96\n4.67\n5.37\n1.77\n3.52\n5.62\n4.22\n3.33\n3.91\n4.85\n3.4"
              )),

            verticalLayout(
            tags$b("因子"), 
            tags$textarea(
              id = "fm", #p
              rows = 10,
              "A1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3"
              ))
            ),

        helpText("サンプルの名称変更"),
        tags$textarea(id = "cnm", rows = 2, "X\nA") #p
            ),
        
         ##-------csv file-------##
          tabPanel(
            "アップロード CSV ファイル",
            p(br()),
            fileInput(
              'filem', 'CSV ファイルを指定', #p
              accept = c(
                'text/csv',
                'text/comma-separated-values,text/plain',
                '.csv'
                )
              ),
            checkboxInput('headerm', 'ヘッダー', TRUE), #p
            radioButtons('sepm', '区切り', #p
              c(
                Comma = ',',
                Semicolon = ';',
                Tab = '\t'
                ),
              ','
              ) 
          ))
        ),

       mainPanel(
        h4("結果"),

        tabsetPanel(

          tabPanel("対応のあるt検定", p(br()),
          radioButtons("method", "方法を1つ選択", 
          c(Bonferroni = 'bonferroni',
            Holm = 'holm',
            Hochberg = 'hochberg',
            Hommel = 'hommel',
            FDR_Benjamini_Hochberg = 'BH',
            Benjamini_Yekutieli = 'BY'
            ), 
          "bonferroni"),
        verbatimTextOutput("multiple")
            ),

          tabPanel("テューキーの範囲検定", p(br()),
            verbatimTextOutput("hsd")
            )
          ),

        h4("データ表示"),
        dataTableOutput("tablem")

        )
      ) 
  ),

##---------- other panels ----------

source("../0tabs/home_jp.R",local=TRUE,encoding = "UTF-8")$value,
source("../0tabs/stop_jp.R",local=TRUE,encoding = "UTF-8")$value





)))

