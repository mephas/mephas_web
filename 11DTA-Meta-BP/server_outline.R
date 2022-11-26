output$ManualPDF_download<-downloadHandler("DTAmanual.pdf"
                                             ,content = function(file){
                                               file.copy("./DTAmanual.pdf",file)
                                             }
                                             ,contentType = "application/pdf")
output$desktopApp_Download<-downloadHandler("DTA-Meta-SA-Setup.exe",
                                            content = function(file){
                                              file.copy("./DTA-Meta-SA-Setup.exe",file)}
                                              )
