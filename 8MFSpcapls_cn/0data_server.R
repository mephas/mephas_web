##----------#----------#----------#----------
##
## 8MFSpcapls SERVER
##
##    >data
##
## Language: CN
## 
## DT: 2019-01-15
##
##----------#----------#----------#----------

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
  {df = coloncancer[,101:105]
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

 output$table.x <- renderDataTable(
    head(X()), options = list(pageLength = 5, scrollX = TRUE))
 output$table.y <- renderDataTable(
    head(Y()), options = list(pageLength = 5, scrollX = TRUE))
 

data <- reactive({
  cbind.data.frame(X(),Y())
})

# Basic Descriptives


output$cv = renderUI({
  selectInput(
    'cv', h5('从X和Y矩阵中选择连续型变量'), 
    selected = NULL, choices = names(data()), multiple = TRUE)
})

output$dv = renderUI({
  selectInput(
    'dv', h5('从X和Y矩阵中选择离散型变量'), 
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
    'tx', h5('x轴的变量'),
    selected = "NULL", 
    choices = c("NULL",names(data())))
  
})

output$ty = renderUI({
  selectInput(
    'ty',
    h5('y轴的变量'),
    selected = "NULL", 
    choices = c("NULL",names(data())))
  
})

output$p1 <- renderPlot({
     validate(
      need(input$tx != "NULL", "请选一个连续型变量")
    )
        validate(
      need(input$ty != "NULL", "请选一个连续型变量")
    )
  ggplot(data(), aes(x=data()[,input$tx], y=data()[,input$ty])) + geom_point(shape=1) + 
    geom_smooth(method=lm) +xlab(input$tx) +ylab(input$ty)+ theme_minimal()
})

## histogram
output$hx = renderUI({

  selectInput(
    'hx',
    h5('连续型变量的直方图'),
    selected = "NULL",
    choices = c("NULL",names(data())))
})



output$hxd = renderUI({
  selectInput(
    'hxd',
    h5('离散型变量的直方图'),
    selected = "NULL",
    choices = c("NULL",names(data())))
})

output$p2 = renderPlot({
   validate(
      need(input$hx != "NULL", "请选一个连续型变量")
    )
  ggplot(data(), aes(x = data()[, input$hx])) + 
    geom_histogram(aes(y=..density..),binwidth = input$bin, colour = "black",fill = "white") + 
    geom_density()+
    xlab("") + theme_minimal() + theme(legend.title = element_blank())
})

output$p3 = renderPlot({
     validate(
      need(input$hxd != "NULL", "请选一个离散型变量")
    )
  ggplot(data(), aes(x = data()[, input$hxd])) + 
    geom_histogram(colour = "black",fill = "white",  stat="count") + 
    xlab("") + theme_minimal() + theme(legend.title = element_blank())
})