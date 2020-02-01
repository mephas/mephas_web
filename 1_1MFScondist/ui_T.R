#****************************************************************************************************************************************************1.5. T
sidebarLayout(
	sidebarPanel(	

	h4(tags$b("Step 1. Select the data source")),
	p("Mathematical-based, simulated-data-based, or user data-based"),	
	#Select Src
	selectInput(
	    "InputSrc_t", "Select plot",
	    c("Mathematical formula based" = "MathDist",
	      "Simulation data based" = "SimuDist",
	      "Data-based" = "DataDist")),
	hr(),
	#Select Src end	

	#condiPa 1
	  conditionalPanel(
	    condition = "input.InputSrc_t == 'MathDist'",
	    HTML("<h4><b>Step 1. Set Parameters for T(v)</h4></b>"), 
 		numericInput("t.df", HTML("v > 0, Degree of Freedom, related to the shape"), value = 4, min = 0),
		  
		  hr(),
		  h4(tags$b("Step 2. Show Probability")),   
	 		numericInput("t.pr", HTML("Area Proportion Left to Red-line = Pr.(X < x0), x0 is the position of Red-line"), value = 0.025, min = 0, max = 1, step = 0.05),
		  
		  hr(),	 		
		  p(tags$b("You can adjust x-axes range")), 
		  numericInput("t.xlim", "Range of x-asis", value = 5, min = 1)
		  #numericInput("t.ylim", "Range of y-asis, > 0", value = 0.5, min = 0.1, max = 3),
	  ),
	 #condiPa 1 end
	
	  #condiPa 2
	  conditionalPanel(
	    condition = "input.InputSrc_t == 'SimuDist'",  
        numericInput("t.size", "Sample size of simulated numbers", value = 100, min = 1, step = 1),
        sliderInput("t.bin", "The number of bins in histogram", min = 0, max = 100, value = 0),
		p("When the number of bins is 0, plot will use the default number of bins")
	    
	  ),
	  #condiPa 2 end
	  #condiPa 3
	  conditionalPanel(
	    condition = "input.InputSrc_t == 'DataDist'",  
	    
	    tabsetPanel(
	       tabPanel("Manual Input",p(br()),
			p("Data point can be separated by , ; /Enter /Tab /Space"),
    		tags$textarea(
        id = "x.t", #p
        rows = 10,
"-0.52\n-0.36\n-1.15\n-1.46\n0.54\n-1.6\n0.1\n-0.48\n-0.69\n-1.66\n0.59\n0.11\n-0.01\n0.32\n-1.31\n1.25\n-0.19\n-0.66\n0.75\n-1.86"
),
      p("Missing value is input as NA")
	     	 ), #tab1 end 
	      tabPanel("Upload Data",p(br()),
	        
	        ##-------csv file-------##
	        p(tags$b("This only reads the 1st column of your data, and will cover the input data")),

        	fileInput('t.file', "1. Choose CSV/TXT file",
                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),

        p(tags$b("2. Show 1st row as header?")),
        checkboxInput("t.header", "Show Data Header?", TRUE),
        
        p(tags$b("3. Use 1st column as row names? (No duplicates)")),
        checkboxInput("t.col", "Yes", TRUE),

        radioButtons("t.sep", 
          "4. Which Separator for Data?",
          choiceNames = list(
            HTML("Comma (,): CSV often use this"),
            HTML("One Tab (->|): TXT often use this"),
            HTML("Semicolon (;)"),
            HTML("One Space (_)")
            ),
          choiceValues = list(",", "\t", ";", " ")
          ),

        p("Correct Separator ensures data input successfully"),

        a(tags$i("Find some example data here"),href = "https://github.com/mephas/datasets")
	      ) #tab2 end 
	    ),
      sliderInput("bin.t","The number of bins in histogram", min = 0, max = 100, value = 0),
        p("When the number of bins is 0, plot will use the default number of bins")
	  )
	  #condiPa 3 end

	), #sidePa end


	mainPanel(
		h4(tags$b("Outputs")),
		
		conditionalPanel(
		  condition = "input.InputSrc_t == 'MathDist'",
		  h4("Mathematical-based Plot"),
		tags$b("T distribution plot"),
        p("The blue curve is the standard normal distribution"),

        plotOutput("t.plot", click = "plot_click3", width ="80%"),
        verbatimTextOutput("t.info"),

        p(tags$b("The position of Red-line, x0")),
        tableOutput("t")
		),
		
		conditionalPanel(
		  condition = "input.InputSrc_t == 'SimuDist'",
		   h4("Simulation-based Plot"),
		  
		tags$b("Histogram from random numbers"),
        plotly::plotlyOutput("t.plot2",  width ="80%"),#click = "plot_click4",


        #verbatimTextOutput("t.info2"),
        downloadButton("download5", "Download Random Numbers"),
        p(tags$b("Sample descriptive statistics")),
        tableOutput("t.sum")
		  
		),
		
		conditionalPanel(
		condition = "input.InputSrc_t == 'DataDist'",
		 h4("Distribution of Your Data"), 
        tags$b("Density from upload data"),
        plotly::plotlyOutput("makeplot.t2", width = "80%"),   
        tags$b("Histogram from upload data"),
        plotly::plotlyOutput("makeplot.t1", width = "80%"),

      p(tags$b("Sample descriptive statistics")),
      tableOutput("t.sum2")

		)
		
	) #main pa end	

	
	)

	

