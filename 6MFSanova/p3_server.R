##----------#----------#----------#----------
##
## 6MFSanova SERVER
##
##		> P3
##
## Language: EN
## 
## DT: 2019-05-04
##
##----------#----------#----------#----------
Ym <- reactive({
  inFile <- input$filem
  if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$xm, "[\n, \t, ]")))
    F1 <- unlist(strsplit(input$fm, "[\n, \t, ]"))
    Y <- data.frame(X = X, F1 = F1)
   names(Y) = unlist(strsplit(input$cnm, "[\n, \t, ]"))
    return(Y)
    }
  else {
    csv <- as.data.frame(
      read.csv(
        inFile$datapath,
        header = input$headerm,
        sep = input$sepm
        )
      )
   #names(Y) = unlist(strsplit(input$cnm, "[\n, \t, ]"))
    return(csv)
  }
})

output$tablem <- renderDataTable({Ym()}, options = list(pageLength = 5, scrollX = TRUE))


output$multiple <- renderPrint({
  x <- Ym()
  res <- pairwise.t.test(x[,names(x)[1]], x[,names(x)[2]], p.adjust.method = input$method)
  return(res)
  })


output$hsd <- renderPrint({
  x <- Ym()
  res <- TukeyHSD(aov(x[,names(x)[1]]~x[,names(x)[2]]))
  return(res)
  })