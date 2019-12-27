##----------#logistic data#----------#----------
load("LGT.RData")

data <- reactive({
                switch(input$edata,
               "Breast Cancer" = LGT)  
                })


DF0 = reactive({
  inFile = input$file
  if (is.null(inFile)){
    x<-data()
    }
  else{
if(input$col){
    csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep, quote=input$quote, row.names=1)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep, quote=input$quote)
    }
    validate( need(ncol(csv)>1, "Please check your data (nrow>1, ncol>1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>1, ncol>1), valid row names, column names, and spectators") )

  x <- as.data.frame(csv)
}
return(as.data.frame(x))
})

## variable type
type.num0 <- reactive({
DF0() %>% select_if(is.numeric) %>% colnames()
})

output$factor1 = renderUI({
selectInput(
  'factor1',
  h5('Numeric Variables/ Numbers --> Categorical Variables / Factors'),
  selected = NULL,
  #choices = names(DF()),
  choices = type.num0(),
  multiple = TRUE
)
})

DF1 <- reactive({
df <-DF0() 
df[input$factor1] <- as.data.frame(lapply(df[input$factor1], factor))
return(df)
  })

type.fac1 <- reactive({
DF1() %>% select_if(is.factor) %>% colnames()
})

output$factor2 = renderUI({
selectInput(
  'factor2',
  h5('Categorical Variables / Factors --> Numeric Variables/ Numbers'),
  selected = NULL,
  #choices = names(DF()),
  choices = type.fac1(),
  multiple = TRUE
)
})



DF2 <- reactive({
  df <-DF1() 
df[input$factor2] <- as.data.frame(lapply(df[input$factor2], as.numeric))
return(df)
  })

type.fac2 <- reactive({
DF2() %>% select_if(is.factor) %>% colnames()
})

output$lvl = renderUI({
selectInput(
'lvl',
h5('1. Choose Categorical Variables / Factors'),
selected = NULL,
choices = type.fac2(),
multiple = TRUE
)
})

DF3 <- reactive({
   
  if (length(input$lvl)==0 || length(unlist(strsplit(input$ref, "[\n]")))==0 ||length(input$lvl)!=length(unlist(strsplit(input$ref, "[\n]")))){
  df <- DF2()
}

else{
  df <- DF2()
  x <- input$lvl
  y <- unlist(strsplit(input$ref, "[\n]"))
  for (i in 1:length(x)){
    #df[,x[i]] <- as.factor(as.numeric(df[,x[i]]))
    df[,x[i]] <- relevel(df[,x[i]], ref= y[i])
  }

}
return(df)
  
  })



output$Xdata <- DT::renderDataTable(DF3(),
  class="row-border", 
  extensions = 'Scroller', 
  options = list(
    scrollX = TRUE,
    scrollY = 290,
  scroller = TRUE))

type.num3 <- reactive({
DF3() %>% select_if(is.numeric) %>% colnames()
})

type.fac3 <- reactive({
DF3() %>% select_if(is.factor) %>% colnames()
})

output$strnum <- renderPrint({str(DF3()[,type.num3()])})

output$strfac <- renderPrint({Filter(Negate(is.null), lapply(DF3(),levels))})


sum <- reactive({
  x <- DF3()[,type.num3()]
  res <- as.data.frame(t(psych::describe(x))[-c(1,6,7), ])
  colnames(res) = names(x)
  rownames(res) <- c("Total Number of Valid Values", "Mean" ,"SD", "Median", "Minimum", "Maximum", "Range","Skew","Kurtosis","SE")
  return(res)
  })

output$sum <- DT::renderDataTable({sum()},
  class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE,
    scrollY = 290,
    scroller = TRUE))

fsum = reactive({
  x <- DF3()[,type.fac3()]
  summary(x)
  })

output$fsum = renderPrint({fsum()})
 
 output$download2 <- downloadHandler(
     filename = function() {
       "lr.des2.txt"
     },
     content = function(file) {
       write.table(fsum(), file, row.names = TRUE)
     }
   )
# 
# # First Exploration of Variables
# 
output$tx = renderUI({
   selectInput(
     'tx', tags$b('1. Choose a numeric variable for the x-axis'),
     selected=type.num3()[1],
     choices = type.num3())
   })
 
 output$ty = renderUI({
   selectInput(
     'ty',
     tags$b('2. Choose a binary (1/0) variable for the y-axis'),
     selected = names(DF3())[1],
     choices = names(DF3()))
   
 })
 
 ## scatter plot
 output$p1 = plotly::renderPlotly({
  validate(need(length(levels(as.factor(DF3()[, input$ty])))==2, "Please choose a binary variable as Y")) 
   #ggplot(DF3(), aes(x = DF3()[, input$tx], y = DF3()[, input$ty])) + geom_point(shape = 1) + 
   #  geom_smooth(method = lm) + xlab(input$tx) + ylab(input$ty) + theme_minimal()
   p<- ggplot(DF3(), aes(x=DF3()[, input$tx], y=(as.numeric(as.factor(DF3()[, input$ty]))-1))) + 
   geom_point(shape = 1,  size = 1) + 
  stat_smooth(method="glm", method.args=list(family="binomial"), se=FALSE,  size = 0.5) +
  xlab(input$tx) + ylab(input$ty) + theme_minimal()

  plotly::ggplotly(p)
   })
 
## histogram
 output$hx = renderUI({
   selectInput(
     'hx',
     tags$b('Choose a numeric variable to see the distribution'),
     selected = type.num3()[1], 
     choices = type.num3())
 })
 
output$p2 = plotly::renderPlotly({
   validate(
       need(input$hx != "NULL", "Please select one numeric variable")
     )
   p<-ggplot(DF3(), aes(x = DF3()[, input$hx])) + 
     geom_histogram(aes(y=..density..),binwidth = input$bin, colour = "black",fill = "white",size = 0.5) + 
     geom_density(size = 0.5)+
     xlab("") + theme_minimal() + theme(legend.title = element_blank())

plotly::ggplotly(p)
   })
 
