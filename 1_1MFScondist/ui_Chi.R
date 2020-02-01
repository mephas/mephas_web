#****************************************************************************************************************************************************1.6. chi
sidebarLayout(


	sidebarPanel(	
	h4(tags$b("Step 1. Select the data source")),
	p("Mathematical-based, simulated-data-based, or user data-based"),	
	#Select Src
	selectInput(
	    "InputSrc_x", "Select plot",
	    c("Mathematical formula based" = "MathDist",
	      "Simulation data based" = "SimuDist",
	      "Data-based" = "DataDist")),
	hr(),
	#Select Src end	

	#condiPa 1
	  conditionalPanel(
	    condition = "input.InputSrc_x == 'MathDist'",
	    HTML("<h4><b>Step 1. Set Parameters for Chi(v)</b></h4>"), 
 		numericInput("x.df", HTML("v > 0, Degree of Freedom related the the shape"), value = 4, min = 0),
		hr(),
		h4(tags$b("Step 2. Show Probability")),
		numericInput("x.pr", HTML("Area Proportion Left to Red-line = Pr.(X < x0), x0 is the position of Red-line"), value = 0.05, min = 0, max = 1, step = 0.05),
		hr(),
		p(tags$b("You can adjust x-axes range")), 
		numericInput("x.xlim", "Range of x-asis, > 0", value = 8, min = 1)
	  ),
	 #condiPa 1 end
	
	  #condiPa 2
	  conditionalPanel(
	    condition = "input.InputSrc_x == 'SimuDist'",  
        numericInput("x.size", "Sample size of simulated numbers", value = 100, min = 1, step = 1),
        sliderInput("x.bin", "The number of bins in histogram", min = 0, max = 100, value = 0),
		p("When the number of bins is 0, plot will use the default number of bins")
	    
	  ),
	  #condiPa 2 end
	  #condiPa 3
	  conditionalPanel(
	    condition = "input.InputSrc_x == 'DataDist'",  
	    tabsetPanel(
	       tabPanel("Manual Input",p(br()),
			p("Data point can be separated by , ; /Enter /Tab /Space"),
    		tags$textarea(
        	id = "x.x", #p
        	rows = 10, "11.92\n1.42\n5.56\n5.31\n1.28\n3.87\n1.31\n2.32\n3.75\n6.41\n3.04\n3.96\n1.09\n5.28\n7.88\n4.48\n1.22\n1.2\n9.06\n2.27"
			),
      		p("Missing value is input as NA")
	     ), #tab1 end 
	      
	      tabPanel("Upload Data",p(br()),
	        
	        ##-------csv file-------##
	        p(tags$b("This only reads the 1st column of your data, and will cover the input data")),
        	fileInput('x.file', "1. Choose CSV/TXT file",
                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),

        	p(tags$b("2. Show 1st row as header?")),
        	checkboxInput("x.header", "Show Data Header?", TRUE),

        	p(tags$b("3. Use 1st column as row names? (No duplicates)")),
        	checkboxInput("x.col", "Yes", TRUE),

        	radioButtons("x.sep", 
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
        sliderInput("bin.x","The number of bins in histogram", min = 0, max = 100, value = 0),
        p("When the number of bins is 0, plot will use the default number of bins")
	  )
	  #condiPa 3 end

	), #sidePa end
	

	mainPanel(
		h4(tags$b("Outputs")),
		
		conditionalPanel(
		  condition = "input.InputSrc_x == 'MathDist'",
		  h4("Mathematical-based Plot"), 
		tags$b("Chi-square distribution plot"),

        plotOutput("x.plot", click = "plot_click5", width = "80%"),
        verbatimTextOutput("x.info"),

        p(tags$b("The position of Red-line, x0")),
        tableOutput("x")
		),
		
		conditionalPanel(
		  condition = "input.InputSrc_x == 'SimuDist'",
		 h4("Simulation-based Plot"),
		  
		 tags$b("Histogram from random numbers"),
        plotly::plotlyOutput("x.plot2", width = "80%"),#click = "plot_click6", 

        p("When the number of bins is 0, plot will use the default number of bins"),
        #verbatimTextOutput("x.info2"),
        downloadButton("download6", "Download Random Numbers"),
        p(tags$b("Sample descriptive statistics")),
        tableOutput("x.sum"),
        HTML(
    " 
    <b> Explanation </b>
   <ul>
    <li>  Mean = v
    <li>  SD = sqrt(2v)
   </ul>
    "
    )
		  
		),
		
		conditionalPanel(
		condition = "input.InputSrc_x == 'DataDist'",
		 h4("Distribution of Your Data"), 
 		tags$b("Density from upload data"),
        plotly::plotlyOutput("makeplot.x2", width = "80%"),
        tags$b("Histogram from upload data"),
        plotly::plotlyOutput("makeplot.x1", width = "80%"),

        p("When the number of bins is 0, plot will use the default number of bins"),
        p(tags$b("Sample descriptive statistics")),
        tableOutput("x.sum2")

		)
		
	) #main pa end	

	
)

	
