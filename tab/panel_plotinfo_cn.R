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


####==========================================================================================


## RCTab test 

tabPanel.checktab <- function(label, tab.id1, tab.id2){

tabPanel("数据确认", p(br()),

p(tags$b(label)), p(br()), DT::DTOutput(tab.id1), p(br()), 

p(tags$b("期望值")), p(br()), DT::DTOutput(tab.id2))

}

tabPanel.perctab <- function(tab.id1, tab.id2, tab.id3){

tabPanel("百分比表", p(br()),

p(tags$b("单元格/行的合计的百分比（单位：100%）")),p(br()),
DT::DTOutput(tab.id1),p(br()),

p(tags$b("单元格/列的合计的百分比（单位：100%）")),p(br()),
DT::DTOutput(tab.id2),p(br()),

p(tags$b("单元格/合计的百分比（单位：100%）")),p(br()),
DT::DTOutput(tab.id3)
)

}


tabPanel.countplot2 <- function(plot.id1, plot.id2, width = 700){

tabPanel("频数直方图", 
p(br()),
p(tags$b("列分组")),
plotly::plotlyOutput(plot.id1, width = width),
p(tags$b("行分组")),
plotly::plotlyOutput(plot.id2, width = width)
)

}


tabPanel.countplot1 <- function(plot.id1, width = 700){

tabPanel("频数直方图", 
p(br()),
plotly::plotlyOutput(plot.id1, width = width)
)

}

tabsetPanel.kappa <- function(label, tab.id1, tab.id2, tab.id3){

tabsetPanel(

tabPanel("数据确认", p(br()),
p(tags$b(label)),p(br()),
DT::DTOutput(tab.id1)),

tabPanel("一致性表", p(br()),
DT::DTOutput(tab.id2)),

tabPanel("权重表", p(br()),
DT::DTOutput(tab.id3))

)

}


kappa.info <- function(){

HTML(
"
<b> Kappa评价和说明 </b> 
<ul>
<li> <b>Cohen's Kappa 统计系数>0.75</b>；b>出色的</b>可重复性 
<li> <b>0.4<=Cohen's Kappa 统计系数<=0.75</b>；<b>良好的</b>可重复性
<li> <b>00<=Cohen's Kappa 统计系数<0.4</b>；<b>较低的</b>可重复性 
<li> Cohen’s kappa 考虑了两个评分器之间的偏差，但没有考虑偏差度
<li> 加权 kappa 通过预定义权重表进行计算，该权重表权衡两个评分器之间的偏差度。偏差越大，加权越高
</ul>

"
)
}









