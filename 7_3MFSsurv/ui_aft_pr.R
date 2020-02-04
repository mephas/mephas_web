#****************************************************************************************************************************************************pred-aft


sidebarLayout(

sidebarPanel(
h4(tags$b("Prediction")),
p("Prepare model first"),
hr(),

h4(tags$b("Step 4. Test Set Preparation")),

tabsetPanel(

tabPanel("Example data", p(br()),

 h4(tags$b("Data: Diabetes / NKI70"))

  ),
tabPanel.upload.pr(file ="newfile", header="newheader", col="newcol", sep="newsep", quote="newquote")

),
hr(),

h4(tags$b("Step 5. If the model and new data are ready, click the blue button to generate prediction results.")),
p(br()),
actionButton("B1.1", (tags$b("Show Prediction >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
p(br()),
p(br()),
hr()

),
mainPanel(
h4(tags$b("Output 3. Prediction Results")),

#actionButton("B1.1", h4(tags$b("Click 2: Output. Prediction Results / Refresh, given model and new data are ready. ")), style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
p(br()),
tabsetPanel(
tabPanel("Prediction Table",p(br()),
DT::DTOutput("pred")
),

tabPanel("Predicted Survival Plot",p(br()),
p("The predicted survival probability of N'th observation"),

numericInput("line", HTML("Choose N'th observation (N'th row of new data)"), value = 1, min = 1),

plotly::plotlyOutput("p.s"),
DT::DTOutput("pred.n")
)
)


)


)
