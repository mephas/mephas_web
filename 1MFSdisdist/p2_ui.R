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
		  numericInput("lad", "Rate, = mean = variance", value = 2.3, min = 0, max = 10000000000, step = 1),
		  numericInput("k2", "The duration of occurrences > 0", value = 12, min = 0 , max = 1000000000),
		  p(tags$i("From the example, the rate is 2.3 and the duration of the rate is 12 months")),

		  hr(),

		  h4(tags$b("Step 2. Adjust Axes Range")), 
		  numericInput("xlim2", "Range of x-asis", value = 15, min = 1, max = 1000000000),
		  hr(),

		  h4(tags$b("Step 3. Change Observed Data")), 
		  numericInput("x0", "The observed duration of occurrences (Red-Dot)", value = 5, min = 0 , max = 1000000000),
		  p(tags$i("The observed is <= 5, and we wanted to know the cumulated probability after 5 months, which means 1 - cumulated probability of 0-5 months"))

	),

	mainPanel(
		h4(tags$b("Output. Plots")),
		plotOutput("p.plot", width = "800px", height = "400px"),
		p(tags$b("Probability at the observed number of occurrences (Red-Dot)")),
		tableOutput("p.k"),
		p(tags$i("Explanation: the probability distribution until 5 month was 0.97. Thus, the probability distribution after 6 months was about 0.03"))
    )
)
	