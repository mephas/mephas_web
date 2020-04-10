#file data input
NUM_X<-reactive({
  
  inFile<-input$NUM_file
  
  if (is.null(inFile)){#file or data
    datatb<-iris[1:30,1:4]
  }else{
    datatb <- read.csv(
      inFile$datapath,
      header = T)
  }

  return(datatb)
})



#ui select variables (cluster)
output$clu_v_NUM_out = renderUI({
  selectInput( ##type(list) length
    'clu_vari_NUM',
    h5('Features'),
    selected = c(names(NUM_X())),
    choices = c(names(NUM_X())),
    multiple = TRUE
  )
})




#new Database
new_NUM_X<-function(){
  new_inFile<-NUM_X()
  if(input$NUM_scale){
    new_inFile<-data.frame(scale(new_inFile))}
  if(is.null(input$clu_vari_NUM)){
    return(new_inFile)
  }else{
    return(new_inFile[input$clu_vari_NUM])
  }
}




#function
gap_result<-reactive({
  sink("result.txt")
  ga<-clusGap(new_NUM_X(),kmeans,K.max = input$NUM_K_Max)
  print(ga)
  sink()
  return(ga)
})

#plot
output$plot_NUM<-renderPlot({
  fviz_gap_stat(gap_result())
})

#output datatable
output$NUM_table <- renderDataTable({new_NUM_X()}, options = list(pageLength = 5))#

#output result
output$NUM_results<-renderPrint({
  if (is.data.frame(new_NUM_X()))
  {tryCatch({gap_result()},
            error = function(e){HTML("Error in your data!")})}
  else{return("No outputs!")}
  
})

#download file
output$NUM_download <- downloadHandler(
  filename = function() { 
    'result.txt' 
  },
  content = function(file) {
    file.copy("result.txt", file)
  }
)

observeEvent(input$NUM_clear,{session$reload()})