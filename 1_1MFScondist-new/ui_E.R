# ****************************************************************************************************************************************************1.2.
# Exp distribution
sidebarLayout(

	sidebarPanel(

  h4(tags$b("Step 1. Select the data source")),
  p("Mathematical-based, simulated-data-based, or user data-based"),
	  #Select Src
	  selectInput(
	    "InputSrc_e", "Select plot",
      c("Mathematical formula based" = "MathDist",
        "Simulation data based" = "SimuDist")),
	  hr(),
	  #Select Src end
	 h4(tags$b("Step 2. Set parameters")),
	  #condiPa 1
	  conditionalPanel(
	    condition = "input.InputSrc_e == 'MathDist'",
	    #"Draw an Exponential Distribution", p(br()),
      HTML("<b>Set Parameters for E(Rate)</b></h4>"),
	    numericInput("r", HTML(" Rate (> 0) indicates the rate of change, input rate"), value = 2, min = 0),
      hr(),
      numericInput("e.mean", HTML("Or. Calculate Rate from Mean and SD (Mean = SD), input mean"), value = 0.5, min = 0),
      verbatimTextOutput("e.rate"),
      p("Mean = SD = 1/Rate"),
	    hr(),

	    numericInput("e.xlim", "2. Change the range of x-axis > 0", value = 5, min = 1)

	  ),
	  #condiPa 2
	  conditionalPanel(
	    condition = "input.InputSrc_e == 'SimuDist'",
	    numericInput("e.size", "Sample size of simulated numbers", value = 100, min = 1,step = 1),
	    sliderInput("e.bin", "The number of bins in histogram", min = 0, max = 100, value = 0),
	    p("When the number of bins is 0, plot will use the default number of bins")
	  ),
	  #condiPa 2 end

    hr(),
    h4(tags$b("Step 3. Show Probability")),
    numericInput("e.pr", HTML("Area Proportion Left to Red-line = Pr(X < x<sub>0</sub>), x<sub>0</sub> is the position of Red-line"), value = 0.05, min = 0, max = 1, step = 0.05),
    hr()
	), #sidePa end

  	mainPanel(
  		h4(tags$b("Outputs")),

  		conditionalPanel(
  		  condition = "input.InputSrc_e == 'MathDist'",
  		  h4("Mathematical-based Plot"),
  		  tags$b("Exponential distribution plot"),
  		  plotOutput("e.plot", click = "plot_click9"),#
  		  verbatimTextOutput("e.info"),
        p(br()),
        p(tags$b("The position of red line")),
  		  #p(tags$b("The position of Red-line, x<sub>0</sub>")),
  		  #verbatimTextOutput("e"),
      hr(),
      plotly::plotlyOutput("e.plot.cdf")        
  		),
  		conditionalPanel(
  		  condition = "input.InputSrc_e == 'SimuDist'",
  		 h4("Simulation-based Plot"),
  		  tags$b("Histogram from random numbers"),
  		  plotly::plotlyOutput("e.plot2"),#click = "plot_click10",
  		  #verbatimTextOutput("e.info2"),
  		  downloadButton("download2", "Download Random Numbers"),

  		  p(tags$b("Sample descriptive statistics")),
  		  tableOutput("e.sum")
  		)



	)
)

