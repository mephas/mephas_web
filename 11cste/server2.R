
## survival outcomes

dataeg2 <- reactive({
  switch(input$edata2,
    "data2" = data2
  )
})

output$file2 <- renderUI({
fileInput("file2", "Choose CSV/TXT file", 
  accept = c("text/csv","text/comma-separated-values,text/plain",".csv"))
})

output$header2 <- renderUI({
  prettyToggle(
     inputId = "header2",
     label_on = "Yes", 
     icon_on = icon("check"),
     status_on = "info",
     status_off = "warning", 
     label_off = "No",
     icon_off = icon("xmark"),
     value = TRUE
   )
})

output$col2 <- renderUI({prettyToggle(
     inputId = "col2",
     label_on = "Yes", 
     icon_on = icon("check"),
     status_on = "info",
     status_off = "warning", 
     label_off = "No",
     icon_off = icon("xmark"),
     value = FALSE
   )
})

output$sep2 <- renderUI({prettyRadioButtons(
     inputId = "sep2",
     label = "Separator for data", 
     status = "info",
     fill = TRUE,
     icon = icon("check"),
     choiceNames = list(
       HTML("Comma (,): CSV default"),
       HTML("One Tab (->|): TXT default"),
       HTML("Semicolon (;)"),
       HTML("One Space (_)")
     ),
     choiceValues = list(",", "\t", ";", " ")
   )
})

output$info2 <- renderUI({prettyRadioButtons(
     inputId = "quote2",
     label = "Quote for characters", 
     status = "info",
     fill = TRUE,
     icon = icon("check"),
     choices = c("None" = "",
                 "Double Quote" = '"',
                 "Single Quote" = "'"),
     selected = '"')
})

data_2 <- reactive({
  inFile <- input$file2
  if (is.null(inFile)) {
    x <- as.data.frame(dataeg2())
  } else {
    if (!input$col2) {
      csv <- read.csv(inFile$datapath, header = input$header2, sep = input$sep2, quote = input$quote2, stringsAsFactors = TRUE)
    } else {
      csv <- read.csv(inFile$datapath, header = input$header2, sep = input$sep2, quote = input$quote2, row.names = 1, stringsAsFactors = TRUE)
    }
    validate(need(ncol(csv) > 1, "Please check the validation of your data"))
    validate(need(nrow(csv) > 1, "Please check the validation of your data"))

    x <- as.data.frame(csv)
  }
  if(input$rmdt_sv) x <- as.data.frame(dataeg2())
  return(x)
})

output$data.pre2 <- renderDT(
{data_2()},
extensions = 'Scroller', 
options = list(
  deferRender = TRUE,
  scrollX = TRUE,
  scrollY = 400,
  scroller = TRUE))

## numaric variables list
type.num2 <- reactive({
  colnames(data_2()[unlist(lapply(data_2(), is.numeric))])
})
## binary variables
var.type.list2 <- reactive({
  var.class(data_2())
})
## binary variables list
# output$ztype <- renderUI({
# radioGroupButtons(
#    inputId = "ztype",
#    label = NULL,
#    choices = list("Single treatment variable"=FALSE, "Multiple treatment variables"=TRUE),
#    selected=FALSE,
#    justified = TRUE
# )
# })

type.bin2 <- reactive({
  colnames(data_2()[,var.type.list2()[,1] %in% "binary", drop=FALSE])
  })
output$z2 <- renderUI({
  pickerInput(
    "z2",
    label= NULL,
    choices = type.bin2(),
    selected= (if(input$ztype=="TRUE") type.bin2()[1:2] else type.bin2()[1]),
    width = "100%",
    multiple = (if(input$ztype=="TRUE") TRUE else FALSE)
  )
})
type.bin.d <- reactive({
  type.bin2()[!(type.bin2() %in% c(input$z2))]
})
output$d2 <- renderUI({
  pickerInput(
    "d2",
    label= NULL,
    choices = type.bin.d(),
    width = "100%"
  )
})
type.num.t <- reactive({
  type.num2()[!(type.num2() %in% c(input$z2, input$d2))]
})
output$t2 <- renderUI({
  pickerInput(
    "t2",
    label= NULL,
    choices = type.num.t(),
    width = "100%"
  )
})
type.num.x2 <- reactive({
  type.num2()[!(type.num2() %in% c(input$z2, input$d2, input$t2))]
})
output$x2 <- renderUI({
  pickerInput(
    "x2",
    label= NULL,
    choices = type.num.x2(),
    width = "100%")
})

output$c2 <- renderUI({
  textInput('c2', label = NULL, "1, 0")
})

output$alpha2 <- renderUI({
sliderTextInput(
  "alpha2", 
  label= NULL,
  choices = c(0.1,0.05,0.01),
  selected=0.05,
  grid = TRUE,
  width ="100%"
  )
})
output$kh2 <- renderUI({
sliderTextInput(
  "kh2", 
  label= NULL,
  choices = seq(0.05,1,0.01),
  selected=0.5,
  grid = TRUE,
  width ="100%"
  )
})
output$m2 <- renderUI({
sliderTextInput(
  "m2", 
  label= NULL,
  choices = seq(10,200,10),
  selected=50,
  grid = TRUE,
  width ="100%"
  )
})


Y2 <- reactive({(subset(data_2(), select=input$t2, drop = FALSE))})
Z2 <- reactive({(subset(data_2(), select=input$z2, drop = FALSE))})
S2 <- reactive({(subset(data_2(), select=input$d2, drop = FALSE))})
X2 <- reactive({(subset(data_2(), select=input$x2, drop = FALSE))})


  # fit2 <- eventReactive(input$B2,{
  # validate(need(z2(), "Choose Treatment variable"))

  # fit <- cste_surv(x = unlist(X2()), y = unlist(Y2()), z = as.matrix(Z2()), s = unlist(S2()), h = input$kh2)
  # return(fit)
  # })
res2 = reactiveVal()
res2plot = reactiveVal()
c2text = reactiveVal()
plotparsv = reactiveValues()

observeEvent(input$B2,{
# browser()
shinyjs::disable("B2")
shinyjs::disable("Bplot1_sv")

  validate(need(input$z2, "Choose Treatment variable"))
  # validate(need(input$ztype=="TRUE" & is.null(input$c2), "Please check the contrast vector for the multiple treatments"))
# validate(need(length(input$c2) == length(input$z2), "Please check the length of contrast vector"))
  if(length(input$z2)==1) c2=1 else c2 <- as.numeric(unlist(strsplit(input$c2,",")))
  validate(need(length(c2) == length(input$z2), "Please check the length of contrast vector"))


  if(is.null(input$alpha2)) aa=0.05 else aa = input$alpha2
  if(is.null(input$m2)) mm=50 else mm = input$m2
  if(is.null(input$kh2)) hh=0.5 else hh = input$kh2

# browser()
  c2text(c2)
  
  X2 = (X2() - min(X2())) / (max(X2()) - min(X2()))
  res <- cste_surv_SCB((c2),
    x = unlist(X2), y = unlist(Y2()), z = as.matrix(Z2()), s = unlist(S2()), 
    h = hh, m = mm, alpha = aa)  

res2(res)

ord = order(unlist(X2))
x <- unlist(X2())
df <- data.frame(x = x[ord], y = res[ord,2], lb = res[ord,1], ub = res[ord,3])
res2plot(df)

plotparsv[["xlm"]] <- range(c(df$x))
plotparsv[["ylm"]] <- range(c(df$ub, df$lb))

shinyjs::enable("B2")
shinyjs::enable("Bplot1_sv")
# browser()
  })


res.table2 <- eventReactive(input$B2,{

shinyjs::disable("B2")
# shinyjs::disable("Bplot1_sv")
validate(need(input$z2, "Choose Treatment variable"))
# validate(need(input$ztype=="TRUE" & is.null(input$c2), "Please check the contrast vector for the multiple treatments"))

if(length(input$z2)==1) c2=1 else c2 <- as.numeric(unlist(strsplit(input$c2,",")))
validate(need(length(c2) == length(input$z2), "Please check the length of contrast vector"))
# validate(need(length(input$c2) == length(input$z2), "Please check the length of contrast vector"))

validate(need(res2(), "Model estimation error"))
res <- rbind.data.frame(unlist(X2()),as.data.frame(t(res2())))
# browser()
res <- round(res, 3)
colnames(res) <- 1:ncol(res)
rownames(res) <- c("X", "Lower bound", "CSTE", "Upper bound")
return(res[c(4,3,2,1),])

shinyjs::enable("B2")
# shinyjs::enable("Bplot1_sv")
  })

output$res.table2 <- renderDT(
datatable(
  res.table2(), 
  extensions = c('Buttons','FixedColumns'),
  options = list(
    # dom = 't',
    dom = 'Bfrtip',
    buttons = list(list(
        extend = 'csv',  # 'csv' button
        filename = 'cste-estimate-result',  # Custom file name
        text = 'Download CSV'  # Button label (optional)
      )),
    fixedColumns = TRUE,
    scrollX = TRUE
  ))
)

output$actionButtonBplot1_sv <- renderUI({
    req(res2())  # Ensure model_result is not NULL
    actionButton("Bplot1_sv", HTML('Show/Update the estimated CSTE curve'), 
             class =  "btn-secondary",
             icon  = icon("chart-column"))
  })

output$ylim1_sv = renderUI({
  sliderTextInput(
    "ylim1_sv", 
    label= NULL,
  choices = round(seq(max(round(-5+plotparsv[["ylm"]][1]*2),-100), min(5+round(plotparsv[["ylm"]][2]*2),100),0.2),2),
  selected= round(plotparsv[["ylm"]]),
  grid = TRUE,
  width ="100%"
  )
})
output$xlim1_sv = renderUI({
  sliderTextInput(
    "xlim1_sv", 
    label= NULL,
  choices = round(seq(-5+round(plotparsv[["xlm"]][1]*2), 5+round(plotparsv[["xlm"]][2]*2),0.2),2),
  selected= round(plotparsv[["xlm"]]),
  grid = TRUE,
  width ="100%"
  )
})

## plot for surv
res.plot2 <- eventReactive(input$Bplot1_sv,{
# validate(need(input$z2, "Choose Treatment variable"))
# validate(need(input$c2, "Please check the contrast vector"))
# c2 <- as.numeric(unlist(strsplit(input$c2,",")))
# validate(need(length(c2) == length(input$z2), "Please check the length of contrast vector"))
req(res2())
validate(need(res2(), "Model estimation failed; please check the input of variables"))
# res <- res2()
# ord = order(unlist(X2()))
# x <- unlist(X2())
# plot(x[ord], res[ord,2],
# col = '#F8766D', type = "l", ylim=c(-4,2.5),
# lwd = 2.5, lty = 3,
# ylab=expression(beta[1](x)), xlab = expression(X))
# lines(x[ord], res[ord,1], lwd = 2,
# col = '#00BFC4', lty = 2)
# lines(x[ord], res[ord,3], lwd = 2,
# col = '#00BFC4', lty = 2)
# # lines(x[ord], beta[ord,1], col='blue')
# legend("topright",
# legend = c("Estimates", "95% SCB"),
# lwd = c(2.5,2), lty = c(3, 2),
# col = c('#F8766D','#00BFC4','blue'))
# abline(h = 0, col= "grey", type = 2)
# df <- data.frame(x = x[ord], y = res[ord,2], lb = res[ord,1], ub = res[ord,3])

df = res2plot()
if((input$xlim1_sv[1]==input$xlim1_sv[2])||is.null(input$xlim1_sv)) xlim = range(df$x) else xlim=input$xlim1_sv
if((input$ylim1_sv[1]==input$ylim1_sv[2])||is.null(input$ylim1_sv)) ylim = c(-5,5) else ylim=input$ylim1_sv
# xlim = input$xlim1_sv
# ylim = input$ylim1_sv
ggplot(df, mapping = aes(x = x)) + 
  scale_x_continuous(limits = xlim, name = "X") +
  scale_y_continuous(limits = ylim, name = latex2exp::TeX("CSTE = $c^T \\beta(X)$")) +
  geom_hline(yintercept=0, colour = "#53868B", lty=2)+
  # geom_ribbon(mapping=aes(ymin=ub,ymax=lb, fill="Confidence band"), colour="#87cefa", alpha=0.2) +
  geom_line(aes(y = y, colour = "Fitted"), na.rm = TRUE)+
  geom_line(aes(y=ub, colour = "Confidence band"), na.rm = TRUE)+
  geom_line(aes(y=lb, colour = "Confidence band"), na.rm = TRUE)+
  theme(panel.background = element_rect(fill = "white", colour = "grey50"),
        panel.grid.major = element_line(colour = "grey87"),
        legend.key = element_rect (fill = "white"),
        legend.position = "bottom")+
  scale_colour_manual("CSTE Curve", 
                      breaks = c("Fitted","Confidence band"),
                      values = c("#F8766D","#87cefa"),
                      guide = guide_legend(override.aes = list(lty = c(1,1))))
  # scale_fill_manual(" ", 
  #                   breaks = c("Confidence band"),
  #                   values = c("#87cefa"),
  #                   guide = guide_legend(override.aes = list(color = c("#87cefa"))))

})

output$res.plot2 <-  renderPlot({
  res.plot2()
})

output$downloadPlot1_sv <- downloadHandler(
    filename = function() {
      paste("plot-cste-surv-estimate-", Sys.Date(), ".png", sep = "")
    },
    content = function(file) {
      # Create the plot and save it as PNG
      ggsave(file, plot = res.plot2(), device = "png", width = 8, height = 6)
    }
  )
output$click_info_sv <- renderText({
    req(input$plot_click_sv)  # Wait for the click input
    paste("Clicked at: (", round(input$plot_click_sv$x, 3), ", ", round(input$plot_click_sv$y, 3), ")", sep = "")
  })

output$c2text <- renderText({
    req(c2text())  # Wait for the click input
    paste("The contrast vector is (", paste0(as.character(c2text()), collapse = ","),")")
  })

output$makeplot2 <- renderPlotly({
  req(res.plot2())
  ggplotly(res.plot2())%>%
  layout(xaxis=list(title= "X"), yaxis=list(title = "CSTE"))
  })