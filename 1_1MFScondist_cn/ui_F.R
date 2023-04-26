#****************************************************************************************************************************************************1.7. F
sidebarLayout(


	sidebarPanel(
	h4(tags$b("第1步  选择数据源")),
	p("基于数学公式、模拟数据或用户数据"),		#Select Src
	selectInput(
	    "InputSrc_f", "Select plot",
	    c("基于数学公式" = "MathDist",
	      "基于模拟数据" = "SimuDist",
	      "基于用户数据" = "DataDist")),
	hr(),
	#Select Src end
	h4(tags$b("第2步 设置参数")),
	#condiPa 1
	  conditionalPanel(
	    condition = "input.InputSrc_f == 'MathDist'",
	    HTML("<b>1. 设置参数</b>"),
	    #HTML("<h4><b>1. 设置参数</b></h4>"),
		numericInput("df11", HTML("v1 > 0, 自由度1"), value = 100, min = 0),
		numericInput("df21", HTML("v2 > 0, 自由度2"), value = 100, min = 0),
		HTML("<li> Mean = v2 / (v2 - 2), for v2 > 2
			<li> Variance = [ 2 * v2^2 * ( v1 + v2 - 2 ) ] / [ v1 * ( v2 - 2 )^2 * ( v2 - 4 ) ] for v2 > 4"),
		hr(),

	 	p(tags$b("You can adjust x-axes range")),
		numericInput("f.xlim", "改变x轴的范围, x轴须 > 0", value = 5, min = 1)
	  ),
	 #condiPa 1 end

	  #condiPa 2
	  conditionalPanel(
	    condition = "input.InputSrc_f == 'SimuDist'",
        numericInput("f.size", "模拟数据样本量", value = 100, min = 1, step = 1),
        sliderInput("f.bin", "直方图中柱子的个数", min = 0, max = 100, value = 0),
        p("如果个数是 0, 直方图将使用默认个数。")

	  ),
	  #condiPa 2 end
	  #condiPa 3
	  conditionalPanel(
	    condition = "input.InputSrc_f == 'DataDist'",
	    tabsetPanel(
	       tabPanel("手动输入",p(br()),
    p("数据可以用「，」，「分号」，「回车」，「空格」，「制表符」进行分隔。"),
    p(tags$b("从CSV（一列）复制数据并粘贴到框中")),     		

    tags$textarea(
        	id = "x.f", #p
        	rows = 10, "1.08\n1.54\n0.89\n0.83\n1.13\n0.89\n1.22\n1.04\n0.71\n0.84\n1.17\n0.88\n1.05\n0.91\n1.37\n0.87\n1\n1\n1\n1.01"
			),
      		p("缺失值输入NA")
	     ), #tab1 end
			tabPanel.upload.num(file ="f.file", header="f.header", col="f.col", sep="f.sep")

	    ),
        sliderInput("bin.f","直方图中的分箱数", min = 0, max = 100, value = 0),
        p("当分箱数为0时，绘图将使用默认分箱数")
	  ),
	  #condiPa 3 end
	  hr(),
		h4(tags$b("第3步 显示概率")),
	 	numericInput("f.pr", HTML("红线左侧的面积比例 = Pr(X < x<sub>0</sub>), x<sub>0</sub>为红线位置"), value = 0.05, min = 0, max = 1, step = 0.05),
		
		hr()
	), #sidePa end


mainPanel(
		h4(tags$b("Outputs")),

		conditionalPanel(
		  condition = "input.InputSrc_f == 'MathDist'",
		  h4("基于数学公式"),
		tags$b("F分布图"),

        plotOutput("f.plot", click = "plot_click7"),
        verbatimTextOutput("f.info"),
     hr(),
    #  plotly::plotlyOutput("f.plot.cdf") 
	plotOutput("f.plot.cdf")
        #HTML("<p><b>The position of Red-line, x<sub>0</sub></b></p>"),
        #p(tags$b("The position of Red-line, x0")),
        #tableOutput("f")
		),

		conditionalPanel(
		  condition = "input.InputSrc_f == 'SimuDist'",
		   h4("基于模拟数据的绘图"),

		tags$b("随机数的直方图"),
        plotly::plotlyOutput("f.plot2"),#click = "plot_click8",

        #verbatimTextOutput("f.info2"),
        downloadButton("download7", "随机数下载"),
        p(tags$b("样本描述性统计量")),
        tableOutput("f.sum")

		),

		conditionalPanel(
		condition = "input.InputSrc_f == 'DataDist'",
		tags$b("数据预览"),
		DT::DTOutput("FF"),
	 h4("用户数据的绘图"),
 		tags$b("上传数据的密度分布"),
        plotly::plotlyOutput("makeplot.f2"),
        tags$b("上传数据的直方图"),
        plotly::plotlyOutput("makeplot.f1"),
        tags$b("上传数据的累积概率分布（CDF）"),
        plotly::plotlyOutput("makeplot.f3"),        
        p(tags$b("样本描述性统计量")),
        tableOutput("f.sum2")

		)

	) #main pa end


)


