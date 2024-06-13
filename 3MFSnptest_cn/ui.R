if (!requireNamespace("shiny", quietly = TRUE)) {install.packages("shiny")}; require("shiny",quietly = TRUE)
if (!requireNamespace("ggplot2",quietly = TRUE)) {install.packages("ggplot2")}; require("ggplot2",quietly = TRUE)
# if (!require("reshape")) {install.packages("reshape")}; library("reshape")
if (!requireNamespace("exactRankTests",quietly = TRUE)) {install.packages("exactRankTests")}; require("exactRankTests",quietly = TRUE)  
# if (!require("psych")) {install.packages("psych")}; library("psych")
# if (!require("DT")) {install.packages("DT")}; library("DT")
# if (!require("plotly")) {install.packages("plotly")}; library("plotly")
# if (!require("shinyWidgets")) {install.packages("shinyWidgets")}; library("shinyWidgets")

source("../tab/tab_cn.R", encoding="utf-8")
source("../tab/panel_cn.R", encoding="utf-8")
source("../tab/panel_plotinfo_cn.R", encoding="utf-8")
source("../tab/func.R", encoding="utf-8")
Sys.setlocale(locale = "Chinese")

tagList(
includeCSS("../www/style_cn.css"),
stylink(),
tabOF(),

##########--------------------##########--------------------##########

navbarPage(
#theme = shinythemes::shinytheme("cerulean"),
#title = a("Non-parametric Test for Medians", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
title = "非参数检验法",
collapsible = TRUE,
#id="navbar", 
position="fixed-top",


##########----------##########----------##########

tabPanel("单样本",

headerPanel("单样本的威尔科克森符号秩检验（Wilcoxon Signed-Rank Test）"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
    "
<p>数据不能假定为正态分布时，这种方法是单样本T检验的替代方法。这种方法基于观测值的大小排序。</p>

<h4><b> 1. 功能  </b></h4>
<ul>
<li> 检验数据来源的总体的中位数/位置在统计学上是否与指定的中位数有显著差异    
<li> 有关数据的基本描述性统计信息     
<li> 数据的描述性统计图，如箱形图、分布直方图及密度分布图
</ul>

<h4><b> 2. 关于数据 </b></h4>

<ul>
<li> 数据仅包含1组值（或 1 个数字向量）    
<li> 该组值是相互独立的观测    
<li> 不假设数据的分布形状，数据可以不是正态分布的
</ul>

<i>
<h4>示例</h4>

假设从一组特定患者中收集了9名患者的抑郁评定量表(DRS) 测量结果。DRS评分>1表示“抑郁”。想知道患者的DRS是否显著大于1。
</i>

<h4>请参考以下步骤，输出分析结果。</h4>
"
)
),

hr(),
source("ui_1.R", local=TRUE, encoding = "utf-8")$value,
hr()

),

##########----------##########----------##########

tabPanel("双样本",

headerPanel("两个独立样本的威尔科克森秩和检验/曼-惠特尼U检验（Wilcoxon Rank-Sum Test/Mann–Whitney U Test)"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(

    "
<p>数据不能假定为正态分布时，这种方法是独立双样本T检验的替代方法。</p>

<h4><b> 1. 功能  </b></h4>
<ul>
<li> 测定2组数据来源的总体中位数在统计学上是否存在显著差异    
<li> 测定2组数据的来源的分布位置是否不同     
<li> 了解有关数据的基本描述性统计信    
<li> 了解数据的描述性统计图，如箱形图、分布直方图及密度分布图
</ul>

<h4><b> 2. 关于数据 </b></h4>

<ul>
<li> 数据仅包含2组数据（或2个数字向量）      
<li> 两组数据相互独    
<li> 不假设数据的分布形状<；/li>
<li> 数据可以不是正态分布
</ul>

<i>
<h4>示例</h4>

假设从一组特定患者中收集了19名患者的抑郁评定量表(DRS) 测量结果。
19人中有9名女性，10名男性。
我们想知道不同性别患者的DRS是否有显著性差异；或者，年龄是否与DRS评分有关。
</i>

<h4>请参考以下步骤，输出分析结果。</h4>
"
 )
),

hr(),
source("ui_2.R", local=TRUE, encoding = "utf-8")$value,
hr()

),

##########----------##########----------##########
tabPanel("配对样本",

headerPanel("两个配对样本的威尔科克森符号秩检验(Wilcoxon Signed-Rank Test)"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
    "
<b>配对情况下，比较2组的差异为零。因此，成为一个单样本检验问题。</b>
<p>数据不能假定为正态分布时，这种方法是配对样本 t 检验的替代方法。</p>

<h4><b> 1. 功能  </b></h4>
<ul>
<li> 检验配对数据的差异是否在统计学上与0显著不同     
<li> 了解有关数据的基本描述性统计信    
<li> 了解数据的描述性统计图，如箱形图、分布直方图及密度分布图
</ul>

<h4><b> 2. 关于数据 </b></h4>

<ul>
<li> 数据包含2组值（或2个数字向量        
<li> 该等值为配对或匹配的观    
<li> 不假设数据的分布形状     
<li> 数据可以不是正态分布
</ul>

<h4><b> 3. 匹配或配对数据示例 </b></h4>
<ul>
<li>  一个人的前测和后测评    
<li>  两个样本匹配或配对时
</ul>


<i>
<h4>示例</h4>

我们想知道患者治疗前后的DRS是否有显著；或者，差异是否与0显著不同，这可以表明治疗是否有效。
</i>

<h4>请参考以下步骤，输出分析结果。</h4>
"
)
),

hr(),
source("ui_p.R", local=TRUE, encoding = "utf-8")$value,
hr()

),
##########----------##########----------##########

tablang("3MFSnptest"),
tabstop(),
tablink()
#navbarMenu("",icon=icon("link"))

))

