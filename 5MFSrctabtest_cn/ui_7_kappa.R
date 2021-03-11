#****************************************************************************************************************************************************7. kk kappa

   sidebarLayout(
      sidebarPanel(

    h4(tags$b("第1步 准备数据")),

    p(tags$b("1. 在列名和行名中为K个评分器/测量命名")), 
    tags$textarea(id="cn6", rows=2, "Yes\nNo"), 

    p(tags$b("2. 在列名和行名中为相关实验/重复测量命名")), 
    tags$textarea(id="rn6", rows=2, "Survey1\nSurvey2"),p(br()),

  
  p(tags$b("3. 请根据行的顺序输入 K*K 个值")),
  p("数据点可以用 逗号（,） 分号（;） 回车（/Enter） 制表符（/Tab） 空格（/Space）分隔"),
  tags$textarea(id="x6", rows=4, 
    "136\n92\n69\n240"),
      p("不可有缺失值。"),
      conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("此处的示例为Survey1和Survey2的回答。"))
    ),
        hr(),

    h4(tags$b("假设")),

   p(tags$b("虚假设")), 
   p("病例对照（行）与分组因子（列）无显著相关"),
    
   p(tags$b("备择假设")), 
   p("病例对照（行）与分组因子（列）显著相关"),     
conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("这个示例我们想确认调查的结果是否有可重复性。"))
    )
   

    ),


    mainPanel(

    h4(tags$b("Output 1. 描述性统计结果")), p(br()), 

    tabsetPanel(

    tabPanel("数据确认", p(br()),

        p(tags$b("含有合计的KxK列联表")),
        DT::DTOutput("dt6")
        ),
    tabPanel("一致性表", p(br()),
        DT::DTOutput("dt6.0")
        ),
    tabPanel("权重表", p(br()),
        DT::DTOutput("dt6.1")
        )
    ),

    hr(),

    h4(tags$b("Output 2. 检验结果")), p(br()), 

    DT::DTOutput("c.test6"),

     HTML(
    "<b> Kappa评价说明和指南 </b> 
    <ul>
      <li> <b>Cohen's Kappa 统计系数>0.75</b>: <b>出色的</b> 可重复性 </li>
      <li> <b>0.4<=Cohen's Kappa 统计系数<=0.75</b>: <b>良好的</b> 可重复性</li>
      <li> <b>00<=Cohen's Kappa 统计系数<0.4</b>: <b>较低的</b> 可重复性 </li>
      <li> Cohen’s kappa 考虑了两个评分器之间的偏差，但没有考虑偏差度。</li>
      <li> 加权 kappa 通过预定义权重表进行计算，该权重表权衡两个评分器之间的偏差度。偏差越大，加权越高。</li>

    </ul>

  "
  ),
conditionalPanel(
    condition = "input.explain_on_off",
     p(tags$i("此默认设置得出结论:调查1和调查2的答复的可重复性偏低，有较低的可重复性。"))
)
        )
      )
    