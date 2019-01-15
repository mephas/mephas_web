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
    #helpText("Xの列は500より大きくできません"),
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
    helpText("Yの列は一つ以上にできます"),
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
      helpText("The first 5 rows and first 5 columns of X matrix"),
      tags$head(tags$style(".shiny-output-error{color: blue;}")),
      tableOutput("table.x"),
      helpText("The first 5 rows and first columns of Y matrix"),
      tableOutput("table.y"),
      hr(),  
      h4(("記述統計")),
      tags$b("Select the variables for 記述統計"),

        fluidRow(
          column(6,
          uiOutput('cv'),
          actionButton("Bc", "Show 記述統計"),
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
          actionButton("Bd", "Show 記述統計"),
          verbatimTextOutput("fsum")
          )),

            h4(("First Exploration of Variables")),  

      tabsetPanel(
        tabPanel("散布図 (with line) between two variables",
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
  h3("モデルの設定"),
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
  h3("モデルの設定"),
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

##---------- other panels ----------

source("../0tabs/home_jp.R",local=TRUE,encoding = "UTF-8")$value,
source("../0tabs/stop_jp.R",local=TRUE,encoding = "UTF-8")$value

)

)   
)   
 

