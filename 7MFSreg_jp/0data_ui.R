##----------#----------#----------#----------
##
## 7MFSreg UI
##
##    >data
##
## Language: JP
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------


#tabPanel("Dataset",

  #titlePanel("Upload your dataset"),

#helpText("Before user's data is uploaded, the example data (mtcars) is being shown ."),
  sidebarLayout(

    sidebarPanel(

    ##----------example datasets----------

    selectInput("edata", "データを Choose data:", 
                            choices =  c("insurance","advertisement","lung"), 
                            selected = "insurance"),
                ## render dynamic checkboxes
    


    ##-------csv file-------##   
    fileInput('file', "CSV ファイルを指定",
              accept = c("text/csv",
                      "text/comma-separated-values,text/plain",
                      ".csv")),
    helpText("Xの列は500を超えない"),
    # Input: Checkbox if file has header ----
    checkboxInput("header", "ヘッダー", TRUE),

      fluidRow(

      column(4, 
         # Input: Select separator ----
      radioButtons("sep", "区切り",
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

      actionButton("choice", "データ挿入", style="color: #fff; background-color: #337ab7; border-color: #2e6da4")),


    mainPanel(
      
      h4("データ表示"),

      tags$br(),

      tags$b("データセットの最初の5行2列の概要"), 

      dataTableOutput("data"),
  
      
      selectInput("columns", "詳細を表示する変数を選択", choices = NULL, multiple = TRUE), # no choices before uploading 
  
      dataTableOutput("data_var"),
      hr(),

      h4("記述統計"), 
      tags$b("説明変数を選択"),

        fluidRow(
          column(6,
          uiOutput('cv'),
          actionButton("Bc", "記述"),
          tableOutput("sum"),
          helpText(HTML(
      "
      注:
      <ul>
      <li> nbr.: the number of </li>
      </ul>
      "
      ))
          ),

          column(6,
          uiOutput('dv'),
          actionButton("Bd", "記述"),
          verbatimTextOutput("fsum")
          )),

      h4(("変数の最初の探査")),  
      tabsetPanel(
        tabPanel("2つの変数間の散布図（線付き）",
          uiOutput('ty'),
          uiOutput('tx'),
          plotOutput("p1", width = "400px", height = "400px")
          ),
        tabPanel("ヒストグラム",
          fluidRow(
          column(6,
            uiOutput('hx'),
            plotOutput("p2", width = "400px", height = "400px"),
            sliderInput("bin", "ヒストグラムの棒幅", min = 0.01, max = 50, value = 1)),
          column(6,
            uiOutput('hxd'),
            plotOutput("p3", width = "400px", height = "400px"))))
        )
   

  ))