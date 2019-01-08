##----------#----------#----------#----------
##
## 6MFSanova UI
##
## Language: CN
## 
## DT: 2019-01-08
##
##----------#----------#----------#----------


shinyUI(

tagList(
# shinythemes::themeSelector(),
navbarPage(
  #theme = shinytheme("cosmo"),
  title = "方差分析",

  ## 2. One way anova ---------------------------------------------------------------------------------
  tabPanel(
    "单因素",

    headerPanel("单因素方差分析"),

    tags$b("前提假设"),
    tags$ul(
      tags$li("连续的，数字型的，并且基于正态分布的样本的差异比较."),
      tags$li("数据收集过程是非置换随机的."),
      tags$li("样本来自具有相同方差的群体.")
      ),

    sidebarLayout(
      sidebarPanel(
        helpText("假设"),
        tags$b("零假设"),
        HTML("<p>所有的分组的平均值都相同</p>"),
        tags$b("对立假设"),
        HTML("<p>至少两组的平均值不相同</p>"),
        hr(),
        ##----Import data----##
        helpText("导入数据"),

        tabsetPanel(
          ##-------input data-------##s
          tabPanel(
            "手动输入",
            p(br()),
            helpText("如有缺失值，请输入NA"),
            tags$textarea(
              id = "x1", #p
              rows = 10,
              "0.55\n3.22\n1.08\n1.99\n0.93\n2.98\n2.93\n2.41\n1.98\n1.94\n2.27\n2.69\n2.23\n3.87\n1.43\n3.6\n1.51\n1.7\n2.79\n2.96\n4.67\n5.37\n1.77\n3.52\n5.62\n4.22\n3.33\n3.91\n4.85\n3.4"
              ),
            p(br()),
            
            helpText("因素"),
            tags$textarea(
              id = "f11", #p
              rows = 10,
              "A1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3"
              ),

        helpText("改变样本名称（可选）"),
        tags$textarea(id = "cn1", rows = 2, "X\nA")),

                    ##-------csv file-------##
          tabPanel(
            "上传 .csv 格式文件",
            p(br()),
            fileInput(
              'file1', '选择 .csv 格式文件', #p
                accept = c(
                'text/csv',
                'text/comma-separated-values,text/plain',
                '.csv'
                )
              ),
            checkboxInput('header1', '标题行', TRUE), #p
            radioButtons('sep1', '分隔符', #p
              c(
                Comma = ',',
                Semicolon = ';',
                Tab = '\t'
                ),
              ','
              ))
          ),

        hr(),
        h4("显示数据"),
        dataTableOutput("table1")),

      mainPanel(
        h3(tags$b("检验结果")),
        tableOutput("anova1"),
        #tags$b('Interpretation'), p("NULL"),

        hr(),
        h3(tags$b('记述统计')),
        verbatimTextOutput("bas1"),

        hr(),
        h3(tags$b("边际均值图")),
        plotOutput("mmean1", width = "500px", height = "300px")


        )

      )
    ),

 ## 2. two way anova ---------------------------------------------------------------------------------
  tabPanel(
    "双因素",

    headerPanel("双因素方差分析"),

    tags$b("前提假设"),
    tags$ul(
      tags$li("获得样本的总体为正态分布或近似正态分布."),
      tags$li("样本是独立的."),
      tags$li("总体的差异是相等的."),
      tags$li("这些组具有相同的样本大小.")

      ),

    sidebarLayout(
      sidebarPanel(
        helpText("假设"),
        tags$b("零假设 1"),
        HTML("<p>第一因素的总体平均值相等. </p>"),
        tags$b("零假设 2"),
        HTML("<p>第二因素的总体平均值相等.</p>"),
        tags$b("零假设 3"),
        HTML("<p>两个因素之间没有相互作用.</p>"),
        hr(),
        
        ##----Import data----##
        helpText("导入数据"),

        tabsetPanel(
          ##-------input data-------##s
          tabPanel(
            "手动输入",
            p(br()),
            helpText("如有缺失值，请输入NA"),
            tags$textarea(
              id = "x", #p
              rows = 10,
              "0.55\n3.22\n1.08\n1.99\n0.93\n2.98\n2.93\n2.41\n1.98\n1.94\n2.27\n2.69\n2.23\n3.87\n1.43\n3.6\n1.51\n1.7\n2.79\n2.96\n4.67\n5.37\n1.77\n3.52\n5.62\n4.22\n3.33\n3.91\n4.85\n3.4"
              ),
            p(br()),
            splitLayout(
            helpText("第一因素"),
            tags$textarea(
              id = "f1", #p
              rows = 10,
              "A1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3"
              ),
            helpText("第二因素"),
            tags$textarea(
              id = "f2", #p
              rows = 10,
              "T1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2"
              )),
            
        helpText("改变样本名称（可选）"),
        tags$textarea(id = "cn", rows = 3, "X\nA\nB") #p
            ), #tabPanel(

          ##-------csv file-------##
          tabPanel(
            "上传 .csv 格式文件",
            p(br()),
            fileInput(
              'file', '选择 .csv 格式文件', #p
              accept = c(
                'text/csv',
                'text/comma-separated-values,text/plain',
                '.csv'
                )
              ),
            checkboxInput('header', '标题行', TRUE), #p
            radioButtons('sep', '分隔符', #p
              c(
                Comma = ',',
                Semicolon = ';',
                Tab = '\t'
                ),
              ','
              )
            )),

        hr(),
        h4("显示数据"),
        dataTableOutput("table")),


      mainPanel(
        h3(tags$b("检验结果")),
        checkboxInput('inter', 'Interaction', TRUE), #p
        tableOutput("anova"),
        #tags$b('Interpretation'), p("NULL"),

        hr(),
        h3(tags$b('记述统计')),
          numericInput("grp", 'Choose the factor in the Data Display column', 2, 2, 3, 1),
          verbatimTextOutput("bas"),

        hr(),
        h3(tags$b("均值图")),
        checkboxInput('tick', 'Untick to change the group and x-axis', TRUE), #p
        plotOutput("meanp.a", width = "500px", height = "300px"),

        hr(),
        h3(tags$b("边际均值图")),
        checkboxInput('tick2', 'Untick to change the x-axis', TRUE), #p
        plotOutput("mmean.a", width = "500px", height = "300px")
        )
      )
    ), ##

  ## 3. multiple comparision ---------------------------------------------------------------------------------
  tabPanel(
    "多重比较",
    headerPanel("多重比较"),

    tags$b("前提假设"),
    tags$ul(
      tags$li("寻找三个或更多个级别的因子的统计学差异."),
      tags$li("在因素方差分析（ANOVA分析）之后，响应变量的平均值可能在因素之间存在统计学显著差异，但是在哪对因素水平间存在统计学差异是不明的")
      ),

    sidebarLayout(

        sidebarPanel(
        helpText("假设"),
        tags$b("零假设"),
        HTML("<p>因素的平均值是相等的.</p>"),
        hr(),
        
        ##----Import data----##
        helpText("导入数据"),

        tabsetPanel(
          ##-------input data-------##s
          tabPanel(
            "手动输入",
            p(br()),
            helpText("如有缺失值，请输入NA"),
            tags$textarea(
              id = "xm", #p
              rows = 10,
              "0.55\n3.22\n1.08\n1.99\n0.93\n2.98\n2.93\n2.41\n1.98\n1.94\n2.27\n2.69\n2.23\n3.87\n1.43\n3.6\n1.51\n1.7\n2.79\n2.96\n4.67\n5.37\n1.77\n3.52\n5.62\n4.22\n3.33\n3.91\n4.85\n3.4"
              ),
            p(br()),
            helpText("因素"),
            tags$textarea(
              id = "fm", #p
              rows = 10,
              "A1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3"
              ),

        helpText("改变样本名称（可选）"),
        tags$textarea(id = "cnm", rows = 2, "X\nA") #p
            ),
        
         ##-------csv file-------##
          tabPanel(
            "上传 .csv 格式文件",
            p(br()),
            fileInput(
              'filem', '选择 .csv 格式文件', #p
              accept = c(
                'text/csv',
                'text/comma-separated-values,text/plain',
                '.csv'
                )
              ),
            checkboxInput('headerm', '标题行', TRUE), #p
            radioButtons('sepm', '分隔符', #p
              c(
                Comma = ',',
                Semicolon = ';',
                Tab = '\t'
                ),
              ','
              ) 
          )),

        hr(),
        h4("显示数据"),
        
        dataTableOutput("tablem")),

       mainPanel(
        h3(tags$b("检验结果")),
        h3("成对t检验(Pairwise t-test)"),

        radioButtons("method", "方法", 
          c(Bonferroni = 'bonferroni',
            Holm = 'holm',
            Hochberg = 'hochberg',
            Hommel = 'hommel',
            FDR_Benjamini_Hochberg = 'BH',
            Benjamini_Yekutieli = 'BY'
            ), 
          "bonferroni"),
        verbatimTextOutput("multiple"),

        hr(),
        h3("杜凯确实差异检验(Tukey Honest Significant Differences)"),
        verbatimTextOutput("hsd")
        )
      ) 
  ),

 ##----------

tabPanel((a("主页",
 #target = "_blank",
 style = "margin-top:-30px;",
 href = paste0("https://pharmacometrics.info/mephas/", "index_cn.html")))),

tabPanel(
      tags$button(
      id = 'close',
      type = "button",
      class = "btn action-button",
      onclick = "setTimeout(function(){window.close();},500);",  # close browser
      "停止"))

)))

