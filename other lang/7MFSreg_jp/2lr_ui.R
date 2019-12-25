##----------#----------#----------#----------
##
## 7MFSreg UI
##
##    >Logistic regression
##
## Language: JP
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------

sidebarLayout(
sidebarPanel(

h4(("データセットがインポートされたら、モデルをデザインしてください")),       
uiOutput('y.l'),    
uiOutput('x.l'),
uiOutput('fx.l'),
# select intercept
radioButtons("intercept.l", "定数項",
             choices = c("定数項を取り除く" = "-1",
                         "K定数項を取り除かない" = ""),
             selected = "-1"),
h5("追加の用語 (confounding交絡因子 or interaction交互作用)"), 
helpText('注: "+"で始める、交互作用では、「+ as.factor（var1）：var2」と入力'), 
tags$textarea(id='conf.l', column=40, ""), 
p(br()),
actionButton("F.l", "Create formula", style="color: #fff; background-color: #337ab7; border-color: #2e6da4")

), ## sidebarPanel(

mainPanel(

  h4(("Lロジスティック回帰")),

  tags$style(type='text/css', '#formula_l {background-color: rgba(0,0,255,0.10); color: blue;}'),
  verbatimTextOutput("formula_l", placeholder = TRUE),
  helpText("注: 式の「-1」は、切片が削除されたことを示す"),
  hr(),

  h4(("結果")),
  actionButton("B1.l", "結果表示"), 
  p(br()),
  tabsetPanel(
    tabPanel("Parameters' estimation", 
      p(br()),
      
      p(br()),
      tags$b("1. 偏回帰係数"), 
      htmlOutput("fit.l"), p(br()),
      tags$b("2. ANOVA テーブル"), tableOutput("anova.l"), p(br()),
      tags$b("3.AICで式ベースのモデルを選択"), verbatimTextOutput("step.l")
      ),

    tabPanel("回帰診断",
      p(br()),
      tags$b("ROC プロット"),
      
      plotOutput("p2.l", width = "400px", height = "400px"),
      verbatimTextOutput("auc")
      ),

    tabPanel("フィッティング推定値",
      tags$b("推定はインポートデータセットに基づく"), 
      dataTableOutput("fitdt")
      ),

    tabPanel("新しいデータの予測", 
      p(br()),
      #prediction part
        ##-------csv file for prediction -------##   
      # Input: Select a file ----
      fileInput("newfile.l", "新しい.csvデータセットをアップロード",
                multiple = TRUE,
                accept = c("text/csv",
                         "text/comma-separated-values,text/plain",
                         ".csv")),

       # Input: Checkbox if file has header ----
      checkboxInput("newheader.l", "ヘッダー", TRUE),

        fluidRow(
      column(3, 
         # Input: Select separator ----
      radioButtons("newsep.l", "区切り",
                   choices = c(Comma = ",",
                               Semicolon = ";",
                               Tab = "\t"),
                   selected = ",")),

      column(3,
        # Input: Select quotes ----
      radioButtons("newquote.l", "クオート",
                   choices = c(None = "",
                               "Double Quote" = '"',
                               "Single Quote" = "'"),
                   selected = '"'))

      ),
      actionButton("B2.l", "モデルの推定後に送信"),
      helpText("データがアップロードされていない場合は、テストデータの例（インポートデータセットの最初の10行）が表示される"),
       
      p(br()),
      tags$b("予測結果付きデータ表示"), 
      p(br()),
      dataTableOutput("preddt.l")
      ) ##  tabPanel("Prediction"
    ) ## tabsetPanel(
) ## mainPanel(
) ## sidebarLayout(