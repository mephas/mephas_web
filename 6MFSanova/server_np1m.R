#****************************************************************************************************************************************************2-np-1way


dunntest <- eventReactive(input$M3,{
  x <- Ynp1()
  res <- dunn.test::dunn.test(x[,1], x[,2], method=input$methodnp2)
  res.table <- data.frame(Z=res$Z, P=res$P, Q=res$P.adjusted, row.names = res$comparisons)
  colnames(res.table) <- c("Kruskal-Wallis chi-squared", "P Value","Adjusted P value")
  return(res.table)
  })

output$dunntest.t <- DT::renderDT({dunntest()
    },
    #class="row-border", 
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

#output$downloadnp2.2 <- downloadHandler(
#    filename = function() {
#      "des.csv"
#    },
#    content = function(file) {
#      write.csv(dunntest(), file, row.names = TRUE)
#    }
#  )
