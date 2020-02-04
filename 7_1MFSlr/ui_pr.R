#****************************************************************************************************************************************************pred

sidebarLayout(

sidebarPanel(
h4(tags$b("Prediction")),
p("Prepare model first"),
hr(),

h4(tags$b("Step 4. Test Set Preparation")),

tabsetPanel(

tabPanel("Example data", p(br()),

 h4(tags$b("Data: Birth Weight"))

  ),

tabPanel.upload.pr(file ="newfile", header="newheader", col="newcol", sep="newsep", quote="newquote")

),

hr(),

h4(tags$b("Step 5. If the model and new data are ready, click the blue button to generate prediction results.")),
p(br()),
actionButton("B2", (tags$b("Show Prediction >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
p(br()),
p(br()),
hr()

),


mainPanel(
h4(tags$b("Output 3. Prediction Results")),
#actionButton("B2", h4(tags$b("Click 2: Output. Prediction Results / Refresh, given model and new data are ready. ")), style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
p(br()),
tabsetPanel(
tabPanel("Prediction",p(br()),
p("Predicted dependent variable is shown in the 1st column"),
DT::DTOutput("pred")
),

tabPanel("Evaluation Plot",p(br()),
p(tags$b("Prediction vs True Dependent Variable Plot")),
p("This plot is shown when new dependent variable is provided in the test data."),
p("This plot shows the relation between predicted dependent variable and new dependent variable, using linear smooth. Grey area is confidence interval."),
plotly::plotlyOutput("p.s")
)
)
)
)
