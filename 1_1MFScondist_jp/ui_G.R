#****************************************************************************************************************************************************1.3. gamma
sidebarLayout(

	sidebarPanel(

	h4(tags$b("Step 1. データソースを選ぶ")),
	p("数式ベース、シミュレーションベース、又は、ユーザのデータベース"),
	#Select Src
	selectInput(
	    "InputSrc_g", "選択肢",
      c("数式ベース" = "MathDist",
        "シミュレーションベース" = "SimuDist",
        "ユーザデータベース" = "DataDist")),
	hr(),
	#Select Src end
	h4(tags$b("Step 2. パラメータの設定")),
	#condiPa 1
	  conditionalPanel(
	    condition = "input.InputSrc_g == 'MathDist'",
	    #h3("Draw a Gamma Distribution", p(br())),
	    HTML("<b>1. パラメータの設定(Gamma(k, &#952))</b>"),
	    numericInput("g.shape", HTML("k > 0：形のパラメータ"), value = 9, min = 0),
		numericInput("g.scale", HTML("&#952 > 0：尺度のパラメータ"), value = 0.5, min = 0),
hr(),
numericInput("g.mean", HTML("または平均とSD (Mean = SD)からk と &#952を計算するために平均を入力"), value = 0.5, min = 0),
numericInput("g.sd", HTML("SDを入力"), value = 0.5, min = 0),

verbatimTextOutput("g.rate"),
HTML("<li> Mean = k&#952
			<li> Variance = k&#952<sup>2</sup>"),
		hr(),

		numericInput("g.xlim", "x軸の範囲（> 0）を変更します。", value = 20, min = 1)
	  ),
	  #condiPa 1 end

	  #condiPa 2
	  conditionalPanel(
	    condition = "input.InputSrc_g == 'SimuDist'",
	    numericInput("g.size", "シミュレートした数の標本サイズ", value = 100, min = 1, step = 1),
	    sliderInput("g.bin", "ヒストグラムのビンの数", min = 0, max = 100, value = 0),
		p("ビンの数が0の場合はプロットでデフォルトのビンの数が使用されます。")

	  ),
	  #condiPa 2 end

	  #condiPa 3
	  conditionalPanel(
	    condition = "input.InputSrc_g == 'DataDist'",
	    tabsetPanel(

	      tabPanel("手入力",p(br()),
		p("データポイントは「,」「;」「Enter」「Tab」で区切ることができます。"),
		p(tags$b("データはCSV（1列）からコピーされ、ボックスに貼り付けられます")),
    			
			tags$textarea(
        	id = "x.g", #p
       	 rows = 10, "4.1\n9.3\n11.7\n2\n2\n5.8\n1.6\n1.9\n4.7\n5.8\n3.1\n3.1\n3\n11\n1.2\n5.7\n10\n13.8\n3.8\n3.1"
				        ),
      	p("欠損値はNAとして入力されます")
	     	 ), #tab1 end
			tabPanel.upload.num(file ="g.file", header="g.header", col="g.col", sep="g.sep")
	    ),
      	sliderInput("bin.g","ヒストグラムのビンの数", min = 0, max = 100, value = 0),
      	p("ビンの数が0の場合はプロットでデフォルトのビンの数が使用されます。")
	  ),
	  #condiPa 3 end
	  hr(),
		h4(tags$b(" Step 3. 確率を表示する")),
	 	numericInput("g.pr", HTML("赤線の左側の面積の割合 = Pr(X < x<sub>0</sub>)で、赤線の位置が x<sub>0</sub> です。"), value = 0.05, min = 0, max = 1, step = 0.05),
 		hr()
	), #sidePa end

mainPanel(
		h4(tags$b("Outputs")),

		conditionalPanel(
		  condition = "input.InputSrc_g == 'MathDist'",
		  h4("数式ベースプロット"),
		  tags$b("ガンマ分布プロット"),
		  plotOutput("g.plot", click = "plot_click11"),
         verbatimTextOutput("g.info"),
         #HTML("<p><b>The position of Red-line, x<sub>0</sub></b></p>"),
		 #p(tags$b("The position of Red-line, x<sub>0</sub>")),
         #tableOutput("g")
     hr(),
     plotly::plotlyOutput("g.plot.cdf")   
		),

		conditionalPanel(
		  condition = "input.InputSrc_g == 'SimuDist'",
		 h4("シミュレーションベースプロット"),

		tags$b("乱数から作成したヒストグラム"),
        plotly::plotlyOutput("g.plot2"),#click = "plot_click12",

        #verbatimTextOutput("g.info2"),
        downloadButton("download3", "乱数をダウンロードする"),
        p(tags$b("サンプルの記述統計")),
        tableOutput("g.sum")

		),

		conditionalPanel(
		condition = "input.InputSrc_g == 'DataDist'",
		tags$b("データの確認"),
		DT::DTOutput("Z"),
		h4("データの分布"),
        tags$b("アプロードされたデータの密度プロット"),
        plotly::plotlyOutput("makeplot.g2"),
        tags$b("アプロードされたデータのヒストグラム"),
        plotly::plotlyOutput("makeplot.g1"),
        tags$b("アプロードされた累積密度プロット（CDF）"),
        plotly::plotlyOutput("makeplot.g3"),
        p(tags$b("データの記述統計")),
        tableOutput("g.sum2")
		)

	)
	)

