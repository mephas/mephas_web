# ****************************************************************************************************************************************************1.1.
# Normal distribution
sidebarLayout(

	sidebarPanel(

	h4(tags$b("Step 1. データソースを選ぶ")),
	p("数式ベース、シミュレーションベース、又は、ユーザのデータベース"),
	  #Select Src
	  selectInput(
	    "InputSrc", "選択肢",
      c("数式ベース" = "MathDist",
        "シミュレーションベース" = "SimuDist")),
	  hr(),
	#Select Src end
	h4(tags$b("Step 2. パラメータの設定")),

	  #condiPa 1
	  conditionalPanel(
	    condition = "input.InputSrc == 'MathDist'",
	    #h3("Draw a Normal Distribution"), p(br()),

	    HTML("<b>パラメータの設定(N(&#956, &#963))</b>"),
	    numericInput("mu", HTML("1. 平均(Mean, &#956)：破線で位置が表されます。"), value = 0, min = -10000000, max = 10000000),
	    numericInput("sigma", HTML("2. 標準偏差(SD, &#963)：形で表されます。"), value = 1, min = 0, max = 10000000),
	    hr(),
	   	numericInput("n", HTML("3. 青色の領域 = Pr(Mean-n*SD < X < Mean+n*SD)"), value = 1, min = 0, max = 10),
	    hr(),
	    numericInput("xlim", "4. （0に対して対称となる）x軸の範囲を変更します。", value = 5)
	    #numericInput("ylim", "Range of y-axis > 0", value = 0.5, min = 0.1, max = 1),
	  ),
	  #condiPa 1 end

	  #condiPa 2
	  conditionalPanel(
	    condition = "input.InputSrc == 'SimuDist'",
	    numericInput("size", "シミュレートした数の標本サイズ", value = 100, min = 1),
	    sliderInput("bin", "ヒストグラムのビンの数", min = 0, max = 100, value = 0),
	    p("ビンの数が0の場合はプロットでデフォルトのビンの数が使用されます。")

	  ),
	  #condiPa 2 end

	  	hr(),
	    h4(tags$b("Step 3. 確率を表示する")),
	    numericInput("pr", HTML("赤線の左側の面積の割合 = Pr(X < x<sub>0</sub>)で、赤線の位置が x<sub>0</sub> です。"), value = 0.025, min = 0, max = 1, step = 0.05),

	    hr()
	), #sidePa end

	mainPanel(
		h4(tags$b("Outputs")),

		conditionalPanel(
		  condition = "input.InputSrc == 'MathDist'",
		  h4("数式ベースプロット"),
		  #tags$b("Normal distribution plot"),
		  #plotOutput("norm.plot", click = "plot_click", width = "600px", height = "400px"), #click = "plot_click",
		  plotOutput("norm.plot", click = "plot_click"), #click = "plot_click",

		  verbatimTextOutput("info"),
		  p(br()),
		  p(tags$b("赤線の位置と青色の領域")),
		  tableOutput("xs"),
		  hr(),
		  plotly::plotlyOutput("norm.plot.cdf")

		),

		conditionalPanel(
		  condition = "input.InputSrc == 'SimuDist'",
		  h4("シミュレーションベースプロット"),
		  tags$b("乱数から作成したヒストグラム"),
		  plotly::plotlyOutput("norm.plot2"),	# click = "plot_click2",

		  #verbatimTextOutput("info2"),
		  downloadButton("download1", "乱数をダウンロードする"),
		  p(tags$b("サンプルの記述統計")),
		  tableOutput("sum")
		  #verbatimTextOutput("data")

		)

	)
	)

