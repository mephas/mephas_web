#****************************************************************************************************************************************************
sidebarLayout(

sidebarPanel(
  tags$head(tags$style("#strnum {overflow-y:scroll; max-height: 200px; background: white};")),
  tags$head(tags$style("#strfac {overflow-y:scroll; max-height: 100px; background: white};")),

h4(tags$b("准备训练集")),

tabsetPanel(

tabPanel("示例数据", p(br()),

  #selectInput("edata", tags$b("使用示例数据"),
  #      choices =  c("Breast Cancer"),
  #      selected = "Breast Cancer")

    shinyWidgets::radioGroupButtons(
   inputId = "edata",
   label = tags$b("使用示例数据"),
   choices =  c("Breast Cancer"),
   selected = "Breast Cancer",
   checkIcon = list(
    yes = tags$i(class = "fa fa-check-square", 
    style = "color: steelblue"),
   no = tags$i(class = "fa fa-square-o", 
  style = "color: steelblue"))
)
  ),

tabPanel.upload(file ="file", header="header", col="col", sep="sep", quote="quote")
  ),

hr(),

h4(tags$b("根据需要，更改变量的类型")),
p(br()),

uiOutput("factor1"),
# uiOutput("factor2"),

# h4(tags$b("是否更改分类变量的参照值（Reference level）")),

# uiOutput("lvl"),

# p(tags$b("2. 输入分类变量的参照值（Reference level）")),

# tags$textarea(id='ref',""),
hr(),

uiOutput("rmrow"),

hr(),

#h4(tags$b(actionLink("Model","Build Model")))
#h4(tags$b("Build Model in the Next Tab"))
p(br()),
actionButton("Model", "进入构建模型页面 >>",class="btn btn-primary",icon("location-arrow")),p(br()),
hr()

),

##########----------##########----------##########
mainPanel(

tabsetPanel(

tabPanel("数据确认", p(br()),

p(tags$b("数据确认")),p(br()),
DT::DTOutput("Xdata"),  

hr(),

p(tags$b("变量的类别")),p(br()),
DT::DTOutput("var.type")

),

tabPanel("描述统计量", p(br()),

p(tags$b("1. 数值变量")),p(br()),

DT::DTOutput("sum"),p(br()),

p(tags$b("2. 分类变量")),p(br()),
DT::DTOutput("fsum")

),


tabPanel("Logit图",p(br()),

# HTML("<p><b>Logit图</b>：。"),
# hr(),

uiOutput('tx'),p(br()),
uiOutput('ty'),p(br()),
p(tags$b("3.  更改X轴和Y轴名称")),
tags$textarea(id = "xlab", rows = 1, "X"),
tags$textarea(id = "ylab", rows = 1, "Y"),p(br()),

plotly::plotlyOutput("p1", width = 700)
),

tabPanel.pdfplot2("hx", "p2", "p21", "bin")


# tabPanel("直方图和概率密度图", p(br()),

# HTML("<p><b>直方图</b>：通过描述某一数值范围内出现的观察值频率，粗略显示一个变量的概率分布</p>"),
# HTML("<p><b>概率密度图</b>：显示变量的分布</p>"),
# hr(),

# uiOutput('hx'),
# p(tags$b("直方图")),
# plotly::plotlyOutput("p2"),
# sliderInput("bin", "直方图的分箱数", min = 0, max = 100, value = 0),
# p("当分箱数为0时，绘图将使用默认分箱数"),
# p(tags$b("密度图")),
# plotly::plotlyOutput("p21"))

))



# h4(tags$b("Output 1. 数据确认")),

# p(tags$b("数据确认")),
# DT::DTOutput("Xdata"),

# #p(tags$b("1. Numeric variable information list")),
# #verbatimTextOutput("strnum"),

# #p(tags$b("2. Categorical variable information list")),
# #verbatimTextOutput("strfac"),
# p(tags$b("变量的类别")),
# DT::DTOutput("var.type"),

# hr(),
# h4(tags$b("Output 2. 描述性结果")),

# tabsetPanel(

# tabPanel("描述统计量", p(br()),

# p(tags$b("1. 数值变量")),

# DT::DTOutput("sum"),

# p(tags$b("2. 分类变量")),
# DT::DTOutput("fsum")

# ),

# tabPanel("Logit图",p(br()),

# HTML("<p><b>Logit图</b>： 粗略表示任意两个数值变量之间的线性关系。"),
# hr(),

# uiOutput('tx'),
# uiOutput('ty'),
# p(tags$b("3.  更改X轴和Y轴标签")),
# tags$textarea(id = "xlab", rows = 1, "X"),
# tags$textarea(id = "ylab", rows = 1, "Y"),

# plotly::plotlyOutput("p1")
# ),

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


# ))
##########----------##########----------##########
)
