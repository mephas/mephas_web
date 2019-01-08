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

    titlePanel("アップロード"),

#helpText("Before user's data is uploaded, the example data (mtcars) is being shown ."),
  sidebarLayout(
    sidebarPanel(##-------csv file-------##   
    # Input: Select a file as variable----
    fileInput('file.x', "アップロード .csv ファイル (説明変数X)",
              multiple = TRUE,
              accept = c("text/csv",
                       "text/comma-separated-values,text/plain",
                       ".csv")),
    helpText("Xの列は500より大きくできません"),
    # Input: Checkbox if file has header ----
    checkboxInput("header.x", "Header", TRUE),

    fluidRow(

    column(4, 
       # Input: Select separator ----
    radioButtons("sep.x", "Separator",
                 choices = c(コンマ = ',',
                             セミコロン = ';',
                             タブ = '\t'),
                 selected = ',')),

    column(4,
    # Input: Select quotes ----
    radioButtons("quote.x", "クォート",
                 choices = c(None = "",
                             "ダブルクォーテーション" = '"',
                             "シングルクォーテーション" = "'"),
                 selected = '"'))
    ),

    # Input: Select a file as response----
    fileInput('file.y', "アップロード.csv データセット(目的変数Y)",
              multiple = TRUE,
              accept = c("text/csv",
                       "text/comma-separated-values,text/plain",
                       ".csv")),
    helpText("Yの列は一つ以上にできます"),
    # Input: Checkbox if file has header ----
    checkboxInput("header.y", "Header", TRUE),

    fluidRow(

    column(4, 
       # Input: Select separator ----
    radioButtons("sep.y", "Separator",
                 choices = c(コンマ = ',',
                             セミコロン = ';',
                             タブ = '\t'),
                 selected = ',')),

    column(4,
    # Input: Select quotes ----
    radioButtons("quote.y", "クォート",
                 choices = c(なし = "",
                             "ダブルクォーテーション" = '"',
                             "シングルクォーテーション" = "'"),
                 selected = '"'))
    )

    ),


    mainPanel(
      h4(tags$b("データ")), 
      dataTableOutput("表"),
      hr(),  
      h4(tags$b("Descriptives")),
      uiOutput('x'),
      verbatimTextOutput("sum"),

      hr(),  
      h4(tags$b("分布図 (Y-X)")), 
      fluidRow(
        column(6, HTML('</br>'), uiOutput('ty')),
        column(6, HTML('</br>'), uiOutput('tx'))),
      plotOutput("p1", width = "400px", height = "400px"),

      hr(),  
      h4(tags$b("ヒストグラム")), 
      HTML('</br>'), uiOutput('hx'),
      plotOutput("p2", width = "400px", height = "400px"),
      sliderInput("bin", "ヒストグラムの棒幅", min = 0.01, max = 5, value = 0.7)
      
  )

  )),
 

## 1. PCA ---------------------------------------------------------------------------------
tabPanel("PCA",

titlePanel("主成分分析（Principal component analysis）"),

sidebarLayout(

sidebarPanel(
  h3("モデルの設定"),
  numericInput("nc", "PCAの要素の数:", 4, min = 2, max = 20),
  helpText("If data are complete, 'pca' uses Singular Value Decomposition; if there are some missing values, it uses the NIPALS algorithm."),
  
  h3("パラメータ設定"),
  numericInput("c1", "x軸の要素", 1, min = 1, max = 20),
  numericInput("c2", "Y軸の要素", 2, min = 1, max = 20)

),

mainPanel(
  h3("結果"),
  #h4(tags$b("PCA output")), ,
  
  h4(tags$b("説明された累積分散")), verbatimTextOutput("fit"),

  h4(tags$b("新しいPCA要素")), dataTableOutput("comp"),

  downloadButton("downloadData", "Download new components"),

  hr(),

  h3("Plots"),

  h4(tags$b("説明変数のプロット")),
  plotOutput("pca.plot", width = "500px", height = "500px"),

  h4(tags$b("個々のプロット")),
  plotOutput("pca.ind", width = "500px", height = "500px"),

  h4(tags$b("変数の相関円のプロット")),
  plotOutput("pca.var", width = "500px", height = "500px"),

  h4(tags$b("最初の二つのプロット")),
  plotOutput("pca.bp", width = "500px", height = "500px")

  )
)
), #penal tab end

## 2.  PLS, ---------------------------------------------------------------------------------
tabPanel("PLS",

titlePanel("部分最小二乗（Partial Least Squares）"),

sidebarLayout(
sidebarPanel(
  h3("モデル設定"),
  numericInput("nc.pls", "要素の数:", 4, min = 2, max = 20),

  h3("パラメータ設定"),
  numericInput("c1.pls", "X軸の要素", 1, min = 1, max = 20),
  numericInput("c2.pls", "Y軸の要素", 2, min = 1, max = 20)
),

mainPanel(
  h3("結果"),
  #h4(tags$b("PLS output")), verbatimTextOutput("fit.pls"),
  h4(tags$b("説明変数からの新しいPLS要素 (X)")), dataTableOutput("comp.x"),
  downloadButton("downloadData.pls.x", "Download the new components"),
  h4(tags$b("目的変数からの新しいPLS要素 (Y)")), dataTableOutput("comp.y"),
  downloadButton("downloadData.pls.y", "Download the new components"),
  hr(),

  h3("プロット"),
  h4(tags$b("個々のプロット")),
  plotOutput("pls.ind", width = "900px", height = "500px"),

  h4(tags$b("変数の相関円のプロット")),
  plotOutput("pls.var", width = "500px", height = "500px")
)

)),

## 3. SPLS, ---------------------------------------------------------------------------------
tabPanel("SPLS",

titlePanel("スパース部分最小二乗Sparse Partial Least Squares"),

sidebarLayout(
sidebarPanel(
  h3("モデル設定"),
  numericInput("nc.spls", "要素の数:", 4, min = 2, max = 20),
  numericInput("x.spls", "Xのローディングで保持する変数の数:", 10, min = 2, max = 20),
  numericInput("y.spls", "Yのローディングで保持する変数の数:", 5, min = 2, max = 20),

  h3("パラメータ設定"),
  numericInput("c1.spls", "X軸の要素", 1, min = 1, max = 20),
  numericInput("c2.spls", "Y軸の要素", 2, min = 1, max = 20)
),

mainPanel(
  h3("結果"),
  #h4(tags$b("PLS output")), verbatimTextOutput("fit.pls"),
  h4(tags$b("説明変数からの新しいPLS要素 (X)")), dataTableOutput("comp.sx"),
  downloadButton("downloadData.spls.x", "Download the new components"),
  h4(tags$b("目的変数からの新しいPLS要素 (Y)")), dataTableOutput("comp.sy"),
  downloadButton("downloadData.spls.y", "Download the new components"),
  hr(),

  h3("プロット"),
  h4(tags$b("個々のプロット")),
  plotOutput("spls.ind", width = "900px", height = "500px"),

  h4(tags$b("変数の相関円のプロット")),
  plotOutput("spls.var", width = "500px", height = "500px"),

  h4(tags$b("ローディングプロット")),
  plotOutput("spls.load", width = "900px", height = "500px")
  ))
),
 #penal tab end

##----------------------------------------------------------------------
## 4. Regularization ---------------------------------------------------------------------------------
#tabPanel("Elastic net",

#titlePanel("Ridge, LASSO, and elastic net"),

#sidebarLayout(
#sidebarPanel(

#  h3("Model's configuration"),
  
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
#  h3("Results"),
  #plotOutput("plot.ela", width = "500px", height = "500px"),
#  verbatimTextOutput("ela")
  #h3("Cross-validated lambda"),
  #verbatimTextOutput("lambda"),
  #helpText("Lambda is merely suggested to be put into the model.")

#  )
#)
#)

 ##----------
tabPanel((a("ホーム",
 #target = "_blank",
 style = "margin-top:-30px;",
 href = paste0("https://pharmacometrics.info/mephas/", "index_jp.html")))),

tabPanel(
      tags$button(
      id = 'close',
     style = "margin-top:-10px;",
      type = "button",
      class = "btn action-button",
      onclick = "setTimeout(function(){window.close();},500);",  # close browser
      "停止"))

)

)   
)   
 

