##----------------------------------------------------------------
##
## PCA PLS regressions for n<p data, server EN
##
##    0. data preparation
##
## DT: 2018-01-07
## 
##----------------------------------------------------------------

load("coloncancer.RData")


X <- reactive({
  # req(input$file)
  inFile <- input$file.x
  if (is.null(inFile)){
    df = coloncancer[,1:100]
  }
  else{
    df <- as.data.frame(
      read.csv(
        inFile$datapath.x,
        header = input$header.x,
        sep = input$sep.x,
        quote = input$quote.x
      )
    )
  }
  return(df)
})

Y <- reactive({
  # req(input$file)
  inFile <- input$file.y
  if (is.null(inFile))
    # eg data
  {df = coloncancer[,101:110]
  }
  else{
    
    df <- as.data.frame(
      read.csv(
        inFile$datapath.y,
        header = input$header.y,
        sep = input$sep.y,
        quote = input$quote.y
      )
    )
  }
  return(df)
})

output$table.x <- renderTable({X()[1:5,1:5]},  rownames = TRUE, colnames = TRUE)
output$table.y <- renderTable({Y()[1:5,1]}, rownames = TRUE, colnames = TRUE)
# summary variable

data <- reactive({
  cbind.data.frame(X(),Y())
})

# Basic Descriptives


output$cv = renderUI({
  selectInput(
    'cv', h5('Select continuous variables from X or Y matrices'), 
    selected = NULL, choices = names(data()), multiple = TRUE)
})

output$dv = renderUI({
  selectInput(
    'dv', h5('Select categorical/discrete variables from X or Y matrices'), 
    selected = NULL, choices = names(data()), multiple = TRUE)
})

sum = eventReactive(input$Bc,  ##> cont var
                    {
                      pastecs::stat.desc(data()[, input$cv], desc = TRUE, norm=TRUE)
                      #Hmisc::describe(X()[,input$cv])
                    })

fsum = eventReactive(input$Bd, ##> dis var
                     {
                       data = as.data.frame(data()[, input$dv])
                       colnames(data) = input$dv
                       lapply(data, table)
                     })

output$sum <- renderTable({sum()}, rownames = TRUE)

fsum = eventReactive(input$Bd, ##> dis var
                     {
                       data = as.data.frame(data()[, input$dv])
                       colnames(data) = input$dv
                       lapply(data, table)
                     })

output$sum = renderTable({sum()}, rownames = TRUE)

output$fsum = renderPrint({fsum()})

# First Exploration of Variables

output$tx = renderUI({
  selectInput(
    'tx', h5('Variable in the x-axis'),
    selected = NULL, 
    choices = names(X())
  )
})

output$ty = renderUI({
  selectInput(
    'ty',
    h5('Variable in the y-axis'),
    selected = NULL, 
    choices = names(X())
  )
})

output$p1 <- renderPlot({
  ggplot(data(), aes(x=data()[,input$tx], y=data()[,input$ty])) + geom_point(shape=1) + 
    geom_smooth(method=lm) +xlab(input$tx) +ylab(input$ty)+ theme_minimal()
})

## histogram
output$hx = renderUI({
  selectInput(
    'hx',
    h5('Histogram of the continuous variable'),
    selected = NULL,
    choices = c("NULL",names(data())))
})

output$hxd = renderUI({
  selectInput(
    'hxd',
    h5('Histogram of the categorical/discrete variable'),
    selected = NULL,
    choices = c("NULL",names(data())))
})

output$p2 = renderPlot({
  ggplot(X(), aes(x = data()[, input$hx])) + 
    geom_histogram(aes(y=..density..),binwidth = input$bin, colour = "black",fill = "white") + 
    geom_density()+
    xlab("") + theme_minimal() + theme(legend.title = element_blank())
})

output$p3 = renderPlot({
  ggplot(X(), aes(x = data()[, input$hxd])) + 
    geom_histogram(colour = "black",fill = "white",  stat="count") + 
    xlab("") + theme_minimal() + theme(legend.title = element_blank())
})