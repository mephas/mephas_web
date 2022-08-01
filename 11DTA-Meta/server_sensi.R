observe({
	
	updatePickerInput(session,"sensisetting",selected = input$Sensitivity_Panel)
	print(input$Sensitivity_Panel)
}
)%>%bindEvent(input$Sensitivity_Panel)