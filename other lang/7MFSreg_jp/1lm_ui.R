##----------#----------#----------#----------
##
## 7MFSreg UI
##
##    >Linear regression
##
## Language: JP
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------


sidebarLayout(

  sidebarPanel(

  h4(("データセットがインポートされたら、モデルをデザインしてください")),      
  uiOutput('y'),    
  uiOutput('x'),
  uiOutput('fx'),
  
  radioButtons("intercept", "定数項", ##> intercept or not
               choices = c("定数項を取り除く" = "-1",
                           "定数項を取り除かない" = ""),
               selected = "-1"),
  h5("追加の用語 (confounding交絡因子 or interaction交互作用)"), 
  helpText('注: "+"で始める、 交互作用では、「+ as.factor（var1）：var2」と入力'), 
  tags$textarea(id='conf', cols=40, " " ), 
  p(br()),
  actionButton("F", "Create formula", style="color: #fff; background-color: #337ab7; border-color: #2e6da4")

  ),
 
mainPanel(

  h4(("線形回帰")),
  
  tags$style(type='text/css', '#formula {background-color: rgba(0,0,255,0.10); color: blue;}'),
  verbatimTextOutput("formula", placeholder = TRUE),
  helpText("注: 式の「-1」は、切片が削除されたことを示す"),
  hr(),


  h4(("結果")),
  actionButton("B1", "結果表示"),
  p(br()),
  tabsetPanel(
    
    tabPanel("パラメータの推定",
      p(br()),
     #sliderInput("range", label = h3("choose subset"), min = 1, max = 100, value = c(1,10)),
      tags$b("1. 偏回帰係数"),
      htmlOutput("fit"), p(br()),
      tags$b("2. ANOVA テーブル"), tableOutput("anova"),p(br()),
      tags$b("3. AICで式ベースのモデルを選択"), verbatimTextOutput("step")
      ),

    tabPanel("回帰診断", 
      p(br()),
      tags$b("診断プロット"), 
      radioButtons("num", "プロットを選択",
                   choices = c("Residuals vs fitted plot" = 1,
                               "Normal Q-Q" = 2,
                               "Scale-Location" = 3,
                               "Cook's distance" = 4,
                               "Residuals vs Leverage" = 5),
                   selected = 1),
      plotOutput("p.lm", width = "800px", height = "400px")
      ),

    tabPanel("フィッティング推定値",
      p(br()),
      tags$b("推定はインポートデータセットに基づく"),
      dataTableOutput("fitdt0")),

      tabPanel("新しいデータの予測", p(br()),
      #prediction part
        ##-------csv file for prediction -------##   
      # Input: Select a file ----
      fileInput("newfile", "新しい.csvデータセットをアップロード",
                multiple = TRUE,
                accept = c("text/csv",
                         "text/comma-separated-values,text/plain",
                         ".csv")),
       # Input: Checkbox if file has header ----
      checkboxInput("newheader", "ヘッダー", TRUE),

      fluidRow(
      column(3, 
         # Input: Select separator ----
      radioButtons("newsep", "区切り",
                   choices = c(Comma = ",",
                               Semicolon = ";",
                               Tab = "\t"),
                   selected = ",")),

      column(3,
        # Input: Select quotes ----
      radioButtons("newquote", "クオート",
                   choices = c(None = "",
                               "Double Quote" = '"',
                               "Single Quote" = "'"),
                   selected = '"')),
      column(3,
       # prediction type
      radioButtons("interval", "予測区間を選択（0.95レベル）",
                   choices = c(
                               "信頼区間" = "confidence",
                               "予測区間" = "prediction"),
                   selected = 'confidence'))
                ), ##fluidRow(

      actionButton("B2", "モデルの推定後に送信"), 
      helpText("データがアップロードされていない場合は、テストデータの例（インポートデータセットの最初の10行）が表示される"),
      
      p(br()),
      tags$b("予測結果付きデータ表示"), 
      p(br()),
      dataTableOutput("pred")
      
  ) 


  )
  )
)

