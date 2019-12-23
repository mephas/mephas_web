
##----------#----------#----------#----------
##
## 5MFSrctabtest SERVER
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------
##---------- Panel 3: R,C, k table ----------
rn <- reactive({unlist(strsplit(input$rn7, "[\n]"))})
cn <- reactive({unlist(strsplit(input$cn7, "[\n]"))})
kn <- reactive({unlist(strsplit(input$kn7, "[\n]"))})

T7 = reactive({ # prepare dataset
  #validate(need(length(cn())==2, "Please input enough names"))
  #validate(need(length(rn())==2, "Please input enough names"))

  x <- as.numeric(unlist(strsplit(input$x7, "[,;\n\t ]")))
  validate(need(length(x)==length(cn())*length(rn())*length(kn()), "Please input enough values"))
  x <- aperm(
    array(x,dim=c(length(cn()),length(rn()),length(kn())), 
    dimnames = list(groups=cn(), status=rn(), confound=kn())),
    perm=c(2,1,3))
  return(x)
  })

output$dt7 = renderTable({
  T <- T7()[,,1]
  for (i in 2:length(kn())){
    T <- rbind.data.frame(T, T7()[,,i])
  }
  T
  k <- length(kn())
  n <- length(rn())
  dm <- dimnames(T7())
  rownames(T) <- paste0(rep(dm[[3]], each=n), "-*-", dm[[1]])
  colnames(T)<- cn()
  return(T)
  }, width = "600px" ,rownames = TRUE, digits=1)

output$c.test7 = renderTable({
    x =T7()
    #dimnames(x) = list(status=rn(), groups=cn(), confound=kn())
    res <- mantelhaen.test(x)

    res.table = t(data.frame(X_statistic = res$statistic[1], 
                              #estimate=res$estimate[1],                           
                              #Degree_of_freedom = res$parameter,
                              P_value = res$p.value))
    colnames(res.table) <- c(res$method)
    rownames(res.table) <- c("Mantel-Haenszel Chi-Square", "P Value")
    return(res.table)
    }, 
    rownames = TRUE, width="500px")

