 
if (!require(shiny)) {install.packages("shiny")}; library(shiny)
if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2)
if (!require(psych)) {install.packages("psych")}; library(psych)
if (!require(Rmisc)) {install.packages("Rmisc")}; library(Rmisc)
##----------#----------#----------#----------
##
## 6MFSanova SERVER
##
## Language: JP
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------

shinyServer(

function(input, output) {

##---------- 1.One way ANOVA ----------
Y1 <- reactive({
  inFile <- input$file1
  if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$x1, "[\n, \t, ]")))
    F1 <- unlist(strsplit(input$f11, "[\n, \t, ]"))
    Y <- data.frame(X = X, F1 = F1)
    names(Y) = unlist(strsplit(input$cn1, "[\n, \t, ]"))
    return(Y)
    }
  else {
    csv <- as.data.frame(
      read.csv(
        inFile$datapath,
        header = input$header1,
        sep = input$sep1
        )
      )
    return(csv)
  }
})

output$table1 <- renderDataTable({Y1()}, options = list(pageLength = 5))

output$bas1 <- renderPrint({
  x <- Y1()
  res <- describeBy(x[,1], x[,2])
  return(res)
  })



output$mmean1 = renderPlot({
  x = Y1()
  b = Rmisc::summarySE(x,names(x)[1], names(x)[2])

  
  ggplot(b, aes(x=b[,1], y=b[,3], fill=b[,1])) + 
    geom_bar(stat="identity", position = "dodge")+ xlab("") +ylab("")+
    geom_errorbar(aes(ymin=b[,3]-b[,5], ymax=b[,3]+b[,5]),
                  width=.2,                    # Width of the error bars
                  position=position_dodge(.9))+
    scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())

  })

output$anova1 <- renderTable({
  x <- Y1()

    res <- aov(x[,1]~x[,2])
    res.table <- summary(res)[[1]]
    rownames(res.table)[1] <- c(names(x)[2])

  return(res.table)
  }, 
  width = "500px", rownames = TRUE)


##---------- 2. two way ANOVA ----------
Y <- reactive({
  inFile <- input$file
  if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$x, "[\n, \t, ]")))
    F1 <- unlist(strsplit(input$f1, "[\n, \t, ]"))
    F2 <- unlist(strsplit(input$f2, "[\n, \t, ]"))
    Y <- data.frame(X = X, F1 = F1, F2 = F2)
    names(Y) = unlist(strsplit(input$cn, "[\n, \t, ]"))
    return(Y)
    }
  else {
    csv <- as.data.frame(
      read.csv(
        inFile$datapath,
        header = input$header,
        sep = input$sep
        )
      )
    return(csv)
  }
})

output$table <- renderDataTable({Y()}, options = list(pageLength = 5))

output$bas <- renderPrint({
  x <- Y()
  res <- describeBy(x[,1], x[,input$grp])
  #rownames(res) = c("number.var", "number.null", "number.na")
  return(res)
  })

output$meanp.a = renderPlot({
  x = Y()
  b = Rmisc::summarySE(x,names(x)[1], c(names(x)[2], names(x)[3]))

  if (input$tick == "TRUE"){
  ggplot(b, aes(x=b[,1], y=b[,4], colour=b[,2], group=b[,2])) + 
      geom_line() + xlab("") +ylab("")+
      geom_point(shape=21, size=3, fill="white") +
      theme_minimal() + theme(legend.title = element_blank())
    }

  else {
  ggplot(b, aes(x=b[,2], y=b[,4], colour=b[,1], group=b[,1])) + 
      geom_line() + xlab("") +ylab("")+
      geom_point(shape=21, size=3, fill="white") +
      theme_minimal() + theme(legend.title = element_blank())
  }

  })

output$mmean.a = renderPlot({
  x = Y()
  b = Rmisc::summarySE(x,names(x)[1], c(names(x)[2], names(x)[3]))

  if (input$tick2 == "TRUE"){
  ggplot(b, aes(x=b[,1], y=b[,4], fill=b[,2])) + 
    geom_bar(stat="identity", position = "dodge")+ xlab("") +ylab("")+
    geom_errorbar(aes(ymin=b[,4]-b[,6], ymax=b[,4]+b[,6]),
                  width=.2,                    # Width of the error bars
                  position=position_dodge(.9))+
    scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())
    }

  else {
  ggplot(b, aes(x=b[,2], y=b[,4], fill=b[,1])) + 
    geom_bar(stat="identity", position = "dodge")+ xlab("") +ylab("")+
        geom_errorbar(aes(ymin=b[,4]-b[,6], ymax=b[,4]+b[,6]),
                  width=.2,                    # Width of the error bars
                  position=position_dodge(.9))+
    scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())
  }

  })

output$anova <- renderTable({
  x <- Y()

  if (input$inter == "TRUE"){
    res <- aov(x[,1]~x[,2]*x[,3])
    res.table <- summary(res)[[1]]
    rownames(res.table)[1:3] <- c(names(x)[2],names(x)[3], paste0(names(x)[2]," X ",names(x)[3]))
  }

  else {
    res <- aov(x[,1]~x[,2]+x[,3])
    res.table <- summary(res)[[1]]
    rownames(res.table)[1:2] <- names(x)[2:3]
  }
  
  return(res.table)
  }, 
  width = "500px", rownames = TRUE)

 
##---------- 2. multiple comparison ----------
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

output$tablem <- renderDataTable({Ym()}, options = list(pageLength = 5))


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



observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })


}
)


