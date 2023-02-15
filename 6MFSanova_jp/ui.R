 
if (!requireNamespace("shiny", quietly = TRUE)) {install.packages("shiny")}; require("shiny",quietly = TRUE)
if (!requireNamespace("ggplot2",quietly = TRUE)) {install.packages("ggplot2")}; require("ggplot2",quietly = TRUE)
#if (!require("psych")) {install.packages("psych")}; library("psych")
#if (!require("DescTools")) {install.packages("DescTools")}; library("DescTools")
if (!require("dunn.test")) {install.packages("dunn.test")}; library("dunn.test")
#if (!require("DT")) {install.packages("DT")}; library("DT")
#if (!require("plotly")) {install.packages("plotly")}; library("plotly")
#if (!require("shinyWidgets")) {install.packages("shinyWidgets")}; library("shinyWidgets")

source("../tab/tab_jp.R")
source("../tab/panel_jp.R")
source("../tab/func.R")

tagList(

includeCSS("../www/style_jp.css"),
stylink(),
tabOF(),

##########--------------------##########--------------------##########

navbarPage(
theme = shinythemes::shinytheme("cerulean"),
#title = a("Test for Contingency Table", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
title = "分散分析",
collapsible = TRUE,
#id="navbar", 
position="fixed-top",

##########----------##########----------##########
tabPanel("一元配置分散分析(1-way ANOVA)と多重比較",

headerPanel("複数の因子群の平均を比較する一元配置分散分析(ANOVA)と、特定の群に関する多重比較の事後補正"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. 使用できる機能  </b></h4>
<ul>
<li> 因子群間で平均に有意差があるかを調べる</li>
<li> 一元配置ANOVAでは因子群間の有意差を測定することから、ペアの間で平均に有意差があるかを調べる</li>

</ul>

<h4><b> 2. 使用するデータについて </b></h4>

<ul>
<li> データに、2つのベクトルで示されるいくつかの別々の因子群がある</li>
<li> 1つのベクトルは観察値で、もう1つのベクトルは異なる因子群をマークするためのものである</li>
<li> 各因子群は独立しており、ほぼ正規分布となっている</li>
<li> 因子群の各平均は、分散が同じ正規分布であり、比較することができる</li>
</ul>

<h4><i>使用例</i></h4>
<i>受動喫煙ががんの発現率に測定可能な影響を及ぼすかを調べたいとします。ある試験で、喫煙状態に応じて参加者を非喫煙者 (NS)、受動喫煙者 (PS)、たばこをふかす喫煙者 (NI) 、軽度の喫煙者 (LS)、中等度の喫煙者 (MS)、および重度の喫煙者 (HS) の6群に分けました。この試験では、努力最大呼気中間流量 (FEF) を測定しました。これらの6群間でFEFの差を調べたいとします。
</i>


<h4> <b>手順</b>にしたがって進むと、<b>アウトプット</b>に解析結果がリアルタイムで出力されます。</h4>
"
)
),

hr(),
source("ui_1.R", local=TRUE, encoding = "utf-8")$value,
hr(),
source("ui_1m.R", local=TRUE, encoding = "utf-8")$value,
hr()

),

##########----------##########----------##########

tabPanel("二元配置分散分析(2-way ANOVA)と多重比較",

headerPanel("複数の群の平均を比較する二元配置分散分析と、特定の群に関する多重比較の事後補正"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. 使用できる機能</b></h4>
<ul>
<li> 因子2を制御した上で、因子1について平均に有意差があるかを調べる</li>
<li> 因子1を制御した上で、因子2について平均に有意差があるかを調べる</li>
<li> 因子1と因子2の間に相互作用があり、アウトカムに影響を与えているかを調べる</li>
<li> 二元配置ANOVAでは群間での有意差を測定することから、どのペアで平均に有意差があるかを調べる</li>

</ul>

<h4><b> 2. 使用するデータについて </b></h4>

<ul>
<li> データにはいくつかの別々の因子群 (または2つのベクトル) がある</li>
<li> 別々の因子群/セットは独立しており、ほぼ正規分布となっている</li>
<li> 因子群の各平均は、分散が同じ正規分布であり、比較することができる</li>
</ul>

<h4><i>使用例</i></h4>
<i>性別と3種類の食事法が収縮期血圧 (SBP) に与える効果を調べたいとします。3種類の食事法は、厳格なベジタリアン (SV)、ラクトベジタリアン (LV)、通常の食事を摂っている人 (NOR) とし、SBPを調べました。
性別と食事群の作用は、互いに関連がある (相互作用がある) 可能性があります。
食事群と性別がSBPに影響を与えるか、またはこれらの因子が互いに関連があるかを調べたいとします。
</i>


<h4> <b>手順</b>にしたがって進むと、<b>アウトプット</b>に解析結果がリアルタイムで出力されます。</h4>
"
)
),

hr(),
source("ui_2.R", local=TRUE, encoding = "utf-8")$value,
hr(),
source("ui_2m.R", local=TRUE, encoding = "utf-8")$value,
hr()
),
#

##########----------##########----------##########
tabPanel("ノンパラメトリック方法",

headerPanel("複数の標本を比較するKruskal-Wallisノンパラメトリック検定と、特定の群に関する多重比較事後補正"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<b>この方法では平均とSDではなく、観察データの順位を比較します。データの分布を仮定しない、一元配置ANOVAの代わりとなる方法です。</b>

<h4><b> 1. 使用できる機能</b></h4>
<ul>
<li> 因子群間で平均に有意差があるかを調べる</li>
<li> 一元配置ANOVAでは群間の有意差を測定することから、ペアの間で平均に有意差があるかを調べる</li>

</ul>

<h4><b> 2. 使用するデータについて</b></h4>

<ul>
<li> データに、2つのベクトルで示されるいくつかの別々の因子群がある</li>
<li> 1つのベクトルは観察値で、もう1つのベクトルは異なる因子群をマークするためのものである</li>
<li> 別々の因子群は独立しており、分布に対する仮定はない</li>
</ul>

<h4><i>使用例</i></h4>
<i>受動喫煙ががんの発現率に測定可能な影響を及ぼすかを調べたいとします。
ある試験で、喫煙状態に応じて参加者を非喫煙者 (NS)、受動喫煙者 (PS)、たばこをふかす喫煙者 (NI) 、軽度の喫煙者 (LS)、中等度の喫煙者 (MS)、および重度の喫煙者 (HS) の6群に分けました。
この試験では、努力最大呼気中間流量 (FEF) を測定しました。これらの6群間でFEFの差を調べたいとします。
</i>


<h4> <b>手順</b>にしたがって進むと、<b>アウトプット</b>に解析結果がリアルタイムで出力されます。</h4>
"
)
),
hr(),
source("ui_np1.R", local=TRUE, encoding = "utf-8")$value,
hr(),
source("ui_np1m.R", local=TRUE, encoding = "utf-8")$value,
hr()
),

##########----------##########----------##########

tablang("6MFSanova"),
tabstop(),
tablink()
#navbarMenu("",icon=icon("link"))


))
#)
