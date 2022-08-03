#
# Functions of some Panels
#
#

## Panel 1

tabPanel.upload <- function(file ="file", header="header", col="col", sep="sep", quote="quote"){

tabPanel("数据上传", p(br()),

p(tags$b("上传示例数据")),
p(("请参考示例数据格式上传数据，上传数据将代替示例数据。")),
#p("すべての独立変数（X）の左側に従属変数（Y）を置いてください"),

fileInput(file, "1. 选择CSV/TXT文件", accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),

p(tags$b("2. 是否将第1行用作列名？")), 
#checkboxInput("header", "Yes", TRUE),
shinyWidgets::prettyToggle(
   inputId = header,
   label_on = "Yes", 
    icon_on = icon("check"),
   status_on = "info",
   status_off = "warning", 
    label_off = "No",
   icon_off = icon("remove"),
   value = TRUE
),

p(tags$b("3. 是否将第1列（无重复项）用作行名？")), 
#checkboxInput("col", "Yes", TRUE),
shinyWidgets::prettyToggle(
   inputId = col,
   label_on = "Yes", 
    icon_on = icon("check"),
   status_on = "info",
   status_off = "warning", 
    label_off = "No",
   icon_off = icon("remove"),
   value = TRUE
),

shinyWidgets::prettyRadioButtons(
   inputId = sep,
   label = "4. 数据使用了哪种分隔符？", 
   status = "info",
   fill = TRUE,
   icon = icon("check"),
  choiceNames = list(
    HTML("逗号 (,)：CSV文件通常使用此分隔符"),
    HTML("一个制表符(->|)：TXT文件通常使用此分隔符"),
    HTML("分号 (;)"),
    HTML("一个空格(_)")
    ),
  choiceValues = list(",", "\t", ";", " ")
  ),

shinyWidgets::prettyRadioButtons(
   inputId = quote,
   label = "5. 数据使用了哪种引号？", 
   status = "info",
   fill = TRUE,
   icon = icon("check"),
  choices = c("不使用" = "",
           "双引号(\")" = '"',
           "单引号(\')" = "'"),
  selected = '"'),

p("正确的分隔符和引号确保数据输入成功"),

a(tags$i("从此处可以下载示例数据"),href = "https://github.com/mephas/datasets")
  )
}

## Panel 2

tabPanel.upload.num <- function(file ="file", header="header", col="col", sep="sep"){

tabPanel("数据上传", p(br()),

p(tags$b("上传示例数据。")),

fileInput(file, "1. 选择CSV/TXT文件", accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),

p(tags$b("2. 是否将第1行用作列名？")), 
#checkboxInput("header", "Yes", TRUE),
shinyWidgets::prettyToggle(
   inputId = header,
   label_on = "Yes", 
    icon_on = icon("check"),
   status_on = "info",
   status_off = "warning", 
    label_off = "No",
   icon_off = icon("remove"),
   value = TRUE
),

p(tags$b("3. 是否将第1列（无重复项）用作行名？")), 
#checkboxInput("col", "Yes", TRUE),
shinyWidgets::prettyToggle(
   inputId = col,
   label_on = "Yes", 
    icon_on = icon("check"),
   status_on = "info",
   status_off = "warning", 
    label_off = "No",
   icon_off = icon("remove"),
   value = TRUE
),

shinyWidgets::prettyRadioButtons(
   inputId = sep,
   label = "4. 数据使用了哪种分隔符？", 
   status = "info",
   fill = TRUE,
   icon = icon("check"),
  choiceNames = list(
    HTML("逗号 (,)：CSV文件通常使用此分隔符"),
    HTML("一个制表符(->|)：TXT文件通常使用此分隔符"),
    HTML("分号 (;)"),
    HTML("一个空格(_)")
    ),
  choiceValues = list(",", "\t", ";", " ")
  ),

p("正确的分隔符和引号确保数据输入成功"),

a(tags$i("从此处可以下载示例数据"),href = "https://github.com/mephas/datasets")
  )
}

## Panel 3

tabPanel.upload.pr <- function(file ="file", header="header", col="col", sep="sep", quote="quote"){

tabPanel("数据上传", p(br()),

p(tags$b("测试集应覆盖模型中使用的所有自变量。")),

#p("すべての独立変数（X）の左側に従属変数（Y）を置いてください"),

fileInput(file, "1. 选择CSV/TXT文件", accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),

p(tags$b("2. 是否将数据的第1行用作变量名称（列名）？")), 
#checkboxInput("header", "Yes", TRUE),
shinyWidgets::prettyToggle(
   inputId = header,
   label_on = "Yes", 
    icon_on = icon("check"),
   status_on = "info",
   status_off = "warning", 
    label_off = "No",
   icon_off = icon("remove"),
   value = TRUE
),

p(tags$b("3. 是否将数据的第1列用作命名（行名）？")), 
#checkboxInput("col", "Yes", TRUE),
shinyWidgets::prettyToggle(
   inputId = col,
   label_on = "Yes", 
    icon_on = icon("check"),
   status_on = "info",
   status_off = "warning", 
    label_off = "No",
   icon_off = icon("remove"),
   value = TRUE
),

shinyWidgets::prettyRadioButtons(
   inputId = sep,
   label = "4. 数据使用了哪种分隔符？", 
   status = "info",
   fill = TRUE,
   icon = icon("check"),
  choiceNames = list(
    HTML("逗号 (,)：CSV文件通常使用此分隔符"),
    HTML("一个制表符(->|)：TXT文件通常使用此分隔符"),
    HTML("分号 (;)"),
    HTML("一个空格(_)")
    ),
  choiceValues = list(",", "\t", ";", " ")
  ),

shinyWidgets::prettyRadioButtons(
   inputId = quote,
   label = "5. 数据使用了哪种引号？", 
   status = "info",
   fill = TRUE,
   icon = icon("check"),
  choices = c("不使用" = "",
           "双引号(\")" = '"',
           "单引号(\')" = "'"),
  selected = '"'),

p("请注意分隔符和引号是否正确，确保数据输入成功。"),

a(tags$i("点击此处可以下载示例数据"),href = "https://github.com/mephas/datasets")
  )
}