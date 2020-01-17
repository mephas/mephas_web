##'
##' MFSdisdist includes probability distribution of
##' (1) binomial distribution
##' and (2) Poisson distribution
##'
##' MFScondist also generates random numbers draw the distribution of user data
##'
##' @title MEPHAS: Discrete Probability Distribution (Probability)
##'
##' @return shiny interface
##'
##' @import shiny
##' @import ggplot2
##' @importFrom stats pbinom  ppois rbinom rpois
##' @importFrom utils head

##' @examples
##' # mephas::MFSdisdist()
##' ## or,
##' # library(mephas)
##' # MFSdisdist()

##' @export
MFSdisdist <- function(){

##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
ui <- tagList(

navbarPage(

title = "Discrete Probability Distribution",


##########----------##########----------##########
tabPanel("Binomial",

titlePanel("Binomial Distribution"),

HTML(
" 
<h4><b>What you can do on this page  </b></h4>
<ul>
<li> Get a plot of Binomial Distribution B(n,p); n is the total sample size, p is the probability of success / event from the total sample; np=mean, np(1-p)=variance
<li> Get the probability of a certain position (at the red point)
</ul>

<i><h4>Case Example</h4>
Suppose we wanted to know the probability of 2 lymphocytes of 10 white blood cells if the probability of any cell being a lymphocyte is 0.2</i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>

"
), 
hr(),
# source("p1_ui.R", local=TRUE)$value
#****************************************************************************************************************************************************1. binom
sidebarLayout(

	sidebarPanel(	

	tabsetPanel(

		tabPanel("Draw a Binomial Distribution", p(br()),

		  h4(tags$b("Step 1. Set Parameters")), 
			numericInput("m", "The number of trials / samples, n > 0", value = 10, min = 1 , max = 1000000000),
		  numericInput("p", "The probability of success / event, p > 0", value = 0.2, min = 0, max = 1, step = 0.1),
		  p(tags$i("From the example, we know n=10 (10 white blood cells), p=0.2 (the probability of any cell being a lymphocyte)")),

		  hr(),

		  h4(tags$b("Step 2. Change Observed Data")), 
		  numericInput("k", "The observed number of success /event (Red-Dot)", value = 2, min =  0, max = 1000, step = 1),
		  p(tags$i("The observed number is 2 lymphocytes"))
		  ),

		tabPanel("Distribution of Your Data", p(br()),

		h4(tags$b("1. Manual Input")),
		p("Data point can be separated by , ; /Enter /Tab /Space"),
    tags$textarea(
        id = "x", #p
        rows = 10,
				"3\n5\n3\n4\n6\n3\n6\n6\n5\n2\n5\n4\n5\n5\n5\n2\n6\n8\n4\n2"
				        ),
      p("Missing value is input as NA"),

      hr(),

      h4(tags$b("Or, 2. Upload Data")),

      ##-------csv file-------##
        p(tags$b("This only reads the 1st column of your data")),
        fileInput('file', "1. Choose CSV/TXT file",
                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),

        p(tags$b("2. Show 1st row as header?")),
        checkboxInput("header", "Show Data Header?", TRUE),

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

        p("Correct Separator ensures data input successfully"),

        a(tags$i("Find some example data here"),href = "https://github.com/mephas/datasets")
        )
      
		)
	),

	mainPanel(
		h4(tags$b("Output. Plots")),
		tabsetPanel(
			 tabPanel("Model-based Plot", p(br()),
			 	p(tags$b("Binomial probability plot")),
				plotOutput("b.plot", width = "80%"),
				p(tags$b("Probability at the observed number of success /event (Red-Dot)")),
				tableOutput("b.k"),
				p(tags$i("Explanation: the probability of 2 lymphocytes was about 0.03"))
				),

			 tabPanel("Simulation-based Plot", p(br()),
			 	
			 	numericInput("size", "The sample size of random numbers", value = 100, min = 1, max = 1000000, step = 1),
			 	p(tags$b("Histogram from random numbers")),
			 	plotOutput("b.plot2", width = "80%"),	

			 	sliderInput("bin", "The width of bins in histogram", min = 0, max = 2, value = 1, step=0.1),
			 	downloadButton("download1", "Download Random Numbers"),
				p(tags$b("Sample descriptive statistics")),
				tableOutput("sum")
			 	),    
			tabPanel("Distribution of Your Data", p(br()),
				p(tags$b("Histogram from upload data")),
			plotOutput("makeplot.1", width = "80%"),
      sliderInput("bin1","The width of bins in histogram",min = 0,max = 2,value = 1, step=0.1),
				p(tags$b("Sample descriptive statistics")),
				tableOutput("sum2")

			 	)
			 			 )


			)
	),
hr()

),


##########----------##########----------##########

tabPanel("Poisson",

titlePanel("Poisson Distribution"),

HTML(
" 
<h4><b>What you can do on this page  </b></h4>
<ul>
<li> Draw a plot of Poisson Distribution P(Rate); Rate indicates the expected number of occurrences; Rate = mean =variance
<li> Get the probability of a certain position (at the red point)
</ul>

<i><h4>Case Example</h4>
Suppose the number of death from typhoid fever over a 12 month period is Poisson distributed with parameter rate=2.3.
What is the probability distribution of the number of deaths over a 6-month period?</i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>

"
),
hr(),
# source("p2_ui.R", local=TRUE)$value#****************************************************************************************************************************************************2. poisson
sidebarLayout(

	sidebarPanel(	

	tabsetPanel(

		tabPanel("Draw a Binomial Distribution", p(br()),

		  h4(tags$b("Step 1. Set Parameters")), 
		  numericInput("lad", "Rate, = mean = variance", value = 2.3, min = 0, max = 10000000000, step = 1),
		  numericInput("k2", "The duration of occurrences > 0", value = 12, min = 0 , max = 1000000000),
		  p(tags$i("From the example, the rate is 2.3 and the duration of the rate is 12 months")),

		  hr(),

		  h4(tags$b("Step 2. Change Observed Data")), 
		  numericInput("x0", "The observed duration of occurrences (Red-Dot)", value = 5, min = 0 , max = 1000000000),
		  p(tags$i("The observed is <= 5, and we wanted to know the cumulated probability after 5 months, which means 1 - cumulated probability of 0-5 months"))
		  ),

	tabPanel("Distribution of Your Data", p(br()),

		h4(tags$b("1. Manual Input")),
		p("Data point can be separated by , ; /Enter /Tab /Space"),
    tags$textarea(
        id = "x.p", #p
        rows = 10,
				"1\n3\n4\n3\n3\n3\n5\n3\n2\n1\n1\n3\n2\n4\n1\n2\n5\n4\n2\n3"
				        ),
      p("Missing value is input as NA"),

      hr(),

      h4(tags$b("Or, 2. Upload Data")),
        p(tags$b("This only reads the 1st column of your data")),
        fileInput('file.p', "1. Choose CSV/TXT file",
                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),

        p(tags$b("2. Show 1st row as header?")),
        checkboxInput("header.p", "Show Data Header?", TRUE),

        p(tags$b("3. Use 1st column as row names? (No duplicates)")),
        checkboxInput("col.p", "Yes", TRUE),
        radioButtons("sep.p", 
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
        )
      
		)
	),

	mainPanel(
		h4(tags$b("Output. Plots")),
	tabsetPanel(
		tabPanel("Model-based Plot", p(br()),
			p(tags$b("Poisson probability plot")),
		plotOutput("p.plot", width = "80%"),
		p(tags$b("Probability at the observed number of occurrences (Red-Dot)")),
		tableOutput("p.k"),
		p(tags$i("Explanation: the probability distribution until 5 month was 0.97. Thus, the probability distribution after 6 months was about 0.03"))
    ),
    tabPanel("Simulation-based Plot", p(br()),
			 	
			 	numericInput("size.p", "The sample size of random numbers", value = 100, min = 1, max = 1000000, step = 1),
			 	p(tags$b("Histogram from random numbers")),
			 	plotOutput("p.plot2", width = "80%"),	

			 	sliderInput("bin.p", "The width of bins in histogram", min = 0, max = 2, value = 1, step=0.1),
			 	downloadButton("download2", "Download Random Numbers"),
				p(tags$b("Sample descriptive statistics")),
				tableOutput("sum.p")
			 	),    
		tabPanel("Distribution of Your Data", p(br()),
			p(tags$b("Histogram from upload data")),
			plotOutput("makeplot.2", width = "80%"),
      sliderInput("bin1.p","The width of bins in histogram",min = 0,max = 2,value = 1, step=0.1),
				p(tags$b("Sample descriptive statistics")),
				tableOutput("sum2.p")

			 	)
			 			 )
	)
),
hr()

),

##########----------##########----------##########
tabPanel((a("Help Pages Online",
            target = "_blank",
            style = "margin-top:-30px; color:DodgerBlue",
            href = paste0("https://mephas.github.io/helppage/")))),
tabPanel(
  tags$button(
    id = 'close',
    type = "button",
    class = "btn action-button",
    style = "margin-top:-8px; color:Tomato; background-color: #F8F8F8  ",
    onclick = "setTimeout(function(){window.close();},500);",  # close browser
    "Stop and Quit"))

))

##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########

server <- function(input, output) {

# source("p1_server.R", local=TRUE)$value
#****************************************************************************************************************************************************1. binom
B = reactive({
  x1 = pbinom(0:(input$m-1), input$m, input$p)
  x2 = pbinom(1:input$m, input$m, input$p)
  x = x2-x1
  data = data.frame(x0 = c(0:length(x)), Pr.at.x0 = round(c(0, x), 6), Pr.x0.cumulated = round(c(0, x2), 6))
  return(data) 
})

output$b.plot <- renderPlot({
X = B()
 ggplot(X, aes(X[,"x0"], X[,"Pr.at.x0"])) + geom_step() + 
  geom_point(aes(x = X$x0[input$k+1], y = X$Pr.at.x0[input$k+1]),color = "red", size = 2.5) +
  stat_function(fun = dnorm, args = list(mean = input$m*input$p, sd = sqrt(input$m*input$p*(1-input$p))), color = "cornflowerblue") + scale_y_continuous(breaks = NULL) + 
  xlab("") + ylab("PMF")  + theme_minimal() + ggtitle("")

})

output$b.k = renderTable({
  x <- t(B()[(input$k+1),])
  rownames(x) <- c("Red-Dot Position", "Probability of Red-Dot Position", "Cumulated Probability of Red-Dot Position")
  colnames(x)="Result"
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

N = reactive({ 
  df = data.frame(x = rbinom(input$size, input$m, input$p))
  return(df)})

output$b.plot2 <- renderPlot({
df = N()
ggplot(df, aes(x = x)) + 
theme_minimal() + 
ggtitle("")+
ylab("Frequency")+ 
geom_histogram(binwidth = input$bin, colour = "white", fill = "cornflowerblue", size = 1)
#geom_vline(aes(xintercept=quantile(x, probs = input$pr, na.rm = FALSE)), color="red", size=0.5)

})


output$sum = renderTable({
  x = N()[,1]
  x <- matrix(c(mean(x), sd(x)), nrow=2)
  rownames(x) <- c("Mean", "Standard Deviation")
  colnames(x)="Result"
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

output$download1 <- downloadHandler(
    filename = function() {
      "rand.csv"
    },
    content = function(file) {
      write.csv(N(), file)
    }
  )

NN <- reactive({
  inFile <- input$file
  if (is.null(inFile)) {
    x <- as.numeric(unlist(strsplit(input$x, "[\n,\t; ]")))
    validate( need(sum(!is.na(x))>1, "Please input enough valid numeric data") )
    x <- as.data.frame(x)
    }
  else {
    if(input$col){
    csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep, row.names=1)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep)
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    x <- as.data.frame(csv[,1])
    }
    colnames(x) = c("X")
    return(as.data.frame(x))
  })

output$makeplot.1 <- renderPlot({
  x = NN()
  ggplot(x, aes(x = x[,1])) + 
  geom_histogram(colour = "black", fill = "grey", binwidth = input$bin1, position = "identity") + 
  xlab("") + 
  ggtitle("") + 
  theme_minimal() + 
  theme(legend.title =element_blank())

  })

output$sum2 = renderTable({
  x = NN()[,1]
  x <- matrix(c(mean(x), sd(x)), nrow=2)
  rownames(x) <- c("Mean", "Standard Deviation")
  colnames(x)="Result"
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")


#****************************************************************************************************************************************************2. poisson
P = reactive({
x1 = ppois(0:(input$k2-1), input$lad)
x2 = ppois(1:input$k2, input$lad)
x = x2-x1
data = data.frame(x0 = c(0:length(x)), Pr.at.x0 = round(c(x1[1], x), 6), Pr.x0.cumulated = round(ppois(0:input$k2, input$lad), 6))
return(data) 
})

output$p.plot <- renderPlot({
X = P()
 ggplot(X, aes(X[,"x0"],X[,"Pr.at.x0"])) + geom_step() + 
  geom_point(aes(x = X$x0[input$x0+1], y = X$Pr.at.x0[input$x0+1]),color = "red", size = 2.5) +
  stat_function(fun = dnorm, args = list(mean = input$lad, sd = sqrt(input$lad)), color = "cornflowerblue") + scale_y_continuous(breaks = NULL) + 
  xlab("") + ylab("PMF")  + theme_minimal() + ggtitle("")
 
   })

output$p.k = renderTable({
  x <- t(P()[(input$x0+1),])
rownames(x) <- c("Red-Dot Position", "Probability of Red-Dot Position", "Cumulated Probability of Red-Dot Position")
  colnames(x)="Result"
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

N.p = reactive({ 
  df = data.frame(x = rpois(input$size.p, input$lad))
  return(df)})

output$p.plot2 <- renderPlot({
df = N.p()
ggplot(df, aes(x = x)) + 
theme_minimal() + 
ggtitle("")+
ylab("Frequency")+ 
geom_histogram(binwidth = input$bin.p, colour = "white", fill = "cornflowerblue", size = 1)
#geom_vline(aes(xintercept=quantile(x, probs = input$pr, na.rm = FALSE)), color="red", size=0.5)

})

output$sum.p = renderTable({
  x = N.p()[,1]
  x <- matrix(c(mean(x), sd(x)), nrow=2)
  rownames(x) <- c("Mean", "Standard Deviation")
  colnames(x) <-"Result"
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

output$download2 <- downloadHandler(
    filename = function() {
      "rand.csv"
    },
    content = function(file) {
      write.csv(N.p(), file)
    }
  )


NN.p <- reactive({
  inFile <- input$file.p
  if (is.null(inFile)) {
    x <- as.numeric(unlist(strsplit(input$x, "[\n,\t; ]")))
    validate( need(sum(!is.na(x))>1, "Please input enough valid numeric data") )
    x <- as.data.frame(x)
    }
  else {
    if(input$col.p){
    csv <- read.csv(inFile$datapath, header = input$header.p, sep = input$sep.p, row.names=1)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$header.p, sep = input$sep.p)
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    x <- as.data.frame(csv[,1])
    }
    colnames(x) = c("X")
    return(as.data.frame(x))
  })

output$makeplot.2 <- renderPlot({
  x = NN.p()
  ggplot(x, aes(x = x[,1])) + 
  geom_histogram(colour = "black", fill = "grey", binwidth = input$bin1.p, position = "identity") + 
  xlab("") + 
  ggtitle("") + 
  theme_minimal() + 
  theme(legend.title =element_blank())
  })

output$sum2.p = renderTable({
  x = NN.p()[,1]
  x <- matrix(c(mean(x), sd(x)), nrow=2)
  rownames(x) <- c("Mean", "Standard Deviation")
  colnames(x)<- "Result"
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })

}

##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########

app <- shinyApp(ui = ui, server = server)

runApp(app, quiet = TRUE)

}
