##----------#----------#----------#----------
##
## Stop tab
##
## Language: CN
## 
## DT: 2019-01-09
##
##----------#----------#----------#----------
tabPanel(
  tags$button(
    id = 'close',
    type = "button",
    class = "btn action-button",
    style = "margin-top:-8px; color:Tomato; background-color: #F8F8F8  ",
    onclick = "setTimeout(function(){window.close();},500);",  # close browser
    "中止"))
