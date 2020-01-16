##' See https://alain003.phs.osaka-u.ac.jp/mephas_web/1MFSdistribution/
##'
##' MFSdistribution includes probability distribution of
##' (1) continuous random variable,
##' (2) derived from the normal distribution,
##' and (3) discrete randomw variable.
##'
##' Help file: https://alain003.phs.osaka-u.ac.jp/mephas/help1.html
##'
##' @title MEPHAS: Probability Distribution (Probability)
##'
##' @return The web-based GUI and interactive interfaces
##'
##' @import shiny
##' @import ggplot2
##' @importFrom stats dchisq dnorm dt pbinom pnorm ppois qchisq qexp qf qgamma qnorm qt quantile rchisq rexp rf rgamma rnorm rt sd var
##' @importFrom utils head

##' @examples
##' # mephas::MFSdistribution()
##' ## or,
##' # library(mephas)
##' # MFSdistribution()

##' @export
MFSdistribution <- function(){

## Yi
## 20190504

##########----------##########----------##########
ui <- tagList(

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
h4(tags$b("Normal Distribution (Mathematical-based)")),

hr(),
tags$b("Configuration"),
fluidRow(
column(3, numericInput("xlim", "Range of x-asis", value = 5, min = 1, max = 20)),
column(3, numericInput("ylim", "Range of y-asis", value = 0.5, min = 0.1, max = 1)),
column(3, numericInput("pr", "Area left to the line; Pr(X <= value)", value = 0.025, min = 0, max = 1, step = 0.05))),

fluidRow(
column(3, numericInput("mu", HTML("Mean (&#956) "), value = 0, min = -100, max = 100)),
column(3, numericInput("sigma", HTML("Standard Deviation (&#963)"), value = 1, min = 0.1, max = 10)),
column(3, numericInput("n", HTML("The space between N-fold SD"), value = 1, min = 0, max = 10))),
p(br()),
plotOutput("norm.plot", click = "plot_click", width = "400px", height = "300px"),
hr(),
verbatimTextOutput("info"),
p(br()),
helpText("The position of x and the area (%) in blue"),
tableOutput("xs")
),
wellPanel(

h4(tags$b("Normal Distributed Sample (Simulation)")),

hr(),
tags$b("Configuration"),

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

tags$b("Parameter"),
tags$ul(
tags$li(HTML("r: rate or the inverse scale parameter"))),

splitLayout(

wellPanel(style = "background-color: #ffffff;",
h4(tags$b("Exponential Distribution (Mathematical)")),

hr(),
tags$b("Configuration"),
fluidRow(
column(3, numericInput("e.xlim", "Range of x-asis", value = 5, min = 1, max = 10, step = 0.5)),
column(3, numericInput("e.ylim", "Range of y-asis", value = 2.5, min = 0.1, max = 3, step = 0.1)),
column(3, numericInput("e.pr", "Area left to the line", value = 0.5, min = 0, max = 1, step = 0.01))),
fluidRow(
column(5, sliderInput("r", HTML("Parameter"), min = 0, max = 10, value =1, step = 0.1))),

plotOutput("e.plot", click = "plot_click9", width = "400px", height = "300px"),
hr(),
verbatimTextOutput("e.info"),
p(br()),
helpText("The position of x"),
tableOutput("e")),
wellPanel(
h4(tags$b("Exponential Distributed Sample (Simulation)")),

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

tags$b("Notes"),
tags$ul(
tags$li(HTML("&#946=1/&#952: rate parameter")),
tags$li(HTML("mean is &#945*&#952"))
),

splitLayout(

wellPanel(style = "background-color: #ffffff;",
h4(tags$b("Gamma Distribution (Mathematical)")),

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
h4(tags$b("Gamma Distributed Sample (Simulation)")),

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
h4(tags$b("Student's t-Distribution (Mathematical)")),

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
h4(tags$b("Student's t Distributed Sample (Simulation)")),

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
h4(tags$b("Chi-square Distribution (Mathematical)")),

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
h4(tags$b("Chi-square Distributed Sample (Simulation)")),

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
h4(tags$b("F Distribution (Mathematical)")),

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
h4(tags$b("F Distributed Sample (Simulation)")),

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
h4(tags$b("Binomial Distribution")),
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
h4(tags$b("Poisson Distribution")),
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
)

##---------- other panels ----------

#source("../0tabs/home.R",local=TRUE, encoding="UTF-8")$value,
#source("../0tabs/stop.R",local=TRUE, encoding="UTF-8")$value
#stop()
,tabPanel((a("Help",
            #target = "_blank",
            style = "margin-top:-30px; color:DodgerBlue",
            href = paste0("https://alain003.phs.osaka-u.ac.jp/mephas/","help1.html"))))

))

##########----------##########----------##########
##########----------##########----------##########

server <- function(input, output) {

##########----------##########----------##########

##---------- 1. Continuous RV ----------
###---------- 1.1 Normal Distribution ----------
output$norm.plot <- renderPlot({

  mynorm = function (x) {
  norm = dnorm(x, input$mu, input$sigma)
  norm[x<=(input$mu-input$n*input$sigma) |x>=(input$mu+input$n*input$sigma)] = NA
  return(norm)
  }

  ggplot(data = data.frame(x = c(-(input$xlim), input$xlim)), aes(x)) +
  stat_function(fun = dnorm, n = 101, args = list(mean = input$mu, sd = input$sigma)) + scale_y_continuous(breaks = NULL) +
  stat_function(fun = mynorm, geom = "area", fill="cornflowerblue", alpha = 0.3) + scale_x_continuous(breaks = c(-input$xlim, input$xlim))+
  ylab("Density") + theme_bw()  + ylim(0, input$ylim) +
  geom_vline(aes(xintercept=input$mu), color="red", linetype="dashed", size=0.5) +
  geom_vline(aes(xintercept=qnorm(input$pr, mean = input$mu, sd = input$sigma, lower.tail = TRUE, log.p = FALSE)), color="red", size=0.5) })

output$info = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Position: ", "\n", xy_str(input$plot_click))})

output$xs = renderTable({
  a = qnorm(input$pr, mean = input$mu, sd = input$sigma, lower.tail = TRUE, log.p = FALSE)
  b = 100*pnorm(input$mu+input$n*input$sigma, input$mu, input$sigma)-pnorm(input$mu-input$n*input$sigma, input$mu, input$sigma)
  data.frame(x.position = a, blue.area = b)}, digits = 4)


N = reactive({ # prepare dataset
  #set.seed(1)
  df = data.frame(x = rnorm(input$size, input$mu, input$sigma))
  return(df)})

output$table1 = renderDataTable({head(N(), n = 100L)},  options = list(pageLength = 10))

output$norm.plot2 = renderPlot(
{df = N()
ggplot(df, aes(x = x)) + theme_bw() + ylab("Frequency")+ geom_histogram(binwidth = input$bin, colour = "white", fill = "cornflowerblue", size = 0.1) +
xlim(-input$xlim, input$xlim) + geom_vline(aes(xintercept=quantile(x, probs = input$pr, na.rm = FALSE)), color="red", size=0.5)})


output$sum = renderTable({
  x = N()
  data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = var(x[,1]), x.position = quantile(x[,1], probs = input$pr))
  }, digits = 4)

output$info2 = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Position: ", "\n", xy_str(input$plot_click2))})

###---------- 1.2 t Distribution ----------

output$t.plot <- renderPlot({
  ggplot(data = data.frame(x = c(-input$t.xlim, input$t.xlim)), aes(x)) +
  stat_function(fun = dt, n = 100, args = list(df = input$t.df)) +
  stat_function(fun = dnorm, args = list(mean = 0, sd = 1), color = "cornflowerblue") +
  ylab("Density") + scale_y_continuous(breaks = NULL) + theme_minimal() + ylim(0, input$t.ylim) +
  theme_bw() + geom_vline(aes(xintercept=qt(input$t.pr, df = input$t.df)), colour = "red")})

output$t.info = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Position: ", "\n", xy_str(input$plot_click3))})

output$t = renderTable({
  data.frame(x.position = qt(input$t.pr, df = input$t.df))
  }, digits = 4)

T = reactive({ # prepare dataset
 #set.seed(1)
  df = data.frame(x = rt(input$t.size, input$t.df))
  return(df)})

output$table2 = renderDataTable({head(T(), n = 100L)},  options = list(pageLength = 10))

output$t.plot2 = renderPlot(
{df = T()
ggplot(df, aes(x = x)) + theme_bw() + ylab("Frequency")+ geom_histogram(binwidth = input$t.bin, colour = "white", fill = "cornflowerblue", size = 0.1) +
xlim(-input$t.xlim, input$t.xlim) + geom_vline(aes(xintercept=quantile(x, probs = input$t.pr, na.rm = FALSE)), color="red", size=0.5)})

output$t.info2 = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Position: ", "\n", xy_str(input$plot_click4))})

output$t.sum = renderTable({
  x = T()
  data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = var(x[,1]))}, digits = 4)

###---------- 1.3 X Distribution ----------

output$x.plot <- renderPlot({
  ggplot(data = data.frame(x = c(-0.1, input$x.xlim)), aes(x)) +
  stat_function(fun = dchisq, n = 100, args = list(df = input$x.df)) + ylab("Density") +
  scale_y_continuous(breaks = NULL) + theme_minimal() + ggtitle("") + ylim(0, input$x.ylim) +
  geom_vline(aes(xintercept=qchisq(input$x.pr, df = input$x.df)), colour = "red")})

output$x.info = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Position: ", "\n", xy_str(input$plot_click5))})

output$xn = renderTable({
  data.frame(x.postion = qchisq(input$x.pr, df = input$x.df))
  }, digits = 4)

X = reactive({ # prepare dataset
  #set.seed(1)
  df = data.frame(x = rchisq(input$x.size, input$x.df))
  return(df)})

output$table3 = renderDataTable({head(X(), n = 100L)},  options = list(pageLength = 10))

output$x.plot2 = renderPlot(
{df = X()
ggplot(df, aes(x = x)) + theme_bw() + ylab("Frequency")+ geom_histogram(binwidth = input$x.bin, colour = "white", fill = "cornflowerblue", size = 0.1) +
xlim(-0.1, input$x.xlim) + geom_vline(aes(xintercept=quantile(x, probs = input$x.pr, na.rm = FALSE)), color="red", size=0.5)})

output$x.info2 = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Position: ", "\n", xy_str(input$plot_click6))})

output$x.sum = renderTable({
  x = X()
  data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = var(x[,1]))
  }, digits = 4)

##---------- 2. Derived from normal distribution ----------
###---------- 2.1 F Distribution ----------

output$f.plot <- renderPlot({
  ggplot(data = data.frame(x = c(-0.1, input$f.xlim)), aes(x)) +
  stat_function(fun = "df", n= 100, args = list(df1 = input$df11, df2 = input$df21)) + ylab("Density") +
  scale_y_continuous(breaks = NULL) + theme_minimal() + ggtitle("") + ylim(0, input$f.ylim) +
  geom_vline(aes(xintercept=qf(input$f.pr, df1 = input$df11, df2 = input$df21)), colour = "red")})

output$f.info = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Position: ", "\n", xy_str(input$plot_click7))})

output$f = renderTable({
  data.frame(x.postion = qf(input$f.pr, df1 = input$df11, df2 = input$df21))
  }, digits = 4)

F = reactive({ # prepare dataset
  #set.seed(1)
  df = data.frame(x = rf(input$f.size, input$df11, input$df21))
  return(df)})

output$table4 = renderDataTable({head(F(), n = 100L)},  options = list(pageLength = 10))

output$f.plot2 = renderPlot(
{df = F()
ggplot(df, aes(x = x)) + theme_bw() + ylab("Frequency")+ geom_histogram(binwidth = input$f.bin, colour = "white", fill = "cornflowerblue", size = 0.1) +
xlim(-0.1, input$f.xlim) + geom_vline(aes(xintercept=quantile(x, probs = input$f.pr, na.rm = FALSE)), color="red", size=0.5)})

output$f.info2 = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }

    paste0("Position: ", "\n", xy_str(input$plot_click8))})

output$f.sum = renderTable({
  x = F()
  data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = var(x[,1]))
  }, digits = 4)

###---------- 2.2. exp Distribution ----------

output$e.plot <- renderPlot({
  ggplot(data = data.frame(x = c(-0.1, input$e.xlim)), aes(x)) +
  stat_function(fun = "dexp", args = list(rate = input$r)) + ylab("Density") +
  scale_y_continuous(breaks = NULL) + theme_minimal() + ggtitle("") + ylim(0, input$e.ylim) +
  geom_vline(aes(xintercept=qexp(input$e.pr, rate = input$r)), colour = "red")})

output$e.info = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Position: ", "\n", xy_str(input$plot_click9))})

output$e = renderTable({
  data.frame(x.postion = qexp(input$e.pr, rate = input$r))
  }, digits = 4)

E = reactive({ # prepare dataset
  #set.seed(1)
  df = data.frame(x = rexp(input$e.size, rate = input$r))
  return(df)})

output$table5 = renderDataTable({head(E(), n = 100L)},  options = list(pageLength = 10))

output$e.plot2 = renderPlot(
{df = E()
ggplot(df, aes(x = x)) + theme_bw() + ylab("Frequency")+ geom_histogram(binwidth = input$e.bin, colour = "white", fill = "cornflowerblue", size = 0.1) +
xlim(-0.1, input$e.xlim) + geom_vline(aes(xintercept=quantile(x, probs = input$e.pr, na.rm = FALSE)), color="red", size=0.5)})

output$e.info2 = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }

    paste0("Position: ", "\n", xy_str(input$plot_click10))})

output$e.sum = renderTable({
  x = E()
  data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = var(x[,1]))
  }, digits = 4)

###---------- 2.3 Gamma distribution ----------

output$g.plot <- renderPlot({
  ggplot(data = data.frame(x = c(-0.1, input$g.xlim)), aes(x)) +
  stat_function(fun = "dgamma", args = list(shape = input$g.shape, scale=input$g.scale)) + ylab("Density") +
  scale_y_continuous(breaks = NULL) + theme_minimal() + ggtitle("") + ylim(0, input$g.ylim) +
  geom_vline(aes(xintercept=qgamma(input$g.pr, shape = input$g.shape, scale=input$g.scale)), colour = "red")})

output$g.info = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Position: ", "\n", xy_str(input$plot_click11))})

output$g = renderTable({
  data.frame(x.postion = qgamma(input$g.pr, shape = input$g.shape, scale=input$g.scale))
  }, digits = 4)

G = reactive({ # prepare dataset
  #set.seed(1)
  df = data.frame(x = rgamma(input$g.size, shape = input$g.shape, scale=input$g.scale))
  return(df)})

output$g.plot2 = renderPlot(
{df = G()
ggplot(df, aes(x = x)) + theme_bw() + ylab("Frequency")+ geom_histogram(binwidth = input$g.bin, colour = "white", fill = "cornflowerblue", size = 0.1) +
xlim(-0.1, input$g.xlim) + geom_vline(aes(xintercept=quantile(x, probs = input$g.pr, na.rm = FALSE)), color="red", size=0.5)})

output$g.info2 = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }

    paste0("Position: ", "\n", xy_str(input$plot_click12))})

output$g.sum = renderTable({
  x = G()
  data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = var(x[,1]))
  }, digits = 4)


##---------- 3. Discrete RV ----------
###----------3.1 Binomial Distribution ----------

B = reactive({
  x1 = pbinom(0:(input$m-1), input$m, input$p)
  x2 = pbinom(1:input$m, input$m, input$p)
  x = x2-x1
  data = data.frame(x0 = c(0:length(x)), Pr.x0 = round(c(0, x), 6), Pr.x0.lower = round(c(0, x2), 6))
  return(data)
})

output$b.plot <- renderPlot({
X = B()
ggplot(X, aes(X[,"x0"], X[,"Pr.x0"])) + geom_step() +
  geom_point(aes(x = X$x0[input$k+1], y = X$Pr.x0[input$k+1]),color = "red", size = 2.5) +
  stat_function(fun = dnorm, args = list(mean = input$m*input$p, sd = sqrt(input$m*input$p*(1-input$p))), color = "cornflowerblue") + scale_y_continuous(breaks = NULL) +
  xlim(-0.1, input$xlim.b) + xlab("") + ylab("PMF")  + theme_minimal() + ggtitle("")
})

output$bino = renderDataTable({head(B(), n = 150L)}, options = list(pageLength = 10))

output$b.k = renderTable({B()[(input$k+1),]})

###---------- 3.2 Poisson Distribution ----------

P = reactive({
x1 = ppois(0:(input$k2-1), input$lad)
x2 = ppois(1:input$k2, input$lad)
x = x2-x1
data = data.frame(x0 = c(0:length(x)), Pr.x0 = round(c(0, x), 6), Pr.x0.lower = round(c(0, x2), 6))
return(data)
})

output$p.plot <- renderPlot({
X = P()
ggplot(X, aes(X[,"x0"],X[,"Pr.x0"])) + geom_step() +
  geom_point(aes(x = X$x0[input$x0+1], y = X$Pr.x0[input$x0+1]),color = "red", size = 2.5) +
  stat_function(fun = dnorm, args = list(mean = input$lad, sd = sqrt(input$lad)), color = "cornflowerblue") + scale_y_continuous(breaks = NULL) +
  xlab("") + ylab("PMF")  + theme_minimal() + ggtitle("") + xlim(-0.1, input$xlim2) })

output$poi = renderDataTable({head(P(), n = 150L)}, options = list(pageLength = 10))

output$p.k = renderTable({P()[(input$x0+1),]})

##########----------##########----------##########

  }

##########----------##########----------##########
##########----------##########----------##########

app <- shinyApp(ui = ui, server = server)

runApp(app, quiet = TRUE)

}

