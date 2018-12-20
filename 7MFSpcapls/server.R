if (!require(shiny)) {install.packages("shiny")}; library(shiny)
if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2)
if (!require(mixOmics)) {install.packages("mixOmics")}; library(mixOmics)

##----------------------------------------------------------------
##
## PCA PLS regressions for n<p data, server EN
##
## 2018-11-30
## 
##----------------------------------------------------------------

shinyServer(
function(input, output) {

## data set ----------------------------------------------------------------------------------------
# input data, variables
X <- reactive({
 # req(input$file)
  inFile <- input$file.x
  if (is.null(inFile))
  # eg data
    {df = mixOmics::liver.toxicity$gene[,1:100]

    return(df)
  }
  else{
    # user data
    df <- as.data.frame(
      read.csv(
        inFile$datapath.x,
        header = input$header.x,
        sep = input$sep.x,
        quote = input$quote.x
        )
      )
      return(df)
   }
})

Y <- reactive({
 # req(input$file)
  inFile <- input$file.y
  if (is.null(inFile))
  # eg data
    {df = mixOmics::liver.toxicity$clinic
    return(df)
  }
  else{
    # user data
    df <- as.data.frame(
      read.csv(
        inFile$datapath.y,
        header = input$header.y,
        sep = input$sep.y,
        quote = input$quote.y
        )
      )
      return(df)
   }
})

data <- reactive({cbind.data.frame(Y(), X())})


output$table.x <- renderDataTable({data()},   options = list(pageLength = 5))
output$table.y <- 
# summary variable
output$x = renderUI({
    selectInput('x', h5('Variable for summary'), selected= colnames(data())[3], choices = colnames(data()))
  })
sum <- reactive({summary(data()[,input$x])})
output$sum <- renderPrint({sum()})

# scatter plot
output$tx = renderUI({
    selectInput('tx', h5('Independent Variable (X) to Plot'), selected= colnames(data())[3], choices = colnames(data()))
  })
output$ty = renderUI({
    selectInput('ty', h5('Dependent Variable (Y) to Plot'), selected= colnames(data())[1], choices = colnames(data()))
  })
output$p1 <- renderPlot({
    ggplot(data(), aes(x=data()[,input$tx], y=data()[,input$ty])) + geom_point(shape=1) + geom_smooth(method=lm) +xlab(input$tx) +ylab(input$ty)+ theme_minimal()
  })

# histogram
output$hx = renderUI({
    selectInput('hx', h5('Variable to Plot'), selected= colnames(data())[1], choices = colnames(data()))
  })
output$p2 <- renderPlot({
    ggplot(data(), aes(x = data()[,input$hx])) + geom_histogram(colour="black", fill = "grey", binwidth=input$bin, position="identity") + xlab("") + theme_minimal() + theme(legend.title=element_blank())
  })


##-------------------------------------------------------------------
##1. PCA
# input data
output$nc <- renderText({ input$nc })
# model
pca <- reactive({
  pca = mixOmics::pca(as.matrix(X()), ncomp = input$nc, scale = TRUE)
  pca})

pca.x <- reactive({ pca()$x })

output$fit  <- renderPrint({
  res <- rbind(pca()$explained_variance,pca()$cum.var)
  rownames(res) <- c("explained_variance", "cumulative_variance")
  res})

output$comp <- renderDataTable({ round(pca.x(),3)}, options = list(pageLength = 5))

output$downloadData <- downloadHandler(
    filename = function() {
      "pca_components.csv"
    },
    content = function(file) {
      write.csv(pca.x(), file, row.names = FALSE)
    }
  )

output$pca.ind  <- renderPlot({ plotIndiv(pca(), comp=c(input$c1, input$c2))})
output$pca.var  <- renderPlot({ plotVar(pca(),   comp=c(input$c1, input$c2))})
output$pca.bp   <- renderPlot({ biplot(pca())})
output$pca.plot <- renderPlot({ plot(pca())})

##-------------------------------------------------------------------

##2. PLS
# input data
#output$nc.pls <- renderText({ input$nc.pls })
# model
pls <- reactive({
  pls = mixOmics::pls(as.matrix(X()),as.matrix(Y()), ncomp = input$nc.pls, scale = TRUE)
  pls})

pls.x <- reactive({ pls()$variates$X })
pls.y <- reactive({ pls()$variates$Y })

output$comp.x <- renderDataTable({ round(pls.x(),3)}, options = list(pageLength = 5))
output$comp.y <- renderDataTable({ round(pls.x(),3)}, options = list(pageLength = 5))

output$downloadData.pls.x <- downloadHandler(
    filename = function() {
      "pls_components_x.csv"
    },
    content = function(file) {
      write.csv(pls.x(), file, row.names = FALSE)
    }
  )

output$downloadData.pls.y <- downloadHandler(
    filename = function() {
      "pls_components_y.csv"
    },
    content = function(file) {
      write.csv(pls.y(), file, row.names = FALSE)
    }
  )

output$pls.ind  <- renderPlot({ plotIndiv(pls(), comp=c(input$c1.pls, input$c2.pls)) })
output$pls.var  <- renderPlot({ plotVar(pls(),   comp=c(input$c1.pls, input$c2.pls)) })

##-------------------------------------------------------------------

##3. SPLS
# input data
# model
spls <- reactive({
  spls = mixOmics::spls(as.matrix(X()),as.matrix(Y()), ncomp = input$nc.spls, scale = TRUE,
    keepX=input$x.spls, keepY=input$y.spls)
  spls})

spls.x <- reactive({ spls()$variates$X })
spls.y <- reactive({ spls()$variates$Y })

output$comp.sx <- renderDataTable({ round(spls.x(),3)}, options = list(pageLength = 5))
output$comp.sy <- renderDataTable({ round(spls.x(),3)}, options = list(pageLength = 5))

output$downloadData.spls.x <- downloadHandler(
    filename = function() {
      "spls_components_x.csv"
    },
    content = function(file) {
      write.csv(spls.x(), file, row.names = FALSE)
    }
  )

output$downloadData.spls.y <- downloadHandler(
    filename = function() {
      "spls_components_y.csv"
    },
    content = function(file) {
      write.csv(spls.y(), file, row.names = FALSE)
    }
  )

output$spls.ind  <- renderPlot({ plotIndiv(spls(), comp=c(input$c1.spls, input$c2.spls)) })
output$spls.var  <- renderPlot({ plotVar(spls(),   comp=c(input$c1.spls, input$c2.spls)) })
output$spls.load <- renderPlot({ plotLoadings(spls()) })


##-------------------------------------------------------------------

##4. elastic net
# input data
# model
#lambda <- reactive({
 # cv.fit = glmnet::cv.glmnet(as.matrix(X()),as.matrix(Y()), family=input$family, alpha = input$alf)
 # cv.fit$lambda.1se
 # })

#output$lambda <- renderPrint({lambda()})

#ela <- reactive({
 # fit = glmnet::glmnet(as.matrix(X()),as.matrix(Y()),
  #  family=input$family, alpha = input$alf)
 # fit
 # })

#output$ela <- renderPrint({ coef(ela()) })

#output$plot.ela  <- renderPlot({ plot(ela()) })
observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })


})



