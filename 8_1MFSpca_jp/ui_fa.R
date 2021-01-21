#****************************************************************************************************************************************************fa

sidebarLayout(

sidebarPanel(

#tags$head(tags$style("#x_fa {height: 150px; background: ghostwhite; color: blue;word-wrap: break-word;}")),
tags$head(tags$style("#fa {overflow-y:scroll; max-height: 300px; background: white};")),
tags$head(tags$style("#tdtrace.fa {overflow-y:scroll; height: 150px; background: white};")),

h4(tags$b("モデルを構築する")),
p("データタブでデータを作成します。"),
p("変数 (列) の数は標本 (行) の数よりも少なくなければなりません。"),
p(tags$i("ここではサンプルデータはマウスのデータです。")),


hr(),     

h4(tags$b("Step 1. モデルを構築するパラメータを選択する")),    

uiOutput('x.fa'), 

numericInput("ncfa", "2. 因子の数 (A < Xの次元)", 3, min = 1, max = NA),
p(tags$i("並列分析で示唆される結果に従い、データから3因子を生成することを選択します。")),
hr(),
h4(tags$b("Step 2. データとモデルが準備できたら、青色のボタンをクリックしてモデルの結果を生成")),

#actionButton("pca1.fa", (tags$b("Show Results >>")),class="btn btn-primary",icon=icon("bar-chart-o"))
p(br()),
actionButton("pca1.fa", (tags$b("結果を表示 >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
p(br()),
p(br()),
hr()
),

mainPanel(

h4(tags$b("Output 1. データの確認")),

tags$b("データの一部"),
p("データタブでデータを編集してください"),
DT::DTOutput("table.x.fa"),

hr(),

h4(tags$b("Output 2. モデルの結果")),
#actionButton("pca1.fa", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")),  style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
# p(br()),

tabsetPanel(
tabPanel("因子分析の結果",p(br()),
    HTML("
<b>説明</b>
<ul>
<li> このプロットでは因子と変数の関係をグラフにします。</li>
<li> ウィンドウ内の結果は、因子の十分性に関する統計検定を示します。</li>
</ul>

  "),
    hr(),
  plotOutput("pca.ind.fa"),
  verbatimTextOutput("fa")),

tabPanel("因子", p(br()),
HTML("
<b>説明</b>
<ul>
<li>このプロットでは2因子の関係をグラフにします。スコアプロットを使用してデータの構造を評価し、クラスター、外れ値、および傾向を検出することができます</li>
<li>プロット上のデータの群は、データ内に2つ以上の別々の分布があることを示す可能性があります。</li>
<li>データが正規分布に従っていて外れ値がない場合には、点はゼロを中心としてランダムに分布します。</li>
</ul>
"),
hr(),

uiOutput('g.fa'), 
uiOutput('type.fa'),
p(tags$b("2. A >=2のとき、2因子を選択して2D負荷量プロットを表示する")),
numericInput("c1.fa", "2.1. x-axisの因子", 1, min = 1, max = NA),
numericInput("c2.fa", "2.2. y-axisの因子", 2, min = 1, max = NA),
conditionalPanel(
condition = "input.explain_on_off",
tags$i("ML1とML2のプロットでは、169や208などの外れ値を見つけることができます。これらのポイントはデータタブで削除できます。
タイプを選択し、ユークリッド距離にグループサークルを追加すると、Bグループが多少異なることがわかりました。 ポイントの数が少なすぎるため、すべてのグループに円があるわけではありません")
),
plotly::plotlyOutput("fa.ind", ),

DT::DTOutput("comp.fa")
  ),

tabPanel("負荷量", p(br()),
	    HTML("
<b>説明</b>
<ul>
<li> このプロットは、変数からPCへの寄与度を示します (左側のパネルで主成分(PC)を選択します)。</li>
<li> 赤色は負の効果、青色は正の効果を表しています。</li>
<li> 分散の割合 (分散表) を使用して、その因子が説明する分散の量を調べることができます。</li>
<li> 記述統計の場合は、分散の80% (0.8) が説明できれば十分です。</li>
<li> データについて他の解析も行う場合は、分散の90%以上を因子によって説明する必要があります。</li>
</ul>

  "),
      hr(),
	plotly::plotlyOutput("pca.ind.fa2"),
	p(tags$b("Loadings")),
  DT::DTOutput("load.fa"),
  p(tags$b("Variance table")),
  DT::DTOutput("var.fa")  ),

tabPanel("因子と負荷量の2Dプロット" ,p(br()),
    HTML("
<b>説明</b>
<ul>
<li> このプロット (バイプロット) では、因子と負荷量を重ねています (左側のパネルでPCを選択します)。</li>
<li> データが正規分布に従っていて外れ値がない場合には、点はゼロを中心としてランダムに分布します。</li>
<li> 負荷量は、各成分に対して最も効果が大きな変数を特定します。</li>
<li> 負荷量の範囲は-1から1です。負荷量が-1または1に近い場合は、その変数が成分に強い影響を与えていることを表します。負荷量が0に近い場合は、その変数が成分にあまり影響を与えていないことを表します。</li>
</ul>
  "),
    hr(),
p(tags$b("A >=2のとき、2因子を選択して成分と負荷量の2Dプロットを表示する")),
numericInput("c1.fa", "1. x-axisの因子", 1, min = 1, max = NA),
numericInput("c2.fa", "2. y-axisの因子", 2, min = 1, max = NA),

conditionalPanel(
condition = "input.explain_on_off",
tags$i("ポイント169と208を削除した後、chem2はML2と比較的強い関係があることがわかりました。")
),

plotly::plotlyOutput("fa.bp")

),

tabPanel("因子と負荷量の3Dプロット" ,p(br()),
HTML("
  <b>説明</b>
<ul>
<li> これは2Dプロットの拡張です。このプロットでは、3つのPCの因子と負荷量を重ねています (左側のパネルでPCおよび線分の長さを選択します)。</li>
<li> プロットで外れ値を見つけることができます。 </li>
<li> データが正規分布に従っていて外れ値がない場合には、点はゼロを中心としてランダムに分布します。</li>
<li> 負荷量は、各成分に対して最も効果が大きな変数を特定します。</li>
<li> 負荷量の範囲は-1から1です。負荷量が-1または1に近い場合は、その変数が成分に強い影響を与えていることを表します。負荷量が0に近い場合は、その変数が成分にあまり影響を与えていないことを表します。</li>
</ul>

  "),
hr(),
p(tags$b("このプロットの初回ロード時は少し時間がかかります。")),
p(tags$b("A >=3のとき、3因子を選択して負荷量の3Dプロットを表示する")),
p(tags$i("デフォルトでは、3Dプロットの最初の3因子が表示されます。")),
numericInput("td1.fa", "1. x-axisの因子", 1, min = 1, max = NA),
numericInput("td2.fa", "2. y-axisの因子", 2, min = 1, max = NA),
numericInput("td3.fa", "3. z-axisの因子", 3, min = 1, max = NA),

numericInput("lines.fa", "4. (オプション) ラインスケール（長さ）を変更する", 10, min = 1, max = NA),
plotly::plotlyOutput("tdplot.fa"),
p(tags$b("トレースの凡例")),
verbatimTextOutput("tdtrace.fa")
)

)

)
)