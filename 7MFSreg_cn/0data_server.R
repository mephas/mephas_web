##----------#----------#----------#----------
##
## 7MFSreg SERVER
##
##    >data
##
## Language: CN
## 
## DT: 2019-01-16
##
##----------#----------#----------#----------

load("reg.RData")


data <- reactive({
                switch(input$edata,
               "insurance" = insurance,
               "advertisement" = advertisement,
               "lung" = lung)
        })
X = eventReactive(input$choice,{
  inFile = input$file
  if (is.null(inFile)){
      df <- data() ##>  example data
    }
  else{
    df <- read.csv(inFile$datapath,
        header = input$header,
        sep = input$sep,
        quote = input$quote)
  }
    return(df)
  })

X_var = eventReactive(input$choice,{
  inFile = input$file
  if (is.null(inFile)){
      df <- data() ##>  example data
    }
  else{
    df <- read.csv(inFile$datapath,
        header = input$header,
        sep = input$sep,
        quote = input$quote)
  }
    vars <- names(df)
    updateSelectInput(session, "columns","选择列", choices = vars)
    return(df)
  })

  output$data <- renderDataTable(
    head(X()[1:2]), options = list(pageLength = 5))

  output$data_var <- renderDataTable(
    subset(X_var(), select = input$columns),
    options = list(pageLength = 5)
    )

# Basic Descriptives

output$cv = renderUI({
  selectInput(
    'cv', h5('请选择连续型变量'),
    selected = NULL, choices = names(X()), multiple = TRUE)
})

output$dv = renderUI({
  selectInput(
    'dv', h5('请选择离散型变量'), 
    selected = NULL, choices = names(X()), multiple = TRUE)
})

sum = eventReactive(input$Bc,  ##> cont var
        {
          pastecs::stat.desc(X()[, input$cv], desc = TRUE, norm=TRUE)
          #Hmisc::describe(X()[,input$cv])
        })
fsum = eventReactive(input$Bd, ##> dis var
       {
         data = as.data.frame(X()[, input$dv])
         colnames(data) = input$dv
         lapply(data, table)
       })

output$sum = renderTable({sum()}, rownames = TRUE)

output$fsum = renderPrint({fsum()})


# First Exploration of Variables

output$tx = renderUI({
  selectInput(
    'tx', h5('x轴的变量'),
    selected = NULL, 
    choices = names(X())
    )
  })

output$ty = renderUI({
  selectInput(
    'ty',
    h5('y轴的变量'),
    selected = NULL, 
    choices = names(X())
    )
})

## scatter plot
output$p1 = renderPlot({
  ggplot(X(), aes(x = X()[, input$tx], y = X()[, input$ty])) + geom_point(shape = 1) + 
    geom_smooth(method = lm) + xlab(input$tx) + ylab(input$ty) + theme_minimal()
  })

## histogram
output$hx = renderUI({
  selectInput(
    'hx',
    h5('连续型变量的直方图'),
    selected = NULL,
    choices = names(X()))
})

output$hxd = renderUI({
  selectInput(
    'hxd',
    h5('离散型变量的直方图'),
    selected = NULL,
    choices = names(X()))
})

output$p2 = renderPlot({
  ggplot(X(), aes(x = X()[, input$hx])) + 
    geom_histogram(aes(y=..density..),binwidth = input$bin, colour = "black",fill = "white") + 
    geom_density()+
    xlab("") + theme_minimal() + theme(legend.title = element_blank())
  })

output$p3 = renderPlot({
  ggplot(X(), aes(x = X()[, input$hxd])) + 
    geom_histogram(colour = "black",fill = "white",  stat="count") + 
    xlab("") + theme_minimal() + theme(legend.title = element_blank())
  })
