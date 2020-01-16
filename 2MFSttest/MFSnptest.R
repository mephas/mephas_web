##' See https://alain003.phs.osaka-u.ac.jp/mephas_web/3MFSnptest/
##'
##' MFSnptest includes Non-parametric test of
##' (1) one sample,
##' (2) two independent samples,
##' and (3) two paried samples.
##'
##' Help file: https://alain003.phs.osaka-u.ac.jp/mephas/help3.html
##'
##' @title MEPHAS: Non-parametric Test (Hypothesis Testing)
##'
##' @return The web-based GUI and interactive interfaces

##' @import shiny
##' @import ggplot2
##' @import stats
##'
##' @importFrom gridExtra grid.arrange
##' @importFrom reshape melt
##' @importFrom psych describe
##' @importFrom exactRankTests wilcox.exact
##' @importFrom DT datatable dataTableOutput renderDataTable

##' @examples
##' # mephas::MFSnptest()
##' #
##' # library(mephas)
##' # MFSnptest()


##' @export
MFSnptest <- function(){

ui <- tagList(

navbarPage(

title = "Wilcoxon Test for Median",  

##---------- Panel 1 ----------
tabPanel("One Sample",

headerPanel("Wilcoxon Signed-Rank Test for One Sample"),

HTML(
    "    
<p>This is an alternative to one-sample t-test, when the data cannot be assumed to be normally distributed.
This method is based on the ranks of observations rather than on their true values</p>

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To determine if the median / location of the population from which your data is drawn statistically significantly different from the specified median
<li> To know the basic descriptive statistics about your data
<li> To know the descriptive statistics plot such as box-plot, distribution histogram, and density distribution plot about your data  
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data contain only 1 group of values (or 1 numeric vector)
<li> Your data are meaningful to measure the distance from the specified median
<li> The values are independent observations
<li> No assumption on the distributional shape of your data, which means your data may be not normally distributed
</ul> 

<i><h4>Case Example</h4>
Suppose we collected the Depression Rating Scale (DRS) measurements of 9 patients from a certain group of patients. DRS Scale > 1 indicated Depression.
We wanted to know if the DRS of patients was significantly greater than 1. 
</h4></i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
    

    "
    ),

hr(),
ui.np1(),
hr()
),

##---------- Panel 2 ----------

tabPanel("Two Samples",

headerPanel("Wilcoxon Rank-Sum Test (Mann–Whitney U test) for Two Independent Samples"),

HTML(
    "
<p>This is an alternative to two-sample t-test, when the data cannot be assumed to be normally distributed</p>

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To determine if the medians of two population from which your 2 groups data drawn are statistically significantly different from each other
<li> To determine if the distributions of 2 groups of data differ in locations
<li> To know the basic descriptive statistics about your data
<li> To know the descriptive statistics plot such as box-plot, distribution histogram, and density distribution plot about your data  
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data contain only 2 group of values (or 2 numeric vectors) 
<li> Your data are meaningful to measure the distance between 2 groups values
<li> The values are independent observations
<li> No assumption on the distributional shape of your data
<li> Your data may be not normally distributed
</ul> 

<i><h4>Case Example</h4>
Suppose we collected the Depression Rating Scale (DRS) measurements of 19 patients from a certain group of patients. Among 19 people, 9 were women, and 10 were men.
We wanted to know if the DRS of patients was significantly different among different genders; or, whether age was related to DRS scores. 
</h4></i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>

    "
    ),

hr(),
ui.np2(),
hr()

),

##---------- Panel 3 ----------

tabPanel("Paired Samples",    

headerPanel("Wilcoxon Signed-Rank Test for Two Paired Samples"),

HTML(
    "
<b>In paired case, we compare the differences of 2 groups to zero. Thus, it becomes a one-sample test problem.</b>
<p>This is an alternative to paired-sample t-test, when the data cannot be assumed to be normally distributed</p>

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To determine if the difference of paired data is statistically significantly different from 0
<li> To know the basic descriptive statistics about your data
<li> To know the descriptive statistics plot such as box-plot, distribution histogram, and density distribution plot about your data  
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data contain 2 group of values (or 2 numeric vectors)
<li> Your data are meaningful to measure the distance from the specified median
<li> The values are paired or matched observations
<li> No assumption on the distributional shape of your data
<li> Your data may be not normally distributed
</ul> 

<h4><b> 3. Examples for Matched or Paired Data </b></h4>
<ul>
<li>  One person's pre-test and post-test scores 
<li>  When there are two samples that have been matched or paired
</ul>  


<i><h4>Case Example</h4>
Suppose we collected the Depression Rating Scale (DRS) measurements of 9 patients from a certain group of patients. We decided to give them some treatment, and after the treatment we tested the DRS again.
We wanted to know if the DRS of patients before and after were significantly; or, whether the differences were significantly different from 0, which could indicate if the treatment was effective.
</h4></i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>    
"
    ),

hr(),
ui.np3(),
hr()

),

##########----------##########----------##########
stop(),
tabPanel((a("Help",
            target = "_blank",
            style = "margin-top:-30px; color:DodgerBlue",
            href = paste0("https://alain003.phs.osaka-u.ac.jp/mephas/","help3.html"))))

))

##########----------##########----------##########
##########----------##########----------##########

server <- function(input, output) {

##p1----------
names1 <- reactive({
  x <- unlist(strsplit(input$cn, "[\n]"))
  return(x[1])
  })


  A <- reactive({
    inFile <- input$file
  if (is.null(inFile)) {
    # input data
    x <- as.numeric(unlist(strsplit(input$a, "[,;\n\t]")))
    x <- as.data.frame(x)
    colnames(x) = names1()
    }
else {
    csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep)
    x <- data.frame(x=csv[,1])
    colnames(x) <- names(csv)[1]
    if(input$header!=TRUE){
      colnames(x) <- names1()
      }
    }
    return(as.data.frame(x))
  })

  #table 
output$table <-renderDT({datatable(A() ,rownames = TRUE)})

  A.des <- reactive({
    x <- A()
    res <- as.data.frame(t(psych::describe(x))[-c(1,6,7), ])
    colnames(res) = names(x)
    rownames(res) <- c("Total Number of Valid Values", "Mean" ,"SD", "Median", "Minimum", "Maximum", "Range","Skew","Kurtosis","SE")
    return(res)
  })

  output$bas <- renderTable({  
    res <- A.des()
    }, width = "500px", rownames = TRUE, colnames = TRUE)


  output$download1b <- downloadHandler(
    filename = function() {
      "des.csv"
    },
    content = function(file) {
      write.csv(A.des(), file, row.names = TRUE)
    }
  )

  #plot
   output$bp = renderPlot({
    x = A()
    ggplot(x, aes(x = 0, y = x[,1])) + geom_boxplot(width = 0.2, outlier.colour = "red", outlier.size = 2) + xlim(-1,1)+
    ylab("") + xlab("") + ggtitle("") + theme_minimal()+ theme(legend.title=element_blank())}) 
  
  output$info <- renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0("The approximate value: ", round(e$y, 4))
    }
    paste0("Horizontal position", "\n", xy_str(input$plot_click))})

  output$makeplot <- renderPlot({  #shinysession 
    x <- A()
    plot1 <- ggplot(x, aes(x = x[,1])) + geom_histogram(colour="black", fill = "grey", binwidth=input$bin, position="identity") + xlab("") + ggtitle("Histogram") + theme_minimal() + theme(legend.title=element_blank())
    plot2 <- ggplot(x, aes(x = x[,1])) + geom_density() + ggtitle("Density Plot") + xlab("") + theme_minimal() + theme(legend.title=element_blank())
    grid.arrange(plot1, plot2, ncol=2)  })
  

  ws.test<- reactive({
    x <- A()
    if (input$alt.md =="a"){
    res <- wilcox.test((x[,1]), mu = input$med, 
      alternative = input$alt.wsr, exact=NULL, correct=TRUE, conf.int = TRUE)
  }
    if (input$alt.md =="b") {
    res <- wilcox.test((x[,1]), 
      mu = input$med, 
      alternative = input$alt.wsr, exact=NULL, correct=FALSE, conf.int = TRUE)
  }
  if (input$alt.md =="c")  {
    res <- exactRankTests::wilcox.exact(x[,1], mu = input$med, 
      alternative = input$alt.wsr, exact=TRUE, conf.int = TRUE)

  }
  
    res.table <- t(data.frame(W = res$statistic,
                              P = res$p.value,
                              EM = res$estimate,
                              CI = paste0("(",round(res$conf.int[1], digits = 4),", ",round(res$conf.int[2], digits = 4), ")")))
    colnames(res.table) <- res$method
    rownames(res.table) <- c("W Statistic", "P Value","Estimated Median","95% Confidence Interval")

    return(res.table)
    })

  output$ws.test.t <- renderTable({ws.test()},
    width = "500px", rownames = TRUE, colnames = TRUE)


output$download1 <- downloadHandler(
    filename = function() {
      "ws.csv"
    },
    content = function(file) {
      write.csv(ws.test(), file, row.names = TRUE)
    }
  )

##p2----------
names2 <- reactive({
  x <- unlist(strsplit(input$cn2, "[\n]"))[1:2]
  return(x)
  })

B <- reactive({
  inFile <- input$file2
  if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$x1, "[,;\n\t]")))
    Y <- as.numeric(unlist(strsplit(input$x2, "[,;\n\t]")))
    x <- data.frame(X = X, Y = Y)
    colnames(x) = names2()
    }
  else {
    x <- read.csv(inFile$datapath, header = input$header2, sep = input$sep2)[,1:2]
    x <- as.data.frame(x)
    if(input$header2!=TRUE){
      colnames(x) = names2()
      }
    }
    return(as.data.frame(x))
})

output$table2 <-DT::renderDataTable({datatable(B() ,rownames = TRUE)})

  B.des <- reactive({
    x <- B()
    res <- as.data.frame(t(psych::describe(x))[-c(1,6,7), ])
    colnames(res) = names(x)
    rownames(res) <- c("Total Number of Valid Values", "Mean" ,"SD", "Median", "Minimum", "Maximum", "Range","Skew","Kurtosis","SE")
    return(res)
  })
  output$bas2 <- renderTable({  ## don't use renerPrint to do renderTable
    res <- B.des()}, width = "500px", rownames = TRUE, colnames = TRUE)


  output$download2b <- downloadHandler(
    filename = function() {
      "desc2.csv"
    },
    content = function(file) {
      write.csv(B.des(), file, row.names = TRUE)
    }
  )

  #plot
  output$bp2 = renderPlot({
    x <- B()
    mx <- melt(B(), idvar = colnames(x))
    ggplot(mx, aes(x = variable, y = value, fill=variable)) + geom_boxplot(alpha=.3, width = 0.2, outlier.color = "red", outlier.size = 2)+ 
    ylab("") + ggtitle("") + theme_minimal() + theme(legend.title=element_blank()) })

  output$info2 <- renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0("The approximate value: ", round(e$y, 4))
    }
    paste0("Horizontal position", "\n", xy_str(input$plot_click2))})

  output$makeplot2 <- renderPlot({
    x <- B()
    mx <- melt(B(), idvar = colnames(x))
    # density plot
    plot1 <- ggplot(mx, aes(x=mx[,"value"], fill=mx[,"variable"])) + geom_histogram(binwidth=input$bin2, alpha=.5, position="identity") + xlab("")+ylab("") + ggtitle("") + theme_minimal()+ theme(legend.title=element_blank())
    plot2 <- ggplot(mx, aes(x=mx[,"value"], colour=mx[,"variable"])) + geom_density()+ xlab("")+ ylab("") + ggtitle("") + theme_minimal()+ theme(legend.title=element_blank())
    grid.arrange(plot1, plot2, ncol=2)  })

#test
  mwu.test <- reactive({
    x <- B()
     if (input$alt.md2 =="a"){
    res <- wilcox.test(x[,1], x[,2], 
      alternative = input$alt.wsr2, exact=NULL, correct=TRUE, conf.int = TRUE)
  }
    if (input$alt.md2 =="b") {
    res <- wilcox.test(x[,1], x[,2], 
      alternative = input$alt.wsr2, exact=NULL, correct=FALSE, conf.int = TRUE)
  }
  if (input$alt.md2 =="c")  {
    res <- exactRankTests::wilcox.exact(x[,1], x[,2],  
      alternative = input$alt.wsr2, exact=TRUE, conf.int = TRUE)

  }
  
    res.table <- t(data.frame(W = res$statistic,
                              P = res$p.value,
                              EM = res$estimate,
                              CI = paste0("(",round(res$conf.int[1], digits = 4),", ",round(res$conf.int[2], digits = 4), ")")))
    colnames(res.table) <- res$method
    rownames(res.table) <- c("W Statistic", "P Value","Estimated Median","95% Confidence Interval")

    return(res.table)
    })

  output$mwu.test.t<-renderTable({
    mwu.test()}, width = "500px", rownames = TRUE)

  output$download2.1 <- downloadHandler(
    filename = function() {
      "mwu.csv"
    },
    content = function(file) {
      write.csv(mwu.test(), file, row.names = TRUE)
    }
  )
##p3----------
names3 <- reactive({
  x <- unlist(strsplit(input$cn3, "[\n]"))
  return(x[1:3])
  })

  C <- reactive({
    inFile <- input$file3
    if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$y1, "[,;\n\t]")))
    Y <- as.numeric(unlist(strsplit(input$y2, "[,;\n\t]")))
    d <- round(X-Y,4)
    x <- data.frame(X =X, Y = Y, diff = d)
    colnames(x) = names3()
  }

    else {
      x <- read.csv(inFile$datapath, header=input$header3, sep=input$sep3)[,1:2]
      x <- as.data.frame(x)
      x$diff <- round(x[, 2] - x[, 1],4)
      if(input$header3!=TRUE){
      colnames(x) = names3()
      }
      } 
    return(as.data.frame(x))
    })
  
  #table
output$table3 <-DT::renderDataTable({datatable(C() ,rownames = TRUE)})

  C.des <- reactive({
    x<- C()
    res <- as.data.frame(t(psych::describe(x))[-c(1,6,7), ])
    colnames(res) = names(x)
    rownames(res) <- c("Total Number of Valid Values", "Mean" ,"SD", "Median", "Minimum", "Maximum", "Range","Skew","Kurtosis","SE")
    return(res)
  })

  output$bas3 <- renderTable({  ## don't use renerPrint to do renderTable
    res <- C.des()}, width = "500px", rownames = TRUE, colnames = TRUE)
  
  output$download3b <- downloadHandler(
    filename = function() {
      "desc3.csv"
    },
    content = function(file) {
      write.csv(C.des(), file, row.names = TRUE)
    }
  )
  # plots
  output$bp3 = renderPlot({
    x <- C()
    ggplot(x, aes(x = 0, y = x[,3])) + geom_boxplot(width = 0.2, outlier.color = "red") + xlim(-1,1)+
    ylab("") + ggtitle("") + theme_minimal()})

  output$info3 <- renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0("The approximate value: ", round(e$y, 4))
    }
    paste0("Horizontal position", "\n", xy_str(input$plot_click3))})

  output$makeplot3 <- renderPlot({
    x <- C()
    plot1 <- ggplot(x, aes(x=x[,3])) + geom_histogram(colour="black", fill = "grey", binwidth=input$bin3, alpha=.5, position="identity") + ylab("Frequncy") + xlab("") +  ggtitle("Histogram") + theme_minimal() + theme(legend.title=element_blank())
    plot2 <- ggplot(x, aes(x=x[,3])) + geom_density() + ggtitle("Density Plot") + theme_minimal() + ylab("Density") + xlab("") + theme(legend.title=element_blank())
    grid.arrange(plot1, plot2, ncol=2)  })

psr.test <- reactive({
  x <- C()
  if (input$alt.md3 =="a"){
    res <- wilcox.test(x[,1], x[,2], paired = TRUE,
      alternative = input$alt.wsr3, exact=NULL, correct=TRUE, conf.int = TRUE)
  }
    if (input$alt.md3 =="b") {
    res <- wilcox.test(x[,1], x[,2], paired = TRUE,
      alternative = input$alt.wsr3, exact=NULL, correct=FALSE, conf.int = TRUE)
  }
  if (input$alt.md3 =="c")  {
    res <- exactRankTests::wilcox.exact(x[,1], x[,2],  paired = TRUE,
      alternative = input$alt.wsr3, exact=TRUE, conf.int = TRUE)

  }
    res.table <- t(data.frame(W = res$statistic,
                              P = res$p.value,
                              EM = res$estimate,
                              CI = paste0("(",round(res$conf.int[1], digits = 4),", ",round(res$conf.int[2], digits = 4), ")")))
    colnames(res.table) <- res$method
    rownames(res.table) <- c("W Statistic", "P Value","Estimated Median","95% Confidence Interval")

    return(res.table)
    })

  output$psr.test.t <- renderTable({
    psr.test()}, width = "500px", rownames = TRUE)

  
output$download3.2 <- downloadHandler(
    filename = function() {
      "psr.csv"
    },
    content = function(file) {
      write.csv(psr.test(), file, row.names = TRUE)
    }
  )

##########----------##########----------##########

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })
}

app <- shinyApp(ui = ui, server = server)
runApp(app, quiet = TRUE)

##########----------##########----------##########

}

