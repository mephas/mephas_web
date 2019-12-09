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

##---------- Binomial 3 ---------

sidebarLayout(

	sidebarPanel(	
			h4(tags$b("Draw a Binomial Distribution")), 
			hr(),
		  h4(tags$b("Step 1. Set Parameters")), 
			numericInput("m", "The number of trials / samples, n > 0", value = 20, min = 1 , max = 1000000000),
		  numericInput("p", "The probability of success / event, p > 0", value = 0.2, min = 0, max = 1, step = 0.1),
		  hr(),

		  h4(tags$b("Step 2. Adjust Axes Range")), 
		  numericInput("xlim.b", "Range of x-asis, > 0", value = 20, min = 1, max = 10000000),
		  hr(),


		  h4(tags$b("Step 3. Change Observed Data")), 

		  numericInput("k", "The observed number of success /event (Red-Dot)", value = 0, min =  0, max = 1000, step = 1)

	),

	mainPanel(
		h4(tags$b("Output. Plots")),
		plotOutput("b.plot", width = "800px", height = "400px"),
		p(tags$b("Probability at the observed number of success /event (Red-Dot)")),
		tableOutput("b.k"),
		  HTML(
    " 
    <b> Explanations</b>
   <ul>
   <li> Mean -> np
    <li> Variance -> np(1-p)
   </ul>
    "
    )


			)
	)
	


