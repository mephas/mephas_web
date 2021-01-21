# ****************************************************************************************************************************************************1.7.
# F
sidebarLayout(


	sidebarPanel(
	h4(tags$b("Step 1. データソースを選ぶ")),
	p("数式ベース、シミュレーションベース、又は、ユーザのデータベース"),
	  #Select Src
	  selectInput(
	    "InputSrc_f", "選択肢",
      c("数式ベース" = "MathDist",
        "シミュレーションベース" = "SimuDist")),
	  hr(),
	#Select Src end
	h4(tags$b("Step 2. パラメータの設定")),
	#condiPa 1
	  conditionalPanel(
	    condition = "input.InputSrc_f == 'MathDist'",
	    HTML("<b>1. パラメータの設定</b>"),
	    #HTML("<h4><b>Step 1. Set Parameters</b></h4>"),
		numericInput("df11", HTML("v1 > 0：自由度1"), value = 100, min = 0),
		numericInput("df21", HTML("v2 > 0：自由度2"), value = 100, min = 0),
		HTML("<li> Mean = v2 / (v2 - 2), for v2 > 2
			<li> Variance = [ 2 * v2^2 * ( v1 + v2 - 2 ) ] / [ v1 * ( v2 - 2 )^2 * ( v2 - 4 ) ] for v2 > 4"),
		hr(),

	 	p(tags$b("x軸の範囲を調整")),
		numericInput("f.xlim", "x軸の範囲（> 0）を変更します。", value = 5, min = 1)
	  ),
	 #condiPa 1 end

	  #condiPa 2
	  conditionalPanel(
	    condition = "input.InputSrc_f == 'SimuDist'",
        numericInput("f.size", "シミュレートした数の標本サイズ", value = 100, min = 1, step = 1),
        sliderInput("f.bin", "ヒストグラムのビンの数", min = 0, max = 100, value = 0),
        p("ビンの数が0の場合はプロットでデフォルトのビンの数が使用されます。")

	  ),
	  #condiPa 2 end

	  hr(),
		h4(tags$b("Step 3. 確率を表示する")),
	 	numericInput("f.pr", HTML("赤線の左側の面積の割合 = Pr(X < x<sub>0</sub>)で、赤線の位置が x<sub>0</sub> です。"), value = 0.05, min = 0, max = 1, step = 0.05),
		
		hr()
	), #sidePa end


mainPanel(
		h4(tags$b("Outputs")),

		conditionalPanel(
		  condition = "input.InputSrc_f == 'MathDist'",
		  h4("数式ベースプロット"),
		tags$b("F分布プロット"),

        plotOutput("f.plot", click = "plot_click7"),
        verbatimTextOutput("f.info"),
     hr(),
     plotly::plotlyOutput("f.plot.cdf") 
        #HTML("<p><b>The position of Red-line, x<sub>0</sub></b></p>"),
        #p(tags$b("The position of Red-line, x0")),
        #tableOutput("f")
		),

		conditionalPanel(
		  condition = "input.InputSrc_f == 'SimuDist'",
		   h4("シミュレーションベースプロット"),

		tags$b("乱数から作成したヒストグラム"),
        plotly::plotlyOutput("f.plot2"),#click = "plot_click8",

        #verbatimTextOutput("f.info2"),
        downloadButton("download7", "乱数をダウンロードする"),
        p(tags$b("サンプルの記述統計")),
        tableOutput("f.sum")

		)

	) #main pa end


)


