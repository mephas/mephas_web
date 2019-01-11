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

    selectInput("edata", "Choose data:", 
                            choices =  c("insurance","advertisement","lung"), 
                            selected = "insurance"),
                ## render dynamic checkboxes
    


    ##-------csv file-------##   
    fileInput('file', "Upload .csv",
              accept = c("text/csv",
                      "text/comma-separated-values,text/plain",
                      ".csv")),
    helpText("The columns of X are not suggested greater than 500"),
    # Input: Checkbox if file has header ----
    checkboxInput("header", "Header", TRUE),

      fluidRow(

      column(4, 
         # Input: Select separator ----
      radioButtons("sep", "Separator",
                   choices = c(Comma = ',',
                               Semicolon = ';',
                               Tab = '\t'),
                   selected = ',')),

      column(4,
      # Input: Select quotes ----
      radioButtons("quote", "Quote",
                   choices = c(None = "",
                               "Double Quote" = '"',
                               "Single Quote" = "'"),
                   selected = '"'))
      ),

      actionButton("choice", "Import dataset", style="color: #fff; background-color: #337ab7; border-color: #2e6da4")),


    mainPanel(
      
      h4(tags$b("Data Display")),

      tags$br(),

      tags$b("Overview of the first 5 row and 2 columns of the dataset"), 

      dataTableOutput("data"),
  
      
      selectInput("columns", "Select variables to display the details", choices = NULL, multiple = TRUE), # no choices before uploading 
  
      dataTableOutput("data_var"),
      hr(),

      h4(tags$b("Basic Descriptives")), 
      tags$b("Select the variables for descriptives"),

        fluidRow(
          column(6,
          uiOutput('cv'),
          actionButton("Bc", "Show descriptives"),
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
          actionButton("Bd", "Show descriptives"),
          verbatimTextOutput("fsum")
          )),

      h4(tags$b("First Exploration of Variables")),  
      tabsetPanel(
        tabPanel("Scatter plot (with line) between two variables",
          uiOutput('ty'),
          uiOutput('tx'),
          plotOutput("p1", width = "400px", height = "400px")
          ),
        tabPanel("Bar plots",
          fluidRow(
          column(6,
            uiOutput('hx'),
            plotOutput("p2", width = "400px", height = "400px"),
            sliderInput("bin", "The width of bins in the histogram", min = 0.01, max = 50, value = 1)),
          column(6,
            uiOutput('hxd'),
            plotOutput("p3", width = "400px", height = "400px"))))
        )
   

  ))