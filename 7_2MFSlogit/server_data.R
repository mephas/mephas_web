#****************************************************************************************************************************************************
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
colnames(DF0()[unlist(lapply(DF0(), is.numeric))])
})

output$factor1 = renderUI({
selectInput(
  'factor1',
  HTML('1. Convert real-valued numeric variable into categorical variable'),
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
colnames(DF1()[unlist(lapply(DF1(), is.factor))])
})

output$factor2 = renderUI({
selectInput(
  'factor2',
  HTML('2. Convert categorical variable into real-valued numeric variable'),
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
colnames(DF2()[unlist(lapply(DF2(), is.factor))])
})

output$lvl = renderUI({
selectInput(
'lvl',
HTML('1. Choose categorical variable'),
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


output$Xdata <- DT::renderDT(DF3(),
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel'),
      deferRender = TRUE,
      scrollY = 300,
      scroller = TRUE))

type.num3 <- reactive({
colnames(DF3()[unlist(lapply(DF3(), is.numeric))])
})

type.fac3 <- reactive({
colnames(DF3()[unlist(lapply(DF3(), is.factor))])
})

output$strnum <- renderPrint({str(DF3()[,type.num3()])})

output$strfac <- renderPrint({Filter(Negate(is.null), lapply(DF3(),levels))})


sum <- reactive({
  x <- DF3()[,type.num3()]
  res <- as.data.frame(psych::describe(x))[,-c(1,6,7)]
  rownames(res) = names(x)
  colnames(res) <- c("Total Number of Valid Values", "Mean" ,"SD", "Median", "Minimum", "Maximum", "Range","Skew","Kurtosis","SE")
  return(res)
  })

output$sum <- DT::renderDT({sum()},
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

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
'tx',
tags$b('1. Choose a numeric variable for the x-axis'),
selected=type.num3()[1],
choices = type.num3())
})

output$ty = renderUI({
selectInput(
'ty',
tags$b('2. Choose a binary variable for the y-axis'),
selected = type.bi()[1],
choices = type.bi())
})
 
 ## scatter plot
output$p1 = plotly::renderPlotly({
x<-DF3()
p<-plot_slgt(x, input$tx, input$ty)
plotly::ggplotly(p)
#ggplot(DF3(), aes(x=DF3()[, input$tx], y=(as.numeric(as.factor(DF3()[, input$ty]))-1))) + 
#geom_point(shape = 1,  size = 1) + 
#stat_smooth(method="glm", method.args=list(family="binomial"), se=FALSE,  size = 0.5) +
#xlab(input$tx) + ylab(input$ty) + theme_minimal()
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
   p<-plot_hist1(DF3(), input$hx, input$bin)
   plotly::ggplotly(p)
   })

output$p21 = plotly::renderPlotly({
     p<-plot_density1(DF3(), input$hx)
     plotly::ggplotly(p)
   })
 
