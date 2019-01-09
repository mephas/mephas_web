##----------#----------#----------#----------
##
## Home and stop tabs
##
## Language: CN
## 
## DT: 2019-01-09
##
##----------#----------#----------#----------

home <- tabPanel((a("主页",
            #target = "_blank",
            style = "margin-top:-30px; color:DodgerBlue",
            href = paste0("https://pharmacometrics.info/mephas/","index_cn.html"))))

stop <- tabPanel(
  tags$button(
    id = 'close',
    type = "button",
    class = "btn action-button",
    style = "margin-top:-8px; color:Tomato; background-color: #F8F8F8  ",
    onclick = "setTimeout(function(){window.close();},500);",  # close browser
    "中止"))
