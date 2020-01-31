#****************************************************************************************************************************************************1.7. F
sidebarLayout(


	sidebarPanel(
	h4(tags$b("Step 1. Selected the data source of distribution plot")),
	p("Mathematical-based, simulated-data-based, or user data-based"),		#Select Src
	selectInput(
	    "InputSrc_f", "Select plot",
	    c("Mathematical formula based" = "MathDist",
	      "Simulation data based" = "SimuDist",
	      "Data-based" = "DataDist")),
	hr(),
	#Select Src end	

	#condiPa 1
	  conditionalPanel(
	    condition = "input.InputSrc_f == 'MathDist'",
	    HTML("<h4><b>Step 1. Set Parameters</b></h4>"), 
		numericInput("df11", HTML("df1 > 0, Degree of Freedom 1"), value = 100, min = 0),
		numericInput("df21", HTML("df2 > 0, Degree of Freedom 2"), value = 100, min = 0),
		hr(),
		h4(tags$b("Step 2. Show Probability")),   
	 	numericInput("f.pr", HTML("Area Proportion Left to Red-line = Pr.(X < x0), x0 is the position of Red-line"), value = 0.05, min = 0, max = 1, step = 0.05),
		hr(),
	 	p(tags$b("You can adjust x-axes range")), 
		numericInput("f.xlim", "Range of x-asis, > 0", value = 5, min = 1)
	  ),
	 #condiPa 1 end
	
	  #condiPa 2
	  conditionalPanel(
	    condition = "input.InputSrc_f == 'SimuDist'",  
        numericInput("f.size", "Sample size of simulated numbers", value = 100, min = 1, step = 1),
        sliderInput("f.bin", "The number of bins in histogram", min = 0, max = 100, value = 0),
        p("When the number of bins is 0, plot will use the default number of bins")
	    
	  ),
	  #condiPa 2 end
	  #condiPa 3
	  conditionalPanel(
	    condition = "input.InputSrc_f == 'DataDist'",  
	    tabsetPanel(
	       tabPanel("Manual Input",p(br()),
			p("Data point can be separated by , ; /Enter /Tab /Space"),
    		tags$textarea(
        	id = "x.f", #p
        	rows = 10, "1.08\n1.54\n0.89\n0.83\n1.13\n0.89\n1.22\n1.04\n0.71\n0.84\n1.17\n0.88\n1.05\n0.91\n1.37\n0.87\n1\n1\n1\n1.01"
			),
      		p("Missing value is input as NA")
	     ), #tab1 end 
	      
	      tabPanel("Upload Data",p(br()),
	        
	        ##-------csv file-------##
	        p(tags$b("This only reads the 1st column of your data, and will cover the input data")),
      		fileInput('f.file', "1. Choose CSV/TXT file",
                accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),

     		p(tags$b("2. Show 1st row as header?")),
     		checkboxInput("f.header", "Show Data Header?", TRUE),

     		p(tags$b("3. Use 1st column as row names? (No duplicates)")),
      		checkboxInput("f.col", "Yes", TRUE),

      		radioButtons("f.sep", "4. Which Separator for Data?",
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
        sliderInput("bin.f","The number of bins in histogram", min = 0, max = 100, value = 0),
        p("When the number of bins is 0, plot will use the default number of bins")
	  )
	  #condiPa 3 end

	), #sidePa end
	

mainPanel(
		h4(tags$b("Outputs")),
		
		conditionalPanel(
		  condition = "input.InputSrc_f == 'MathDist'",
		  h4("Mathematical-based Plot"),
		tags$b("F distribution plot"),

        plotOutput("f.plot", click = "plot_click7", width = "80%"),
        verbatimTextOutput("f.info"),

        p(tags$b("The position of Red-line, x0")),
        tableOutput("f")
		),
		
		conditionalPanel(
		  condition = "input.InputSrc_f == 'SimuDist'",
		   h4("Simulation-based Plot"), 
		  
		tags$b("Histogram from random numbers"),
        plotly::plotlyOutput("f.plot2", width = "80%"),#click = "plot_click8", 

        #verbatimTextOutput("f.info2"),
        downloadButton("download7", "Download Random Numbers"),
        p(tags$b("Sample descriptive statistics")),
        tableOutput("f.sum")
		  
		),
		
		conditionalPanel(
		condition = "input.InputSrc_f == 'DataDist'",
	 h4("Distribution of Your Data"), 
 		tags$b("Density from upload data"),
        plotly::plotlyOutput("makeplot.f2", width = "80%"),
        tags$b("Histogram from upload data"),
        plotly::plotlyOutput("makeplot.f1", width = "80%"),

        p(tags$b("Sample descriptive statistics")),
        tableOutput("f.sum2")

		)
		
	) #main pa end	

	
)

	
