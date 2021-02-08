sidebarLayout(
  sidebarPanel(
    tabsetPanel(     
    tabPanel("CSV file",
             h4(tags$b("Step 1. Data Preparation")),
             
             fileInput('NUM_file','1. Upload your CSV file here(with heading)',
                       accept=c(
                         'text/csv',
                         'text/comma-separated-values,text/plain',
                         '.csv')),
             
             p(tags$b("2. Choose whether you need standardized your data")),
             checkboxInput("NUM_scale", "Scale", FALSE),
             
             p(tags$b("3. Choose the features which are used in clusting")),
             uiOutput('clu_v_NUM_out'),
             
             h4(tags$b("Step 2. Result visualisation")),
             
             p(tags$b("1. Set the max clusting number in the output image")),
             numericInput('NUM_K_Max', 'the max clusting number', 8, 2, 20,1),
             


#			 selectInput("dist_method","hist method",c("euclidean", "maximum", "manhattan", "canberra", "binary","minkowski"),selected ="euclidean"),
#			 selectInput("hclust_method","hclust method",c("complete","ward.D", "ward.D2", "single", "average", "mcquitty", "median","centroid"),selected ="complete"),
             p(tags$b("you can reload this page by clicking the button below.")),
             actionButton("NUM_clear","clear")
                       
      )
    )),
  mainPanel(
    h4(tags$b("Output")),
    h4('Plot:'),
    plotOutput('plot_NUM'),
#    uiOutput('condi_plot'),
#    uiOutput('test'),
    h4('Input Confirm:'),
    dataTableOutput('NUM_table'),
    h4('Results:'),
    verbatimTextOutput("NUM_results"),
    h4('Download:'),
    downloadButton('NUM_download', 'Download')
  )
)

