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
navbarPage(

  title = "方差分析",

##---------- Panel 1 ----------
  tabPanel(
    "单因素",

    headerPanel("单因素方差分析"),

    tags$b("前提假设"),
    tags$ul(
      tags$li("连续的，数字型的，并且基于正态分布的样本的差异比较"),
      tags$li("数据收集过程是非置换随机的"),
      tags$li("样本来自具有相同方差的群体")
      ),

    sidebarLayout(
      sidebarPanel(
        h4("假设检验"),
        tags$b("零假设"),
        p("所有的分组的平均值都相同"),

        tags$b("备择检验"),
        p("至少两组的平均值不相同"),
        hr(),
        ##----Import data----##
        h4("数据准备"),

        tabsetPanel(
          ##-------input data-------##s
          tabPanel(
            "手动输入",
            p(br()),
            helpText("请输入数值和因子的名字（缺失值请输入NA）"),

            splitLayout(

              verticalLayout(
              tags$b("数值"),
              tags$textarea(
              id = "x1",
              rows = 10,
              "0.55\n3.22\n1.08\n1.99\n0.93\n2.98\n2.93\n2.41\n1.98\n1.94\n2.27\n2.69\n2.23\n3.87\n1.43\n3.6\n1.51\n1.7\n2.79\n2.96\n4.67\n5.37\n1.77\n3.52\n5.62\n4.22\n3.33\n3.91\n4.85\n3.4"
              )),

            verticalLayout(
            tags$b("因子"), 
            tags$textarea(
              id = "f11", #p
              rows = 10,
              "A1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3"
              ))
            )
            ,

      helpText("改变样本的名称（可选)"),
        tags$textarea(id = "cn1", rows = 2, "X\nA")),

                    ##-------csv file-------##
          tabPanel(
            "上传CSV文件",
            p(br()),
            fileInput(
              'file1', '选择CSV文件', #p
                accept = c(
                'text/csv',
                'text/comma-separated-values,text/plain',
                '.csv'
                )
              ),
            checkboxInput('header1', '第一行为变量名', TRUE), #p
            radioButtons('sep1', '分隔符', #p
              c(
                Comma = ',',
                Semicolon = ';',
                Tab = '\t'
                ),
              ','
              ))
          )
        ),

      mainPanel(
        h4("ANOVA 表"),
        tableOutput("anova1"),
        hr(),

     h4("数据的描述统计"),
        tabsetPanel(
          tabPanel("数据显示",p(br()),
          dataTableOutput("table1")
            ),

          tabPanel('描述性统计量',p(br()),
          verbatimTextOutput("bas1")),

          tabPanel("边际均值图",p(br()),
            plotOutput("mmean1", width = "500px", height = "300px")
            )
          )
        )
      )
    ),

##---------- Panel 2 ----------

  tabPanel(
    "双因素",

    headerPanel("双因素方差分析"),

    tags$b("前提假设"),
    tags$ul(
      tags$li("获得样本的总体为正态分布或近似正态分布"),
      tags$li("样本是独立的"),
      tags$li("总体的差异是相等的"),
      tags$li("这些组具有相同的样本大小")

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
        h4("导入数据"),

        tabsetPanel(
          ##-------input data-------##s
          tabPanel(
            "手动输入",
            p(br()),
            helpText("缺失值请输入NA"),

            splitLayout(

            verticalLayout(
            tags$b("数值"), 
            tags$textarea(
              id = "x", #p
              rows = 10,
              "0.55\n3.22\n1.08\n1.99\n0.93\n2.98\n2.93\n2.41\n1.98\n1.94\n2.27\n2.69\n2.23\n3.87\n1.43\n3.6\n1.51\n1.7\n2.79\n2.96\n4.67\n5.37\n1.77\n3.52\n5.62\n4.22\n3.33\n3.91\n4.85\n3.4"
              )),

            verticalLayout(
            tags$b("因子 1"), 
            tags$textarea(
              id = "f1", #p
              rows = 10,
              "A1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3"
              )),

            verticalLayout(
            tags$b("因子 2"), 
            tags$textarea(
              id = "f2", #p
              rows = 10,
              "T1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2"
              ))
            ),
            
        helpText("改变样本的名称（可选)"),
        tags$textarea(id = "cn", rows = 3, "X\nA\nB") #p
            ), #tabPanel(

          ##-------csv file-------##
          tabPanel(
            "上传CSV文件",
            p(br()),
            fileInput(
              'file', '选择CSV文件', #p
              accept = c(
                'text/csv',
                'text/comma-separated-values,text/plain',
                '.csv'
                )
              ),
            checkboxInput('header', '第一行为变量名', TRUE), #p
            radioButtons('sep', '分隔符', #p
              c(
                Comma = ',',
                Semicolon = ';',
                Tab = '\t'
                ),
              ','
              )
            ))
        ),


      mainPanel(

        h3(tags$b("ANOVA 表")),
        checkboxInput('inter', '交互项', TRUE), #p
        tableOutput("anova"),

        hr(),

        tabsetPanel(
        tabPanel("数据显示", p(br()),
        dataTableOutput("table")
        ),

        tabPanel('描述性统计量',p(br()),
        numericInput("grp", '选择因子', 2, 2, 3, 1),
        verbatimTextOutput("bas")
            ),

        tabPanel("均值图",p(br()),
        checkboxInput('tick', '取消打勾改变分组和x轴', TRUE), #p
        plotOutput("meanp.a", width = "500px", height = "300px")
          ),

        tabPanel("边际均值图",p(br()),
          checkboxInput('tick2', '取消打勾改变x轴', TRUE), #p
        plotOutput("mmean.a", width = "500px", height = "300px")
          )
          )
        )
      )
    ), ##

##---------- Panel 3 ----------

  tabPanel(
    "多重比较",
    headerPanel("多重比较"),

    tags$b("前提假设"),
    tags$ul(
      tags$li("寻找三个或更多个级别的因子的统计学差异"),
      tags$li("在因素方差分析（ANOVA分析）之后，响应变量的平均值可能在因素之间存在统计学显著差异，但是在哪对因素水平间存在统计学差异是不明的")
      ),

    sidebarLayout(

        sidebarPanel(
        h4("假设检验"),
        tags$b("零假设"),
        HTML("<p>各组平均值是相等的</p>"),
        hr(),
        
        ##----Import data----##
        h4("数据准备"),

        tabsetPanel(
          ##-------input data-------##s
          tabPanel(
            "M手动输入",
            p(br()),
            helpText("缺失值请输入NAA"),

            splitLayout(
            verticalLayout(
            tags$b("数值"), 
            tags$textarea(
              id = "xm", #p
              rows = 10,
              "0.55\n3.22\n1.08\n1.99\n0.93\n2.98\n2.93\n2.41\n1.98\n1.94\n2.27\n2.69\n2.23\n3.87\n1.43\n3.6\n1.51\n1.7\n2.79\n2.96\n4.67\n5.37\n1.77\n3.52\n5.62\n4.22\n3.33\n3.91\n4.85\n3.4"
              )),

            verticalLayout(
            tags$b("因子"), 
            tags$textarea(
              id = "fm", #p
              rows = 10,
              "A1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3"
              ))
            ),

       helpText("改变样本的名称（可选)"),
        tags$textarea(id = "cnm", rows = 2, "X\nA") #p
            ),
        
         ##-------csv file-------##
          tabPanel(
            "上传CSV文件",
            p(br()),
            fileInput(
              'filem', '选择CSV文件', #p
              accept = c(
                'text/csv',
                'text/comma-separated-values,text/plain',
                '.csv'
                )
              ),
            checkboxInput('headerm', '第一行为变量名', TRUE), #p
            radioButtons('sepm', '分隔符', #p
              c(
                Comma = ',',
                Semicolon = ';',
                Tab = '\t'
                ),
              ','
              ) 
          ))
        ),

       mainPanel(
        h4("结果"),

        tabsetPanel(

          tabPanel("成对的t检验", p(br()),
          radioButtons("method", "选择一种方法", 
          c(Bonferroni = 'bonferroni',
            Holm = 'holm',
            Hochberg = 'hochberg',
            Hommel = 'hommel',
            FDR_Benjamini_Hochberg = 'BH',
            Benjamini_Yekutieli = 'BY'
            ), 
          "bonferroni"),
        verbatimTextOutput("multiple")
            ),

          tabPanel("Tukey Honest Significant Differences检验", p(br()),
            verbatimTextOutput("hsd")
            )
          ),

        h4("数据显示"),
        dataTableOutput("tablem")

        )
      ) 
  ),

##---------- other panels ----------

source("../0tabs/home_cn.R",local=TRUE)$value,
source("../0tabs/stop_cn.R",local=TRUE)$value





)))

