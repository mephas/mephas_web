sidebarLayout(
sidebarPanel(
tags$head(tags$style("#strnum {overflow-y:scroll; max-height: 200px; background: white};")),
tags$head(tags$style("#strfac {overflow-y:scroll; max-height: 100px; background: white};")),
h4(tags$b("Step 4. Set Probability")),
aceEditor(
  outputId = "prob",
  value = "1,0.8,0.6",
  mode = "r",
  theme = "chrome",
  fontSize=20,
  height = "50px"
),
verbatimTextOutput("probability")


),
mainPanel(
    dataTableOutput("TDSAMeta"),plotOutput("TDSAMetaSROC")
)
)
