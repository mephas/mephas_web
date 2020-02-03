#****************************************************************************************************************************************************1.1. Normal distribution
sidebarLayout(

	sidebarPanel(	

	h4(tags$b("Step 1. Select the data source")),
	p("Mathematical-based, simulated-data-based, or user data-based"),	
	#Select Src
	selectInput(
	    "InputSrc", "Select plot",
	    c("Mathematical formula based" = "MathDist",
	      "Simulation data based" = "SimuDist",
	      "Data-based" = "DataDist")),
	hr(),
	#Select Src end
		h4(tags$b("Step 2. Set parameters")),	

	  #condiPa 1
	  conditionalPanel(
	    condition = "input.InputSrc == 'MathDist'",
	    #h3("Draw a Normal Distribution"), p(br()),

	    HTML("<b>1. Set Parameters for N(&#956, &#963)</b>"), 
	    numericInput("mu", HTML("Mean(&#956), the dashed line, indicates the location  "), value = 0, min = -10000000, max = 10000000),
	    numericInput("sigma", HTML("Standard Deviation(&#963), indicates the shape"), value = 1, min = 0, max = 10000000),
	    hr(),
	    
	    (tags$b("2. Show Probability")),   
	    numericInput("n", HTML("Blue Area = Pr(Mean-n*SD < X < Mean+n*SD)"), value = 1, min = 0, max = 10),
	    numericInput("pr", HTML("Area Proportion Left to Red-line = Pr(X < x<sub>0</sub>), x<sub>0</sub> is the position of Red-line"), value = 0.025, min = 0, max = 1, step = 0.05),
	    
	    hr(),
	    p(tags$b("You can adjust x-axes range")), 
	    numericInput("xlim", "Range of x-axis, symmetric to 0", value = 5, min = 1, max = 10000000)
	    #numericInput("ylim", "Range of y-axis > 0", value = 0.5, min = 0.1, max = 1),
	  ),
	  #condiPa 1 end
	
	  #condiPa 2
	  conditionalPanel(
	    condition = "input.InputSrc == 'SimuDist'",  
	    numericInput("size", "Sample size of simulated numbers", value = 100, min = 1),
	    sliderInput("bin", "The number of bins in histogram", min = 0, max = 100, value = 0),
	    p("When the number of bins is 0, plot will use the default number of bins")
	    
	  ),
	  #condiPa 2 end
	  
	  #condiPa 3
	  conditionalPanel(
	    condition = "input.InputSrc == 'DataDist'",  
	    
	    tabsetPanel(
	      tabPanel("Manual Input",p(br()),
	        p("Data point can be separated by , ; /Enter /Tab /Space"),
	        tags$textarea(
	          id = "x", #p
	          rows = 10,
	          "-1.8\n0.8\n-0.3\n1\n-1.2\n-0.7\n-0.7\n-0.6\n1.3\n-0.8\n-1.2\n0.6\n2.2\n0.5\n0.4\n-0.3\n0.3\n-0.2\n-1.1\n0"
	        ),
	        p("Missing value is input as NA")
	      ), 
	      tabPanel("Upload Data",p(br()),
	        
	        ##-------csv file-------##
	        p(tags$b("This only reads the 1st column of your data")),
	        fileInput('file', "1. Choose CSV/TXT file",
	                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
	        
	        p(tags$b("2. Use the 1st row as column names?")),
	        checkboxInput("header", "Yes", TRUE),
	        
	        p(tags$b("3. Use 1st column as row names? (No duplicates)")),
	        checkboxInput("col", "Yes", TRUE),
	        
	        # Input: Select separator ----
	        radioButtons("sep", 
	                     "4. Which Separator for Data?",
	                     choiceNames = list(
	                       HTML("Comma (,): CSV often use this"),
	                       HTML("One Tab (->|): TXT often use this"),
	                       HTML("Semicolon (;)"),
	                       HTML("One Space (_)")
	                     ),
	                     choiceValues = list(",", "\t", ";", " ")
	        ),
	        br(),
	        p("Correct Separator ensures data input successfully"),
	        
	        a(tags$i("Find some example data here"),href = "https://github.com/mephas/datasets")
	      )
	    ),
	    sliderInput("bin1","The number of bins in histogram", min = 0, max = 100, value = 0),
	    p("When the number of bins is 0, plot will use the default number of bins")
	  )
	  #condiPa 3 end

	), #sidePa end

	mainPanel(
		h4(tags$b("Outputs")),
		
		conditionalPanel(
		  condition = "input.InputSrc == 'MathDist'",
		  h4("Mathematical-based Plot"), 
		  #tags$b("Normal distribution plot"),
		  #plotOutput("norm.plot", click = "plot_click", width = "600px", height = "400px"), #click = "plot_click", 
		  plotOutput("norm.plot", click = "plot_click", width = "80%"), #click = "plot_click", 
		  
		  verbatimTextOutput("info"),
		  
		  p(tags$b("The position of Red-line and the Blue Ares")),
		  tableOutput("xs")
		),
		
		conditionalPanel(
		  condition = "input.InputSrc == 'SimuDist'",
		  h4("Simulation-based Plot"), 
		  tags$b("Histogram from random numbers"),
		  plotly::plotlyOutput("norm.plot2",  width = "80%"),	# click = "plot_click2",

		  #verbatimTextOutput("info2"),
		  downloadButton("download1", "Download Random Numbers"),
		  p(tags$b("Sample descriptive statistics")),
		  tableOutput("sum")
		  #verbatimTextOutput("data")
		  
		),
		
		conditionalPanel(
		  condition = "input.InputSrc == 'DataDist'",
		  h4("Distribution of Your Data"),
		  
		  tags$b("Density from upload data"),
		  plotly::plotlyOutput("makeplot.2", width = "80%"),
		  tags$b("Histogram from upload data"),
		  plotly::plotlyOutput("makeplot.1", width = "80%"),

		  p(tags$b("Sample descriptive statistics")),
		  tableOutput("sum2")
		  
		  
		)
		
	)
	)

