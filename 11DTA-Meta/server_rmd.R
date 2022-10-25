#RMD====
rmd<-reactive({
paste0("---
title: 'DTA'
author: 'mochi'
output: html_document
date: '`r format(Sys.Date())`'
---

```{r setup, include=FALSE}
library(knitr)
library(kableExtra)
library(latex2exp)
library(mvmeta)
library(meta)
library(mada)
knitr::opts_chunk$set(echo = TRUE)
```

# TABLE: ESTIMATES

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:

```{r}
prob<- c(",paste(p.seq(),collapse =","),")

```

## Including Plots

You can also embed plots, for example:

```{r pressure, echo=FALSE}
plot(pressure)
```

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.
"
)})
#rmd_read<-reactive(readLines("ReproduceScript.Rmd"))

Rmd<-reactive({

  p<-paste(p.seq(),collapse=",")
  sauc.type<-input$Sauc1
  file<-input$filer
  if(is.null(file)) filename<-"filename"
  else filename<-basename(input$filer$datapath)
  # sprintf(,p,sauc.type,filename)
  # paste(rmd_read(),collapse="\n")
  val<-0
  value<-c(input$Rmd_title,input$Rmd_document,p,sauc.type,filename)
  con_file <- file(description = "ReproduceScript.Rmd", open = "r")
  # lines<-sapply(1:120, function(x) {
  #   line <- readLines(con_file, n = 1)
  #   if(length(line) == 0) break
  #   if(length(grep("%s",line))>0) {
  #     val<<-val+1
  #     return(sprintf(line,value[val]))
  #   }
  #   line
  #   }) 
  lines<-NULL
  while(TRUE){
    line <- readLines(con_file, n = 1)
    if(length(line) == 0) break
    if(length(grep("%s",line))>0) {
      val<-val + 1
      lines<-c(lines,sprintf(line,value[val]))
      next
    }
    lines<-c(lines,line)
  }
  close(con_file)
  paste(lines,collapse="\n")
  })
output$rmd<-reactive(Rmd())
output$rmddownload<-downloadHandler(
  filename = input$rmdname,
  content = function(file){
    cat(Rmd(),file=file)
  }
)
#=======
output$htmldownload <- downloadHandler(
  # For PDF output, change this to "report.pdf"
  
  filename = input$htmlname,
  
  content = function(file) {
    
    tempReport <- file.path(tempdir(), "HTML-Example-IVD.Rmd")
    file.copy("HTML-Example-IVD.Rmd", tempReport, overwrite = TRUE)
    params <- list(n="mo",p = p.seq(),data=data(),sauc=input$Sauc1)
    
    progress <- shiny::Progress$new()
    on.exit(progress$close())
    progress$set(message = "Result", value = 0)
    progress$inc(0.70, detail = "generating Rmarkdown file")
    rmarkdown::render(tempReport, output_file = file,
                      params = params,
                      envir = new.env(parent = globalenv())
    )
  }
)
  observe({
    showModal(modalDialog(
      title = "Create",
      easyClose = FALSE,
      p(tags$strong("Set Value On the Website"), "Please edit the data-set",br(),
        tags$i(tags$u("download as"))),
      textInput("rmdname",value = "report.RMD",label = "file name"),
      br(),downloadButton("rmddownload","download")
      ,tags$style("#rmddownload {
                   outline-color:#0000ff;
                    background-color: white;                   
                    background: #4169e1;
                    color:white;}"
                  )

      ,modalButton("Cancel"),
      footer = NULL
    ))
  })%>%bindEvent(input$RMDdownload)
  observe({
    showModal(modalDialog(
      title = "Rmd download",
      easyClose = FALSE,
      p(tags$strong("Set name below :
                             "), "Click download button",br(),
        tags$i(tags$u("")), "download Result to html as a name:"),
      textInput("htmlname",value = "report.html",label = "file name"),
      br(),downloadButton("htmldownload","download")
      ,tags$style("#htmldownload {
                   outline-color:#0000ff;
                    background-color: white;                   
                    background: #4169e1;
                    color:white;}"
                  )

      ,modalButton("Cancel"),
      footer = NULL
    ))
  })%>%bindEvent(input$HTMLdownload)
  observe({
    removeModal()
    params <- list(p = p.seq())
    rmarkdown::render("momo.Rmd", output_file = input$html,
                      params = params,
                      envir = globalenv())#new.env(parent = globalenv()
                      
    })%>%bindEvent(input$htmldownlo)