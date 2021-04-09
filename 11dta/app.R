library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(dtametasa)
library(DT)

sidebar<-dashboardSidebar(
    #menuItem("Input",tabName = "dashboard",icon = icon("dashboard")),
   # menuItem("Upload-Data",icon = icon("th"),tabName = "widgets",
    #         badgeLabel = "mochi",badgeColor = "blue"),
  
  tags$head(
    tags$script(
      HTML(
        "
        $(document).ready(function(){
          // Bind classes to menu items, easiet to fill in manually
          var ids = ['subItemOne','subItemTwo','subItemThree','subItemFour'];
          for(i=0; i<ids.length; i++){
            $('a[data-value='+ids[i]+']').addClass('my_subitem_class');
          }

          // Register click handeler
          $('.my_subitem_class').on('click',function(){
            // Unactive menuSubItems
            $('.my_subitem_class').parent().removeClass('active');
          })
        })
        "
      )
    )
  ),
  width = 290,
    sidebarMenu(
      menuItem('Required Settings', tabName = 'menuOne', icon = icon('line-chart'),
               startExpanded = TRUE,
                 #menuSubItem('Sub-Item One', tabName = 'subItemOne'),
               
                 menuSubItem(fileInput(inputId = "file1", 
                                       label = "Upload CSV/TXT File",
                                       accept = c("text/csv"),
                                       multiple = FALSE,
                                       width = "80%",
                                       buttonLabel = "Open Folder",
                                       placeholder = "Upload"),
                             
                             icon = icon("desktop")
                             ),
               menuSubItem(textAreaInput(
                 inputId = "x", 
                 label = "Manually input data",
                 value = "study,TP,FN,FP,TN\n1,12,0,29,289\n2,10,2,14,72\n3,17,1,36,85\n4,13,0,18,67\n5,4,0,21,225\n6,15,2,122,403\n7,45,5,28,34\n8,18,4,69,133\n9,5,0,11,34\n10,8,9,15,96\n11,5,0,7,63\n12,11,2,122,610\n13,5,1,6,145\n14,7,5,25,342\n15,10,1,93,296",
                 rows = 10
               ), icon = icon("keyboard")),
               menuSubItem(sliderInput("mochifc","Single Selection Probability(FC)",0, 1, 0.5),
                           icon = icon("dashboard")),
               
               menuSubItem(sliderInput("mochirc","Single Selection Probability(RC)",0, 1, 0.5),
                           icon = icon("dashboard")),
               menuSubItem(textAreaInput(inputId = "plist","Multiple Selection Probabilities",value = "1, 0.9, 0.8, 0.7, 0.6"),
                           icon = icon("dashboard"))
              # menuItem("a",tabName="!!!",icon=icon("dashboard"),menuSubItem("m1",tabName = "momo"),menuSubItem("m2",tabName = "momo"))
      )
    ),

    sidebarMenu(
      menuItem('Optinal Settings of Paramaters', tabName = 'menuTwo', icon = icon('code-branch'),
      menuSubItem(icon=icon("dashboard"),sliderInput("correct.value","correct.value",0,1,0.5)),
      menuSubItem(icon=icon("dashboard"),switchInput(inputId = "Id015",label = "brem.init",labelWidth = "80px",onLabel = "Set Vector",offLabel = "NUll")),
      htmlOutput("html.brem.init1"),
      menuSubItem(icon=icon("dashboard"),sliderInput("b.init1","b.init",0.1,5,0.1)),
      menuSubItem(icon=icon("dashboard"),sliderInput(inputId = "b.interval1", label = "b.interval", value  = c(0, 2),min = 0,max=10)),
      menuSubItem(icon=icon("dashboard"),sliderInput(inputId = "a.interval1", label = "a.interval", value  = c(-3, 3),min = -10,max=10)),
      menuSubItem(
        icon = icon("dashboard"), 
        radioGroupButtons(
        inputId = "Id070",
        label = "Label",
        choices = c("all", "single"),
        justified = TRUE,
        checkIcon = list(
          yes = icon("ok", 
                     lib = "glyphicon"))
      ))
      # prettyCheckbox(
      #   inputId = "Id021",
      #   label = "Click Caluculate SAUC!", 
      #   value = TRUE,
      #   status = "danger",
      #   shape = "curve"
      # )
      )
  )
  # ,
  # sidebarMenu(
  #   menuItem('Confidence interval of SAUC',tabName = 'menuThree',icon =icon('code-branch'),
  #            startExpanded = TRUE,
  #            menuSubItem(icon = icon("dashboard"), sliderInput("B","Boostraping times",1,2000,5, step = 100)),
  #            
  #            menuSubItem(
  #              icon = icon("dashboard"),
  #              radioGroupButtons(
  #              inputId = "ci.level1",
  #              label = "Level of alpha",
  #              choices = c("0.90", "0.95", "0.99"),
  #              selected = "0.95",
  #              justified = TRUE,
  #              checkIcon = list(
  #                yes = icon("ok", lib = "glyphicon"))
  #            )),
  #            
  #            menuSubItem(icon = icon("dashboard"), textAreaInput("set.seed1", "Set a seed", 2021)),
  #            menuSubItem(icon = icon("desktop"),
  #              actionBttn(
  #                inputId = "Id114",
  #                label = "Calculate CI", 
  #                style = "gradient",
  #                color = "danger",
  #                icon = icon("thumbs-up")
  #            )
  #            )
  #            # prettyCheckbox(
  #            #   inputId = "Id022",
  #            #   label = "Click to caluculate the confidence intervals of SAUC", 
  #            #   value = FALSE,
  #            #   status = "danger",
  #            #   shape = "curve"
  #            # ),
  # ))
    )
#=================================================================================================================================================
body<-dashboardBody( 
  fluidRow(  tabBox(title = "",width = 6,tabPanel("Raw Input Data","data",dataTableOutput("default"))) ,
             tabBox(title = "",width = 6,tabPanel("Logit-transformed Data","default-generated",dataTableOutput("dafaultsa1")))),
  fluidRow(
    
    tabBox(title = tagList(shiny::icon("chart-line"), "SROC1"), width = 6,
        
          
          tabPanel("SROC1","Estimated SROC when c11 and c22 are assigned by the specific values",

               plotOutput("roc1data", width = "400px", height = "400px"),
               downloadButton("download1","Save Image"),
                    br(),     
          HTML(
              "<b> Explanations </b>
                  <ul>
                    <li> item1
                    <li> item2
                    <li> item3
                  </ul>"
            ),
          dropdownButton(
            
            tags$h3("List of Inputs"),
            
            # colorPickr(inputId = 'fig0_1_0',
            #            selected = "black",
            #            label = 'X Variable',
            #            #  choices = c("fjif",2)
            # ),
            
            htmlOutput("html.select1"),
            selectInput(inputId = 'ycol',
                        label = 'Y Variable',
                        choices = names(iris),
                        selected = names(iris)[[2]]),
            
            sliderInput(inputId = 'roc1data.c1',
                        label = 'c1.sq',
                        value = 0.5,
                        min = 0,
                        max = 1),
            
            circle = TRUE, status = "danger",
            icon = icon("gear"), width = "300px",
            
            tooltip = tooltipOptions(title = "Click to see inputs !")
          )
))
,
           tabBox(title = tagList(shiny::icon("chart-line"), "SROC2"), width = 6,
                  
                    tabPanel("SROC2","Estimated SROC when c11 and c22 are estimated",

                             plotOutput("roc2data", width = "400px", height = "400px"),
                    
                      HTML(
                      "<b> Explanations </b>
                          <ul>
                            <li> item1
                            <li> item2
                            <li> item3
                          </ul>"
                    ),
                    dropdownButton(
                      
                      tags$h3("List of Inputs"),
                      
                      # colorPickr(inputId = 'fig1_1_0',
                      #            selected = "black",
                      #            label = 'X Variable',
                      #            #  choices = c("fjif",2)
                      # ),
                      
                      selectInput(inputId = 'ycol',
                                  label = 'Y Variable',
                                  choices = names(iris),
                                  selected = names(iris)[[2]]),
                      
                      
                      htmlOutput("html.select2"),
                      
                      sliderInput(inputId = 'roc2data.c1',
                                  label = 'c1.sq',
                                  value = 0.5,
                                  min = 0,
                                  max = 1),
                      
                      circle = TRUE, status = "danger",
                      icon = icon("gear"), width = "300px",
                      
                      tooltip = tooltipOptions(title = "Click to see inputs !")
                    )
))),
 # fluidRow(
 # tabBox(
 #   title = "First tabBox",width = 6,
 #   # The id lets us use input$tabset1 on the server to find the current tab
 #   id = "tabset1", height = "250px",
 #   tabPanel("Tab1", "First tab content",dataTableOutput("dataParFc")),
 #   tabPanel("Tab2", "Tab content 2")
 # ),
  
 # tabBox(
 #   title = "First tabBox",width = 6,
 #   # The id lets us use input$tabset1 on the server to find the current tab
 #   id = "tabset1", 
 #   tabPanel("Tab1", "First tab content",dataTableOutput("dataParRc")),
 #   tabPanel("Tab2", "Tab content 2")
 # )
  #fluidRow(
 #   tabBox(title = "default",
  #         id="ta",tabPanel("roc","o",dataTableOutput("default")),tabPanel("d","d",dataTableOutput("dafaultsa1")))
  
  #),
#),
fluidRow(
  tabBox(
    # Title can include an icon
    title = tagList(shiny::icon("gear"), "Parameters1"),
    tabPanel("Par1","Estimates when c11 and c22 are assigned by the specific values",
             dataTableOutput("safc1")) 
  ),
  tabBox(
    title = tagList(shiny::icon("gear"), "Parameters2"),
    tabPanel("Par2","Estimated SROC when c11 and c22 are assigned by the specific values",
             dataTableOutput("sarc1"))
))
# ,
# fluidRow(
#   
#   tabBox(title = tagList(icon("gear"),"SAUC1"),selected = "Estimates",
#          tabPanel("Estimates",
#                   "Estimates",
#                   dataTableOutput("SAUC1Table")),
#          tabPanel("Plot","Plot",
#                   plotOutput("SAUC1Plot", 
#                              width = "400px", height = "400px"))),
#   
#   tabBox(title = tagList(icon("gear"),"SAUC2"),selected = "Estimates",
#          tabPanel("Estimates","Estimates",dataTableOutput("SAUC2Table")),
#          tabPanel("Plot","Plot",plotOutput("SAUC2Plot", width = "400px", height = "400px")))
#   
# )
)

ui<-dashboardPage(dashboardHeader(title = "DTA-META-SA"),sidebar,body)


#=================================================================================================================================================
server <-function(input, output, session){
  
  output$menu<- renderMenu({
    sidebarMenu()
  })
  
  inFile <- reactive({
    inFile1 <- input$file1
    if (is.null(inFile1)){
      return(NULL)
    } else {
      df <- read.csv(inFile1$datapath, header=TRUE)
      return(df)
    }
  })
  
  output$outInFile <- renderDataTable({ # DT:: はなくてもOK
    data.frame(inFile())
  })
  
  
  sa<-reactive({
    inFile1 <- input$file1
    if (is.null(inFile1)){
      df<-read.table(text=input$x,sep = ",",header = TRUE)
    } else {
      df <- read.csv(inFile1$datapath, header=TRUE)
      }
  })
  
  sa1<-reactive({
    inFile1 <- input$file1
    if (is.null(inFile1)){
      df<-read.table(text=input$x,sep = ",",header = TRUE)
      df<-dtametasa::dtametasa.fc(df,p=1)
      return(df)
    } else {
      df <- read.csv(inFile1$datapath, header=TRUE)
      df<-dtametasa::dtametasa.fc(df, p=1)
      df
      
     # dt <- as.data.frame(dtametasa::dtametasa.fc(df, input$mochi)$par)
     # dt <- round(t(dt),3)
     # rownames(dt) <- paste0("p = ", input$mochi)
      #colnames(dt) <- c("u1", "u2", "t11", "t22", "t12", "b", "a", "c11", "c22", "SAUC", "Se", "Sp")
      #dt
      }
  })
  
  safc<-reactive({
      p.seq<- as.numeric(unlist(strsplit(input$plist, "[,;\n\t]")))
      res <- round(sapply(p.seq,
                          function(p) dtametasa.fc(sa(),
                                                   p,
                                                   input$mochifc,
                                                   correct.value = input$correct.value,
                                                   correct.type = input$Id070,
                                                   
                                                   brem.init = {if(!input$Id015) NULL else {c(as.numeric(unlist(strsplit(input$brem.init1, "[,;\n\t]"))))}},
                                                   b.init=input$b.init1,
                                                   
                                                   b.interval = input$b.interval1,
                                                   a.interval = input$a.interval1
                                                   
                                                   )$par), 3)
      colnames(res) =  paste("p=",p.seq)
      res
  })
  
  sarc<-reactive({
    
    p.seq<- as.numeric(unlist(strsplit(input$plist, "[,;\n\t]")))
     res <- round(sapply(p.seq, function(p) dtametasa.rc(sa(),
                                                         p,
                                                         correct.value = input$correct.value,
                                                         correct.type = input$Id070,
                                                         
                                                         brem.init = {if(!input$Id015){NULL} else {as.numeric(unlist(strsplit(input$brem.init1, "[,;\n\t]")))}},
                                                         b.init=input$b.init1,
                                                         
                                                         b.interval = input$b.interval1,
                                                         a.interval = input$a.interval1,
                                                         c1.sq.init = input$mochirc
                                                         
                                                         )$par),3)
     colnames(res) =  paste("p=",p.seq)
     res
  })
  
  SAUC1<-eventReactive(input$Id114,{
    
     p.seq<- as.numeric(unlist(strsplit(input$plist, "[,;\n\t]")))
     
     if (input$ci.level1=="0.90")  ci.lv <- 0.9 else {if (input$ci.level1=="0.95") ci.lv <- 0.95 else ci.lv <- 0.99}
     
     withProgress({
      SAUC1 <- sapply(p.seq, function(p) {
        
        sa1 <- dtametasa.fc(sa(),
                            p,
                            input$mochifc,
                            correct.value = input$correct.value,
                            correct.type = input$Id070,
                            
                            brem.init = {if(!input$Id015) NULL else {c(as.numeric(unlist(strsplit(input$brem.init1, "[,;\n\t]"))))}},
                            b.init=input$b.init1,
                            
                            b.interval = input$b.interval1,
                            a.interval = input$a.interval1)
        
        SAUC <- sAUC.ci(sa1,
                        B=input$B,
                        hide.progress = TRUE,
                       set.seed =  input$set.seed1,
                       ci.level = ci.lv
                        )
        # round(sa1$par[1:3], 3)
        incProgress(1/length(p.seq))
        Sys.sleep(0.1)
        round(c(SAUC[[1]], SAUC[[2]], SAUC[[3]]), 3)
        
      })}
      , message = "Calculating CI1")
      
      colnames(SAUC1)<- paste0("p = ", p.seq)
      rownames(SAUC1)<- c("SAUC", "CI.L", "CI.U")
      
      SAUC1
  })
  
  SAUC2<-eventReactive(input$Id114,{
    
      p.seq<- as.numeric(unlist(strsplit(input$plist, "[,;\n\t]")))
      if (input$ci.level1=="0.90")  ci.lv <- 0.9 else {if (input$ci.level1=="0.95") ci.lv <- 0.95 else ci.lv <- 0.99}
      
      withProgress({
        
      SAUC2 <- sapply(p.seq, function(p) {
        
        sa2 <- dtametasa.rc(sa(),
                            p,
                            correct.value = input$correct.value,
                            correct.type = input$Id070,
                            
                            brem.init = {if(!input$Id015){NULL} else {as.numeric(unlist(strsplit(input$brem.init1, "[,;\n\t]")))}},
                            b.init=input$b.init1,
                            
                            b.interval = input$b.interval1,
                            a.interval = input$a.interval1,
                            c1.sq.init = input$mochirc
                            )
        
        SAUC <- sAUC.ci(sa2, B=input$B,
                        hide.progress = TRUE,
                        set.seed =  input$set.seed1,
                        ci.level = ci.lv)
        
        incProgress(1/length(p.seq))
        Sys.sleep(0.1)
        round(c(SAUC[[1]], SAUC[[2]], SAUC[[3]]),3)
        
      })}
      , message = "Calculating CI2")
      
      colnames(SAUC2)<- paste0("p = ", p.seq)
      rownames(SAUC2)<- c("SAUC", "CI.L", "CI.U")
      SAUC2
    
  })
#=================================================================================================================================================
  output$default<-renderDataTable(sa(),options=(list(scrollX = TRUE)))
  output$dafaultsa1<-renderDataTable(datatable(sa1()$data,options=(list(scrollX = TRUE)))%>%
                                       formatRound(columns=c( 'sens', 'spec', 'y1', 'y2', 'v1', 'v2', 'ldor.t'), digits=3))
  output$safc1<- renderDataTable(datatable(safc(),
                                           extensions = 'Buttons',
                                           options=(list(scrollX = TRUE,
                                                         dom = 'Blfrtip',
                                                         buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
                                                         lengthMenu = list(c(12))
                                                         ))))
  output$sarc1<- renderDataTable(datatable(sarc(),
                                           extensions = 'Buttons',
                                           options=(list(scrollX = TRUE,
                                                         dom = 'Blfrtip',
                                                         buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
                                                         lengthMenu = list(c(12))
                                                         ))))
  
#  output$roc1data<-renderPlot(sROC.matrix(safc()[c(1,2,4,5),]))
  output$roc1data<-renderPlot({
    
    sROC.matrix(safc()[c(1,2,4,5),])
    
    with(sa(), points(FP/(FP+TN), TP/(TP+FN), pch = 4, cex = 0.5))
    
    # legend("bottomright", c("dtametasa.fc"), 
    #        col = c(input$fig0_1_0), lty = c(1), pch = c(19))
    
    # title(paste0("When selection prob = ",input$select1))
  })
  
  
  output$roc2data<-renderPlot({
    
    sROC.matrix(sarc()[c(1,2,4,5),])
    with(sa(), points(FP/(FP+TN), TP/(TP+FN), pch = 4, cex = 0.5))
    
    # legend("bottomright", c("dtametasa.rc"), 
    #        col = c(input$fig1_1_0), lty = c(1), pch = c(19))
    # title(paste("When selection prob = ",input$select2))
    })
  
  
  output$dataParFc<-renderDataTable({
    
     dt <- as.data.frame(sa1()$par)
     dt <- round(t(dt),3)
     
     rownames(dt) <- paste0("p = ", input$mochi)
     colnames(dt) <- c("u1", "u2", "t11", "t22", "t12", "b", "a", "c11", "c22", "SAUC", "Se", "Sp")
     
    datatable(dt,options=(list(scrollX = TRUE)))
  })
  
output$dataParRc<-renderDataTable({
  
  dt <- as.data.frame(sa2()$par)
  dt <- round(t(dt),3)
  
  rownames(dt) <- paste0("p = ", input$mochi)
  colnames(dt) <- c("u1", "u2", "t11", "t22", "t12", "b", "a", "c11", "c22", "SAUC", "Se", "Sp")
  
  datatable(dt,options=(list(scrollX = TRUE)))
})

output$SAUC1Table<-renderDataTable({datatable(SAUC1(),options=(list(scrollX = TRUE)))})
output$SAUC2Table<-renderDataTable(datatable(SAUC2(),options=(list(scrollX = TRUE))))

output$SAUC1Plot<-renderPlot({
  
  matplot(t(SAUC1()), type = "b", lty = c(1,2,2), 
          pch = 19, col = c("black", "grey", "grey"),
          xlab = "p", ylab = "SAUC",
          ylim = c(0,1),
          xaxt = "n")
  
  axis(1, at = 1:length(unlist(strsplit(input$plist, "[,;\n\t]"))), labels =as.numeric(unlist(strsplit(input$plist, "[,;\n\t]"))) )
  
  # title("dtametasa.fc")
})

output$SAUC2Plot<-renderPlot({
  
  matplot(t(SAUC2()), type = "b", lty = c(1,2,2), 
          pch = 19, col = c("black", "grey", "grey"),
          xlab = "p", ylab = "SAUC",
          ylim = c(0,1),
          xaxt = "n")
  axis(1, at = 1:length(unlist(strsplit(input$plist, "[,;\n\t]"))), 
       labels =as.numeric(unlist(strsplit(input$plist, "[,;\n\t]"))) )
  
  # title("dtametasa.rc")
})

output$download1 <- downloadHandler(
  filename = function() {
    "dtametasa_fc.png"
  },
  content = function(file) {
    
    png(file)
    
    sROC.matrix(safc()[c(1,2,4,5),])
    
    with(sa(), points(FP/(FP+TN), TP/(TP+FN), pch = 4, cex = 0.5))
    
    # legend("bottomright", c("Reistma", "dtametasa.fc", "dtametasa.rc", "IVD"),
    #        col = c(input$fig0_1_0, "black", "darkgray", "black"), lty = c(1,2,2, 0), pch = c(19,1,19, 4))
    # title("When selection prob = 0.0.5")
    dev.off()
  }
)

output$html.select1 <- renderUI({
  
  selectInput("select1", 
              
              label = "select p", 
              choices = as.numeric(unlist(strsplit(input$plist, "[,;\n\t]"))),
              selected =as.numeric(unlist(strsplit(input$plist, "[,;\n\t]")))[1])
})
output$html.select2 <- renderUI({
  
  selectInput("select2", 
              label = "select p", 
              choices = as.numeric(unlist(strsplit(input$plist, "[,;\n\t]"))),
              selected =as.numeric(unlist(strsplit(input$plist, "[,;\n\t]")))[1])
})

output$html.brem.init1<-renderUI({
  
  if (input$Id015) {
    
  menuSubItem(textAreaInput(
    
    inputId = "brem.init1", 
    label = "Input initial values for c(u1, u2, t1, t2, r)",
    value = "0, 0, 0.1, 0.1, -0.1",
    rows = 2), 
    
    icon = icon("keyboard"))
  }
})
}

shinyApp(ui, server)
