#****************************************************************************************************************************************************

rn <- reactive({unlist(strsplit(input$rn7, "[\n]"))})
cn <- reactive({unlist(strsplit(input$cn7, "[\n]"))})
kn <- reactive({unlist(strsplit(input$kn7, "[\n]"))})

T7 = reactive({ # prepare dataset
  #validate(need(length(cn())==2, "Please input enough names"))
  #validate(need(length(rn())==2, "Please input enough names"))

  x <- as.numeric(unlist(strsplit(input$x7, "[,;\n\t ]")))
  validate(need(length(x)==length(cn())*length(rn())*length(kn()), "请检查数据输入是否有效。"))
  x <- aperm(
    array(x,dim=c(length(cn()),length(rn()),length(kn())), 
    dimnames = list(groups=cn(), status=rn(), confound=kn())),
    perm=c(2,1,3))
  return(x)
  })

output$dt7 = DT::renderDT({
  T <- T7()[,,1]
  for (i in 2:length(kn())){
    T <- rbind.data.frame(T, T7()[,,i])
  }
  T
  k <- length(kn())
  n <- length(rn())
  dm <- dimnames(T7())
  rownames(T) <- paste0(rep(dm[[3]], each=n), " : ", dm[[1]])
  colnames(T)<- cn()
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

output$c.test7 = DT::renderDT({
    x =T7()
    #dimnames(x) = list(status=rn(), groups=cn(), confound=kn())
    res <- mantelhaen.test(x)

    res.table = t(data.frame(X_statistic = res$statistic[1], 
                              #estimate=res$estimate[1],                           
                              #Degree_of_freedom = res$parameter,
                              P_value = res$p.value))
    colnames(res.table) <- c(res$method)
    rownames(res.table) <- c("Mantel-Haenszel Chi-Square", "P Value")
    return(round(res.table,6))
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

