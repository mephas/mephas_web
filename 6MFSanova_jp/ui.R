##----------------------
##
## anova ui JP
##
## 2018-11-30
##
##-----------------------


shinyUI(

tagList(
# shinythemes::themeSelector(),
navbarPage(
  #theme = shinytheme("cosmo"),
  title = "分散分析",

  ## 2. One way anova ---------------------------------------------------------------------------------
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
        helpText("仮説"),
        tags$b("帰無仮説"),
        HTML("<p>すべてのグループの平均は等しい</p>"),
        tags$b("代替仮説"),
        HTML("<p>グループの平均はすべて等しいわけではない</p>"),
        hr(),
        ##----Import data----##
        helpText("インポート"),

        tabsetPanel(
          ##-------input data-------##s
          tabPanel(
            "手入力",
            p(br()),
            helpText("誤った値はNAとして表示されます"),
            tags$textarea(
              id = "x1", #p
              rows = 10,
              "0.55\n3.22\n1.08\n1.99\n0.93\n2.98\n2.93\n2.41\n1.98\n1.94\n2.27\n2.69\n2.23\n3.87\n1.43\n3.6\n1.51\n1.7\n2.79\n2.96\n4.67\n5.37\n1.77\n3.52\n5.62\n4.22\n3.33\n3.91\n4.85\n3.4"
              ),
            p(br()),
            
            helpText("The factor"),
            tags$textarea(
              id = "f11", #p
              rows = 10,
              "A1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3"
              ),

        helpText("標本の名前を変えることができます"),
        tags$textarea(id = "cn1", rows = 2, "X\nA")),

                    ##-------csv file-------##
          tabPanel(
            "アップロード.csv ファイルのみ",
            p(br()),
            fileInput(
              'file1', ' .csvファイルを選んでください', #p
                accept = c(
                'text/csv',
                'text/comma-separated-values,text/plain',
                '.csv'
                )
              ),
            checkboxInput('header1', 'Header', TRUE), #p
            radioButtons('sep1', 'Separator', #p
              c(
                カンマ = ',',
                セミコロン　= ';',
                タブ = '\t'
                ),
              ','
              ))
          ),

        hr(),
        h4("データ"),
        dataTableOutput("table1")),

      mainPanel(
        h3(tags$b("検定結果")),
        tableOutput("anova1"),
        #tags$b('Interpretation'), p("NULL"),

        hr(),
        h3(tags$b('記述統計')),
        verbatimTextOutput("bas1"),

        hr(),
        h3(tags$b("平均値の差のプロット")),
        plotOutput("mmean1", width = "500px", height = "300px")


        )

      )
    ),

 ## 2. two way anova ---------------------------------------------------------------------------------
  tabPanel(
    "二元",

    headerPanel("二元配置分散分析"),

    tags$b("前提として"),
    tags$ul(
      tags$li("標本から得られた集団は、正規分布に分布している、もしくはそれに近い。"),
      tags$li("標本はそれぞれ独立する"),
      tags$li("母集団の分散は等しい。"),
      tags$li("グループの標本サイズは同じ。")

      ),

    sidebarLayout(
      sidebarPanel(
        helpText("仮説"),
        tags$b("帰無仮説1"),
        HTML("<p>第1因子の母集団平均は等しい。 </p>"),
        tags$b("帰無仮説 2"),
        HTML("<p第２因子の母集団平均は等しい。</p>"),
        tags$b("帰無仮説 3"),
        HTML("<p>二つの因子の間に相関はない</p>"),
        hr(),
        
        ##----Import data----##
        helpText("インポート"),

        tabsetPanel(
          ##-------input data-------##s
          tabPanel(
            "手入力",
            p(br()),
            helpText("誤った値はNAとして表示されます"),
            tags$textarea(
              id = "x", #p
              rows = 10,
              "0.55\n3.22\n1.08\n1.99\n0.93\n2.98\n2.93\n2.41\n1.98\n1.94\n2.27\n2.69\n2.23\n3.87\n1.43\n3.6\n1.51\n1.7\n2.79\n2.96\n4.67\n5.37\n1.77\n3.52\n5.62\n4.22\n3.33\n3.91\n4.85\n3.4"
              ),
            p(br()),
            splitLayout(
            helpText("第一因子"),
            tags$textarea(
              id = "f1", #p
              rows = 10,
              "A1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3"
              ),
            helpText("第二因子"),
            tags$textarea(
              id = "f2", #p
              rows = 10,
              "T1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2"
              )),
            
        helpText("標本の名前変更"),
        tags$textarea(id = "cn", rows = 3, "X\nA\nB") #p
            ), #tabPanel(

          ##-------csv file-------##
          tabPanel(
            "アップロード.csv ファイル",
            p(br()),
            fileInput(
              'file', '.csv ファイルを選ぶ', #p
              accept = c(
                'text/csv',
                'text/comma-separated-values,text/plain',
                '.csv'
                )
              ),
            checkboxInput('header', 'Header', TRUE), #p
            radioButtons('sep', 'Separator', #p
              c(
                コンマ = ',',
                セミコロン = ';',
                タブ = '\t'
                ),
              ','
              )
            )),

        hr(),
        h4("データ"),
        dataTableOutput("table")),


      mainPanel(
        h3(tags$b("結果")),
        checkboxInput('inter', 'Interaction', TRUE), #p
        tableOutput("anova"),
        #tags$b('Interpretation'), p("NULL"),

        hr(),
        h3(tags$b('記述統計')),
          numericInput("grp", 'Choose the factor in the Data Display column', 2, 2, 3, 1),
          verbatimTextOutput("bas"),

        hr(),
        h3(tags$b("平均プロット")),
        checkboxInput('tick', 'Untick to change the group and x-axis', TRUE), #p
        plotOutput("meanp.a", width = "500px", height = "300px"),

        hr(),
        h3(tags$b("平均の差のプロット")),
        checkboxInput('tick2', 'Untick to change the x-axis', TRUE), #p
        plotOutput("mmean.a", width = "500px", height = "300px")
        )
      )
    ), ##

  ## 3. multiple comparision ---------------------------------------------------------------------------------
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
        helpText("データインポート"),

        tabsetPanel(
          ##-------input data-------##s
          tabPanel(
            "手入力",
            p(br()),
            helpText("誤った値はNAとして表示されます"),
            tags$textarea(
              id = "xm", #p
              rows = 10,
              "0.55\n3.22\n1.08\n1.99\n0.93\n2.98\n2.93\n2.41\n1.98\n1.94\n2.27\n2.69\n2.23\n3.87\n1.43\n3.6\n1.51\n1.7\n2.79\n2.96\n4.67\n5.37\n1.77\n3.52\n5.62\n4.22\n3.33\n3.91\n4.85\n3.4"
              ),
            p(br()),
            helpText("因子"),
            tags$textarea(
              id = "fm", #p
              rows = 10,
              "A1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3"
              ),

        helpText("標本の名前変更"),
        tags$textarea(id = "cnm", rows = 2, "X\nA") #p
            ),
        
         ##-------csv file-------##
          tabPanel(
            "アップロード .csv ファイル",
            p(br()),
            fileInput(
              'filem', '.csvファイルを選ぶ', #p
              accept = c(
                'text/csv',
                'text/comma-separated-values,text/plain',
                '.csv'
                )
              ),
            checkboxInput('headerm', 'Header', TRUE), #p
            radioButtons('sepm', 'Separator', #p
              c(
                カンマ = ',',
                セミコロン = ';',
                タブ = '\t'
                ),
              ','
              ) 
          )),

        hr(),
        h4("データ"),
        
        dataTableOutput("tablem")),

       mainPanel(
        h3(tags$b("結果")),
        h3("Pairwise t-test"),

        radioButtons("method", "Method", 
          c(Bonferroni = 'bonferroni',
            Holm = 'holm',
            Hochberg = 'hochberg',
            Hommel = 'hommel',
            FDR_Benjamini_Hochberg = 'BH',
            Benjamini_Yekutieli = 'BY'
            ), 
          "bonferroni"),
        verbatimTextOutput("multiple"),

        hr(),
        h3("Tukey Honest Significant Differences"),
        verbatimTextOutput("hsd")
        )
      ) 
  ),

 
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
     onclick ="window.open('https://pharmacometrics.info/mephas/index_jp.html')",HTML("トップ")))



)))
