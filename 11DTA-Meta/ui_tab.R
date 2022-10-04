tablang <- function(name){
        navbarMenu("", icon = icon("globe"),
                   tabPanel(
                           tags$a("",
                                  target = "_blank",
                                  #style = "margin-top:-30px; color:DodgerBlue",
                                  href = paste0("https://alain003.phs.osaka-u.ac.jp/mephas_web/",name,"/"),#,
                                  list(icon("EN"), "English"))
                   )
              )       
}
tablink <- function(){
        navbarMenu("", icon = icon("link"),
                   tabPanel(
                           tags$a("",
                                  #target = "_blank",
                                  #style = "margin-top:-30px; color:DodgerBlue",
                                  href = paste0("https://alain003.phs.osaka-u.ac.jp/mephas/","index.html"),#,
                                  list(icon("home"), "Home Page"))
                   ),
                   
                   tabPanel(
                           tags$a("",
                                  #target = "_blank",
                                  #style = "margin-top:-30px; color:DodgerBlue",
                                  href = paste0("https://mephas.github.io/helppage/"),#,
                                  list(icon("question-circle"), "Tutorial"))
                    ),
                   tabPanel(

                          tags$a("",
                                #target = "_blank",
                                #style = "margin-top:-30px; color:DodgerBlue",
                                href = paste0("https://www.youtube.com/channel/UC7NNDN2iIjWe2NSRKT-7VgA/videos"),#,
                                list(icon("video"), "Video"))
                   )
              )       
}