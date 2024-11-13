
## binary outcomes

dataeg <- reactive({
  switch(input$edata,
    "data1" = data1
  )
})

output$file <- renderUI({
fileInput("file", "Choose CSV/TXT file", 
  accept = c("text/csv","text/comma-separated-values,text/plain",".csv"))
})

output$header <- renderUI({
  prettyToggle(
     inputId = "header",
     label_on = "Yes", 
     icon_on = icon("check"),
     status_on = "info",
     status_off = "warning", 
     label_off = "No",
     icon_off = icon("xmark"),
     value = TRUE
   )
})

output$col <- renderUI({
  prettyToggle(
     inputId = "col",
     label_on = "Yes", 
     icon_on = icon("check"),
     status_on = "info",
     status_off = "warning", 
     label_off = "No",
     icon_off = icon("xmark"),
     value = FALSE
   )
})

output$sep <- renderUI({
  prettyRadioButtons(
     inputId = "sep",
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

output$info <- renderUI({prettyRadioButtons(
     inputId = "quote",
     label = "Quote for characters", 
     status = "info",
     fill = TRUE,
     icon = icon("check"),
     choices = c("None" = "",
                 "Double Quote" = '"',
                 "Single Quote" = "'"),
     selected = '"')
})

data <- reactive({
  inFile <- input$file
  if (is.null(inFile)) {
    x <- as.data.frame(dataeg())
  } else {
    if (!input$col) {
      csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep, quote = input$quote, stringsAsFactors = TRUE)
    } else {
      csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep, quote = input$quote, row.names = 1, stringsAsFactors = TRUE)
    }
    validate(need(ncol(csv) > 1, "Please check the validation of your data"))
    validate(need(nrow(csv) > 1, "Please check the validation of your data"))

    x <- as.data.frame(csv)
  }
  if(input$rmdt) x <- as.data.frame(dataeg())
  return(x)
})

output$data.pre <- renderDT(
data(),
extensions = 'Scroller', 
options = list(
  deferRender = TRUE,
  scrollX = TRUE,
  scrollY = 400,
  scroller = TRUE))

## numaric variables list
type.num <- reactive({
  colnames(data()[unlist(lapply(data(), is.numeric))])
})
## binary variables
var.type.list <- reactive({
  var.class(data())
})
## binary variables list
type.bin <- reactive({
  colnames(data()[,var.type.list()[,1] %in% "binary", drop=FALSE])
  })

## choose variables
output$z1 <- renderUI({
  pickerInput(
    "z1",
    label= NULL,
    choices = type.bin(),
    width = "100%"
  )
})

type.bin.y <- reactive({
  type.bin()[!(type.bin() %in% c(input$z1))]
})

output$y1 <- renderUI({
  pickerInput(
    "y1",
    label= NULL,
    choices = type.bin.y(),
    width = "100%"
  )
})

type.num.x1 <- reactive({
  type.num()[!(type.num() %in% c(input$z1, input$y1))]
})
output$x1 <- renderUI({
  pickerInput(
    "x1",
    label= NULL,
    choices = type.num.x1(),
    selected = type.num.x1(),
    width = "100%",
    multiple = TRUE,
    options = pickerOptions(
      actionsBox = TRUE, 
      dropdownAlignRight = "auto",
      dropupAuto = FALSE)
  )
})

output$knot <- renderUI({
sliderTextInput(
  "knot", 
  label= NULL,
  choices = seq(2,10,1),
  selected=2,
  grid = TRUE #round(1+length(input$x1)^(1/5)*log(length(input$x1)))
  )
})

output$maxtune <- renderUI({
sliderTextInput(
  "maxtune", 
  label= NULL,
  choices = seq(from = 0.001,
     to = 0.01,
     by = 0.001),
  selected=c(0.001,0.005),
     grid = TRUE
  )
})

output$seqtune <- renderUI({
sliderTextInput(
  "seqtune", 
  label= NULL,
  choices = c(0.0001,0.001,0.01),
  selected=0.001,
     grid = TRUE
  )
})


Y <- reactive({(subset(data(), select=input$y1, drop = FALSE))})
Z <- reactive({(subset(data(), select=input$z1, drop = FALSE))})
X <- reactive({(subset(data(), select=input$x1, drop = FALSE))})

fit <- reactiveVal()
parfit = reactiveVal()

  shinyjs::enable("start")
  shinyjs::enable("slider")
observeEvent(input$B,{

if(input$scale) x <- normalize(as.matrix(X())) else x <- as.matrix(X())
if(is.null(input$knot)) nkt = 2 else nkt = input$knot

# withProgress(message = "Estimating (please hold on...)", value = 0.5, {
if(!input$clamb){

  fit(suppressWarnings(try(cste_bin(x = x, y = unlist(Y()), z = unlist(Z()), 
    beta_ini = NULL,
    lam = 0, 
    nknots = nkt, 
    max.iter= 1000, eps = 0.001))))
    shinyjs::enable("start")
    shinyjs::enable("slider")
  # browser()
} else {

  if(is.null(input$maxtune)) maxtune = c(0.001,0.005) else maxtune = input$maxtune
  if(is.null(input$seqtune)) seqtune = 0.001 else seqtune = input$seqtune
# browser()
  par = suppressWarnings(try(select_cste_bin(x = x, y = unlist(Y()), z = unlist(Z()), 
    beta_ini = NULL,
    lam_seq = seq(from=maxtune[1],to=maxtune[2],by=seqtune), 
    nknots = nkt, 
    max.iter =1000, eps = 0.001)))
  fit(par$optimal)
  parfit(par)
  shinyjs::enable("start")
  shinyjs::enable("slider")
}
# })

# yy1 <- unlist(Y())[unlist(Z())==1]
# xx1 <- as.matrix(X())[unlist(Z())==1,]
# ini_guess <- as.vector(summary(ppr(yy1~xx1,nterms=2))$alpha)

})


# res <- eventReactive(input$B,{
# # if(input$kh==0) kh <- 0.1 else kh <- input$kh

# progress <- Progress$new(session, min=0, max=input$knot)
# on.exit(progress$close())

# progress$set(message = 'Calculating',
#             detail = ''
#                )
# # if(input$knot==1) kh <- 0.1 else kh <- input$kh
# validate(need(!inherits(fit(), "try-error"), "All betas are 0. Decrease lambda."))

# res <- cste_bin_SCB(as.matrix(X()), fit(), h = input$kh, alpha = input$alpha)

# return(res)

# })


output$kh <- renderUI({
sliderTextInput(
  "kh", 
  label= NULL,
  choices = seq(0.001,0.1,0.001),
  selected=0.01,
  grid = TRUE,
  width ="100%"
  )
})

output$ylim1 = renderUI({
  sliderTextInput(
    "ylim1", 
    label= NULL,
  choices = seq(-50,50,1),
  selected=c(-5,5),
  grid = TRUE,
  width ="100%"
  )
})
output$xlim1 = renderUI({
  sliderTextInput(
    "xlim1", 
    label= NULL,
  choices = seq(-50,50,1),
  selected=c(0,0),
  grid = TRUE,
  width ="100%"
  )
})
output$alpha <- renderUI({
sliderTextInput(
  "alpha", 
  label= NULL,
  choices = c(0.1,0.05,0.01),
  selected=0.05,
  grid = TRUE,
  width ="50%"
  )
})

## plot for bin
res = reactiveVal()
estdf = reactiveVal()
res.plot <- eventReactive(input$Bplot1,{

# validate(need(fit()), "Error")
if(input$scale) x <- normalize(as.matrix(X())) else x <- as.matrix(X())

res <- cste_bin_SCB(x, fit(), h = input$kh, alpha = input$alpha)
res(res)
df <- data.frame(x = res$or_x, y = res$fit_x, lb = res$lower_bound, ub = res$upper_bound)
estdf(df)
if(input$xlim1[1]==input$xlim1[2]) xlim = range(df$x) else xlim=input$xlim1
ggplot(df, mapping = aes(x = x, y = y)) + 
  scale_x_continuous(limits = xlim, name = latex2exp::TeX("$X\\hat{\\beta}_1$")) +
  scale_y_continuous(limits = input$ylim1,
    name = latex2exp::TeX("$CSTE = g_1(X\\hat{\\beta}_1)$")) +
  geom_hline(yintercept=0, colour = "#53868B", lty=2)+
  geom_ribbon(mapping=aes(ymin=ub,ymax=lb, fill="Confidence band"), colour="#87cefa", alpha=0.2) +
  geom_line(aes(colour = "Fitted"))+
  theme(panel.background = element_rect(fill = "white", colour = "grey50"),
        panel.grid.major = element_line(colour = "grey87"),
        legend.key = element_rect (fill = "white"))+
  scale_colour_manual("CSTE Curve", 
                      breaks = c("Fitted"),
                      values = c("#F8766D"),
                      guide = guide_legend(override.aes = list(lty = c(1))))+
  scale_fill_manual(" ", 
                    breaks = c("Confidence band"),
                    values = c("#87cefa"),
                    guide = guide_legend(override.aes = list(color = c("#87cefa"))))

})

output$res.plot <-  renderPlot({
  res.plot()
})
output$click_info <- renderText({
    req(input$plot_click)  # Wait for the click input
    paste("Clicked at: (", round(input$plot_click$x, 3), ", ", round(input$plot_click$y, 3), ")", sep = "")
  })
# output$makeplot <- renderPlotly({
#   ggplotly(res.plot())%>%
#   layout(xaxis=list(title= "X beta_1"), yaxis=list(title = "CSTE"))
#   })

res.table12 <- eventReactive(input$Bplot1,{
validate(need(estdf(), "Model estimation failed"))
df = round(as.data.frame(t(estdf())),3)
df = df[c(4,2,1,3),]
rownames(df) <- c("Upper Bound","CSTE","Lower Bound","X*beta1")
colnames(df) <- 1:nrow(estdf())
return(df)
  
})


output$res.table12 <- renderDT(
datatable(
  res.table12(), 
  extensions = 'FixedColumns',
  options = list(
    dom = 't',
    scrollX = TRUE,
    fixedColumns = TRUE
  ))
)

res.table <- eventReactive(input$B,{
validate(need(!inherits(fit(), "try-error"), "All betas are 0. Decrease lambda."))
res <- rbind.data.frame(round(fit()$beta1,3))
rownames(res) <- c("Beta1")
colnames(res) <- input$x1
return(res)
  
})

output$res.table <- renderDT(
datatable(
  res.table(), 
  extensions = 'FixedColumns',
  options = list(
    dom = 't',
    scrollX = TRUE,
    fixedColumns = TRUE
  ))
)



res.bic <- eventReactive(input$B,{
validate(need(parfit(), ""))
# browser()
res <- data.frame(
  BIC.optimal = round(parfit()$bic,3),
  Lambda.seq = parfit()$lam_seq)
opt = which.min(parfit()$bic)
res2 = res[opt,]
rownames(res2) <- NULL
return(res2)

})

output$res.bic <- renderDT(
  {res.bic()}, 
  options = list(
    scrollX = TRUE
  )
)

## Prediction

dataeg3 <- reactive({
  switch(input$edata3,
    "data3" = data3
  )
})

output$filep <- renderUI({
fileInput("filep", "Choose CSV/TXT file", 
  accept = c("text/csv","text/comma-separated-values,text/plain",".csv"))
})

output$headerp <- renderUI({
  prettyToggle(
     inputId = "headerp",
     label_on = "Yes", 
     icon_on = icon("check"),
     status_on = "info",
     status_off = "warning", 
     label_off = "No",
     icon_off = icon("xmark"),
     value = TRUE
   )
})

output$colp <- renderUI({prettyToggle(
     inputId = "colp",
     label_on = "Yes", 
     icon_on = icon("check"),
     status_on = "info",
     status_off = "warning", 
     label_off = "No",
     icon_off = icon("xmark"),
     value = FALSE
   )
})

output$sepp <- renderUI({prettyRadioButtons(
     inputId = "sepp",
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

output$infop <- renderUI({prettyRadioButtons(
     inputId = "quote",
     label = "Quote for characters", 
     status = "infop",
     fill = TRUE,
     icon = icon("check"),
     choices = c("None" = "",
                 "Double Quote" = '"',
                 "Single Quote" = "'"),
     selected = '"')
})



datap <- reactive({
  inFile <- input$filep
  if (is.null(inFile)) {
    x <- as.data.frame(dataeg3())
  } else {
    if (!input$colp) {
      csv <- read.csv(inFile$datapath, header = input$headerp, sep = input$sepp, quote = input$quotep, stringsAsFactors = TRUE)
    } else {
      csv <- read.csv(inFile$datapath, header = input$headerp, sep = input$sepp, quote = input$quotep, row.names = 1, stringsAsFactors = TRUE)
    }
    validate(need(ncol(csv) > 1, "Please check the validation of your data"))
    validate(need(nrow(csv) > 1, "Please check the validation of your data"))

    x <- as.data.frame(csv)
  }
  if(input$prmdt) x <- as.data.frame(dataeg3())
  return(x)
})

output$data.prep <- renderDT(
{datap()},
extensions = 'Scroller', 
options = list(
  deferRender = TRUE,
  scrollX = TRUE,
  scrollY = 400,
  scroller = TRUE))


plotpar =reactiveValues()
observeEvent(input$B3,{
# browser()
newx = tryCatch(subset(datap(), select=input$x1, drop = FALSE),
  error = function(e) NULL)
validate(need(newx, 
  "Please check whether the variables of the new data are the same with the modeling data"))

# pred <- predict_cste_bin(fit(), newX)
beta <- fit()$beta1
# newx = subset(datap(), select=input$x1, drop = FALSE)
if(input$scale) newX <- normalize(as.matrix(newx)) else newX <- as.matrix(newx)
newor <- newX %*%matrix(beta, ncol=1)
res <- res()
# browser()
df <- data.frame(x = res$or_x, y = res$fit_x, lb = res$lower_bound, ub = res$upper_bound)
plotpar[["df"]] =df 
df2<- data.frame(id = seq_along(newor), x = newor)#, y = pred$g1
plotpar[["df2"]]=df2
rownames(plotpar[["df2"]]) <- seq_along(newor)

plotpar[["xlm"]] <- range(c(df$x, df2$x))
plotpar[["ylm"]] <- range(c(df$ub, df$lb, df2$y))

})


output$ylim12 = renderUI({
  sliderTextInput(
    "ylim12", 
    label= NULL,
  choices = seq(round(plotpar[["ylm"]][1]*2), round(plotpar[["ylm"]][2]*2),1),
  selected= round(plotpar[["ylm"]]),
  grid = TRUE,
  width ="100%"
  )
})
output$xlim12 = renderUI({
  sliderTextInput(
    "xlim12", 
    label= NULL,
  choices = seq(round(plotpar[["xlm"]][1]*2), round(plotpar[["xlm"]][2]*2),1),
  selected= round(plotpar[["xlm"]]),
  grid = TRUE,
  width ="100%"
  )
})

res.plotp <- eventReactive(input$B32,{
  newx = tryCatch(subset(datap(), select=input$x1, drop = FALSE),
  error = function(e) NULL)
validate(need(newx, 
  "Please check whether the variables of the new data are the same with the modeling data"))

df = plotpar[["df"]]
df2 = plotpar[["df2"]]
p <- ggplot(df, mapping = aes(x = x, y = y)) + 
  scale_x_continuous(limits = input$xlim12 , name = latex2exp::TeX("$X\\hat{\\beta}_1$")) +
  scale_y_continuous(limits = input$ylim12, name = latex2exp::TeX("$CSTE = g_1(X\\hat{\\beta}_1)$")) +
  geom_hline(yintercept=0, colour = "#53868B", lty=2)+
  geom_ribbon(mapping=aes(ymin=ub,ymax=lb, fill="Confidence band"), colour="#87cefa", alpha=0.1) +
  geom_line(aes(colour = "Fitted"))+
  geom_vline(data = df2, aes(xintercept = x, colour = "Predicted",group = id), lty=2)+
  # geom_point(data = df2, mapping = aes(x = x, y = y, colour = "Predicted", group = id), shape = 1, size=2)+
  theme(panel.background = element_rect(fill = "white", colour = "grey50"),
        panel.grid.major = element_line(colour = "grey87"),
        legend.key = element_rect (fill = "white"))+
  scale_colour_manual("CSTE Curve", 
                      breaks = c("Fitted", "Predicted"),
                      values = c("#F8766D", "#6495ed"),
                      guide = guide_legend(override.aes = list(lty = c(1, 2))))+
  scale_fill_manual(" ", 
                    breaks = c("Confidence band"),
                    values = c("#87cefa"),
                    guide = guide_legend(override.aes = list(color = c("#87cefa"))))

return(p)
})

output$res.plotp <-  renderPlot({
  res.plotp()
})

output$click_info2 <- renderText({
    req(input$plot_click2)  # Wait for the click input
    paste("Clicked at: (", round(input$plot_click2$x, 3), ", ", round(input$plot_click2$y, 3), ")", sep = "")
  })

# output$makeplotp <- renderPlotly({
#   ggplotly(res.plotp())%>%
#   layout(xaxis=list(title= "X beta_1"), yaxis=list(title = "CSTE"))
#   })

res.tablep <- eventReactive(input$B3,{
newx = tryCatch(subset(datap(), select=input$x1, drop = FALSE),
  error = function(e) NULL)
validate(need(newx, 
  "Please check whether the variables of the new data are the same with the modeling data"))

if(input$scale) newX <- normalize(as.matrix(newx)) else newX <- as.matrix(newx)

  beta <- fit()$beta1
  res <- data.frame(
    ID=1:nrow(newX),
    pred = round(newX %*%matrix(beta, ncol=1), 3))
  sorted_data <- res[order(res$pred), ]
  res2 = as.data.frame(t(sorted_data))
  colnames(res2) <- paste0("Order",1:nrow(newX))
  rownames(res2) <- c("ID","Predicted (newx*beta_1)")
  return(res2)
  
})

output$res.tablep <- renderDT(
datatable(
  res.tablep(), 
  extensions = 'FixedColumns',
  options = list(
    dom = 't',
    scrollX = TRUE,
    fixedColumns = TRUE
  ))

)


