##----------#----------#----------#----------
##
## 1MFSdistribution UI
##
## Language: EN
## 
## DT: 2019-01-08
## Update: 2019-12-05
##
##----------#----------#----------#----------
sidebarLayout(

	sidebarPanel(	
			h4(tags$b("Draw a Poisson Distribution")), 
			hr(),
		  h4(tags$b("Step 1. Set Parameters")), 
		  numericInput("lad", "Rate", value = 5, min = 0, max = 1, step = 0.1),
		  numericInput("k2", "The number of occurrences > 0", value = 10, min = 0 , max = 1000000000),

		  hr(),

		  h4(tags$b("Step 2. Adjust Axes Range")), 
		  numericInput("xlim2", "Range of x-asis", value = 20, min = 1, max = 1000000000),
		  hr(),

		  h4(tags$b("Step 3. Change Observed Data")), 
		  numericInput("x0", "The observed number of occurrences (Red-Dot)", value = 0, min = 0 , max = 1000000000)

	),

	mainPanel(
		h4(tags$b("Output. Plots")),
		plotOutput("p.plot", width = "800px", height = "400px"),
		p(tags$b("Probability at the observed number of occurrences (Red-Dot)")),
		tableOutput("p.k"),
				  HTML(
    " 
    <b> Explanations</b>
   <ul>
   <li> Mean -> Rate
    <li> Variance -> Rate
   </ul>
    "
    )

			)
	)