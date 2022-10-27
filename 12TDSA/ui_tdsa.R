sidebarLayout(
sidebarPanel(
tags$head(tags$style("#strnum {overflow-y:scroll; max-height: 200px; background: white};")),
tags$head(tags$style("#strfac {overflow-y:scroll; max-height: 100px; background: white};"))
),
mainPanel(
    dataTableOutput("TDSAMeta"),plotOutput("TDSAMetaSROC")
)
)
