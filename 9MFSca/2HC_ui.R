sidebarLayout(
  sidebarPanel(
    tabsetPanel(     
    tabPanel("CSV file",
             h4(tags$b("Step 1. Data Preparation")),
             
             fileInput('HC_file','1. Upload your CSV file here(with heading)',
                       accept=c(
                         'text/csv',
                         'text/comma-separated-values,text/plain',
                         '.csv')),
             p(tags$b("2. Choose whether you need standardized your data")),
             checkboxInput("HC_scale", "Scale", FALSE),
             
             p(tags$b("3. Choose the features which are used in clusting")),
             uiOutput('clu_v_HC_out'),
             
             h4(tags$b("Step 2. Model Fitting")),
             
             p(tags$b("1. Determine the number of clusters")),
             numericInput('HC_clusternumber', 'clusting number', 2, 2, 10,1),
             
             
             p(tags$b("2. Determine the distance measure to be used")),
			       selectInput("dist_method","hist method",c("euclidean", "maximum", "manhattan", "canberra", "binary","minkowski"),selected ="euclidean"),

			                    p(tags$b("3. Determine the agglomeration method to be used")),
		      	 selectInput("hclust_method","hclust method",c("complete","ward.D", "ward.D2", "single", "average", "mcquitty", "median","centroid"),selected ="complete"),

			       p(tags$b("you can reload this page by clicking the button below.")),
             actionButton("HC_clear","clear")
                       
      )
    )),
  mainPanel(
    h4(tags$b("Output")),
    h4('Plot:'),
    plotOutput('plot_HC'),
#    uiOutput('condi_plot'),
#    uiOutput('test'),
    h4('Input Confirm:'),
    dataTableOutput('HC_table'),
    h4('Results:'),
    verbatimTextOutput("HC_results"),
    h4('Download:'),
    downloadButton('HC_download', 'Download')
  )
)

