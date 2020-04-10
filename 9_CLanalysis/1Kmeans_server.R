#file data input
KM_X<-reactive({
  
  inFile<-input$KM_file
  
  if (is.null(inFile)){#file or data
    datatb<-iris[1:4]
  }else{
    datatb <- read.csv(
      inFile$datapath,
      header = T)
  }

  return(datatb)
})



#ui select variables (cluster)
output$clu_vari_out = renderUI({
  selectInput( ##type(list) length
    'clu_vari',
    h5('features'),
    selected = c(names(KM_X())),
    choices = c(names(KM_X())),
    multiple = TRUE
  )
})




#new Database
new_KM_X<-reactive({
  new_inFile<-KM_X()
  if(input$KM_scale){
    new_inFile<-data.frame(scale(new_inFile))}
  if(is.null(input$clu_vari)){
    return(new_inFile)
  }else{
    return(new_inFile[input$clu_vari])
  }
})

#plot bool用于判断是否显示图片窗格
plot_bool<-reactive({
  if(length(input$clu_vari)<2 || is.null(input$clu_vari)){return(0)}
  else if(length(input$clu_vari)==2){return(1)}
  else{
    if(input$to2dimension == 'no_pic'){return(0)}
    else if(input$to2dimension == 'two'){return(1)}
    else if(input$to2dimension == 'pca'){return(2)}
    else if(input$to2dimension == 'tsne'){return(3)}
    else if(input$to2dimension == 'umap'){return(4)}
    else{print("wrong in plot bool")}
    
  }
})

#用来测试变量 之后需删掉
#output$test = renderUI({
#  HTML(plot_bool())
#})


#ui select variables (plot)
output$condi_plot = renderUI({
  conditionalPanel(condition= plot_bool(),  #  "input.clu_vari.length == 2",#
                   h4('PLOT:'),
                   plotOutput('KM_plot')
  )
})



#cluster function
KM_clusters <- function(){
  sink("result.txt")
  text<-kmeans(new_KM_X(), input$KM_clusternumber)
  print(text)
  sink()
  return(text)
}

#建立降维后的数据集 isolate避免一上传数据就运行


#生成图片plot 疑问点：是否应该加入条件判断 
output$KM_plot<-renderPlot({
  palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
            "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))

  if(plot_bool()==0){return(NULL)}
  else if(plot_bool()==1){
    par()#mar = c(5.1, 4.1, 0, 1)
    plot(new_KM_X()[1:2],
         col = KM_clusters()$cluster,
         pch = 20, cex = 3)
    points(KM_clusters()$centers, pch = 4, cex = 4, lwd = 4)
  }
  else if(plot_bool()==2){
    par()#mar = c(5.1, 4.1, 0, 1)
    pca_out<-prcomp(new_KM_X())
    plot(pca_out$x[,1:2],
         col = KM_clusters()$cluster,
         pch = 20, cex = 3)
  }
  else if(plot_bool()==3){
    par()#mar = c(5.1, 4.1, 0, 1)
    tsne_out<-Rtsne(new_KM_X(),check_duplicates=FALSE)
    plot(tsne_out$Y,
         col = KM_clusters()$cluster,
         pch = 20, cex = 3)
    #points(KM_clusters()$centers, pch = 4, cex = 4, lwd = 4)
  }
  else if(plot_bool()==4){
    par()#mar = c(5.1, 4.1, 0, 1)
    umap_out<-umap(new_KM_X())
    plot(umap_out$layout,
         col = KM_clusters()$cluster,
         pch = 20, cex = 3)
    #points(KM_clusters()$centers, pch = 4, cex = 4, lwd = 4)
  }
  else{print("wrong in plot")}
})

#output datatable
output$KM_table <- renderDataTable({new_KM_X()}, options = list(pageLength = 5))

#output result
output$KM_results<-renderPrint({
  if (is.data.frame(new_KM_X()))
  {tryCatch({KM_clusters()},
            error = function(e){HTML("Error in your data!")})}
  else{return("No outputs!")}#或可改成无实验组X
  
})

#下载文件
output$KM_download <- downloadHandler(
  filename = function() { 
    'result.txt' 
  },
  content = function(file) {
    file.copy("result.txt", file)
  }
)

observeEvent(input$KM_clear,{session$reload()})