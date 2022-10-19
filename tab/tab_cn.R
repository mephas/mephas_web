tabstop <- function(){
        navbarMenu("", icon = icon("power-off"),
           tabPanel(
                   actionLink(
                           "close", "停止", 
                           icon = icon("power-off"),
                           onclick = "setTimeout(function(){window.close();}, 100);"
                   )
           ),
           tabPanel(
                   tags$a("",
                          #target = "_blank",
                          #style = "margin-top:-30px; color:DodgerBlue",
                          href = paste0("javascript:history.go(0)"),#,
                          list(icon("rotate"), "刷新"))
           )
)
}

tablang <- function(name){
        navbarMenu("", icon = icon("globe"),
                   tabPanel(
                           tags$a("",
                                  target = "_blank",
                                  #style = "margin-top:-30px; color:DodgerBlue",
                                  href = paste0("https://alain003.phs.osaka-u.ac.jp/mephas_web/",name,"/"),#,
                                  list(icon("EN"), "英文"))
                   ),
                   
                   tabPanel(
                           tags$a("",
                                  target = "_blank",
                                  #style = "margin-top:-30px; color:DodgerBlue",
                                  href = paste0("https://alain003.phs.osaka-u.ac.jp/mephas_web/",name,"_jp/"),#
                                  list(icon("JP"), "日语"))
                    ),
                   tabPanel(

                          tags$a("",
                                target = "_blank",
                                #style = "margin-top:-30px; color:DodgerBlue",
                                href = paste0("https://alain003.phs.osaka-u.ac.jp/mephas_web/",name,"_cn/"),#
                                list(icon("CN"), "中文"))
                   )
              )       
}

tablink <- function(){
        navbarMenu("", icon = icon("link"),
                   tabPanel(
                           tags$a("",
                                  #target = "_blank",
                                  #style = "margin-top:-30px; color:DodgerBlue",
                                  href = paste0("https://alain003.phs.osaka-u.ac.jp/mephas/","index_jp.html"),#,
                                  list(icon("house"), "主页"))
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
                                list(icon("video"), "YouTube参考视频"))
                   )
              )       
}



tabOF <- function(){
fluidPage(#
shinyWidgets::switchInput(#
       inputId = "explain_on_off",#
       label = "<i class=\"fa fa-book\"></i>", # Explanation in Details
        inline = TRUE,
        onLabel = "隐藏",
        offLabel = "查看详细",
        size = "small"
        )
)
}

stylink <- function(){
  tags$head(
  tags$link(rel = "shortcut icon", href = "../www/favicon.ico"),
  tags$link(rel = "icon", type = "image/png", sizes = "96x96", href = "../www/favicon-96x96.ico"),
  tags$link(rel = "icon", type = "image/png", sizes = "32x32", href = "../www/favicon-32x32.png"),
  tags$link(rel = "icon", type = "image/png", sizes = "16x16", href = "../www/favicon-16x16.png")
)
}