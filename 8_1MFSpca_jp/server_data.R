#****************************************************************************************************************************************************

load("pca.RData")

data <- reactive({
                switch(input$edata,
               "Chemical (EFA)" = chem,
               "Mouse (PCA)" = mouse)
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
    csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep, quote=input$quote, stringsAsFactors=TRUE)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep, quote=input$quote, row.names=1, stringsAsFactors=TRUE)
    }
    validate( need(ncol(csv)>1, "Please check your data (nrow>1, ncol>1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>1, ncol>1), valid row names, column names, and spectators") )

  x <- as.data.frame(csv)
}

  if(input$transform) {
    x <- as.data.frame(t(x))
    names(x)<- make.names(names(x), unique = TRUE, allow_ = FALSE)
    }
return(as.data.frame(x))
})

type.num0 <- reactive({
colnames(DF0()[unlist(lapply(DF0(), is.numeric))])
})

output$factor1 = renderUI({
selectInput(
  'factor1',
  HTML('1. 実数変数をカテゴリ変数に変換する'),
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
  HTML('2. カテゴリ変数を実数値の数値変数に変換する'),
  selected = NULL,
  #choices = names(DF()),
  choices = type.fac1(),
  multiple = TRUE
)
})

X.1 <- reactive({
  df <-DF1() 
df[input$factor2] <- as.data.frame(lapply(df[input$factor2], as.numeric))
return(df)
  })

type.fac2 <- reactive({
colnames(X.1()[unlist(lapply(X.1(), is.factor))])
})

output$rmrow = renderUI({
shinyWidgets::pickerInput(
'rmrow',
h4(tags$b('いくつかのサンプル/外れ値を削除する')),
selected = NULL,
choices = rownames(X.1()),
multiple = TRUE,
options = shinyWidgets::pickerOptions(
      actionsBox=TRUE,
      size=5)
)
})

X <- reactive({
  if(length(input$rmrow)==0) {df <- X.1()}

  else{
  df <- X.1()[-which(rownames(X.1()) %in% c(input$rmrow)),]
  }
  return(df)
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
      scrollX=TRUE,
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
  return(round(res,6))
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
     tags$b('1. x軸の数値変数を選択する'),
     selected=type.num3()[2],
     choices = type.num3())
   })
 
 output$ty = renderUI({
   selectInput(
     'ty',
     tags$b('2. y軸の数値変数を選択する'),
     selected = type.num3()[1],
     choices = type.num3())
   
 })

 output$p1 = plotly::renderPlotly({
  validate(need(input$tx, "Waiting for a variable"))
  validate(need(input$ty, "Waiting for a variable"))

   p<- plot_scat(X(), input$tx, input$ty, input$xlab, input$ylab)
   plotly::ggplotly(p)
   })

## histogram
output$hx = renderUI({

  selectInput(
    'hx',
     tags$b('数値変数を選択する'),
     selected = type.num3()[1], 
     choices = type.num3())
})

output$p2 = plotly::renderPlotly({
  validate(need(input$hx, "Waiting for a variable"))
   p<-plot_hist1(X(), input$hx, input$bin)
   plotly::ggplotly(p)
   })

output$p21 = plotly::renderPlotly({
    validate(need(input$hx, "Waiting for a variable"))
     p<-plot_density1(X(), input$hx)
     plotly::ggplotly(p)
   })


output$heat.x = renderUI({
  shinyWidgets::pickerInput(
    inputId = "heat.x",
    label = "ヒートマップをプロットする変数を選択する",
    selected =type.num3(),
    choices = type.num3(),
    multiple = TRUE,
    options = shinyWidgets::pickerOptions(
      actionsBox=TRUE,
      size=5)
)
  })

output$heat = plotly::renderPlotly({
  validate(need(input$heat.x, "Waiting for a variable"))
    if(input$heat.scale){
    plotly::plot_ly(x = input$heat.x,
             y = paste0("s.",c(rownames(X()))),
            z = scale(as.matrix(X()[,input$heat.x])), 
            type = "heatmap")      
    }
    else{
    plotly::plot_ly(x = input$heat.x,
             y = paste0("s.",c(rownames(X()))),
            z = as.matrix(X()[,input$heat.x]), 
            type = "heatmap")
  }
   })


output$cor.x = renderUI({
  shinyWidgets::pickerInput(
    inputId = "cor.x",
    label = "相関行列をプロットする変数を選択します",
    selected =type.num3(),
    choices = type.num3(),
    multiple = TRUE,
    options = shinyWidgets::pickerOptions(
      actionsBox=TRUE,
      size=5)
)
  })

output$cor <- DT::renderDT({
  c <- as.data.frame(cor(X()[,input$cor.x]))
  c <- c[ , order(names(c))]
  c <- c[order(rownames(c)),]
  return(round(c,6))}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$cor.plot   <- renderPlot({ 
    validate(need(input$cor.x, "Waiting for a variable"))
plot_corr(X()[,input$cor.x])

})

output$para.x = renderUI({
  shinyWidgets::pickerInput(
    inputId = "para.x",
    label = "PCAとEFAの並列分析をプロットする変数を選択する",
    selected =type.num3(),
    choices = type.num3(),
    multiple = TRUE,
    options = shinyWidgets::pickerOptions(
      actionsBox=TRUE,
      size=5)
)
  })

output$fa.plot   <- renderPlot({
df <- X()[,input$para.x]
validate(need(nrow(df)>ncol(df), "Number of variables should be less than the number of rows"))
validate(need(input$para.x, "Waiting for a variables"))

psych::fa.parallel(df,fa="both")
})

output$fancomp   <- renderPrint({ 
df <- X()[,input$para.x]
psych::fa.parallel(df,fa="both")
#cat(paste0("Parallel analysis suggests that the number of factors: ", f$nfact))
})
