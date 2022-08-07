  output$ManualPDF_download<-downloadHandler("DTAmanual.pdf"
                                             ,content = function(file){
                                               file.copy("./DTAmanual.pdf",file)
                                             }
                                             ,contentType = "application/pdf")
