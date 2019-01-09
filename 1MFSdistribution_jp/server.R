if (!require(shiny)) {install.packages("shiny")}; library(shiny)
if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2)

##----------#----------#----------#----------
##
## 1MFSdistribution SERVER
##
## Language: JP
## 
## DT: 2019-01-08
##
##----------#----------#----------#----------

shinyServer(

function(input, output) {

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


observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })

}


)

