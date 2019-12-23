##----------#----------#----------#----------
##
## 7MFSreg SERVER
##
##    >data
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------
load("regression.RData")

data <- reactive({
                switch(input$edata,
               "insurance_linear_regression" = insurance_linear_regression,
               "advertisement_logistic_regression" = advertisement_logistic_regression,
               "lung_cox_regression" = lung_cox_regression)  
                })



XR = reactive({
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
  
  #fac <- as.data.frame(lapply(df[,input$factor], factor))
  #df2 <- cbind.data.frame(df, fac)
  return(df)
  })


#output$data <- renderDataTable(
#    XR(), options = list(pageLength = 5, scrollX = TRUE))

output$factor1 = renderUI({
selectInput(
  'factor1',
  h5('Continuous/numeric --> Discrete/factor/categorical'),
  selected = NULL,
  choices = names(XR()),
  multiple = TRUE
)
})

output$lvl = renderUI({
selectInput(
'lvl',
h5('Re-set the referential level'),
selected = "NULL",
choices = c("NULL", names(XR()))
)
})

output$factor2 = renderUI({
selectInput(
  'factor2',
  h5('Discrete/factor/categorical --> Continuous/numeric'),
  selected = NULL,
  choices = names(XR()),
  multiple = TRUE
)
})

X <- reactive({
  df2 <- XR()

  F <- N <- data.frame(NULL)
  F <- as.data.frame(lapply(XR()[input$factor1], as.factor))
  N <- as.data.frame(lapply(XR()[input$factor2], as.numeric))

  if (!is.null(input$factor1) & !is.null(input$factor2)) {df2 <- data.frame(F,N, XR())}
  if (!is.null(input$factor1) &  is.null(input$factor2)) {df2 <- data.frame(F, XR())}
  if ( is.null(input$factor1) & !is.null(input$factor2)) {df2 <- data.frame(N, XR())}
  if ( is.null(input$factor1) &  is.null(input$factor2)) {df2 <- XR()}

  if (input$lvl!="NULL") {df2[,input$lvl] <- relevel(df2[,input$lvl], input$ref)}

  return(df2)
  })

Xdata <- eventReactive(input$changevar,{
    X()})

X
output$Xdata2 <- renderDataTable(
    Xdata(), options = list(pageLength = 5,scrollX = TRUE))

## variable type
type.num <- reactive({
con.names = X() %>% select_if(is.numeric) %>% colnames()
return(con.names)
})

type.fac <- reactive({
cat.names = X() %>% select_if(is.factor) %>% colnames()
return(cat.names)
})

output$str.num <- renderPrint({type.num()})
output$str.fac <- renderPrint({str(X()[,type.fac()])})


  output$data.h1 <- renderDataTable(
    head(X()), options = list(scrollX = TRUE))
  output$data.h2 <- renderDataTable(
    head(X()), options = list(scrollX = TRUE))
  output$data.h3 <- renderDataTable(
    head(X()), options = list(scrollX = TRUE))

  output$str1 <- renderPrint({str(head(X()))})
  output$str2 <- renderPrint({str(head(X()))})
  output$str3 <- renderPrint({str(head(X()))})
  output$str0 <- renderPrint({str(head(XR()))})
  output$str00 <- renderPrint({str(head(X()))})


# Basic Descriptives

output$cv = renderUI({
  selectInput(
    'cv', h5('Select continuous variables'),
    selected = NULL, 
    choices = type.num(), 
    multiple = TRUE)
})

output$dv = renderUI({
  selectInput(
    'dv', h5('Select discrete / categorical variables'), 
    selected = NULL, 
    choices = type.fac(), 
    multiple = TRUE)
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

output$sum = DT::renderTable({sum()}, rownames = TRUE)

output$fsum = renderPrint({fsum()})

output$download1 <- downloadHandler(
    filename = function() {
      "reg1.csv"
    },
    content = function(file) {
      write.csv(sum(), file, row.names = TRUE)
    }
  )

output$download2 <- downloadHandler(
    filename = function() {
      "reg2.txt"
    },
    content = function(file) {
      write.table(fsum(), file)
    }
  )

# First Exploration of Variables

output$tx = renderUI({
  selectInput(
    'tx', h5('Variable at the x-axis'),
    selected = "NULL", 
    choices = c("NULL",names(X())))
  
  })

output$ty = renderUI({
  selectInput(
    'ty',
    h5('Variable at the y-axis'),
    selected = "NULL", 
    choices = c("NULL",names(X())))
  
})

## scatter plot
output$p1 = renderPlot({
   validate(
      need(input$tx != "NULL", "Please select one continuous variable")
   )
  validate(
      need(input$ty != "NULL", "Please select one continuous variable")
    )
  ggplot(X(), aes(x = X()[, input$tx], y = X()[, input$ty])) + geom_point(shape = 1) + 
    geom_smooth(method = lm) + xlab(input$tx) + ylab(input$ty) + theme_minimal()
  })

## histogram
output$hx = renderUI({
  selectInput(
    'hx',
    h5('Histogram of the continuous variable'),
    selected = "NULL", 
    choices = c("NULL",names(X())))
})

output$hxd = renderUI({
  selectInput(
    'hxd',
    h5('Histogram of the categorical/discrete variable'),
    selected = "NULL", 
    choices = c("NULL",names(X())))
})

output$p2 = renderPlot({
  validate(
      need(input$hx != "NULL", "Please select one continuous variable")
    )
  ggplot(X(), aes(x = X()[, input$hx])) + 
    geom_histogram(aes(y=..density..),binwidth = input$bin, colour = "black",fill = "white") + 
    geom_density()+
    xlab("") + theme_minimal() + theme(legend.title = element_blank())
  })

output$p3 = renderPlot({
  validate(
      need(input$hxd != "NULL", "Please select one categorical/discrete variable")
    )
  ggplot(X(), aes(x = X()[, input$hxd])) + 
    geom_histogram(colour = "black",fill = "white",  stat="count") + 
    xlab("") + theme_minimal() + theme(legend.title = element_blank())
  })
