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
load("Surv.RData")

data <- reactive({
                switch(input$edata,
               "NKI70" = Surv)  
                })


DF0 = reactive({
  inFile = input$file
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

output$t = renderUI({
selectInput(
't',
tags$b('Choice 1. Time-duration, numeric'),
selected = type.num3()[1],
choices = type.num3())
})

output$t1 = renderUI({
selectInput(
't1',
('1. Start-time variable, numeric'),
selected = type.num3()[1],
choices = type.num3())
})

output$t2 = renderUI({
selectInput(
't2',
('2. End-time variable, numeric'),
selected = "NULL",
choices = c("NULL",type.num3()))
})

output$c = renderUI({
selectInput(
'c',
('2. Choose binary censoring information variable'),
selected = names(DF3())[2],
choices = names(DF3()))
})

##3. Survival Object
surv = reactive({
if (input$time == "A"){
y <- paste0("Surv(", input$t, ",", input$c, ")")
}
if (input$time == "B"){
y <- paste0("Surv(", input$t1, ",", input$t2, ",", input$c, ")")
}
return(y)
})

output$surv = renderPrint({
validate(need(length(levels(as.factor(DF3()[, input$c])))==2, "Please choose a binary variable as Y")) 
surv()
})


output$Xdata <- DT::renderDataTable(
DF3(), options = list(scrollX = TRUE))

type.num3 <- reactive({
DF3() %>% select_if(is.numeric) %>% colnames()
})

type.fac3 <- reactive({
DF3() %>% select_if(is.factor) %>% colnames()
})

output$strnum <- renderPrint({str(DF3()[,type.num3()])})
#output$str.fac <- renderPrint({str(DF2()[,type.fac()])})
output$strfac <- renderPrint({Filter(Negate(is.null), lapply(DF3(),levels))})


sum <- reactive({
  x <- DF3()[,type.num3()]
  res <- as.data.frame(t(psych::describe(x))[-c(1,6,7), ])
  colnames(res) = names(x)
  rownames(res) <- c("Total Number of Valid Values", "Mean" ,"SD", "Median", "Minimum", "Maximum", "Range","Skew","Kurtosis","SE")
  return(res)
  })

output$sum <- DT::renderDataTable({sum()}, options = list(scrollX = TRUE))

fsum = reactive({
  x <- DF3()[,type.fac3()]
  summary(x)
  })

output$fsum = renderPrint({fsum()})
 
output$download1 <- downloadHandler(
     filename = function() {
       "lr.des1.csv"
     },
     content = function(file) {
       write.csv(sum(), file, row.names = TRUE)
     }
   )
 
 output$download2 <- downloadHandler(
     filename = function() {
       "lr.des2.txt"
     },
     content = function(file) {
       write.table(fsum(), file, row.names = TRUE)
     }
   )
 
 ## scatter plot
 output$p1 = renderPlot({
  validate(need(length(levels(as.factor(DF3()[, input$ty])))==2, "Please choose a binary variable as Y")) 
   #ggplot(DF3(), aes(x = DF3()[, input$tx], y = DF3()[, input$ty])) + geom_point(shape = 1) + 
   #  geom_smooth(method = lm) + xlab(input$tx) + ylab(input$ty) + theme_minimal()
   ggplot(DF3(), aes(x=DF3()[, input$tx], y=(as.numeric(as.factor(DF3()[, input$ty]))-1))) + geom_point(shape = 1) + 
  stat_smooth(method="glm", method.args=list(family="binomial"), se=FALSE) +
  xlab(input$tx) + ylab(input$ty) + theme_minimal()
   })
 
## histogram
 output$hx = renderUI({
   selectInput(
     'hx',
     tags$b('Choose a numeric variable to see the distribution'),
     selected = type.num3()[1], 
     choices = type.num3())
 })
 
output$p2 = renderPlot({
   validate(
       need(input$hx != "NULL", "Please select one numeric variable")
     )
   ggplot(DF3(), aes(x = DF3()[, input$hx])) + 
     geom_histogram(aes(y=..density..),binwidth = input$bin, colour = "black",fill = "white") + 
     geom_density()+
     xlab("") + theme_minimal() + theme(legend.title = element_blank())
   })
 
