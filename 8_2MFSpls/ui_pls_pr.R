#****************************************************************************************************************************************************pls-pred

sidebarLayout(

sidebarPanel(

h4(tags$b("Prediction")),
p("Prepare model first"),
hr(),

h4(tags$b("Step 3. Test Set Preparation")),
tabsetPanel(

tabPanel("Example data", p(br()),

 h4(tags$b("Data: NKI"))

  ),

tabPanel.upload.pr(file ="newfile.pls", header="newheader.pls", col="newcol.pls", sep="newsep.pls", quote="newquote.pls")

),

hr(),

h4(tags$b("Step 4. If the model and new data are ready, click the blue button to generate prediction results.")),

#actionButton("B.pls", (tags$b("Show Prediction >>")),class="btn btn-primary",icon=icon("bar-chart-o"))
p(br()),
actionButton("B.pls", (tags$b("Show Prediction >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
p(br()),
p(br()),
hr()

),


mainPanel(

h4(tags$b("Output. Model Results")),

tabsetPanel(
tabPanel("Predicted dependent variables",p(br()),

DT::DTOutput("pred.lp.pls")
),

tabPanel("Predicted Components",p(br()),
DT::DTOutput("pred.comp.pls")
),
tabPanel("Test Data",p(br()),
DT::DTOutput("newX.pls")
)
)
)
)
