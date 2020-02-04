#****************************************************************************************************************************************************1.2. Exp distribution
sidebarLayout(

	sidebarPanel(

  h4(tags$b("Step 1. Select the data source")),
  p("Mathematical-based, simulated-data-based, or user data-based"),
	  #Select Src
	  selectInput(
	    "InputSrc_e", "Select plot",
      c("Mathematical formula based" = "MathDist",
        "Simulation data based" = "SimuDist",
        "Data-based" = "DataDist")),
	  hr(),
	  #Select Src end
	 h4(tags$b("Step 2. Set parameters")),
	  #condiPa 1
	  conditionalPanel(
	    condition = "input.InputSrc_e == 'MathDist'",
	    #"Draw an Exponential Distribution", p(br()),
      HTML("<b>1. Set Parameters for E(Rate)</b></h4>"),
	    numericInput("r", HTML("Rate (> 0) indicates the rate of change"), value = 2, min = 0),
	    hr(),

	    h4(tags$b("2. Show Probability")),
	    numericInput("e.pr", HTML("Area Proportion Left to Red-line = Pr(X < x<sub>0</sub>), x<sub>0</sub> is the position of Red-line"), value = 0.05, min = 0, max = 1, step = 0.05),

      hr(),
	    p(tags$b("You can adjust x-axes range")),
	    numericInput("e.xlim", "Range of x-axis > 0", value = 5, min = 1)

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
      	        tags$textarea(
      	          id = "x.e", #p
      	          rows = 10,
      	          "2.6\n0.5\n0.8\n2.3\n0.3\n2\n0.5\n4.4\n0.1\n1.1\n0.7\n0.2\n0.7\n0.6\n3.7\n0.3\n0.1\n1\n2.6\n1.3"
      	        ),
      	        p("Missing value is input as NA")
      	        ),
      	      tabPanel.upload.num(file ="e.file", header="e.header", col="e.col", sep="e.sep")

      	      # tabPanel("Upload Data",p(br()),
      	      #   ##-------csv file-------##
      	      #   p(tags$b("This only reads the 1st column of your data, and will cover the input data")),
      	      #   fileInput('e.file', "1. Choose CSV/TXT file",
      	      #             accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
      	      #
      	      #   p(tags$b("2. Use 1st row as column names?")),
      	      #   checkboxInput("e.header", "Yes", TRUE),
      	      #
      	      #   p(tags$b("3. Use 1st column as row names? (No duplicates)")),
      	      #   checkboxInput("e.col", "Yes", TRUE),
      	      #   radioButtons("e.sep",
      	      #                "3. Which Separator for Data?",
      	      #                choiceNames = list(
      	      #                  HTML("Comma (,): CSV often use this"),
      	      #                  HTML("One Tab (->|): TXT often use this"),
      	      #                  HTML("Semicolon (;)"),
      	      #                  HTML("One Space (_)")
      	      #                ),
      	      #                choiceValues = list(",", "\t", ";", " ")
      	      #   ),
      	      #   p("Correct Separator ensures data input successfully"),
      	      #   a(tags$i("Find some example data here"),href = "https://github.com/mephas/datasets")
      	      # )

	     ),
	    sliderInput("bin.e", "The number of bins in histogram", min = 0, max = 100, value = 0),
	    p("When the number of bins is 0, plot will use the default number of bins")
	  ) #condiPa 3 end
	), #sidePa end

  	mainPanel(
  		h4(tags$b("Outputs")),

  		conditionalPanel(
  		  condition = "input.InputSrc_e == 'MathDist'",
  		  h4("Mathematical-based Plot"),
  		  tags$b("Exponential distribution plot"),
  		  plotOutput("e.plot", click = "plot_click9", width = "80%"),#
  		  verbatimTextOutput("e.info"),
  		  p(tags$b("The position of Red-line, x<sub>0</sub>")),
  		  tableOutput("e")
  		),
  		conditionalPanel(
  		  condition = "input.InputSrc_e == 'SimuDist'",
  		 h4("Simulation-based Plot"),
  		  tags$b("Histogram from random numbers"),
  		  plotly::plotlyOutput("e.plot2",  width = "80%"),#click = "plot_click10",
  		  #verbatimTextOutput("e.info2"),
  		  downloadButton("download2", "Download Random Numbers"),

  		  p(tags$b("Sample descriptive statistics")),
  		  tableOutput("e.sum"),
  		  HTML(
  		    "
			    <b> Explanation </b>
			   <ul>
			    <li>  Mean = 1/Rate </li>
			    <li>  SD = 1/Rate </li>
			   </ul>
			    "
  		  )
  		),

  		conditionalPanel(
  		  condition = "input.InputSrc_e == 'DataDist'",
        tags$b("Data preview"),
        DT::DTOutput("Y"),
  		  h4("Distribution of Your Data"),
  		  tags$b("Density from upload data"),
  		  plotly::plotlyOutput("makeplot.e2", width = "80%"),
  		  tags$b("Histogram from upload data"),
  		  plotly::plotlyOutput("makeplot.e1", width = "80%"),
  		  p(tags$b("Sample descriptive statistics")),
  		  tableOutput("e.sum2")

  		)



	)
)

