#
# Functions of some Panels
#
#

## Add new panel for T test

##
tabPanel.boxplot <- function(plot.id, width =500){

tabPanel("箱型图", 

p(br()),

plotly::plotlyOutput(plot.id, width = width),

p(br()),

HTML(
"
<b> 说明 </b>
<ul>
<li> 框内的条带为中位数
<li> 方框测量第75和第25个百分位数之间的差值
<li> 显示的点为可能的离群点（outlier）
</ul>
"
))

}

##
tabPanel.msdplot <- function(plot.id, width = 500){

tabPanel("均值和方差图", 

p(br()),

plotly::plotlyOutput(plot.id, width = width)

)
}


##
tabPanel.pdfplot <- function(plot.id1, plot.id2, plot.id3, bin.id, width = 500){

tabPanel("分布图", 

p(br()),

p(tags$b("正态QQ图")),
plotly::plotlyOutput(plot.id1, width = width),
p(br()),

p(tags$b("直方图")),
plotly::plotlyOutput(plot.id2, width = width),
p(br()),

sliderInput(bin.id,"直方图的分箱数",min = 0,max = 100,value = 0),
p("当分箱数为0时，绘图将使用默认分箱数。"),
p(br()),


p(tags$b("概率密度函数图")),
plotly::plotlyOutput(plot.id3, width = width),
p(br()),

HTML(
"
<b> 说明 </b>
<ul>
<li> 正态QQ图：将垂直轴上随机生成的独立标准正态数据与水平轴上的标准正态总体进行比较，点的线性表明数据呈正态分布
<li> 直方图：通过描述某一数值范围内出现的观察值频率，粗略评估给定变量的概率分布
<li> 密度图：估计数据的概率密度函数
</ul>
"
)

)

}

####==========================================================================================

## NPtest 

tabPanel.histplot <- function(plot.id1, plot.id2, bin.id, width = 500){


tabPanel("直方图", 
p(br()),

p(tags$b("直方图")),
plotly::plotlyOutput(plot.id1, width = width),
p(br()),

sliderInput(bin.id, "直方图的分箱数",min = 0,max = 100,value = 0),
p("当分箱数为0时，绘图将使用默认分箱数。"),
p(br()),

p(tags$b("密度图")),
plotly::plotlyOutput(plot.id2, width = width),
p(br()),

HTML(
"
<b> 说明 </b>
<ul>
<li> 直方图：通过描述某一数值范围内出现的观察值频率，粗略评估给定变量的概率分布
<li> 密度图：估计数据的概率密度函数
</ul>
"
)

)
}




























