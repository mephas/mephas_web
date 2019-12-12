
##----------#----------#----------#----------
##
## 5MFSrctabtest SERVER
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------
##---------- Panel 3: 2,2, k table ----------
rn8 <- reactive({unlist(strsplit(input$rn8, "[\n]"))})
cn8 <- reactive({unlist(strsplit(input$cn8, "[\n]"))})
kn8 <- reactive({unlist(strsplit(input$kn8, "[\n]"))})

T8 = reactive({ # prepare dataset
  x <- as.numeric(unlist(strsplit(input$x8, "[,;\n\t ]")))
  x <- array(x,dim=c(2,2, length(kn8())), 
    dimnames = list(status=rn8(), groups=cn8(),confound=kn8())
    )
  return(x)
  })

output$dt8 = renderTable({
  T <- T8()[,,1]
  for (i in 2:length(kn8())){
    T <- rbind.data.frame(T, T8()[,,i])
  }
  T
  k <- length(kn8())
  n <- length(rn8())
  dm <- dimnames(T8())
  rownames(T) <- paste0(rep(dm[[3]], rep(2,k)), "-*-",dm[[1]])
  colnames(T)<- cn8()
  return(T)
  }, width = "600px" ,rownames = TRUE, digits=1)

output$c.test8 = renderTable({
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

    res.table = t(data.frame(X_statistic = res$statistic,
                              estimate=res$estimate,
                              #Degree_of_freedom = res$parameter,
                              P_value = res$p.value,
                              CI = paste0("(",round(res$conf.int[1], digits = 4),", ",round(res$conf.int[2], digits = 4), ")")))
  
    colnames(res.table) <- c(res$method)
    rownames(res.table) <- c("Mantel-Haenszel Chi-Square", "Estimated Odds Ratio", "P Value", "95% Confidence Interval")
    return(res.table)
    }, 
    rownames = TRUE, width="700px")

