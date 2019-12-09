if (!require(shiny)) {install.packages("shiny")}; library(shiny)
if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2)

##----------#----------#----------#----------
##
## 1MFSdistribution SERVER
##
## Language: EN
## 
## DT: 2019-01-08
## Update: 2019-12-05
##
##----------#----------#----------#----------


###---------- 3.2 Poisson Distribution ----------

P = reactive({
x1 = ppois(0:(input$k2-1), input$lad)
x2 = ppois(1:input$k2, input$lad)
x = x2-x1
data = data.frame(x0 = c(0:length(x)), Pr.at.x0 = round(c(0, x), 6), Pr.x0.cumulated = round(c(0, x2), 6))
return(data) 
})

output$p.plot <- renderPlot({
X = P()
ggplot(X, aes(X[,"x0"],X[,"Pr.at.x0"])) + geom_step() + 
  geom_point(aes(x = X$x0[input$x0+1], y = X$Pr.at.x0[input$x0+1]),color = "red", size = 2.5) +
  stat_function(fun = dnorm, args = list(mean = input$lad, sd = sqrt(input$lad)), color = "cornflowerblue") + scale_y_continuous(breaks = NULL) + 
  xlab("") + ylab("PMF")  + theme_minimal() + ggtitle("") + xlim(-0.1, input$xlim2) })

output$p.k = renderTable({
  x <- t(P()[(input$x0+1),])
rownames(x) <- c("Red-Dot Position", "Probability of Red-Dot Position", "Cumulated Probability of Red-Dot Position")
  return(x)
  }, 
  digits = 4, colnames=FALSE, rownames=TRUE, width = "500px")