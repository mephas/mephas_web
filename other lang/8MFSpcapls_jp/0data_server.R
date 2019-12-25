##----------#----------#----------#----------
##
## 8MFSpcapls SERVER
##
##    >data
##
## Language: JP
## 
## DT: 2019-01-15
##
##----------#----------#----------#----------

load("pcapls.RData")

example.x <- reactive({
                switch(input$edata.x,
               "Gene sample1" = genesample1,
               "Gene sample2" = genesample2)
        })

X <- reactive({
  # req(input$file)
  inFile <- input$file.x
  if (is.null(inFile)){
    df = example.x()
  }
  else{
    df <- as.data.frame(
      read.csv(
        inFile$datapath,
        header = input$header.x,
        sep = input$sep.x,
        quote = input$quote.x
      )
    )
  }
  return(df)
})

example.y <- reactive({
                switch(input$edata.y,
               "Y_group_pca" = ygroup_pca,
               "Y_array_s_pls" = yarray_s_pls,
               "Y_matrix_s_pls"= ymatrix_s_pls)
        })

Y <- reactive({
  if (input$add.y == FALSE)
  {
    df = NULL
  }
  else
  {
    inFile <- input$file.y
  if (is.null(inFile))
    # eg data
  {
    df = example.y()
  }
  else{
  df <- as.data.frame(
    read.csv(
      inFile$datapath,
      header = input$header.y,
      sep = input$sep.y,
      quote = input$quote.y
      )
    )
  }
  }
  
  return(df)
})


 output$table.x <- renderDataTable(
    X(), options = list(pageLength = 5, scrollX = TRUE))
 output$table.y <- renderDataTable(
    Y(), options = list(pageLength = 5, scrollX = TRUE))

data <- reactive({
  if (input$add.y == FALSE) X()
  else cbind.data.frame(Y(),X())})

output$table.z <- renderDataTable(
    data(), options = list(pageLength = 5, scrollX = TRUE))


# Basic Descriptives


output$cv = renderUI({
  selectInput(
    'cv', h5('Select continuous variables from data'), 
    selected = NULL, choices = names(data()), multiple = TRUE)
})

output$dv = renderUI({
selectInput(
'dv', h5('Select categorical/discrete variables from data'), 
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
    selected = "NULL", 
    choices = c("NULL",names(data())))
  
})

output$ty = renderUI({
  selectInput(
    'ty',
    h5('Variable in the y-axis'),
    selected = "NULL", 
    choices = c("NULL",names(data())))
  
})

output$p1 <- renderPlot({
     validate(
      need(input$tx != "NULL", "Please select one continuous variable")
    )
        validate(
      need(input$ty != "NULL", "Please select one continuous variable")
    )
  ggplot(data(), aes(x=data()[,input$tx], y=data()[,input$ty])) + geom_point(shape=1) + 
    geom_smooth(method=lm) +xlab(input$tx) +ylab(input$ty)+ theme_minimal()
})

## histogram
output$hx = renderUI({

  selectInput(
    'hx',
    h5('Histogram of the continuous variable'),
    selected = "NULL",
    choices = c("NULL",names(data())))
})



output$hxd = renderUI({
  selectInput(
    'hxd',
    h5('Histogram of the categorical/discrete variable'),
    selected = "NULL",
    choices = c("NULL",names(data())))
})

output$p2 = renderPlot({
   validate(
      need(input$hx != "NULL", "Please select one continuous variable")
    )
  ggplot(data(), aes(x = data()[, input$hx])) + 
    geom_histogram(aes(y=..density..),binwidth = input$bin, colour = "black",fill = "white") + 
    geom_density()+
    xlab("") + theme_minimal() + theme(legend.title = element_blank())
})

output$p3 = renderPlot({
     validate(
      need(input$hxd != "NULL", "Please select one categorical/discrete variable")
    )
  ggplot(data(), aes(x = data()[, input$hxd])) + 
    geom_histogram(colour = "black",fill = "white",  stat="count") + 
    xlab("") + theme_minimal() + theme(legend.title = element_blank())
})