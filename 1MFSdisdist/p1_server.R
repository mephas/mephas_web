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



##---------- 3. Discrete RV ----------
###----------3.1 Binomial Distribution ----------

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
  xlim(-0.1, input$xlim.b) + xlab("") + ylab("PMF")  + theme_minimal() + ggtitle("")
})

output$b.k = renderTable({
  x <- t(B()[(input$k+1),])
  rownames(x) <- c("Red-Dot Position", "Probability of Red-Dot Position", "Cumulated Probability of Red-Dot Position")
  return(x)
  }, 
  digits = 4, colnames=FALSE, rownames=TRUE, width = "500px")
