#****************************************************************************************************************************************************pca

sidebarLayout(

sidebarPanel(

#tags$head(tags$style("#x {height: 150px; background: ghostwhite; color: blue;word-wrap: break-word;}")),
tags$head(tags$style("#tdtrace {overflow-y:scroll; max-height: 150px; background: white};")),

h4(tags$b("モデルを構築する")),
p("データタブでデータを作成します。"),
p("変数 (列) の数は標本 (行) の数よりも少なくなければなりません。"),
p(tags$i("ここではサンプルデータは化学のデータです。")),
hr(),       

h4(tags$b("Step 1. モデルを構築するパラメータを選択する")),    

uiOutput('x'), 

numericInput("nc", "2. 成分の数 (A < Xの次元)", 3, min = 1, max = NA),

hr(),

h4(tags$b("Step 2. データとモデルが準備できたら、青色のボタンをクリックしてモデルの結果を生成")),
#actionButton("pca1", (tags$b("Show Results >>")),class="btn btn-primary",icon=icon("bar-chart-o"))
p(br()),
actionButton("pca1", (tags$b("結果を表示 >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
p(br()),
p(br()),
hr()

),

mainPanel(

h4(tags$b("Output 1. データの確認")),
#tabsetPanel(
#tabPanel("Parallel Analysis", p(br()),
#plotOutput("pc.plot", ),
#verbatimTextOutput("pcncomp")
#),
#tabPanel("Correlation Matrix", p(br()),
#plotOutput("cor.plot", ),p(br()),
#DT::DTOutput("cor")
#),

tags$b("データの一部"),
 p("データタブでデータを編集してください"),
DT::DTOutput("table.x"),
#)

#  ),

hr(),
h4(tags$b("Output 2. モデルの結果")),
#actionButton("pca1", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")),  style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
 #p(br()),

tabsetPanel(

tabPanel("主成分分析の結果", p(br()),
  HTML("
<b>説明</b>
<ul>
<li>このプロットでは2つの主成分の関係をグラフにします。スコアプロットを使用してデータの構造を評価し、クラスター、外れ値、および傾向を検出することができます。</li>
<li>プロット上のデータの群は、データ内に2つ以上の別々の分布があることを示す可能性があります。</li>
<li>データが正規分布に従っていて外れ値がない場合には、点はゼロを中心としてランダムに分布します。</li>
</ul>
  "),
  hr(),

uiOutput('g'), 
uiOutput('type'),

p(tags$b("2. A >=2のとき、2成分を選択して2D負荷量プロットを表示する")),
numericInput("c1", "2.1. x-axisの成分", 1, min = 1, max = NA),
numericInput("c2", "2.2. y-axisの成分", 2, min = 1, max = NA),

conditionalPanel(
condition = "input.explain_on_off",
tags$i("PC1とPC2（グループ円なし）のプロットでは、いくつかの外れ値、たとえば11と23を見つけることができました。
ダイエットを選択し、ユークリッド距離にグループサークルを追加すると、ダイエットタイプの円が他の円から分離されていることがわかりす。")
),
plotly::plotlyOutput("pca.ind", ),
DT::DTOutput("comp")
  ),

tabPanel("負荷量", p(br()),
    HTML("
<b>説明</b>
<ul>
<li> このプロットは、変数からPCへの寄与度を示します (左側のパネルでPCを選択します)。</li>
<li> 赤色は負の効果、青色は正の効果を表しています。</li>
<li> 分散の累積割合 (分散表) を使用して、その因子が説明する分散の量を調べることができます。</li>
<li> 記述統計の場合は、分散の80% (0.8) が説明できれば十分です。 </li>
<li> データについて他の解析も行う場合は、分散の90%以上を因子によって説明する必要があります。</li>
</ul>
  "),
    hr(),
  plotly::plotlyOutput("pca.ind2", ),
  p(tags$b("Loadings")),
  DT::DTOutput("load"),
  p(tags$b("Variance table")),
  DT::DTOutput("var")
  ),
tabPanel("主成分と負荷量の2Dプロット" ,p(br()),
    HTML("
<b>説明</b>
<ul>
<li> このプロット (バイプロット) では、主成分と負荷量を重ねています (左側のパネルでPCを選択します)。</li>
<li> データが正規分布に従っていて外れ値がない場合には、点はゼロを中心としてランダムに分布します。</li>
<li> 負荷量は、各成分に対して最も効果が大きな変数を特定します。</li>
<li> 負荷量の範囲は-1から1です。負荷量が-1または1に近い場合は、その変数が成分に強い影響を与えていることを表します。負荷量が0に近い場合は、その変数が成分にあまり影響を与えていないことを表します。</li>
</ul>

  "),
    hr(),
p(tags$b("A >=2のとき、2成分を選択して負荷量の2Dプロットを表示する")),
numericInput("c11", "2.1. x-axisの成分", 1, min = 1, max = NA),
numericInput("c22", "2.2. y-axisの成分", 2, min = 1, max = NA),

conditionalPanel(
condition = "input.explain_on_off",
tags$i("PC1とPC2のプロットでは、ACAT2がPC1に対して比較的強い負の効果を持ち、PKD4がPC1に対して強い正の効果を持っていることがわかりました。PC2の場合、THIOLには強いプラスの効果があり、VDRには強いマイナスの効果があります。
結果は負荷量プロットに対応しています")
),

plotly::plotlyOutput("pca.bp", )

),

tabPanel("主成分と負荷量の3Dプロット" ,p(br()),
HTML("
  <b>説明</b>
<ul>
<li> これは2Dプロットの拡張です。このプロットでは、3つのPCの成分と負荷量を重ねます (左パネルでPCおよび線分の長さを選択します)。</li>
<li> プロットで外れ値を見つけることができます。</li>
<li> データが正規分布に従っていて外れ値がない場合には、点はゼロを中心としてランダムに分布します。</li>
<li> 負荷量は、各成分に対して最も効果が大きな変数を特定します。</li>
<li> 負荷量の範囲は-1から1です。負荷量が-1または1に近い場合は、その変数が成分に強い影響を与えていることを表します。負荷量が0に近い場合は、その変数が成分にあまり影響を与えていないことを表します</li>
</ul>

  "),
hr(),
p(tags$b("このプロットの初回ロード時は少し時間がかかります。")),
p(tags$b("A >=3のとき、3成分を選択して負荷量の3Dプロットを表示する")),
p(tags$i("デフォルトでは、3Dプロットの最初の3成分が表示されます。")),
numericInput("td1", "1. x-axisの成分", 1, min = 1, max = NA),
numericInput("td2", "2. y-axisの成分", 2, min = 1, max = NA),
numericInput("td3", "3. z-axisの成分", 3, min = 1, max = NA),

numericInput("lines", "4. (オプション) ラインスケール（長さ）を変更する", 10, min = 1, max = NA),
plotly::plotlyOutput("tdplot"),
p(tags$b("トレースの凡例")),
verbatimTextOutput("tdtrace")
)
)

)

)