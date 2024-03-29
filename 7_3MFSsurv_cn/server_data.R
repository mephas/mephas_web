#****************************************************************************************************************************************************

load("Surv.RData")

data <- reactive({
                switch(input$edata,
               "Diabetes" = dia.train,
               "NKI70" = nki.train
               )  
                })


DF0 = reactive({
  inFile = input$file
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
return(as.data.frame(x))
})

## variable type
type.num0 <- reactive({
colnames(DF0()[unlist(lapply(DF0(), is.numeric))])
})

output$factor1 = renderUI({
selectInput(
  'factor1',
  HTML('1. 将整数型数值变量转换为分类变量'),
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
  HTML('2. 将分类变量转换为数值变量'),
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
HTML('1. 选择一个分类变量'),
selected = NULL,
choices = type.fac2(),
multiple = TRUE
)
})

output$rmrow = renderUI({
shinyWidgets::pickerInput(
'rmrow',
h4(tags$b('删除一些样本/离群值')),
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

type.bi3 <- reactive({
  df <- DF3()
  names <- apply(df,2,function(x) { length(levels(as.factor(x)))==2 &&  max(x)==1 && min(x)==0 })
  #df <- DF3()[,names]
  #names <- apply(df,2,function(x) {  })
  x <- colnames(df)[names]
  return(x)
  })

type.time3 <- reactive({
  df <- DF3()
  names <- apply(df,2,function(x) { length(levels(as.factor(x)))>2 })
  df <- DF3()[,names,drop=FALSE]
  x <- colnames(df[unlist(lapply(df, is.numeric))])
  return(x)
  })

type.num3 <- reactive({
colnames(DF3()[unlist(lapply(DF3(), is.numeric))])
})

type.fac3 <- reactive({
colnames(DF3()[unlist(lapply(DF3(), is.factor))])
})

output$t = renderUI({
selectInput(
't',
tags$b('2.1. 选择一个时间段变量（数值型）'),
#selected = type.time3()[1],
choices = type.time3())
})

output$t1 = renderUI({
selectInput(
't1',
('2.1. 开始时间变量（数值型）'),
#selected = "NULL",
choices = type.time3())
})

type.time2 <- reactive({
  if (input$time=="B") {df <-DF3()[ ,-which(names(DF3()) %in% c(input$c,input$t1))]
  names <- apply(df,2,function(x) { length(levels(as.factor(x)))>2 })
  df <- df[,names, drop=FALSE]
  x <- colnames(df[unlist(lapply(df, is.numeric))])
  return(x)
  }
return(df)
  })

output$t2 = renderUI({
selectInput(
't2',
'2.2. 结束时间变量（数值型）',
#selected = "NULL",
choices = type.time2())
})

output$c = renderUI({
selectInput(
'c',
('1. 选择1/0删失信息变量（1 = 事件，0 = 删失）'),
#selected = type.bi3()[1],
choices = type.bi3())
})

##3. Survival Object
surv = reactive({

validate(need(input$c, "选择检查信息变量"))

if (input$time == "A"){
validate(need(!("FALSE" %in% (DF0()[,input$t]>=0)), "时间需要 >= 0"))
validate(need(input$t, "Please choose a time variable"))
y <- paste0("Surv(", input$t, ",", input$c, ")")
}
if (input$time == "B"){
#validate(need(!("FALSE" %in% (input$t2>=input$t1)), "終了時間は開始時間より大きい必要があります"))
validate(need(!("FALSE" %in% (DF0()[,input$t2] - DF0()[,input$t1]>=0)), "结束时间需要大于开始时间"))
validate(need(!("FALSE" %in% (DF0()[,input$t1]>=0)), "时间需要 >= 0"))
#validate(need(!(input$t1=="NULL"), "開始時間を選んでください"))
#validate(need(!(input$t2=="NULL"), "終了時間を選んでください"))
#validate(need(!("FALSE" %in% (DF0()[,input$t2]>=0)), "时间需要 >= 0"))

y <- paste0("Surv(", input$t1, ",", input$t2, ",", input$c, ")")
}
return(y)
})



output$surv = renderPrint({
validate(need(length(levels(as.factor(DF3()[, input$c])))==2, "打ち切り情報（二値変数）を選んでください")) 
surv()
})


output$Xdata <- DT::renderDT(
DF3(), 
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = 
      list('copy',
        list(extend = 'csv', title = "数据结果"),
        list(extend = 'excel', title = "数据结果")
        ),
      deferRender = TRUE,
      scrollX=TRUE,
      scrollY = 300,
      scroller = TRUE))



output$strnum <- renderPrint({str(DF3()[,type.num3()])})
#output$str.fac <- renderPrint({str(DF2()[,type.fac()])})
output$strfac <- renderPrint({Filter(Negate(is.null), lapply(DF3(),levels))})


sum <- reactive({
  x <- DF3()[,type.num3()]
  res <- as.data.frame(psych::describe(x))[,-c(1,6,7)]
  rownames(res) = names(x)
  colnames(res) <- c("Total Number of Valid Values", "Mean" ,"SD", "Median", "Minimum", "Maximum", "Range","Skew","Kurtosis","SE")
  return(round(res,6))
  })

output$sum <- DT::renderDT({sum()},
extensions = 'Buttons', 
options = list(
dom = 'Bfrtip',
buttons = 
      list('copy',
        list(extend = 'csv', title = "数据结果"),
        list(extend = 'excel', title = "数据结果")
        ),
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
 
 km.a = reactive({
  y <- paste0(surv(), "~1")
  fit <- survfit(as.formula(y), data = DF3())
  fit$call <- NULL
  return(fit)
})

output$km.a= renderPlot({

y <- paste0(surv(), "~1")
fit <- surv_fit(as.formula(y), data = DF3())

ggsurvplot(fit, data=DF3(),
          fun=paste0(input$fun1), 
           conf.int = TRUE,
           pval = FALSE,
           risk.table = "abs_pct",
           #surv.median.line = "hv", 
           palette = "Set1",
           #ggtheme = theme_minimal(),
           ggtheme = theme_classic(
            base_size = 11,
            base_family = "Helvetica"
            ),
           legend="bottom",
           risk.table.y.text.col = TRUE, # colour risk table text annotations.
           risk.table.y.text = FALSE) 
  })

output$kmat1= renderPrint({
(km.a())})

output$kmat= DT::renderDT({
res<- data.frame(
  time=km.a()[["time"]],
  n.risk=km.a()[["n.risk"]],
  n.event=km.a()[["n.event"]],
  n.censor=km.a()[["n.censor"]],
  surv=km.a()[["surv"]],
  lower=km.a()[["lower"]],
  upper=km.a()[["upper"]],
  std.err=km.a()[["std.err"]],
  cumhaz=km.a()[["cumhaz"]]
  #std.chaz=km.a()[["std.chaz"]],
  )
colnames(res) <- c("Time", "Number of at Risk", "Number of Event", "Number of Censor", 
  "Survival Probability", "95% CI lower limit", "95% CI upper limit",
  "SE of Surv. Prob.", "Cumulative Hazard Probability")
return(round(res,6))
},
extensions = 'Buttons', 
options = list(
dom = 'Bfrtip',
buttons = 
      list('copy',
        list(extend = 'csv', title = "数据结果"),
        list(extend = 'excel', title = "数据结果")
        ),
scrollX = TRUE)
)

 
## histogram
 output$hx = renderUI({
   selectInput(
     'hx',
     tags$b('数値変数を選択する'),
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
 
