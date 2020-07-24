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
    csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep, quote=input$quote, row.names=1, stringsAsFactors=TRUE)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep, quote=input$quote, stringsAsFactors=TRUE)
    }
    validate( need(ncol(csv)>1, "Please check your data (nrow>1, ncol>1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>1, ncol>1), valid row names, column names, and spectators") )

  x <- as.data.frame(csv)
}

#class <- var.class(x)

 # b.names <- colnames(x[,class[,1] %in% "binary",drop=FALSE])
 # x[,b.names]<-sapply(x[,b.names], as.factor)

return(x)
})

## raw variable type
var.type.list0 <- reactive({
  var.class(DF0())
})


#type.num0 <- reactive({
#colnames(DF0()[unlist(lapply(DF0(), is.numeric))])
#})

type.int <- reactive({
colnames(DF0()[,var.type.list0()[,1] %in% "integer", drop=FALSE])
})

output$factor1 = renderUI({
selectInput(
  'factor1',
  HTML('1. Convert integer variable into categorical variable'),
  selected = NULL,
  choices = type.int(),
  multiple = TRUE
)
})

DF1 <- reactive({
df <-DF0() 
df[input$factor1] <- as.data.frame(lapply(df[input$factor1], factor))
return(df)
  })


var.type.list1 <- reactive({
  var.class(DF1())
})

type.fac1 <- reactive({
colnames(DF1()[,var.type.list1()[,1] %in% c("factor", "binary"),drop=FALSE])
})

output$factor2 = renderUI({
selectInput(
  'factor2',
  HTML('2. Convert categorical variable into real-valued numeric variable'),
  selected = NULL,
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

output$rmrow = renderUI({
shinyWidgets::pickerInput(
'rmrow',
h4(tags$b('Remove some samples / outliers')),
selected = NULL,
choices = rownames(DF2()),
multiple = TRUE,
options = shinyWidgets::pickerOptions(
      actionsBox=TRUE,
      size=5)
)
})

DF2.1 <- reactive({
  if(length(input$rmrow)==0) {df <- DF2()}

  else{
  df <- DF2()[-which(rownames(DF2()) %in% c(input$rmrow)),]
  }
  return(df)
  })

DF3 <- reactive({

if (length(input$lvl)==0 || length(unlist(strsplit(input$ref, "[\n]")))==0 ||length(input$lvl)!=length(unlist(strsplit(input$ref, "[\n]")))){
df <- DF2.1()
}

else{
df <- DF2.1()
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
      scrollX=TRUE,
      scrollY = 300,
      scroller = TRUE))

type.num3 <- reactive({
colnames(DF3()[unlist(lapply(DF3(), is.numeric))])
})

type.fac3 <- reactive({
colnames(DF3()[unlist(lapply(DF3(), is.factor))])
})

#output$strnum <- renderPrint({str(DF3()[,type.num3()])})
#output$strfac <- renderPrint({Filter(Negate(is.null), lapply(DF3(),levels))})

## final variable type
var.type.list3 <- reactive({
  var.class(DF3())
})

output$var.type <- DT::renderDT(var.type.list3(),
  extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel'),
      deferRender = TRUE,
      scrollX = TRUE,
      scrollY = 200,
      scroller = TRUE))


output$sum <- DT::renderDT({desc.numeric(DF3())}, 
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel'),
      deferRender = TRUE,
      scrollX = TRUE,
      scrollY = 200,
      scroller = TRUE))

output$fsum = DT::renderDT({desc.factor(DF3())}, 
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel'),
      deferRender = TRUE,
      scrollX = TRUE,
      scrollY = 200,
      scroller = TRUE))
 

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
  validate(need(input$tx, "Loading variable"))
  validate(need(input$ty, "Loading variable"))

x<-DF3()
p<-plot_slgt(x, input$tx, input$ty, input$xlab, input$ylab)
plotly::ggplotly(p)
})
 
## histogram
 output$hx = renderUI({
   selectInput(
     'hx',
     tags$b('Choose a numeric variable'),
     selected = type.num3()[1], 
     choices = type.num3())
 })
 
output$p2 = plotly::renderPlotly({
    validate(need(input$hx, "Loading variable"))
   p<-plot_hist1(DF3(), input$hx, input$bin)
   plotly::ggplotly(p)
   })

output$p21 = plotly::renderPlotly({
    validate(need(input$hx, "Loading variable"))
     p<-plot_density1(DF3(), input$hx)
     plotly::ggplotly(p)
   })
 
