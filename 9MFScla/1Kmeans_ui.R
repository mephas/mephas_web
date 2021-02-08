sidebarLayout(
  sidebarPanel(
    tabsetPanel(     
    tabPanel("CSV file",
             h4(tags$b("Step 1. Data Preparation")),
             
             fileInput('KM_file','1. Upload your CSV file here(with heading)',
                       accept=c(
                         'text/csv',
                         'text/comma-separated-values,text/plain',
                         '.csv')),
             
             p(tags$b("2. Choose whether you need standardized your data")),
             checkboxInput("KM_scale", "Scale", FALSE),
             p(tags$b("3. Choose the features which are used in clusting")),
             uiOutput('clu_vari_out'),
             
             h4(tags$b("Step 2. Model Fitting")),
             
             p(tags$b("1. Determine the number of clusters")),
             numericInput('KM_clusternumber', 'clusting number', 1, 2, 10,1),             
             
             conditionalPanel(condition="input.clu_vari.length > 2",
                              p(tags$b("2. Choose the Visualization method")),
                              selectInput(#
                                "to2dimension", "Visualization",
                                c("No Picture"="no_pic",
                                  "first two divisions"="two",
                                  "PCA"="pca",
                                  "T-SNE"="tsne",
                                  "UMAP"="umap"))),
#             uiOutput('plot_x'),
#             uiOutput('plot_y'),
             p(tags$b("you can reload this page by clicking the button below.")),
             actionButton("KM_clear","clear")
                       
      )
    )),
  mainPanel(
    h4(tags$b("Output")),
#    h4('Plot:'),
#    plotOutput('plot1'),
    uiOutput('condi_plot'),
#    uiOutput('test'),
    h4('Input Confirm:'),
    dataTableOutput('KM_table'),
    h4('Results:'),
    verbatimTextOutput("KM_results"),
    h4('Download:'),
    downloadButton('KM_download', 'Download')
  )
)

