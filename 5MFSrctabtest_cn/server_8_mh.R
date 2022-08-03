#****************************************************************************************************************************************************

rn8 <- reactive({unlist(strsplit(input$rn8, "[\n]"))})
cn8 <- reactive({unlist(strsplit(input$cn8, "[\n]"))})
kn8 <- reactive({unlist(strsplit(input$kn8, "[\n]"))})

T8 = reactive({ # prepare dataset
  x <- as.numeric(unlist(strsplit(input$x8, "[,;\n\t ]")))
  validate(need(length(x)==4*length(kn8()), "Please input enough values"))
  validate(need(length(cn8())==2, "Please input enough names"))
  validate(need(length(rn8())==2, "Please input enough names"))
  x <- aperm(
    array(x,dim=c(2,2, length(kn8())), 
    dimnames = list(status=rn8(), groups=cn8(),confound=kn8())),
    perm=c(2,1,3)
    )
  return(x)
  })

output$dt8 = DT::renderDT({
  T <- T8()[,,1]
  for (i in 2:length(kn8())){
    T <- rbind.data.frame(T, T8()[,,i])
  }
  T
  k <- length(kn8())
  n <- length(rn8())
  dm <- dimnames(T8())
  rownames(T) <- paste0(rep(dm[[3]], rep(2,k)), " : ",dm[[2]])
  colnames(T)<- cn8()
  return(T)
  }, 
  #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv',    title = "数据结果"),
        list(extend = 'excel',  title = "数据结果")
        ),
    scrollX = TRUE))

output$c.test8 = DT::renderDT({
    x <- T8()
    if (input$md8=="a"){
      res <- mantelhaen.test(x, alternative=input$alt8, correct=TRUE, exact=FALSE)
    }
    if (input$md8=="b"){
      res <- mantelhaen.test(x, alternative=input$alt8, correct=FALSE, exact=FALSE)
    }
    if (input$md8=="c"){
      res <- mantelhaen.test(x, alternative=input$alt8, correct=TRUE, exact=TRUE)
    }

    res.table = t(data.frame(X_statistic = round(res$statistic, 6),
                              estimate=round(res$estimate, 6),
                              #Degree_of_freedom = res$parameter,
                              P_value = round(res$p.value, 6),
                              CI = paste0("(",round(res$conf.int[1], 6),", ",round(res$conf.int[2], 6), ")")))
  
    colnames(res.table) <- c(res$method)
    rownames(res.table) <- c("Mantel-Haenszel Chi-Square", "Estimated Odds Ratio", "P Value", "95% Confidence Interval")
    return(res.table)
    }, 
    #class="row-border", 
  extensions = 'Buttons', 
  options = list(
    dom = 'Bfrtip',
    buttons = 
      list('copy',
        list(extend = 'csv',    title = "数据结果"),
        list(extend = 'excel',  title = "数据结果")
        ),
    scrollX = TRUE))

