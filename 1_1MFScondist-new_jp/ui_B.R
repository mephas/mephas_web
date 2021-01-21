#****************************************************************************************************************************************************1.4. beta

sidebarLayout(

	sidebarPanel(

	h4(tags$b("Step 1. データソースを選ぶ")),
	p("数式ベース、シミュレーションベース、又は、ユーザのデータベース"),
	  #Select Src
	  selectInput(
	    "InputSrc_b", "選択肢",
      c("数式ベース" = "MathDist",
        "シミュレーションベース" = "SimuDist")),
	  hr(),
	hr(),
	#Select Src end
	h4(tags$b("Step 2. パラメータの設定")),
	#condiPa 1
	  conditionalPanel(
	    condition = "input.InputSrc_b == 'MathDist'",
	    HTML("<b>1. パラメータの設定((&#945, &#946))</b>"),
	    #HTML("<h4><b>Step 1. Set Parameters for Beta(&#945, &#946)</h4></b>"),
		numericInput("b.shape", HTML("&#945 > 0：形のパラメータ"), value = 12, min = 0),
		  numericInput("b.scale", HTML("&#946 > 0：形のパラメータ"), value = 12, min = 0),
		  hr(),
		  numericInput("b.mean", HTML("または平均とSD (平均 = SD) からk と &#952を計算するために平均を入力"), value = 0.5, min = 0),
			numericInput("b.sd", HTML("SDを入力"), value = 0.1, min = 0),

verbatimTextOutput("b.rate"),
HTML("<li> Mean = &#945 / (&#945 + &#946)
			<li> Variance = &#945&#946/[(&#945 + &#946)^2(&#945 + &#946+1)]"),
		hr(),
		  numericInput("b.xlim", "x軸の範囲（> 0）を変更します。", value = 1, min = 1)
		  #snumericInput("b.ylim", "Range of y-asis, > 0", value = 2.5, min = 0.1, max = 3),
	  ),
	 #condiPa 1 end

	  #condiPa 2
	  conditionalPanel(
	    condition = "input.InputSrc_b == 'SimuDist'",
	    numericInput("b.size", "シミュレートした数の標本サイズ", value = 100, min = 1, step = 1),
	    sliderInput("b.bin", "ヒストグラムのビンの数", min = 0, max = 100, value = 0),
		p("ビンの数が0の場合はプロットでデフォルトのビンの数が使用されます。")

	  ),
	  #condiPa 2 end

	  hr(),
	  h4(tags$b("Step 3. 確率を表示する")),
 		numericInput("b.pr", HTML("赤線の左側の面積の割合 = Pr(X < x<sub>0</sub>)で、赤線の位置が x<sub>0</sub> です。"), value = 0.05, min = 0, max = 1, step = 0.05),
	  hr()
	), #sidePa end

mainPanel(
		h4(tags$b("Outputs")),

		conditionalPanel(
		  condition = "input.InputSrc_b == 'MathDist'",
		  h4("数式ベースプロット"),
		tags$b("ベータ分布プロット"),
        plotOutput("b.plot", click = "plot_click13"),
        verbatimTextOutput("b.info"),
        #HTML("<p><b>The position of Red-line, x<sub>0</sub></b></p>"),
        #p(tags$b("The position of Red-line, x<sub>0</sub>")),
        #tableOutput("b")
   hr(),
   plotly::plotlyOutput("b.plot.cdf")  
		),

		conditionalPanel(
		  condition = "input.InputSrc_b == 'SimuDist'",
		   h4("シミュレーションベースプロット"),

		tags$b("乱数から作成したヒストグラム"),
        plotly::plotlyOutput("b.plot2"),# click = "plot_click14",

        #verbatimTextOutput("b.info2"),
        downloadButton("download4", "乱数をダウンロードする"),
        p(tags$b("サンプルの記述統計")),
        tableOutput("b.sum"),
        HTML(
    "
    <b> 説明 </b>
   <ul>
    <li>  Mean = &#945/(&#945+&#946) </li>
    <li>  SD = sqrt(&#945*&#946/(&#945+&#946)^2(&#945+&#946+1)) </li>
   </ul>
    "
    )

		)

	) #main pa end


	)

