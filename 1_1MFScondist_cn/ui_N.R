#****************************************************************************************************************************************************1.1. Normal distribution
sidebarLayout(

	sidebarPanel(

	h4(tags$b("第1步  选择数据源")),
	p("基于数学公式、模拟数据或用户数据"),
	#Select Src
	selectInput(
	    "InputSrc", "选择绘图",
	    c("基于数学公式" = "MathDist",
	      "基于模拟数据" = "SimuDist",
	      "基于用户数据" = "DataDist")),
	hr(),
	#Select Src end
		h4(tags$b("第2步  设置参数")),

	  #condiPa 1
	  conditionalPanel(
	    condition = "input.InputSrc == 'MathDist'",
	    #h3("Draw a Normal Distribution"), p(br()),

	    HTML("<b>设置参数 N(&#956, &#963)</b>"),
	    numericInput("mu", HTML("1. 均值(&#956), 虚线表示位置"), value = 0, min = -10000000, max = 10000000),
	    numericInput("sigma", HTML("2. 标准差 (&#963), 表示形状"), value = 1, min = 0, max = 10000000),
	    hr(),
	   	numericInput("n", HTML("3. 蓝色区域 = Pr(Mean-n*SD < X < Mean+n*SD)"), value = 1, min = 0, max = 10),
	    hr(),
	    numericInput("xlim", "4. 改变x轴的范围，与 0 对称", value = 5)
	    #numericInput("ylim", "Range of y-axis > 0", value = 0.5, min = 0.1, max = 1),
	  ),
	  #condiPa 1 end

	  #condiPa 2
	  conditionalPanel(
	    condition = "input.InputSrc == 'SimuDist'",
	    numericInput("size", "模拟数据样本量", value = 100, min = 1),
	    sliderInput("bin", "直方图中柱子的个数", min = 0, max = 100, value = 0),
	    p("如果个数是 0, 直方图将使用默认个数。")

	  ),
	  #condiPa 2 end

	  #condiPa 3
	  conditionalPanel(
	    condition = "input.InputSrc == 'DataDist'",

	    tabsetPanel(
	      tabPanel("手动输入数据",p(br()),
    p("数据可以用 , ; /Enter /Tab /Space 分隔"),
    p(tags$b("数据可以从CSV（一列）复制数据并粘贴到框中")), 	        
	        tags$textarea(
	          id = "x", #p
	          rows = 10,
	          "-1.8\n0.8\n-0.3\n1\n-1.2\n-0.7\n-0.7\n-0.6\n1.3\n-0.8\n-1.2\n0.6\n2.2\n0.5\n0.4\n-0.3\n0.3\n-0.2\n-1.1\n0"
	        ),
	        p("缺失值显示为 NA")
	      ),
	      tabPanel.upload.num(file ="file", header="header", col="col", sep="sep")

	    ),
	    sliderInput("bin1","直方图中柱子的个数", min = 0, max = 100, value = 0),
	    p("如果个数是 0, 直方图将使用默认个数。")
	  ),
	  #condiPa 3 end
	  	hr(),
	    h4(tags$b("第3步  显示概率")),
	    numericInput("pr", HTML("红线左侧的面积比例 = Pr(X < x<sub>0</sub>), x<sub>0</sub> 为红线位置"), value = 0.025, min = 0, max = 1, step = 0.05),

	    hr()
	), #sidePa end

	mainPanel(
		h4(tags$b("Outputs")),

		conditionalPanel(
		  condition = "input.InputSrc == 'MathDist'",
		  h4("基于数学公式"),
		  #tags$b("Normal distribution plot"),
		  #plotOutput("norm.plot", click = "plot_click", width = "600px", height = "400px"), #click = "plot_click",
		  plotOutput("norm.plot", click = "plot_click"), #click = "plot_click",

		  verbatimTextOutput("info"),
		  p(br()),
		  p(tags$b("红线和蓝色区域")),
		  tableOutput("xs"),
		  hr(),
		#   plotly::plotlyOutput("norm.plot.cdf")
		plotOutput("norm.plot.cdf")

		),

		conditionalPanel(
		  condition = "input.InputSrc == 'SimuDist'",
		  h4("基于模拟数据"),
		  tags$b("随机数产生的直方图"),
		  plotly::plotlyOutput("norm.plot2"),	# click = "plot_click2",

		  #verbatimTextOutput("info2"),
		  downloadButton("download1", "下载随机数"),
		  p(tags$b("样本描述性统计量")),
		  tableOutput("sum")
		  #verbatimTextOutput("data")

		),

		conditionalPanel(
		  condition = "input.InputSrc == 'DataDist'",
		  tags$b("数据预览"),
		DT::DTOutput("NN"),
		  h4("数据的分布"),

		  tags$b("上传数据的分布"),
		  plotly::plotlyOutput("makeplot.2"),
		  tags$b("上传数据的直方图"),
		  plotly::plotlyOutput("makeplot.1"),
		  tags$b("上传数据的累积概率分布"),
		  plotly::plotlyOutput("makeplot.3"),
		  p(tags$b("样本描述性统计量")),
		  tableOutput("sum2")


		)

	)
	)

