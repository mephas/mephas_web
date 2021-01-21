# ****************************************************************************************************************************************************1.1. User data distribution
sidebarLayout(

sidebarPanel(

h4(tags$b("Step 1. データの準備")),

tabsetPanel(
tabPanel("手入力",p(br()),
	p("データポイントは「,」「;」「Enter」「Tab」で区切ることができます。"),
	p(tags$b("データはCSV（1列）からコピーされ、ボックスに貼り付けられます")), 	        
	tags$textarea(
	id = "x", #p
	rows = 10,
	"-1.8\n0.8\n-0.3\n1\n-1.2\n-0.7\n-0.7\n-0.6\n1.3\n-0.8\n-1.2\n0.6\n2.2\n0.5\n0.4\n-0.3\n0.3\n-0.2\n-1.1\n0"
	),
	p("欠損値はNAとして入力されます")
),

tabPanel.upload.num(file ="file", header="header", col="col", sep="sep")

),
sliderInput("bin1","ヒストグラムのビンの数", min = 0, max = 100, value = 0),
p("ビンの数が0の場合はプロットでデフォルトのビンの数が使用されます。"),

hr(),
h4(tags$b("Step 2. 確率を表示する")),
numericInput("pr.data", HTML("赤線の左側の面積の割合 = Pr(X < x<sub>0</sub>)で、赤線の位置が x<sub>0</sub> です。e"), value = 0.025, min = 0, max = 1, step = 0.05),

hr()
),

	mainPanel(
		h4(tags$b("Outputs")),p(br()),
		  h4("データの確認"),
			DT::DTOutput("NN"),
		  
		  h4("Distribution of Your Data"),
		  tags$b("密度プロット"),
		  plotly::plotlyOutput("makeplot.2"),

		  tags$b("ヒストグラム"),
		  plotly::plotlyOutput("makeplot.1"),

		  tags$b("累積密度プロット"),
		  plotly::plotlyOutput("makeplot.3"),

		  p(tags$b("サンプルの記述統計")),
		  tableOutput("sum2")

		)

)

