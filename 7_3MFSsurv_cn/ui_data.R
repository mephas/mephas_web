#****************************************************************************************************************************************************

sidebarLayout(

sidebarPanel(

  tags$style(type='text/css', '#surv {background-color: rgba(0,0,255,0.10); color: blue;}'),
  tags$head(tags$style("#fsum {overflow-y:scroll; max-height: 200px; background: white};")),
  tags$head(tags$style("#strnum {overflow-y:scroll; max-height: 200px; background: white};")),
  tags$head(tags$style("#strfac {overflow-y:scroll; max-height: 200px; background: white};")),
  tags$head(tags$style("#kmat1 {overflow-y:scroll; max-height: 200px; background: white};")),

h4(tags$b("准备训练集")),

tabsetPanel(

tabPanel("示例数据", p(br()),

#selectInput("edata", tags$b("使用示例数据"),
#        choices =  c("Diabetes","NKI70"),
#        selected = "Diabetes")
#),

shinyWidgets::radioGroupButtons(
   inputId = "edata",
   label = tags$b("使用示例数据"),
   choices = c("Diabetes","NKI70"),
   selected = "Diabetes",
   checkIcon = list(
    yes = tags$i(class = "fa fa-check-square", 
    style = "color: steelblue"),
   no = tags$i(class = "fa fa-square-o", 
  style = "color: steelblue"))
)
),

tabPanel.upload(file ="file", header="header", col="col", sep="sep", quote="quote")

),
tags$i("糖尿病数据只有一个持续时间变量，而Nki70数据有开始时间和结束时间。"),
hr(),

h4(tags$b("第2步 创建生存对象")),

#p(tags$b("1. Choose a Time Variable")),

uiOutput('c'),

  selectInput(
      "time", "2. 选择时间数据格式",
      c("时间区间" = "A",
        "开始时间和结束时间" = "B"
        )),
  p("时间区间只有一个时间变量"),
  p("开始时间和结束时间需要两个时间变变量"),


conditionalPanel(
  condition = "input.time == 'A'",
  uiOutput('t')
  ),
conditionalPanel(
  condition = "input.time == 'B'",
  uiOutput('t1'),
  uiOutput('t2')
  ),

tags$i("糖尿病数据具有右删失时间，而Nki70数据具有左截断的右删失时间。"),

hr(),
h4(tags$b("第3步 检查生存对象")),
p(tags$b("有效生存对象示例： Surv (time, status)")),
p(tags$b("或，Surv (start.time, end.time, status)")),
verbatimTextOutput("surv", placeholder = TRUE),


hr(),


h4(tags$b("更改某个变量的类型？")),

uiOutput("factor1"),

# uiOutput("factor2"),

# h4(tags$b("是否更改分类变量的参考级别？")),

# uiOutput("lvl"),

# p(tags$b("2. 输入参考级别，每行为一个变量")),

# tags$textarea(id='ref', column=40, ""),

hr(),

uiOutput("rmrow"),

hr(),
p(br()),
#h4(tags$b(actionLink("Non-Parametric Model","Build Non-Parametric Model"))),
#h4(tags$b(actionLink("Semi-Parametric Model","Build Semi-Parametric Model"))),
#h4(tags$b(actionLink("Parametric Model","Build Parametric Model")))
#h4(tags$b("Build Model in the Next Tab"))

actionButton("Non-Parametric Model", "Kaplan-Meier估计 >>",class="btn btn-primary",icon("location-arrow")),p(br()),
actionButton("Semi-Parametric Model", "构建Cox模型 >>",class="btn btn-primary",icon("location-arrow")),p(br()),
actionButton("Parametric Model", "构建AFT模型 >>",class="btn btn-primary",icon("location-arrow")),p(br()),

hr()
),

##########----------##########----------##########

mainPanel(
h4(tags$b("Output 1. 数据确认")),
p(tags$b("数据确认")),
p(br()),
DT::DTOutput("Xdata"),

p(tags$b("1. 数值型变量表")),
verbatimTextOutput("strnum"),


p(tags$b("2. 分类变量表")),
verbatimTextOutput("strfac"),


hr(),
h4(tags$b("Output 2. 描述性结果")),

tabsetPanel(

tabPanel("描述统计量", p(br()),

p(tags$b("1. 数值变量")),

DT::DTOutput("sum"),

p(tags$b("2. 分类变量")),
verbatimTextOutput("fsum"),

downloadButton("download2", "下载结果（分类变量）")

),

tabPanel("生存曲线",  p(br()),
  radioButtons("fun1", "请选择一个图",
  choiceNames = list(
    HTML("1. 生存概率(存活率)"),
    HTML("2. 累积事件"),
    HTML("3. 累积危险")
    ),
  choiceValues = list("pct", "event","cumhaz")
  ),
plotOutput("km.a"),
verbatimTextOutput("kmat1")
     ),

tabPanel("生命表",  p(br()),
DT::DTOutput("kmat")
     ),

tabPanel.pdfplot2("hx", "p2", "p21", "bin")
# tabPanel("直方图和密度分布图", p(br()),

# HTML("<p><b>直方图</b>：通过描述某一数值范围内出现的观察值频率，粗略显示一个变量的概率分布。</p>"),
# HTML("<p><b>密度图</b>：显示变量的分布。</p>"),
# hr(),

# uiOutput('hx'),
# p(tags$b("直方图")),
# plotly::plotlyOutput("p2"),
# sliderInput("bin", "直方图的分箱数", min = 0, max = 100, value = 0),
# p("当分箱数为0时，绘图将使用默认分箱数"),
# p(tags$b("密度图")),
# plotly::plotlyOutput("p21"))

)

)
##########----------##########----------##########

)
