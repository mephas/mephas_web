sidebarLayout(
	sidebarPanel(width=3,
    tags$head(tags$style("#strnum {overflow-y:scroll; max-height: 200px; background: white};")),
    tags$head(tags$style("#strfac {overflow-y:scroll; max-height: 100px; background: white};")),
    ),
    mainPanel(
        tabsetPanel(id="Funnel_Panel",
            tabPanel("Funnel plot",
                p(plotOutput("ml.lnDOR_funnel",width=500),downloadButton("mo"),downloadButton("momof")),plotOutput("logit.Sens_plot",width=500),plotOutput("logit.Spec_plot",width=500)
                )
        )
    )
    
)