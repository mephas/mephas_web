  output$ManualPDF_download<-downloadHandler("mochi.pdf",content = function(file){"https://www.ichitabi.jp/feature/special/mochi/images/mochi.pdf"}
  
 
  ,contentType = "application/pdf")
observe({
  download.file("https://alain003.phs.osaka-u.ac.jp/mephas_website/7.1.png","C:/Users/ayame_yfbb0/Documents/mo.pdf")
})%>%bindEvent(input$mochimochi)