#****************************************************************************************************************************************************1.6. chi
sidebarLayout(


	sidebarPanel(
	h4(tags$b("第1步  选择数据源")),
	p("基于数学公式、模拟数据或用户数据"),
	#Select Src
	selectInput(
	    "InputSrc_x", "Select plot",
	    c("基于数学公式" = "MathDist",
	      "基于模拟数据" = "SimuDist",
	      "基于用户数据" = "DataDist")),
	hr(),
	#Select Src end
	h4(tags$b("第2步 设置参数")),

	#condiPa 1
	  conditionalPanel(
	    condition = "input.InputSrc_x == 'MathDist'",
	    HTML("<b>1. 设置参数 Chi(v)</b>"),
	    #HTML("<h4><b>Step 1. Set Parameters for Chi(v)</b></h4>"),
 		numericInput("x.df", HTML("v > 0, 自由度=均值=方差/2"), value = 4, min = 0),
		hr(),

		numericInput("x.xlim", "改变x轴的范围, x轴须 > 0", value = 8, min = 1)
	  ),
	 #condiPa 1 end

	  #condiPa 2
	  conditionalPanel(
	    condition = "input.InputSrc_x == 'SimuDist'",
        numericInput("x.size", "模拟数据样本量", value = 100, min = 1, step = 1),
        sliderInput("x.bin", "直方图中柱子的个数", min = 0, max = 100, value = 0),
		p("如果个数是 0, 直方图将使用默认个数。")

	  ),
	  #condiPa 2 end
	  #condiPa 3
	  conditionalPanel(
	    condition = "input.InputSrc_x == 'DataDist'",
	    tabsetPanel(
	       tabPanel("手动输入",p(br()),
		p("数据可以用「，」，「分号」，「回车」，「空格」，「制表符」进行分隔。"),
		p(tags$b("从CSV（一列）复制数据并粘贴到框中")),
		tags$textarea(
        	id = "x.x", #p
        	rows = 10, "11.92\n1.42\n5.56\n5.31\n1.28\n3.87\n1.31\n2.32\n3.75\n6.41\n3.04\n3.96\n1.09\n5.28\n7.88\n4.48\n1.22\n1.2\n9.06\n2.27"
			),
      		p("缺失值输入NA")
	     ), #tab1 end

			tabPanel.upload.num(file ="x.file", header="x.header", col="x.col", sep="x.sep")

	    ),
        sliderInput("bin.x","直方图中的分箱数", min = 0, max = 100, value = 0),
        p("当分箱数为0时，绘图将使用默认分箱数")
	  ),
	  #condiPa 3 end
	  hr(),
		h4(tags$b("第3步 显示概率")),
		numericInput("x.pr", HTML("红线左侧的面积比例 = Pr(X < x<sub>0</sub>), x<sub>0</sub>为红线位置"), value = 0.05, min = 0, max = 1, step = 0.05),
		hr()
	), #sidePa end


	mainPanel(
		h4(tags$b("Outputs")),

		conditionalPanel(
		  condition = "input.InputSrc_x == 'MathDist'",
		  h4("基于数学公式"),
		tags$b("卡方分布图"),

        plotOutput("x.plot", click = "plot_click5"),
        verbatimTextOutput("x.info"),

        #HTML("<p><b>The position of Red-line, x<sub>0</sub></b></p>"),
        #p(tags$b("The position of Red-line, x<sub>0</sub>")),
        #tableOutput("x")
     hr(),
    #  plotly::plotlyOutput("x.plot.cdf")  
	 plotOutput("x.plot.cdf")
    ),

		conditionalPanel(
		  condition = "input.InputSrc_x == 'SimuDist'",
		 h4("基于模拟数据的绘图"),

		 tags$b("随机数的直方图"),
        plotly::plotlyOutput("x.plot2"),#click = "plot_click6",

        p("如果个数是 0, 直方图将使用默认个数。"),
        #verbatimTextOutput("x.info2"),
        downloadButton("download6", "随机数下载"),
        p(tags$b("样本描述性统计量")),
        tableOutput("x.sum"),
        HTML(
    "
    <b> 说明 </b>
   <ul>
    <li>  Mean = v </li>
    <li>  SD = sqrt(2v) </li>
   </ul>
    "
    )

		),

		conditionalPanel(
		condition = "input.InputSrc_x == 'DataDist'",
		tags$b("数据预览"),
		DT::DTOutput("XX"),
		 h4("用户数据的绘图"),
 		tags$b("上传数据的密度分布"),
        plotly::plotlyOutput("makeplot.x2"),
        tags$b("上传数据的直方图"),
        plotly::plotlyOutput("makeplot.x1"),
        tags$b("上传数据的累积概率分布（CDF）"),
        plotly::plotlyOutput("makeplot.x3"),
        p(tags$b("样本描述性统计量")),
        tableOutput("x.sum2")

		)

	) #main pa end


)


