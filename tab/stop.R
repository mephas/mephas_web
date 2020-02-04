##----------#----------#----------#----------
##
## Stop tab
##
## Language: EN
## 
## DT: 2019-01-09
##
##----------#----------#----------#----------

tabPanel(
  tags$button(
    id = 'close',
    type = "button",
    class = "btn action-button",
    icon("power-off"),
    style = "background:rgba(255, 255, 255, 0); display: inline-block; padding: 0px 0px;",
    onclick = "setTimeout(function(){window.close();},500);")
  )
#tabPanel("Close",icon = icon("power-off"),value = "stop")
#setTimeout(function(){window.close();},500)
	#)