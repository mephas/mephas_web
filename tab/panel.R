tabPanel.upload <- function(file ="file", header="header", col="col", sep="sep", quote="quote"){

tabPanel("Upload Data", p(br()),

p(tags$b("Upload data will cover the example data")),
p("We suggested putting the dependent variable (Y) in the left side of all independent variables (X) "),

fileInput(file, "1. Choose CSV/TXT file", accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),

p(tags$b("2. Show 1st row as column names?")), 
#checkboxInput("header", "Yes", TRUE),
shinyWidgets::prettyToggle(
   inputId = "header",
   label_on = "Yes", 
    icon_on = icon("check"),
   status_on = "info",
   status_off = "warning", 
    label_off = "No",
   icon_off = icon("remove"),
   value = TRUE
),

p(tags$b("3. Use 1st column as row names? (No duplicates)")), 
#checkboxInput("col", "Yes", TRUE),
shinyWidgets::prettyToggle(
   inputId = "col",
   label_on = "Yes", 
    icon_on = icon("check"),
   status_on = "info",
   status_off = "warning", 
    label_off = "No",
   icon_off = icon("remove"),
   value = TRUE
),

shinyWidgets::prettyRadioButtons(
   inputId = "sep",
   label = "4. Which separator for data?", 
   status = "info",
   fill = TRUE,
   icon = icon("check"),
  choiceNames = list(
    HTML("Comma (,): CSV often uses this"),
    HTML("One Tab (->|): TXT often uses this"),
    HTML("Semicolon (;)"),
    HTML("One Space (_)")
    ),
  choiceValues = list(",", "\t", ";", " ")
  ),

shinyWidgets::prettyRadioButtons(
   inputId = "quote",
   label = "5. Which quote for characters?", 
   status = "info",
   fill = TRUE,
   icon = icon("check"),
  choices = c("None" = "",
           "Double Quote" = '"',
           "Single Quote" = "'"),
  selected = '"'),

p("Correct separator and quote ensure the successful data input"),

a(tags$i("Find some example data here"),href = "https://github.com/mephas/datasets")
  )
}


tabPanel.upload.num <- function(file ="file", header="header", col="col", sep="sep"){

tabPanel("Upload Data", p(br()),

p(tags$b("Upload data will cover the example data")),

fileInput(file, "1. Choose CSV/TXT file", accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),

p(tags$b("2. Show 1st row as column names?")), 
#checkboxInput("header", "Yes", TRUE),
shinyWidgets::prettyToggle(
   inputId = "header",
   label_on = "Yes", 
    icon_on = icon("check"),
   status_on = "info",
   status_off = "warning", 
    label_off = "No",
   icon_off = icon("remove"),
   value = TRUE
),

p(tags$b("3. Use 1st column as row names? (No duplicates)")), 
#checkboxInput("col", "Yes", TRUE),
shinyWidgets::prettyToggle(
   inputId = "col",
   label_on = "Yes", 
    icon_on = icon("check"),
   status_on = "info",
   status_off = "warning", 
    label_off = "No",
   icon_off = icon("remove"),
   value = TRUE
),

shinyWidgets::prettyRadioButtons(
   inputId = "sep",
   label = "4. Which separator for data?", 
   status = "info",
   fill = TRUE,
   icon = icon("check"),
  choiceNames = list(
    HTML("Comma (,): CSV often uses this"),
    HTML("One Tab (->|): TXT often uses this"),
    HTML("Semicolon (;)"),
    HTML("One Space (_)")
    ),
  choiceValues = list(",", "\t", ";", " ")
  ),

p("Correct separator and quote ensure the successful data input"),

a(tags$i("Find some example data here"),href = "https://github.com/mephas/datasets")
  )
}