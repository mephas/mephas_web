#****************************************************************************************************************************************************1.4. beta

sidebarLayout(

	sidebarPanel(

	h4(tags$b("第1步  选择数据源")),
	p("基于数学公式、模拟数据或用户数据"),
	#Select Src
	selectInput(
	    "InputSrc_b", "Select plot",
      c("基于数学公式" = "MathDist",
        "基于模拟数据" = "SimuDist",
        "基于用户数据" = "DataDist")),
	hr(),
	#Select Src end
	h4(tags$b("第2步 设置参数")),
	#condiPa 1
	  conditionalPanel(
	    condition = "input.InputSrc_b == 'MathDist'",
	    HTML("<b>1. 设置参数 Beta(&#945, &#946)</b>"),
	    #HTML("<h4><b>Step 1. Set Parameters for Beta(&#945, &#946)</h4></b>"),
		numericInput("b.shape", HTML("&#945 > 0, 形状参数"), value = 12, min = 0),
		  numericInput("b.scale", HTML("&#946 > 0, 形状参数"), value = 12, min = 0),
		  hr(),
		  numericInput("b.mean", HTML("O或根据均值和SD（均值=SD）计算k 和 &#952, 输入均值"), value = 0.5, min = 0),
			numericInput("b.sd", HTML("输入SD"), value = 0.1, min = 0),

verbatimTextOutput("b.rate"),
HTML("<li> Mean = &#945 / (&#945 + &#946)
			<li> Variance = &#945&#946/[(&#945 + &#946)^2(&#945 + &#946+1)]"),
		hr(),
		  numericInput("b.xlim", "改变x轴的范围, x轴须 > 0", value = 1, min = 1)
		  #snumericInput("b.ylim", "Range of y-asis, > 0", value = 2.5, min = 0.1, max = 3),
	  ),
	 #condiPa 1 end

	  #condiPa 2
	  conditionalPanel(
	    condition = "input.InputSrc_b == 'SimuDist'",
	    numericInput("b.size", "模拟数据样本量", value = 100, min = 1, step = 1),
	    sliderInput("b.bin", "直方图中柱子的个数", min = 0, max = 100, value = 0),
		p("如果个数是 0, 直方图将使用默认个数。")

	  ),
	  #condiPa 2 end

	  #condiPa 3
	  conditionalPanel(
	    condition = "input.InputSrc_b == 'DataDist'",

	    tabsetPanel(
	       tabPanel("手动输入",p(br()),
		p("数据可以用「，」，「分号」，「回车」，「空格」，「制表符」进行分隔。"),
		p(tags$b("从CSV（一列）复制数据并粘贴到框中")),
    	tags$textarea(
        id = "x.b", #p
        rows = 10,
"0.11\n0.57\n0.59\n0.52\n0.13\n0.45\n0.63\n0.68\n0.44\n0.55\n0.48\n0.54\n0.29\n0.41\n0.64\n0.75\n0.33\n0.24\n0.45\n0.18"
),
      	p("缺失值输入NA")
	     	 ), #tab1 end

tabPanel.upload.num(file ="b.file", header="b.header", col="b.col", sep="b.sep")

	    ),
		sliderInput("bin.b","直方图中的分箱数", min = 0, max = 100, value = 0),
        p("当分箱数为0时，绘图将使用默认分箱数")
	  ),
	  #condiPa 3 end
	  hr(),
	  h4(tags$b("第3步 显示概率")),
 		numericInput("b.pr", HTML("红线左侧的面积比例 = Pr(X < x<sub>0</sub>), x<sub>0</sub>为红线位置"), value = 0.05, min = 0, max = 1, step = 0.05),
	  hr()
	), #sidePa end

mainPanel(
		h4(tags$b("Outputs")),

		conditionalPanel(
		  condition = "input.InputSrc_b == 'MathDist'",
		  h4("基于数学公式"),
		tags$b("贝塔分布图"),
        plotOutput("b.plot", click = "plot_click13"),
        verbatimTextOutput("b.info"),
        #HTML("<p><b>The position of Red-line, x<sub>0</sub></b></p>"),
        #p(tags$b("The position of Red-line, x<sub>0</sub>")),
        #tableOutput("b")
   hr(),
#    plotly::plotlyOutput("b.plot.cdf")  
plotOutput("b.plot.cdf") 
		),

		conditionalPanel(
		  condition = "input.InputSrc_b == 'SimuDist'",
		   h4("基于模拟数据的绘图"),

		tags$b("随机数的直方图"),
        plotly::plotlyOutput("b.plot2"),# click = "plot_click14",

        #verbatimTextOutput("b.info2"),
        downloadButton("download4", "随机数下载"),
        p(tags$b("样本描述性统计量")),
        tableOutput("b.sum"),
        HTML(
    "
    <b> 说明 </b>
   <ul>
    <li>  Mean = &#945/(&#945+&#946) </li>
    <li>  SD = sqrt(&#945*&#946/(&#945+&#946)^2(&#945+&#946+1)) </li>
   </ul>
    "
    )

		),

		conditionalPanel(
		condition = "input.InputSrc_b == 'DataDist'",

		tags$b("数据预览"),
		DT::DTOutput("ZZ"),
		h4("用户数据的绘图"),
        tags$b("上传数据的密度分布"),
        plotly::plotlyOutput("makeplot.b2"),
        tags$b("上传数据的直方图"),
        plotly::plotlyOutput("makeplot.b1"),
        tags$b("上传数据的累积概率分布（CDF）"),
        plotly::plotlyOutput("makeplot.b3"),
        p(tags$b("样本描述性统计量")),
        tableOutput("b.sum2")



		)

	) #main pa end


	)

