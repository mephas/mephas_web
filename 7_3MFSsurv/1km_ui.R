##----------#----------#----------#----------
##
## 7MFSreg UI
##
##    >Linear regression
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------

sidebarLayout(

sidebarPanel(

("Example data: NKI70"),      

h4(tags$b("Choose Variable")),      

uiOutput('g')

#tags$style(type='text/css', '#km {background-color: rgba(0,0,255,0.10); color: blue;}'),
#verbatimTextOutput("km", placeholder = TRUE),

),

mainPanel(

h4(tags$b("Output 1. Data Preview")),
 tabsetPanel(
 tabPanel("Browse Data",p(br()),
 p("This only shows the first several lines, please check full data in the 1st tab"),
 DT::dataTableOutput("Xdata2")
 ),
 tabPanel("Variables information",p(br()),
 verbatimTextOutput("str"),
 tags$head(tags$style("#str {overflow-y:scroll; max-height: 350px; background: white};"))
 
 )
 ),
 hr(),
 
# #h4(tags$b("Output 2. Model Results")),
actionButton("B1", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")),  style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
p(br()),
tabsetPanel(
# 
tabPanel("Kaplan-Meier Plot",  p(br()),
    plotOutput("km.p", width = "800px", height = "400px")
     )
)
# 
# tabPanel("Sensitivity and Specificity",  p(br()),
#      DT::dataTableOutput("sst"),
#     downloadButton("download111", "Download Results")
# 
#     ),
# 
# tabPanel("Fitting", p(br()),
# 
#     p(tags$b("Fitting values and residuals from the existed data")),
#     DT::dataTableOutput("fitdt0"),
#     downloadButton("download11", "Download Results")
# )
# 
# )
)
)