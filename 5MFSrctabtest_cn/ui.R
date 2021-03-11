#if (!require("psych")) {install.packages("psych")}; library("psych")
if (!requireNamespace("shiny", quietly = TRUE)) {install.packages("shiny")}; require("shiny",quietly = TRUE)
if (!requireNamespace("ggplot2",quietly = TRUE)) {install.packages("ggplot2")}; require("ggplot2",quietly = TRUE)
#if (!require("DT")) {install.packages("DT")}; library(DT)
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
#title = a("Test for Contingency Table", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
title = "列联表的检验",
collapsible = TRUE,
#id="navbar", 
position="fixed-top",
##########----------##########----------##########
tabPanel("2x2",

headerPanel("病例对照状态 2 类因子的卡方检验"),

conditionalPanel(
condition = "input.explain_on_off",
HTML("

<h4><b> 1. 功能   </b></h4>
<ul>
<li> 测定病例对照状态（行）和因子类别（列）之间是否存在关联</li>
<li> 测定 2 个独立样本中的比例是否相同</li>
<li> 测定比例是否均质</li>
<li> 获取百分比表和图表以及每个单元格的期望值</li>
</ul>

<h4><b> 2. 计数数据为4-单元2×2列联表 </b></h4>

<ul>
<li> 病案对照状态有2个类别（行名）</li>
<li> 因子状态有2个类别（列名）</li>
<li> 每个单元格独立，有较多的计数</li>
</ul>

<h4><i>示例</i></h4>
<i>假设想知道经口避孕药（OC）使用者和心肌梗塞（MI）之间的关系。在一项研究中，调查了5000名OC使用者和10000名OC非使用者的数据，
并将他们分为MI和非MI患者组。5000名OC使用者中，13人出现MI；10000名OC非使用者中，7人发生MI。想要测定OC的使用是否与较高的MI发生率显著相关。</i>
<h4>请按照以下<b>步骤</b>，<b>输出</b>实时分析结果。</h4>
"
)
),
hr(),

source("ui_1_chi.R", local=TRUE)$value,

hr()
),

##########----------##########----------##########
tabPanel("2x2(精确检验)",

headerPanel("病例对照条件下 2 类小期望计数因子的费雪精确检验"),

conditionalPanel(
condition = "input.explain_on_off",
HTML("
<h4><b> 1. 功能  </b></h4>
<ul>
<li> 测定病例对照状态（行）和因子状态（列）之间是否存在关联</li>
<li> 测定 2 个相依样本中的比例是否相同</li>
<li> 测定比例是否均质</li>
<li> 获取百分比表和图表以及每个单元格的期望值</li>

</ul>

<h4><b> 2. 计数数据为2×2列联表</b></h4>

<ul>
<li> 病案对照状态有2个类别（行名）</li>
<li> 因子状态有2个类别（列名）</li>
<li> 每个单元格独立</li>
<li> 数据的期望值很小</li>
</ul>

<h4><i>示例</i></h4>
<i>假设想知道心血管疾病（CVD）和高盐饮食之间的关系。在一项研究中，调查了35例CVD患者和25例非CVD患者的数据，并将他们分为高盐饮食组和低盐饮食组。
35例CVD患者中，5例为高盐饮食；25例非CVD患者中，2例为高盐饮食。想要测定CVD是否与高盐饮食显著相关。</i>
<h4>请按照以下<b>步骤</b>，<b>输出</b>实时分析结果。</h4>
"
)
),
hr(),

source("ui_2_fisher.R", local=TRUE)$value,
hr()
),

##########----------##########----------##########
tabPanel("2x2(配对)",

headerPanel("病例对照条件下 2 类因子配对计数的McNemar检验"),

conditionalPanel(
condition = "input.explain_on_off",
HTML("
<h4><b> 1. 功能  </b></h4>
<ul>
<li> 测定匹配样本的两个因子是否有显著差异</li>
<li> 获取百分比表和图表以及每个单元格的期望值</li>


</ul>

<h4><b> 2. 计数数据为2×2列联表和配对计数</b></h4>

<ul>
<li> 病例对照结果有2个类别（在行名和列名中）</li>
<li> 因子状态有2个类别（在行名和列名中）</li>
<li> 数据样本为匹配/配对数据</li>
<li> 知道<b>一致对</b>，即匹配对组成的结果均相同</li>
<li> 知道<b>不一致对</b>，即匹配对组成的结果均不同</li>
</ul>

<h4><b> 3. 2×2列联表中的配对计数</b></h4>

<ul>
<li> 两对患者配对，年龄和临床情况相似。一组接受治疗A，另一组接受治疗B，记录有多少人好转，有多少人恶化。</li>
<li> 对于<b>一致对</b>，匹配对组成均改善或恶化</li>
<li> 对于<b>不一致对</b>，匹配对的一个组成改善或恶化</li>
</ul>


<i><h4>示例</h4>
假设想比较两种治疗方法的疗效。调查了两组患者，一组患者接受A治疗，另一组患者接受B治疗。两组患者配对，共组成621对。每一配对中，一个患者接受A治疗，另一个接受B治疗。在621对中，有510对经过A、B治疗后均好转；90对经过A、B治疗后无变化。16对中，接受A治疗的患者好转；5组中，接受B治疗的患者好转。
</h4></i>
<h4>请按照以下<b>步骤</b>，<b>输出</b>实时分析结果。</h4>
"
)
),
hr(),

source("ui_3_mcnemar.R", local=TRUE)$value,

hr()
),

##########----------##########----------##########
tabPanel("2xC",

headerPanel("病例对照条件下3个以上类别因子的卡方检验"),
conditionalPanel(
condition = "input.explain_on_off",
HTML("
<h4><b> 1. 功能  </b></h4>
<ul>
<li> 测定病例对照状态（行）和因子状态（列）之间是否存在关联</li>
<li> 测定多组数据背后的总体比率/比例是否有显著差异</li>
<li> 获取百分比表和图表以及每个单元格的期望值</li>

</ul>

<h4><b> 2. 计数数据为2×C列联表</b></h4>

<ul>
<li> 病例对照结果有2个类别（在行名和列名中）</li>
<li> 因子状态超过2个类别（在行名和列名中）</li>
<li> 组数据来自二项分布（成功比例）</li>
<li> 知道各组的整个样本和指定事件的数量（子组比例）</li>
<li> 多组为独立观察值</li>
</ul>

<h4><i>示例</i></h4>
<i>假设我们想研究第一次生育年龄与乳腺癌发展之间的关系。因此，我们调查了3220例乳腺癌患者和10254例非乳腺癌患者。然后，我们将参加者分为不同的年龄组。
我们想知道不同年龄组患癌症的概率是否不同；或者她们的年龄是否与乳腺癌有关。
</i>
<h4>请按照以下<b>步骤</b>，<b>输出</b>实时分析结果。</h4>
"
)
),
hr(),

source("ui_4_2cchi.R", local=TRUE)$value,

hr()
),

##########----------##########----------##########

tabPanel("RxC",

headerPanel("3个以上状态中因子的3个以上因子类别的卡方检验"),

conditionalPanel(
condition = "input.explain_on_off",
HTML("
<h4><b> 1. 功能</b></h4>
<ul>
<li> 测定病例对照状态（行）和因子状态（列）之间是否存在关联</li>
<li> 测定多组数据背后的总体比率/比例是否有显著差异</li>
<li> 获取百分比表和图表以及每个单元格的期望值</li>

</ul>

<h4><b> 2. 计数数据为R×C列联表</b></h4>

<ul>
<li> 组数据来自二项分布（成功比例）</li>
<li> 知道各组的整个样本和指定事件的数量（子组比例）</li>
<li> 多组为独立观察值</li>
</ul>

<h4><i>示例</i></h4>
<i>假设想知道 3 种治疗方式（青霉素、低剂量大观霉素和高剂量大观霉素）与患者反应的关系。在一项研究中，登记了400名患者，200名患者使用青霉素，100名患者使用低剂量大观霉素，
100名患者使用高剂量大观霉素。200例青霉素使用者中，40例涂片+，30例涂片培养+，130例涂片培养-。100例低剂量大观霉素使用者中，10例涂片+，20例涂片培养+，
70例涂片培养-。在100例高剂量大观霉素使用者中，15例涂片+，40例涂片培养+，45例涂片培养-。想知道治疗是否与反应有显著联系。
</i>
<h4>请按照以下<b>步骤</b>，<b>输出</b>实时分析结果。</h4>
"
)
),

hr(),
source("ui_5_rcchi.R", local=TRUE)$value,
hr()
),


##########----------##########----------##########

tabPanel("Kappa统计系数(2xK)",

headerPanel("两个评分器可重复性/一致性的 Kappa 统计系数"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. 功能</b></h4>
<ul>
<li> 从两个评分器或两个排名中量化一致性</li>
<li> 获取百分比表及每个单元格的期望值</li>
</ul>

<h4><b> 2. 计数数据为2×K列联表</b></h4>

<ul>
<li> 两个评分器的结果或两个测量值（例如，Y/N 答案、排名、类别）</li>
</ul>

<h4><i>示例</i></h4>
<i>假设想检查来自两个调查的答案一致性。在一项调查中，评分从1到9，而在另一项调查中，使用别种评分。想检查这两个答案是否可复制，或者这两个调查是否一致。
</i>
<h4>请按照以下<b>步骤</b>，<b>输出</b>实时分析结果。</h4>
"
)
),

hr(),
source("ui_6_2kappa.R", local=TRUE)$value,

hr()

),

##########----------##########----------##########

tabPanel("Kappa统计系数(KxK)",

headerPanel("重复/相关测量重复性的Kappa统计系数"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<p> 此方法使用不同类型的数据。它使用 K×K 表中所示的一致和不一致计数。</p>

<h4><b> 1. 功能  </b></h4>
<ul>
<li> 对多次测量的同一变量的可重复性进行量化</li>
<li> 量化具有相同结果的2项测量值之间的关联</li>
<li> 获取百分比表及每个单元格的期望值</li>

</ul>

<h4><b> 2. 计数数据为K×K列联表</b></h4>

<ul>
<li> 知道<b>结果的一致性</b>、即重复测量中测量结果均相同</li>
<li> 知道<b>结果的不一致</b>、即重复测量中测量结果不同</li>
</ul>

<h4><i>示例</i></h4>
<i>假设在一项研究中，对一组患者做了同样问题的两次调查。
想知道在两次调查中一致性的百分比。最终结果是136名患者对两次调查的回答均为是，240名患者对两次调查的回答均为否。
69人在第一次调查中回答“否”，在第二次调查中回答“是”，92人在第一次调查中回答“是”，在第二次调查中回答“否”。
想知道调查的一致性是否良好。
</i>
<h4>请按照以下<b>步骤</b>，<b>输出</b>实时分析结果。</h4>
"
)
),

hr(),
source("ui_7_kappa.R", local=TRUE)$value,

hr()

),
##########----------##########----------##########

tabPanel("(2x2)xK",

headerPanel("K混杂层病例对照条件下 2 类因子的Mantel-Haenszel检验"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. 功能</b></h4>
<ul>
<li> 通过控制分层/混杂测定病例对照状态（行）和因子状态（列）之间是否存在关联</li>
<li> K层中的两个标称变量具有条件独立性</li>
<li> 获取百分比表和图表以及每个单元格的期望值</li>

</ul>

<h4><b> 2. 计数数据为K层下的2×2列联表</b></h4>

<ul>
<li> 若干 2×2 列联表的计数</li>
<li> 每个2×2列联表在单因子分层中</li>
</ul>

<h4><i>示例</i></h4>
<i>假设想看看被动吸烟对癌症风险的影响。一个潜在的混杂因素是参与者自己吸烟。
因为个人吸烟既与癌症风险有关，也与配偶吸烟有关。
因此，在研究被动吸烟与癌症风险之间的关系之前，我们控制了个人主动吸烟。
绘制了两张2×2 表格，一张为主动吸烟组，有466人，另一张为非主动吸烟组，有532人。
如输入数据所示。想知道在控制主动吸烟后，被动吸烟是否与癌症风险显著相关；或者，让步比是否有显著差异。
</i>
<h4>请按照以下<b>步骤</b>，<b>输出</b>实时分析结果。</h4>
"
)
),

hr(),
source("ui_8_mh.R", local=TRUE)$value,

hr()

),

##########----------##########----------##########

tabPanel("(RxC)xK",

headerPanel("K分层中3个以上状态中因子的3个以上因子类别的Cochran-Mantel-Haenszel"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. 功能</b></h4>
<ul>
<li> 通过控制分层/混杂测定病例对照状态（行）和因子状态（列）之间是否存在关联</li>
<li> K层中的两个标称变量具有条件独立性</li>
<li> 获取百分比表和图表以及每个单元格的期望值</li>

</ul>

<h4><b> 2. 计数数据为 K层下的R×C列联表</b></h4>

<ul>
<li> 若干 R×C 表的计数</li>
<li> 每个 R×C 列联表在单因子分层中</li>

</ul>

<h4><i>示例</i></h4>
<i>假设想知道打鼾和年龄之间的关系。对3513名30-60岁的人进行了调查，其中女性1843人，男性1670人。
考虑到性别可能是本研究中的混杂变量，编制了女性和男性层的3×2表。想知道在控制性别后，年龄是否与打鼾显著相关。
</i>
<h4>请按照以下<b>步骤</b>，<b>输出</b>实时分析结果。</h4>
"
)
),

hr(),
source("ui_9_cmh.R", local=TRUE)$value,

hr()

),

##########----------##########----------##########

tablang("5MFSrctabtest"),
tabstop(),
tablink()
#navbarMenu("",icon=icon("link"))


))


