##----------#----------#----------#----------
##
## 7MFSreg UI
##
##    >Cox regression
##
## Language: JP
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------

sidebarLayout(

sidebarPanel(
  
##>>---------cox formula---------->>
h4(tags$b("データセットがインポートされたら、モデルをデザインしてください")),
uiOutput('t1.c'),
uiOutput('t2.c'),
uiOutput('c.c'),    
uiOutput('x.c'),
uiOutput('fx.c'),
uiOutput('sx.c'),
uiOutput('clx.c'),

h5("追加の用語 (confounding交絡因子 or interaction交互作用)"), 
helpText('注: "+"で始める、 交互作用では、「+ as.factor（var1）：var2」と入力'), 
tags$textarea(id='conf.c', cols=40, " " ), 
p(br()),
actionButton("F.c", "Create formula", style="color: #fff; background-color: #337ab7; border-color: #2e6da4")

), ## sidebarPanel(

mainPanel( 

h4(("Cox 回帰")),
tags$style(type='text/css', '#formula_c {background-color: rgba(0,0,255,0.10); color: blue;}'),
verbatimTextOutput("formula_c", placeholder = TRUE),
hr(),

h4(("結果")),
actionButton("B1.c", "結果表示"),
p(br()),

tabsetPanel(
tabPanel("変数の探査",
p(br()),
actionButton("Y.c", "式作成後にプロットする"),
p(br()),
tags$b("1. K-M生存プロット（ヌルモデル）"), 
helpText("Formula: Surv(time, status)~1 "),
plotOutput("p0.c", width = "400px", height = "400px"),

tags$b("2. K-M生存プロット（グループ別）"), 
helpText("計算式：Surv（time、status）〜グループ"),
uiOutput('tx.c'),
plotOutput("p1.c", width = "400px", height = "400px")
),
tabPanel("パラメータの推定", 
p(br()),

tags$b("1. 偏回帰係数"), 
htmlOutput("fit.c"), p(br()),
tags$b("2. ANOVA テーブル"), tableOutput("anova.c"),p(br()),
tags$b("3. AICで式ベースのモデルを選択"), verbatimTextOutput("step.c")
),
tabPanel("回帰診断", 
p(br()),
tags$b("1. 経時的に一定のハザード比をチェックする"),
tableOutput("zph.c"), 
plotOutput("p2.c",width = "400px", height = "400px"),
tags$b("2. 診断プロット"), 
radioButtons("res.c", "Residual type",
       choices = c("Martingale" = "martingale",
                   "Deviance" = "deviance",
                   "Cox-Snell" = "Cox-Snell"),
       selected = "martingale") ,
plotOutput("p4.c", width = "700px", height = "500px")),

tabPanel("フィッティング推定値",
p(br()),
tags$b("推定はインポートデータセットに基づく"),
dataTableOutput("fitdt.c")),

tabPanel("新しいデータの予測", 
p(br()),
#prediction part
##-------csv file for prediction -------##   
# Input: Select a file ----
fileInput("newfile.c", "新しい.csvデータセットをアップロード",
        multiple = TRUE,
        accept = c("text/csv",
                 "text/comma-separated-values,text/plain",
                 ".csv")),

# Input: Checkbox if file has header ----
checkboxInput("newheader.c", "ヘッダー", TRUE),

fluidRow(
column(3, 
 # Input: Select separator ----
radioButtons("newsep.c", "区切り",
           choices = c(Comma = ",",
                       Semicolon = ";",
                       Tab = "\t"),
           selected = ",")),

column(3,
# Input: Select quotes ----
radioButtons("newquote.c", "クオート",
           choices = c(None = "",
                       "Double Quote" = '"',
                       "Single Quote" = "'"),
           selected = '"'))

),
actionButton("B2.c", "モデルの推定後に送信"), 
p(br()),
tags$b("結果の表示"), 
p(br()),
dataTableOutput("pred.c")
)
) ##tabsetPanel(
) ## mainPanel(

) ## sidebarLayout(