#****************************************************************************************************************************************************1.2. Exp distribution
sidebarLayout(

	sidebarPanel(

  h4(tags$b("第1步  选择数据源")),
  p("Mathematical-based, simulated-data-based, or user data-based"),
	  #Select Src
	  selectInput(
	    "InputSrc_e", "Select plot",
      c("Mathematical formula based" = "MathDist",
        "Simulation data based" = "SimuDist",
        "Upload data based" = "DataDist")),
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

	  #condiPa 3
	  conditionalPanel(
	    condition = "input.InputSrc_e == 'DataDist'",

	    tabsetPanel(
      	      tabPanel("Manual Input",p(br()),
    p("Data point can be separated by , ; /Enter /Tab /Space"),
    p(tags$b("Data be copied from CSV (one column) and pasted in the box")),      	        
    tags$textarea(
      	          id = "x.e", #p
      	          rows = 10,
      	          "2.6\n0.5\n0.8\n2.3\n0.3\n2\n0.5\n4.4\n0.1\n1.1\n0.7\n0.2\n0.7\n0.6\n3.7\n0.3\n0.1\n1\n2.6\n1.3"
      	        ),
      	        p("Missing value is input as NA")
      	        ),
      	      tabPanel.upload.num(file ="e.file", header="e.header", col="e.col", sep="e.sep")

	     ),
	    sliderInput("bin.e", "The number of bins in histogram", min = 0, max = 100, value = 0),
	    p("When the number of bins is 0, plot will use the default number of bins")
	  ), #condiPa 3 end
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
  		),

  		conditionalPanel(
  		  condition = "input.InputSrc_e == 'DataDist'",
        tags$b("Data preview"),
        DT::DTOutput("Y"),
  		  h4("Distribution of Your Data"),
  		  tags$b("Density from upload data"),
  		  plotly::plotlyOutput("makeplot.e2"),
  		  tags$b("Histogram from upload data"),
  		  plotly::plotlyOutput("makeplot.e1"),
        tags$b("CDF from upload data"),
        plotly::plotlyOutput("makeplot.e3"),
  		  p(tags$b("Sample descriptive statistics")),
  		  tableOutput("e.sum2")

  		)



	)
)

