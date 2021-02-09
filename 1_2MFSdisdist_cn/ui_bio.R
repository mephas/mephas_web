#****************************************************************************************************************************************************1. binom
sidebarLayout(

	sidebarPanel(
	h4(tags$b("第1步  选择数据源")),
	p("基于数学、模拟数据或用户数据"),		#Select Src
	selectInput(
	    "InputSrc_b", "选项",
	    c("基于数学" = "MathDist",
	      "基于模拟数据" = "SimuDist",
	      "基于用户数据" = "DataDist")),
	hr(),

	#Select Src end
		h4(tags$b("第2步  设置参数")),

	#condiPa 1
	  conditionalPanel(
	    condition = "input.InputSrc_b == 'MathDist'",
	    HTML("<b> 1. 设置参数</b>"),
		numericInput("m", "试验/样本数，n>0", value = 10, min = 1 , max = 1000000000),
		numericInput("p", "成功/事件概率，p>0", value = 0.2, min = 0, max = 1, step = 0.1),
		HTML("
<li> 均值（Mean） = np
<li> 方差（Variance） = np(1-p)
			")
		),
	  conditionalPanel(
	    condition = "input.InputSrc_b == 'MathDist' && input.explain_on_off",
		p(tags$i("在这个例子中，我们知道，n = 10（10个白血球）、p = 0.2（1个白血球是淋巴球的概率）。"))
		),
	  conditionalPanel(
	    condition = "input.InputSrc_b == 'MathDist'",
		hr(),
		tags$b(" 2. 更改观察数据"),
		numericInput("k", "观察到的成功/事件数（红点）", value = 2, min =  0, max = 1000, step = 1)
		),
	  conditionalPanel(
	    condition = "input.InputSrc_b == 'MathDist' && input.explain_on_off",
		p(tags$i("观察到的个数是2个淋巴球。"))
	  ),
	 #condiPa 1 end

	  #condiPa 2
	  conditionalPanel(
	    condition = "input.InputSrc_b == 'SimuDist'",
		numericInput("size", "随机样本的个数", value = 100, min = 1, max = 1000000, step = 1),
		sliderInput("bin", "直方图中的分箱数", min = 0, max = 100, value = 0),
		p("当分箱数为0时，绘图将使用默认分箱数")

	  ),
	  #condiPa 2 end
	  #condiPa 3
	  conditionalPanel(
	    condition = "input.InputSrc_b == 'DataDist'",
	    tabsetPanel(
	      tabPanel("手动输入",p(br()),
    p("数据可以用「，」，「回车」，「制表符」进行分隔。"),
    p(tags$b("从CSV（一列）复制数据并粘贴到框中")), 			
    		tags$textarea(
        	id = "x", #p
        	rows = 10, "3\n5\n3\n4\n6\n3\n6\n6\n5\n2\n5\n4\n5\n5\n5\n2\n6\n8\n4\n2"
			),
      		p("缺失值输入NA")
	     ), #tab1 end
			tabPanel.upload.num(file ="file", header="header", col="col", sep="sep")

	    ),
      sliderInput("bin1","直方图中的分箱数", min = 0, max = 100, value = 0),
        p("当分箱数为0时，绘图将使用默认分箱数")
	  )
	  #condiPa 3 end

	), #sidePa end




mainPanel(
		h4(tags$b("Outputs")),

		conditionalPanel(
		  condition = "input.InputSrc_b == 'MathDist'",
		  h4("基于数学公式的绘图"),
		  p(tags$b("二项分布的概率图")),
		  p("蓝色曲线为正态分布，均值为n*p，sd n*p*(1-p)。它表示二项分布的正态近似。"),
		  plotly::plotlyOutput("b.plot"),
		  p(tags$b("观察到的成功/事件数的概率（红点）")),
		  tableOutput("b.k"),
		 hr(),
     plotly::plotlyOutput("b.plot.cdf")   
		),
		conditionalPanel(
		  condition = "input.InputSrc_b == 'MathDist' && input.explain_on_off",
		  p(tags$i("说明： 2个淋巴球的概率为0.03"))
		),

		conditionalPanel(
		  condition = "input.InputSrc_b == 'SimuDist'",
		  h4("基于模拟数据的绘图"),
		  p(tags$b("随机数的直方图")),
		  plotly::plotlyOutput("b.plot2"),
		  downloadButton("download1", "随机数下载"),
		  p(tags$b("数据的描述性统计量")),
		  tableOutput("sum")

		),

		conditionalPanel(
		condition = "input.InputSrc_b == 'DataDist'",
		h4("用户数据的绘图"),
 		p(tags$b("上传数据的直方图")),
		plotly::plotlyOutput("makeplot.1"),
    tags$b("上传数据的密度分布（CDF）"),
    plotly::plotlyOutput("makeplot.11"),
		p(tags$b("数据的描述性统计量")),
		tableOutput("sum2")

		)

	) #main pa end


)
