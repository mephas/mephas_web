#****************************************************************************************************************************************************1.6. chi
sidebarLayout(


	sidebarPanel(
	h4(tags$b("Step 1. データソースを選ぶ")),
	p("数式ベース、シミュレーションベース、又は、ユーザのデータベース"),
	  #Select Src
	  selectInput(
	    "InputSrc_x", "選択肢",
      c("数式ベース" = "MathDist",
        "シミュレーションベース" = "SimuDist")),
	  hr(),
	#Select Src end
	h4(tags$b("Step 2. パラメータの設定")),

	#condiPa 1
	  conditionalPanel(
	    condition = "input.InputSrc_x == 'MathDist'",
	    HTML("<b>1. パラメータの設定(Chi(v))</b>"),
	    #HTML("<h4><b>Step 1. Set Parameters for Chi(v)</b></h4>"),
 		numericInput("x.df", HTML("v > 0：自由度 = 平均 = 分散/2"), value = 4, min = 0),
		hr(),

		numericInput("x.xlim", "x軸の範囲（> 0）を変更します。", value = 8, min = 1)
	  ),
	 #condiPa 1 end

	  #condiPa 2
	  conditionalPanel(
	    condition = "input.InputSrc_x == 'SimuDist'",
        numericInput("x.size", "シミュレートした数の標本サイズ", value = 100, min = 1, step = 1),
        sliderInput("x.bin", "ヒストグラムのビンの数", min = 0, max = 100, value = 0),
		p("ビンの数が0の場合はプロットでデフォルトのビンの数が使用されます。")

	  ),
	  #condiPa 2 end

	  hr(),
		h4(tags$b("Step 2. 確率を表示する")),
		numericInput("x.pr", HTML("赤線の左側の面積の割合 = Pr(X < x<sub>0</sub>)で、赤線の位置が x<sub>0</sub> です。"), value = 0.05, min = 0, max = 1, step = 0.05),
		hr()
	), #sidePa end


	mainPanel(
		h4(tags$b("Outputs")),

		conditionalPanel(
		  condition = "input.InputSrc_x == 'MathDist'",
		  h4("数式ベースプロット"),
		tags$b("カイ二乗分布プロット"),

        plotOutput("x.plot", click = "plot_click5"),
        verbatimTextOutput("x.info"),

        #HTML("<p><b>The position of Red-line, x<sub>0</sub></b></p>"),
        #p(tags$b("The position of Red-line, x<sub>0</sub>")),
        #tableOutput("x")
     hr(),
     plotly::plotlyOutput("x.plot.cdf")   
    ),

		conditionalPanel(
		  condition = "input.InputSrc_x == 'SimuDist'",
		 h4("シミュレーションベースプロット"),

		 tags$b("乱数から作成したヒストグラム"),
        plotly::plotlyOutput("x.plot2"),#click = "plot_click6",

        p("ビンの数が0の場合はプロットでデフォルトのビンの数が使用されます。"),
        #verbatimTextOutput("x.info2"),
        downloadButton("download6", "乱数をダウンロードする"),
        p(tags$b("サンプルの記述統計")),
        tableOutput("x.sum"),
        HTML(
    "
    <b> 説明 </b>
   <ul>
    <li>  Mean = v </li>
    <li>  SD = sqrt(2v) </li>
   </ul>
    "
    )

		)

	) #main pa end


)


