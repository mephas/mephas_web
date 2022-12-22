output$ManualPDF_download<-downloadHandler("DTAmanual.pdf"
                                             ,content = function(file){
                                               file.copy("./DTAmanual.pdf",file)
                                             }
                                             ,contentType = "application/pdf")
output$desktopApp_Download<-downloadHandler("Setup.exe",
                                            content = function(file){
                                              file.copy("./DTAmetasa-setup-0.1.0.exe",file)}
                                              )