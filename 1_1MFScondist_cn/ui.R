

if (!requireNamespace("shiny", quietly = TRUE)) {install.packages("shiny")}; require("shiny",quietly = TRUE)
if (!requireNamespace("ggplot2",quietly = TRUE)) {install.packages("ggplot2")}; require("ggplot2",quietly = TRUE)
#if (!require("plotly")) {install.packages("plotly")}; library("plotly")
#if (!require("shinyWidgets")) {install.packages("shinyWidgets")}; library("shinyWidgets")


source("../tab/tab_cn.R")
source("../tab/panel_cn.R")
source("../tab/func.R")

tagList(

includeCSS("../www/style_cn.css"),
stylink(),
tabOF(),

##########--------------------##########--------------------##########

navbarPage(
theme = shinythemes::shinytheme("cerulean"),
#title = a("Continuous Probability Distribution", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
title = "连续概率分布",
collapsible = TRUE,
#id="navbar",
position="fixed-top",

##########----------##########----------##########
tabPanel("正态分布",

headerPanel("正态分布"),

#condiPa 1
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b>功能</b></h4>
<p><b>绘制基于数学的正态分布</b></p>
<ul>
<li> 绘制具有 N(&#956, &#963)的正态分布；&#956 表示均值（位置），&#963 表示标准差（形状）。</li>
<li> 计算用户定义概率 Pr(X &#8804; x<sub>0</sub>) 该概率为变量X在概率分布区间 (-&#8734, x<sub>0</sub>]内的可能性。 
<br> 曲线中，红线的左侧区域表示该可能性值，红线和水平轴（X轴）的交点为x<sub>0</sub>.</li>
<li> 计算变量X在区间 (&#956 &#8211; n &#215 &#963, &#956 + n &#215 &#963]内的可能性，即概率Pr(&#956 &#8211; n &#215 &#963 < X &#8804; &#956 + n &#215 &#963)。
<br> 曲线中，蓝色区域表示可能性值 </li>
</ul>
<p><b>绘制基于模拟的正态分布 </b></p>
<ul>
<li> 使用用户定义的样本量生成和下载正态分布的随机数。</li>
<li> 绘制生成随机数的直方图。</li>
<li> 计算所生成随机数的均值(&#956)和标准差 (&#963)</li>
<li> 计算用户定义概率 Pr(X &#8804; x<sub>0</sub>) 该概率为变量X在概率分布区间 (-&#8734, x<sub>0</sub>]内的可能性。</li>
</ul>
<p><b>绘制基于用户数据的正态分布</b></p>
<ul>
<li> 使用手动输入或从CSV/TXT文件上传您的数据。</li>
<li> 绘制数据的直方图和密度图。</li>
<li> 计算数据的均值(&#956)和标准差 (&#963)</li>
<li> 计算用户定义概率 Pr(X &#8804; x<sub>0</sub>) 该概率为变量X在概率分布区间 (-&#8734, x<sub>0</sub>]内的可能性。</li>
</ul>

<li><h4>示例</h4>
假设我们想看到N (0, 1) 的形状，并想知道1. Pr(X < x<sub>0</sub>) = 0.025 时，x<sub>0</sub> 在何处，及2. 均值+/- 1SD之间的概率是多少

<h4> 请按照以下<b>步骤</b>, <b>输出</b> 实时分析结果。</h4>
"
)
	),


hr(),

source("ui_N.R", local=TRUE, encoding = "utf-8")$value,

hr()
),

##########----------##########----------##########
tabPanel("指数分布",

headerPanel("指数分布"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 功能</b></h4>
<ul>
<li> 用E（比率）绘制指数分布；比率表示变化率</li>
<li> 得出 x0 的概率分布，其中 Pr(X &#8804; x<sub>0</sub>) =红线左侧</li>
<li> 得出基于模拟的选项卡中模拟数的概率分布 </li>
<li> 下载基于模拟的选项卡中的随机数</li>
<li> 得出和模拟数均值，SD， Pr(X &#8804; x<sub>0</sub>)</li>
<li> 得出数据的概率分布，将其与E（比率）进行粗略比较</li>
</ul>

<h4><i>示例</i></h4>
<i> 假设我们想看到 E(2)的形状，并想知道 Pr(X < x<sub>0</sub>)= 0.05时，x<sub>0</sub>的位置。</i>
<h4> 请按照以下<b>步骤</b>, <b>输出</b> 实时分析结果。</h4>

"

)
),

hr(),

source("ui_E.R", local=TRUE, encoding = "utf-8")$value,

hr()
),


##########----------##########----------##########
tabPanel("伽马分布",

headerPanel("伽马分布"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 功能</b></h4>
<ul>
<li> 使用Gamma(&#945, &#952)绘制伽马分布；&#945 控制形状，1/&#952 控制比率变化</li>
<li> 得出 x0 的概率分布，其中 Pr(X &#8804; x<sub>0</sub>) =红线左侧</li>
<li>  得出基于模拟的选项卡中模拟数的概率分布</li>
<li> 下载基于模拟的选项卡中的随机数<</li>
<li> 得出和模拟数均值，SD， Pr(X &#8804; x<sub>0</sub>)</li>
<li> 得出数据的概率分布，将其与Gamma(&#945, &#952)进行粗略比较  </li>
</ul>

<i><h4>示例</h4>
假设我们想看到 Gamma(9,0.5)的形状, 并想知道 Pr(X < x<sub>0</sub>)= 0.05时，x<sub>0</sub>的位置。</i>

<h4> 请按照以下<b>步骤</b>, <b>输出</b> 实时分析结果。</h4>
"
)
),

hr(),

source("ui_G.R", local=TRUE, encoding = "utf-8")$value,

hr()
),


##########----------##########----------##########
tabPanel("贝塔分布",

headerPanel("贝塔分布"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 功能</b></h4>
<ul>
<li> 绘制贝塔分布 Beta(&#945, &#946); &#945, &#946 控制形状
<li> 得出 x0 的概率分布，其中 Pr(X &#8804; x<sub>0</sub>) =红线左侧</li>
<li>  得出基于模拟的选项卡中模拟数的概率分布</li>
<li> 下载基于模拟的选项卡中的随机数<</li>
<li> 得出和模拟数均值，SD， Pr(X &#8804; x<sub>0</sub>)</li>
<li> 得出数据的概率分布，将其与Beta(&#945, &#946)进行粗略比较 </li>
</ul>

<h4><i>示例</i></h4>
<i>假设我们想看到 Beta(12, 12)的形状, 并想知道 Pr(X < x<sub>0</sub>)= 0.05时，x<sub>0</sub>的位置。</i>

<h4> 请按照以下<b>步骤</b>, <b>输出</b> 实时分析结果。</h4>
"
)
),

hr(),

source("ui_B.R", local=TRUE, encoding = "utf-8")$value,

hr()
),


##########----------##########----------##########
tabPanel("T分布",

headerPanel("学生T分布"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 功能</b></h4>
<ul>
<li> 绘制T分布 T(v); v 是与样本量有关的自由度，并控制形状</li>
<li> 得出 x0 的概率分布，其中 Pr(X &#8804; x<sub>0</sub>) =红线左侧</li>
<li>  得出基于模拟的选项卡中模拟数的概率分布</li>
<li> 下载基于模拟的选项卡中的随机数<</li>
<li> 得出和模拟数均值，SD， Pr(X &#8804; x<sub>0</sub>)</li>
<li> 得出数据的概率分布，将其与T(v)进行粗略比较 </li>
</ul>

<h4><i>示例</i></h4>
<i>假设我们想看到 T(4) 的形状，并想知道 Pr(X < x<sub>0</sub>)= 0.025时，x<sub>0</sub>的位置。</i>

<h4> 请按照以下<b>步骤</b>, <b>输出</b> 实时分析结果。</h4>
"
)
),

hr(),

source("ui_T.R", local=TRUE, encoding = "utf-8")$value,

hr()
),


##########----------##########----------##########
tabPanel("卡方分布",

headerPanel("卡方分布"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 功能</b></h4>
<ul>
<li> 绘制卡方分布 Chi(v); v 是与样本量有关的自由度，并控制形状</li>
<li> 得出 x0 的概率分布，其中 Pr(X &#8804; x<sub>0</sub>) =红线左侧</li>
<li>  得出基于模拟的选项卡中模拟数的概率分布</li>
<li> 下载基于模拟的选项卡中的随机数<</li>
<li> 得出和模拟数均值，SD， Pr(X &#8804; x<sub>0</sub>)</li>
<li> 得出数据的概率分布，将其与Chi(v)进行粗略比较 </li>
</ul>

<h4><i>示例</i></h4>
<i>假设我们想看到 Chi(4)的形状, 并想知道 Pr(X < x<sub>0</sub>)= 0.05时，x<sub>0</sub>的位置。</i>

<h4> 请按照以下<b>步骤</b>, <b>输出</b> 实时分析结果。</h4>
"
)
),

hr(),

source("ui_Chi.R", local=TRUE, encoding = "utf-8")$value,

hr()
),

##########----------##########----------##########
tabPanel("F分布",

headerPanel("F 分布"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 功能</b></h4>
<ul>
<li>  绘制 F分布 F(df<sub>1</sub>, df<sub>2</sub>) ; df<sub>1</sub> and df<sub>2</sub> 是与样本量相关的自由度，并控制形状
<li> 得出 x0 的概率分布，其中 Pr(X &#8804; x<sub>0</sub>) =红线左侧
<li>  得出基于模拟的选项卡中模拟数的概率分布
<li> 下载基于模拟的选项卡中的随机数<
<li> 得出和模拟数均值，SD， Pr(X &#8804; x<sub>0</sub>)
<li> 得出数据的概率分布，将其与F(df<sub>1</sub>, df<sub>2</sub>)进行粗略比较 
</ul>

<h4><i>示例</i></h4>
<i>假设我们想看到 F(100, 10)的形状, 并想知道 Pr(X < x<sub>0</sub>)= 0.05时，x<sub>0</sub>的位置。</i>

<h4> 请按照以下<b>步骤</b>, <b>输出</b> 实时分析结果。</h4>
"
)
),

hr(),

source("ui_F.R", local=TRUE, encoding = "utf-8")$value,

hr()
),

##########----------##########----------##########
tablang("1_1MFScondist"),
tabstop(),
tablink()

#navbarMenu("",icon=icon("link"))

))

