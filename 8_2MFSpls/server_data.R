#****************************************************************************************************************************************************

load("pls.RData")

data <- reactive({
                switch(input$edata,
               "NKI" = nki2.train)
               #"Liver" = liver.train)
               #"Independent variable matrix (Gene sample2)" = genesample2)
        })

DF0 <- reactive({
  # req(input$file)
  inFile <- input$file
  if (is.null(inFile)){
    x<-data()
    }
  else{
if(!input$col){
    csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep, quote=input$quote)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep, quote=input$quote, row.names=1)
    }
    validate( need(ncol(csv)>1, "Please check your data (nrow>1, ncol>1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>1, ncol>1), valid row names, column names, and spectators") )

  x <- as.data.frame(csv)
}
return(as.data.frame(x))
})

type.num0 <- reactive({
colnames(DF0()[unlist(lapply(DF0(), is.numeric))])
})

output$factor1 = renderUI({
selectInput(
  'factor1',
  HTML('1. Convert real-valued numeric variable into categorical variable'),
  selected = NULL,
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

X <- reactive({
  df <-DF1() 
df[input$factor2] <- as.data.frame(lapply(df[input$factor2], as.numeric))
return(df)
  })

type.fac2 <- reactive({
colnames(X()[unlist(lapply(X(), is.factor))])
})

 output$Xdata <- DT::renderDT({
  if (ncol(X())>1000 || nrow(X())>1000) {X()[,1:1000]}
  else { X()}
  }, 
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
colnames(X()[unlist(lapply(X(), is.numeric))])
})

type.fac3 <- reactive({
colnames(X()[unlist(lapply(X(), is.factor))])
})

output$strnum <- renderPrint({str(X()[,type.num3()])})
output$strfac <- renderPrint({Filter(Negate(is.null), lapply(X(),levels))})

sum <- reactive({
  x <- X()[,type.num3()]
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
  x <- X()[,type.fac3()]
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

# First Exploration of Variables

output$tx = renderUI({
   selectInput(
     'tx', 
     tags$b('1. Choose a numeric variable for the x-axis'),
     selected=type.num3()[2],
     choices = type.num3())
   })
 
 output$ty = renderUI({
   selectInput(
     'ty',
     tags$b('2. Choose a numeric variable for the y-axis'),
     selected = type.num3()[1],
     choices = type.num3())
   
 })

 output$p1 = plotly::renderPlotly({
   p<- plot_scat(X(), input$tx, input$ty)
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
   p<-plot_hist1(X(), input$hx, input$bin)
   plotly::ggplotly(p)
   })

output$p21 = plotly::renderPlotly({
     p<-plot_density1(X(), input$hx)
     plotly::ggplotly(p)
   })

