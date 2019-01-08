##----------#----------#----------#----------
##
## 1MFSdistribution UI
##
## Language: EN
## 
## DT: 2019-01-08
##
##----------#----------#----------#----------

shinyUI(
  
tagList(
#shinythemes::themeSelector(),
navbarPage(
  
  title = "Probability Distributions",

##---------- Panel 1 ---------

tabPanel("Continuous Random Variable",

###---------- 1.1 ---------

titlePanel("Normal Distribution (Gaussian Distribution)"),

tags$b("Parameters"), 
tags$ul(
  tags$li(HTML("&#956: mean indicates the location")),
  tags$li(HTML("&#963: standard deviation (SD) indicates the variation"))
  ),

splitLayout(

  wellPanel(style = "background-color: #ffffff;",
    h3("Normal Distribution (Mathematical-based)"),

    hr(),
    tags$b("Configurations"),
    fluidRow(
      column(3, numericInput("xlim", "Range of x-asis", value = 5, min = 1, max = 20)),
      column(3, numericInput("ylim", "Range of y-asis", value = 0.5, min = 0.1, max = 1)),
      column(3, numericInput("pr", "Area left to the line; Pr(X <= value)", value = 0.025, min = 0, max = 1, step = 0.05))),

    fluidRow(
      column(3, numericInput("mu", HTML("Mean (&#956): "), value = 0, min = -100, max = 100)),
      column(3, numericInput("sigma", HTML("Standard Deviation (&#963):"), value = 1, min = 0.1, max = 10)),
      column(3, numericInput("n", HTML("The space between N-fold SD:"), value = 1, min = 0, max = 10))),
    p(br()),
    plotOutput("norm.plot", click = "plot_click", width = "400px", height = "300px"),
    hr(),  
    verbatimTextOutput("info"),
    p(br()),
    helpText("The position of x and the area (%) in blue"),
    tableOutput("xs")
    ),
  wellPanel(

    h3("Normal Distributed Sample (Simulation)"),

    hr(),
    tags$b("Configurations"),

    fluidRow(
      column(3, numericInput("bin", "Binwidth of histogram", value = 0.1, min = 0.01, max = 5, step = 0.1))),
    fluidRow(
      column(6, sliderInput("size", "Sample size", min = 0, max = 10000, value = 1000))),

    plotOutput("norm.plot2", click = "plot_click2", width = "400px", height = "300px"),

    hr(),
    verbatimTextOutput("info2"),
    p(br()),
    helpText("Sample mean and standard deviation"),
    tableOutput("sum"),
    verbatimTextOutput("data")
    #>tags$b("The first 100 simulated values"),
    #>dataTableOutput("table1")
    )
  ),

###---------- 1.2 ---------

titlePanel("Exponential Distribution"),

tags$b("Parameters"), 
tags$ul(
  tags$li(HTML("r: rate or the inverse scale parameter"))),

splitLayout(

  wellPanel(style = "background-color: #ffffff;",
    h3("Exponential Distribution (Mathematical)"),
    
    hr(),
    tags$b("Configuration"),
    fluidRow(
      column(3, numericInput("e.xlim", "Range of x-asis", value = 5, min = 1, max = 10, step = 0.5)),
      column(3, numericInput("e.ylim", "Range of y-asis", value = 2.5, min = 0.1, max = 3, step = 0.1)),
      column(3, numericInput("e.pr", "Area left to the line", value = 0.5, min = 0, max = 1, step = 0.01))),
    fluidRow(
      column(5, sliderInput("r", HTML("parameter"), min = 0, max = 10, value =1, step = 0.1))),

    plotOutput("e.plot", click = "plot_click9", width = "400px", height = "300px"),
    hr(),
    verbatimTextOutput("e.info"),
    p(br()),
    helpText("The position of x"),
    tableOutput("e")),
  wellPanel(
    h3("Exponential Distributed Sample (Simulation)"),

    hr(),
    tags$b("Configuration"),
    
    fluidRow(
      column(3, numericInput("e.bin", "Binwidth of histogram", value = 0.1, min = 0.01, max = 5, step = 0.1))),

    fluidRow(
      column(6, sliderInput("e.size", "Sample size", min = 0, max = 10000, value = 1000))),
    
    plotOutput("e.plot2", click = "plot_click10", width = "400px", height = "300px"),
    hr(),
    verbatimTextOutput("e.info2"),
    p(br()),
    helpText("Sample mean and standard deviation"),
    tableOutput("e.sum")
    #>tags$b("The first 100 simulated values"),
    #>dataTableOutput("table5")
    )
  ),

###---------- 1.3 ---------

titlePanel("Gamma Distribution"),
tags$b("Parameters"), 
tags$ul(
  tags$li(HTML("&#945: shape parameter")),
  tags$li(HTML("&#952: scale parameter"))
  ),
hr(),
tags$b("Notes"), 
tags$ul(
  tags$li(HTML("&#946=1/&#952: rate parameter")),
  tags$li(HTML("mean is &#945*&#952"))
  ),

splitLayout(

  wellPanel(style = "background-color: #ffffff;",
    h3("Gamma Distribution (Mathematical)"),
    
    hr(),
    tags$b("Configuration"),
    fluidRow(
      column(3, numericInput("g.xlim", "Range of x-asis", value = 5, min = 1, max = 20, step = 0.5)),
      column(3, numericInput("g.ylim", "Range of y-asis", value = 0.5, min = 0, max = 1.5, step = 0.1)),
      column(3, numericInput("g.pr", "Area left to the line", value = 0.5, min = 0, max = 1, step = 0.01))),
    fluidRow(
      column(5, sliderInput("g.shape", HTML("&#945, shape"), min = 0, max = 10, value =0.5, step = 0.1)),
      column(5, sliderInput("g.scale", HTML("&#952, scale"), min = 0, max = 10, value =1, step = 0.1))),

    plotOutput("g.plot", click = "plot_click11", width = "400px", height = "300px"),
    hr(),
    verbatimTextOutput("g.info"),
    p(br()),
    helpText("The position of x"),
    tableOutput("g")),

  wellPanel(
    h3("Gamma Distributed Sample (Simulation)"),

    hr(),
    tags$b("Configuration"),
    
    fluidRow(
      column(3, numericInput("g.bin", "Bin-width of histogram", value = 0.1, min = 0.01, max = 5, step = 0.1))),

    fluidRow(
      column(6, sliderInput("g.size", "Sample size", min = 0, max = 10000, value = 1000))),
    
    plotOutput("g.plot2", click = "plot_click12", width = "400px", height = "300px"),
    hr(),
    verbatimTextOutput("g.info2"),
    p(br()),
    helpText("Sample mean and standard deviation"),
    tableOutput("g.sum")
    #>tags$b("The first 100 simulated values"),
    #>dataTableOutput("table5")
    )
)
),


##---------- Panel 2 ---------

tabPanel("Derived from the Normal Distribution",

###---------- 2.1 ---------

titlePanel("Student's t-Distribution"),

tags$b("Parameter"), 
tags$ul(
  tags$li(HTML("v: degree of freedom, the greater v"))
  ),

tags$b("Note"),
tags$ul(
  tags$li(HTML("When v is extremely great, t-distribution approximates to standard normal distribution"))), 

splitLayout(
  wellPanel(style = "background-color: #ffffff;",
    h3("Student's t-Distribution (Mathematical)"),

    hr(),
    tags$b("Configuration"),
    fluidRow(
      column(3, numericInput("t.xlim", "Range of x-asis", value = 5, min = 1, max = 10, step = 0.5)),
      column(3, numericInput("t.ylim", "Range of y-asis", value = 0.5, min = 0.1, max = 1, step = 0.1)),
      column(3, numericInput("t.pr", "Area left to the line", value = 0.025, min = 0, max = 1, step = 0.01))),
    sliderInput("t.df", HTML("Degree of freedom (v):"), min = 0.01, max = 50, value =4, width ="50%"),
    
    plotOutput("t.plot", click = "plot_click3", width = "400px", height = "300px"),
    hr(),
    verbatimTextOutput("t.info"),
    p(br()),
    helpText("The position of x (The blue curve is standard normal distribution)"),
    tableOutput("t")),
  wellPanel(
    h3("Student's t Distributed Sample (Simulation)"),

    hr(),
    tags$b("Configuration"),
    fluidRow(
      column(3, numericInput("t.bin", "Binwidth of histogram", value = 0.1, min = 0.01, max = 5, step = 0.1))),
    fluidRow(
      column(6, sliderInput("t.size", "Sample size", min = 0, max = 10000, value = 1000))),

    plotOutput("t.plot2", click = "plot_click4", width = "400px", height = "300px"),      
    hr(),
    verbatimTextOutput("t.info2"),
    p(br()),
    helpText("Sample mean and standard deviation"),
    tableOutput("t.sum")
    #>tags$b("The first 100 simulated values"),
    #>dataTableOutput("table2")
    )
  ),

###---------- 2.2 ---------

titlePanel("Chi-square Distribution"),

tags$b("Parameters"), 
tags$ul(
  tags$li(HTML("v: degree of freedom"))),

tags$b("Note"),
tags$ul(
  tags$li(HTML("mean = v; variance = 2v"))),

splitLayout(
  wellPanel(style = "background-color: #ffffff;",
    h3("Chi-square Distribution (Mathematical)"),
   
    hr(),
    tags$b("Configuration"),
    fluidRow(
      column(3, numericInput("x.xlim", "Range of x-asis", value = 5, min = 1, max = 10, step = 0.5)),
      column(3, numericInput("x.ylim", "Range of y-asis", value = 0.75, min = 0.1, max = 1, step = 0.1)),
      column(3, numericInput("x.pr", "Area left to the line", value = 0.5, min = 0, max = 1, step = 0.01))),
    fluidRow(
      column(6, sliderInput("x.df", HTML("Degree of freedom (v):"), min = 0, max = 10, value =1))),
    
    plotOutput("x.plot", click = "plot_click5", width = "400px", height = "300px"),
    hr(),
    verbatimTextOutput("x.info"),
    p(br()),
    helpText("The position of x"),
    tableOutput("xn")),
  wellPanel(
    h3("Chi-square Distributed Sample (Simulation)"),

    hr(),
    tags$b("Configuration"),
    fluidRow(
      column(3, numericInput("x.bin", "Binwidth of histogram", value = 0.1, min = 0.01, max = 5, step = 0.1))),
    fluidRow(
      column(6, sliderInput("x.size", "Sample size", min = 0, max = 10000, value = 1000))),
   
    plotOutput("x.plot2", click = "plot_click6", width = "400px", height = "300px"),
    hr(),    
    verbatimTextOutput("x.info2"),
    p(br()),
    helpText("Sample mean and standard deviation"),
    tableOutput("x.sum")
    #>tags$b("The first 100 simulated values"),
    #>dataTableOutput("table3")
    )
  ),

###---------- 2.3 ---------

titlePanel("F Distribution"),

tags$b("Parameters"), 
tags$ul(
  tags$li(HTML("u: the first degree of freedom")),
  tags$li(HTML("v: the second degree of freedom"))),

splitLayout(
  wellPanel(style = "background-color: #ffffff;",
    h3("F Distribution (Mathematical)"),
    
    hr(),
    tags$b("Configuration"),
    fluidRow(
      column(3, numericInput("f.xlim", "Range of x-asis", value = 5, min = 1, max = 10, step = 0.5)),
      column(3, numericInput("f.ylim", "Range of y-asis", value = 2.5, min = 0.1, max = 3, step = 0.1)),
      column(3, numericInput("f.pr", "Area left to the line", value = 0.5, min = 0, max = 1, step = 0.01))),
    fluidRow(
      column(5, sliderInput("df11", HTML("The first degree of freedom (u):"), min = 0, max = 200, value =100)),
      column(5, sliderInput("df21", HTML("The second degree of freedom (v):"), min =0, max = 200, value =100))),

    plotOutput("f.plot", click = "plot_click7", width = "400px", height = "300px"),
    hr(),
    verbatimTextOutput("f.info"),
    p(br()),
    helpText("The position of x"),
    tableOutput("f")),
  wellPanel(
    h3("F Distributed Sample (Simulation)"),

    hr(),
    tags$b("Configuration"),
    
    fluidRow(
      column(3, numericInput("f.bin", "Binwidth of histogram", value = 0.1, min = 0.01, max = 5, step = 0.1))),

    fluidRow(
      column(6, sliderInput("f.size", "Sample size", min = 0, max = 10000, value = 1000))),
    
    plotOutput("f.plot2", click = "plot_click8", width = "400px", height = "300px"),
    hr(),   
    verbatimTextOutput("f.info2"),
    p(br()),
    helpText("Sample mean and standard deviation"),
    tableOutput("f.sum")
    #>tags$b("The first 100 simulated values"),
    #>dataTableOutput("table4")
    )
  )
),

##---------- Panel 3 ---------

tabPanel("Discrete Random Variable",

titlePanel("Binomial Distribution, Poisson Distribution"),

tags$b("Notes"),

tags$ul(
  tags$li("The blue curve shows the normal approximation"),
  tags$li("Binomial distribution has mean = np and var = npq"),
  tags$li("Poisson distribution has mean = var = parameter")
  ),

splitLayout(

###---------- 3.1 ---------

  wellPanel(style = "background-color: #ffffff;",
    h3("Binomial Distribution"),
    hr(),
    tags$b("Configuration"),

    fluidRow(
      column(3, numericInput("m", "The number of trials", value = 10, min = 1 , max = 1000)),
      column(3, numericInput("p", "The probability of success", value = 0.5, min = 0, max = 1, step = 0.1)),
      column(3, numericInput("xlim.b", "Range of x-asis", value = 20, min = 1, max = 100)),
      column(3, numericInput("k", "The number of success (x0)", value = 0, min =  0, max = 1000))),

    hr(),  
    plotOutput("b.plot", width = "400px", height = "400px"),
    helpText("The probability of X=x0 is"),
    tableOutput("b.k")
    #>dataTableOutput("bino")
    ),

###---------- 3.2 ---------

  wellPanel(style = "background-color: #ffffff;",
    h3("Poisson Distribution"),
    hr(),
    tags$b("Configuration"),

    fluidRow(
      column(3, numericInput("k2", "The number of meet", value = 10, min =  0, max = 1000)),
      column(3, numericInput("lad", "Parameter", value = 5, min = 0, max = 1000)),
      column(3, numericInput("x0", "X = x0", value = 0, min =  0, max = 1000)),
      column(3, numericInput("xlim2", "Range of x-asis", value = 20, min = 1, max = 100))),

    hr(),  
    plotOutput("p.plot", width = "400px", height = "400px"),
    helpText("The probability of X=x0 is"),
    tableOutput("p.k")
    #>dataTableOutput("poi")
    )
  )
),

tabPanel((a("Homepage",
 style = "margin-top:-30px;",
 href = paste0("https://pharmacometrics.info/mephas/")))
 #you can input subfolder and file name in the second ""

 )


#  tabPanel(
 #     tags$button(
  #    id = 'close',
   #   type = "button",
    #  #class = "btn action-button",
     # onclick = "setTimeout(function(){window.close();},500);",  # close browser
      #"Stop App")
#)


))
)



