##----------#----------#----------#----------
##
## 8MFSpcapls UI
##
## Language: JP
## 
## DT: 2019-01-08
##
##----------#----------#----------#----------

shinyUI(
tagList(
#shinythemes::themeSelector(),
navbarPage(
 
  title = "多変量解析",

  tabPanel("データセット",

    titlePanel("データ挿入"),

#helpText("Before user's data is uploaded, the example data (mtcars) is being shown ."),
  sidebarLayout(
    sidebarPanel(##-------csv file-------##   
    # Input: Select a file as variable----
    fileInput('file.x', "CSV ファイルを指定してください（説明変数X）",
              multiple = TRUE,　
              accept = c("text/csv",
                       "text/comma-separated-values,text/plain",
                       ".csv")),
    #helpText("Xの列は400より大きくできません"),
    # Input: Checkbox if file has header ----
    checkboxInput("header.x", "ヘッダー", TRUE),

    fluidRow(

    column(4, 
       # Input: Select separator ----
    radioButtons("sep.x", "区切り",
                   choices = c(Comma = ',',
                               Semicolon = ';',
                               Tab = '\t'),
                   selected = ',')),

    column(4,
    # Input: Select quotes ----
    radioButtons("quote", "クオート",
                   choices = c(None = "",
                               "Double Quote" = '"',
                               "Single Quote" = "'"),
                   selected = '"'))
    ),

    # Input: Select a file as response----
    fileInput('file.y', "CSV ファイルを指定してください　(目的変数Y)",
              multiple = TRUE,
              accept = c("text/csv",
                       "text/comma-separated-values,text/plain",
                       ".csv")),
    helpText("Yの列は一つ以上にできる"),
    # Input: Checkbox if file has header ----
    checkboxInput("header.y", "ヘッダー", TRUE),

    fluidRow(

    column(4, 
       # Input: Select separator ----
    radioButtons("sep.y", "区切り",
                   choices = c(Comma = ',',
                               Semicolon = ';',
                               Tab = '\t'),
                   selected = ',')),


    column(4,
    # Input: Select quotes ----
    radioButtons("quote.y", "クオート",
                   choices = c(None = "",
                               "Double Quote" = '"',
                               "Single Quote" = "'"),
                   selected = '"'))
    )

    ),


 mainPanel(
      h4(("データ表示")), 
      helpText("X行列の最初の5行"),
      tags$head(tags$style(".shiny-output-error{color: blue;}")),
      dataTableOutput("table.x"),
      helpText("Y行列の最初の5行"),
      dataTableOutput("table.y"),
      hr(),  
      h4(("記述統計")),
      tags$b("記述統計の変数を選択"),

        fluidRow(
          column(6,
          uiOutput('cv'),
          actionButton("Bc", "記述統計を表示"),
          tableOutput("sum"),
          helpText(HTML(
      "
      Note:
      <ul>
      <li> nbr.: the number of </li>
      </ul>
      "
      ))
          ),

          column(6,
          uiOutput('dv'),
          actionButton("Bd", "記述統計を表示"),
          verbatimTextOutput("fsum")
          )),
        hr(),

            h4(("変数の最初の探査")),  

      tabsetPanel(
        tabPanel("2つの変数間の散布図（線付き）",
          uiOutput('tx'),
          uiOutput('ty'),
          plotOutput("p1", width = "400px", height = "400px")
          ),
        tabPanel("ヒストグラム",
          fluidRow(
          column(6,
            uiOutput('hx'),
            plotOutput("p2", width = "400px", height = "400px"),
            sliderInput("bin", "ヒストグラムの棒幅", min = 10, max = 150, value = 1)),
          column(6,
            uiOutput('hxd'),
            plotOutput("p3", width = "400px", height = "400px"))))
        )
  )


  )),
 

## 1. PCA ---------------------------------------------------------------------------------
tabPanel("PCA",

titlePanel("主成分分析（Principal component analysis）"),

sidebarLayout(

sidebarPanel(
  h4("モデルの設定"),
  numericInput("nc", "PCAの要素の数:", 4, min = 2, max = 20),
  helpText("データが完全な場合 'pca'は特異値分解を使用、 欠損値がある場合は、NIPALSアルゴリズムを使用"),
  
  h4("パラメータ設定"),
  numericInput("c1", "x軸の要素", 1, min = 1, max = 20),
  numericInput("c2", "Y軸の要素", 2, min = 1, max = 20)

),

mainPanel(
  h4("結果"),
  #h4(tags$b("PCA output")), ,
  
  (tags$b("1. 説明された累積分散")),p(br()), verbatimTextOutput("fit"),
p(br()),
  (tags$b("2. 新しいPCA要素")), p(br()),dataTableOutput("comp"),
  downloadButton("downloadData", "Download new components"),

  hr(),

  h4("プロット"),

  tabsetPanel(
    tabPanel("説明変数のプロット",p(br()),
      plotOutput("pca.plot", width = "400px", height = "400px")),

    tabPanel("個々のプロット",p(br()),
      plotOutput("pca.ind", width = "400px", height = "400px")),

    tabPanel("変数の相関円のプロット",p(br()),
      plotOutput("pca.var", width = "400px", height = "400px")),

    tabPanel("最初の二つのプロット",p(br()),
      plotOutput("pca.bp", width = "400px", height = "400px"))
    )
  )
)
), #penal tab end

## 2.  PLS, ---------------------------------------------------------------------------------
tabPanel("PLS",

titlePanel("部分最小二乗（Partial Least Squares）"),

sidebarLayout(
sidebarPanel(
  h4("モデルの設定"),
  numericInput("nc.pls", "要素の数:", 4, min = 2, max = 20),

  h4("パラメータ設定"),
  numericInput("c1.pls", "X軸の要素", 1, min = 1, max = 20),
  numericInput("c2.pls", "Y軸の要素", 2, min = 1, max = 20)
),

mainPanel(
  h4("結果"),
  #h4(tags$b("PLS output")), verbatimTextOutput("fit.pls"),
  (tags$b("説明変数からの新しいPLS要素 (X)")),p(br()),  dataTableOutput("comp.x"),
  downloadButton("downloadData.pls.x", "新しいコンポーネントをダウンロードする"),
  p(br()), 
  (tags$b("目的変数からの新しいPLS要素 (Y)")),p(br()),  dataTableOutput("comp.y"),
  downloadButton("downloadData.pls.y", "新しいコンポーネントをダウンロードする"),
  hr(),

  h4("プロット"),
  tabsetPanel(
tabPanel("個々のプロット",p(br()), 
  plotOutput("pls.ind", width = "800px", height = "400px")),

tabPanel("変数の相関円のプロット",p(br()), 
  plotOutput("pls.var", width = "400px", height = "400px"))
    )
)

)),

## 3. SPLS, ---------------------------------------------------------------------------------
tabPanel("SPLS",

titlePanel("スパース部分最小二乗Sparse Partial Least Squares"),

sidebarLayout(
sidebarPanel(
  h4("モデルの設定"),
  numericInput("nc.spls", "要素の数:", 4, min = 2, max = 20),
  numericInput("x.spls", "Xのローディングで保持する変数の数:", 10, min = 2, max = 20),
  numericInput("y.spls", "Yのローディングで保持する変数の数:", 5, min = 2, max = 20),

  h4("パラメータ設定"),
  numericInput("c1.spls", "X軸の要素", 1, min = 1, max = 20),
  numericInput("c2.spls", "Y軸の要素", 2, min = 1, max = 20)
),

mainPanel(
  h4("結果"),
  #h4(tags$b("PLS output")), verbatimTextOutput("fit.pls"),
  (tags$b("1. 説明変数からの新しいPLS要素 (X)")), p(br()),dataTableOutput("comp.sx"),
  downloadButton("downloadData.spls.x", "Download the new components"),
  p(br()),
  (tags$b("2. 目的変数からの新しいPLS要素 (Y)")), p(br()),dataTableOutput("comp.sy"),
  downloadButton("downloadData.spls.y", "Download the new components"),
  hr(),

  h4("プロット"),
  tabsetPanel(
    tabPanel("個々のプロット",p(br()),
      plotOutput("spls.ind", width = "800px", height = "400px")),

    tabPanel("変数の相関円のプロット",p(br()),
      plotOutput("spls.var", width = "400px", height = "400px")),

    tabPanel("ローディングプロット",p(br()),
      plotOutput("spls.load", width = "800px", height = "400px"))

    )
  
  ))
),
 #penal tab end

##----------------------------------------------------------------------
## 4. Regularization ---------------------------------------------------------------------------------
#tabPanel("Elastic net",

#titlePanel("Ridge, LASSO, and elastic net"),

#sidebarLayout(
#sidebarPanel(

#  h4("Model's configuration"),
  
#  sliderInput("alf", "Alpha parameter", min = 0, max = 1, value = 1),
#  helpText(HTML("
#  <ul>
#    <li>Alpha = 0: Ridge</li>
#    <li>Alpha = 1: LASSO</li>
#    <li>0 < Alpha < 1: Elastic net</li>
#  </ul>
#    ")),

#  radioButtons("family", "Response type",
#                 choices = c(Continuous =   "gaussian",
#                             Quantitative = "mgaussian",
#                             Counts = "poisson",
#                             Binary = "binomial",
#                             Multilevel = "multinomial",
#                             Survival = "cox"),
#                 selected = "mgaussian"),
#
#   numericInput("lamd", "Lambda parameter", min = 0, max = 100, value = 100)

#  ),

#mainPanel(
#  h4("Results"),
  #plotOutput("plot.ela", width = "400px", height = "400px"),
#  verbatimTextOutput("ela")
  #h4("Cross-validated lambda"),
  #verbatimTextOutput("lambda"),
  #helpText("Lambda is merely suggested to be put into the model.")

#  )
#)
#)

##---------- other panels ----------

source("../0tabs/home_jp.R",local=TRUE,encoding = "UTF-8")$value,
source("../0tabs/stop_jp.R",local=TRUE,encoding = "UTF-8")$value

)

)   
)   
 

