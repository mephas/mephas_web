tabPanel.upload <- function(file ="file", header="header", col="col", sep="sep", quote="quote"){

tabPanel("アップロード", p(br()),

p(tags$b("サンプルデータをアップロードします")),
p(("新しいデータをアップロードするには、サンプルのデータ形式を参照してください")),
#p("すべての独立変数（X）の左側に従属変数（Y）を置いてください"),

fileInput(file, "1. CSV / TXTファイルを選択", accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),

p(tags$b("2. 最初の行を列名として使用?")), 
#checkboxInput("header", "Yes", TRUE),
shinyWidgets::prettyToggle(
   inputId = header,
   label_on = "Yes", 
    icon_on = icon("check"),
   status_on = "info",
   status_off = "warning", 
    label_off = "No",
   icon_off = icon("xmark"),
   value = TRUE
),

p(tags$b("3. 最初の列を行名として使用? （重複なし）")), 
#checkboxInput("col", "Yes", TRUE),
shinyWidgets::prettyToggle(
   inputId = col,
   label_on = "Yes", 
    icon_on = icon("check"),
   status_on = "info",
   status_off = "warning", 
    label_off = "No",
   icon_off = icon("xmark"),
   value = TRUE
),

shinyWidgets::prettyRadioButtons(
   inputId = sep,
   label = "4. データの区切り文字?", 
   status = "info",
   fill = TRUE,
   icon = icon("check"),
  choiceNames = list(
    HTML("カンマ (,)：CSVでよく使用"),
    HTML("タブ1つ (->|)：TXTでよく使用"),
    HTML("セミコロン (;)"),
    HTML("スペース1つ (_)")
    ),
  choiceValues = list(",", "\t", ";", " ")
  ),

shinyWidgets::prettyRadioButtons(
   inputId = quote,
   label = "5. 文字の引用符?", 
   status = "info",
   fill = TRUE,
   icon = icon("check"),
  choices = c("なし" = "",
           "二重引用符(\")" = '"',
           "一重引用符(\')" = "'"),
  selected = '"'),

p("正しい区切りと引用符を選ばないとデータがうまく入力されません。"),

a(tags$i("ここからサンプルデータをダウンロードできます"),href = "https://github.com/mephas/datasets")
  )
}


tabPanel.upload.num <- function(file ="file", header="header", col="col", sep="sep"){

tabPanel("アップロード", p(br()),

p(tags$b("サンプルデータをアップロードします")),

fileInput(file, "1. CSV / TXTファイルを選択", accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),

p(tags$b("2. 最初の行を列名として使用?")), 
#checkboxInput("header", "Yes", TRUE),
shinyWidgets::prettyToggle(
   inputId = header,
   label_on = "Yes", 
    icon_on = icon("check"),
   status_on = "info",
   status_off = "warning", 
    label_off = "No",
   icon_off = icon("xmark"),
   value = TRUE
),

p(tags$b("3. 最初の列を行名として使用? （重複なし）")), 
#checkboxInput("col", "Yes", TRUE),
shinyWidgets::prettyToggle(
   inputId = col,
   label_on = "Yes", 
    icon_on = icon("check"),
   status_on = "info",
   status_off = "warning", 
    label_off = "No",
   icon_off = icon("xmark"),
   value = TRUE
),

shinyWidgets::prettyRadioButtons(
   inputId = sep,
   label = "4. データの区切り文字?", 
   status = "info",
   fill = TRUE,
   icon = icon("check"),
  choiceNames = list(
	HTML("カンマ (,)：CSVでよく使用"),
    HTML("タブ1つ (->|)：TXTでよく使用"),
    HTML("セミコロン (;)"),
    HTML("スペース1つ (_)")
    ),
  choiceValues = list(",", "\t", ";", " ")
  ),

p("正しい区切りと引用符を選ばないとデータがうまく入力されません。"),

a(tags$i("ここからサンプルデータをダウンロードできます"),href = "https://github.com/mephas/datasets")
  )
}

tabPanel.upload.pr <- function(file ="file", header="header", col="col", sep="sep", quote="quote"){

tabPanel("アップロード", p(br()),

p(tags$b("予測用のデータは、モデル内のすべての変数を持つ必要があります")),

#p("すべての独立変数（X）の左側に従属変数（Y）を置いてください"),

fileInput(file, "1. CSV / TXTファイルを選択", accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),

p(tags$b("2. 最初の行を列名として使用?")), 
#checkboxInput("header", "Yes", TRUE),
shinyWidgets::prettyToggle(
   inputId = header,
   label_on = "Yes", 
    icon_on = icon("check"),
   status_on = "info",
   status_off = "warning", 
    label_off = "No",
   icon_off = icon("xmark"),
   value = TRUE
),

p(tags$b("3. 最初の列を行名として使用? （重複なし）")), 
#checkboxInput("col", "Yes", TRUE),
shinyWidgets::prettyToggle(
   inputId = col,
   label_on = "Yes", 
    icon_on = icon("check"),
   status_on = "info",
   status_off = "warning", 
    label_off = "No",
   icon_off = icon("xmark"),
   value = TRUE
),

shinyWidgets::prettyRadioButtons(
   inputId = sep,
   label = "4. データの区切り文字?", 
   status = "info",
   fill = TRUE,
   icon = icon("check"),
  choiceNames = list(
	HTML("カンマ (,)：CSVでよく使用"),
    HTML("タブ1つ (->|)：TXTでよく使用"),
    HTML("セミコロン (;)"),
    HTML("スペース1つ (_)")
    ),
  choiceValues = list(",", "\t", ";", " ")
  ),

shinyWidgets::prettyRadioButtons(
   inputId = quote,
   label = "5. 文字の引用符?", 
   status = "info",
   fill = TRUE,
   icon = icon("check"),
  choices = c("なし" = "",
           "二重引用符(\")" = '"',
           "一重引用符(\')" = "'"),
  selected = '"'),

p("正しい区切りと引用符を選ばないとデータがうまく入力されません。"),

a(tags$i("ここからサンプルデータをダウンロードできます"),href = "https://github.com/mephas/datasets")
  )
}