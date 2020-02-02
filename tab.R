##----------#----------#----------#----------
##
## ONOFF tab
##
## Language: EN
## 
## DT: 2019-01-09
##
##----------#----------#----------#----------

#tabPanel(switchInput(
#   inputId = "explain_on_off",
#   label = "<i class=\"fa fa-book\"></i>", # Explanation in Details
#    #labelWidth = "250px",
#    inline = TRUE,
##handleWidth = "100px",
#    size = "mini"
#)
#)

#tabPanel("",icon = icon("fa-book"),value = "hint")


#fluidPage(#
#	shinyWidgets::switchInput(#
#			   inputId = "explain_on_off",#
#			   label = "<i class=\"fa fa-book\"></i>", # Explanation in Details
#			    inline = TRUE,
#			    onLabel = "Show",
#			    offLabel = "Hide",
#			    size = "mini"
#			    )
#	)

##' @title tab functions in MEPHAS
##'
##' @export
tabof <- function(){
 fluidPage(

 shinyWidgets::switchInput(
        inputId = "explain_on_off",
        label = "<i class=\"fa fa-book\"></i>", # Explanation in Details
         inline = TRUE,
         onLabel = "Show",
         offLabel = "Hide",
         size = "mini"
          )
 )
}