dtametasa <- function(
    data,
    p,
    fix.c=TRUE,
    c1.square = 0.5,
    beta0 = 1,
    reitsma.par0 = NULL,
    beta.interval = c(0, 2),
    alpha.interval = c(-5, 3),
    ci.level = 0.95,
    correct.value = 0.5,
    correct.type = c("single", "all")[1],
    show.warn.message = FALSE,
    alpha.root.extendInt = "downX",
    eps = sqrt(.Machine$double.eps),
    sauc.type = c("sroc", "hsroc")[1],
    ...
){
  
  ##
  ## INPUT: DATA PREPROCESS ----------------------------------------------------------
  ##
  
  if (p <= 0 | p > 1) 
    stop("PLEASE MAKE SET SELECTION PROBABILITY: p in (0, 1]", 
         call. = FALSE)
  if (!any(c("y1", "y1", "v1", "v2", "TP", "FN", "TN", "FP") %in% 
           names(data))) 
    stop("COLNAMES OF DATA MUST BE 'TP/FN/TN/FP' OR 'y1/y2/v1/v2'", 
         call. = FALSE)
  n <- nrow(data)
  if ("TP" %in% names(data)) {
    data <- correction(data, value = correct.value, type = correct.type)
    data <- logit.data(data)
  }
  
  y1 <- data$y1
  y2 <- data$y2
  v1 <- data$v1
  v2 <- data$v2
  c1 <- sqrt(c1.square)
  
  ##
  ##  INPUT: OPTIMIZATION LOGLIKELIHOOD FUNCTION --------------------------------------
  ##
  
  
  ## AUTO-SET START POINTS
  if(!length(reitsma.par0)==5) {
    
    start7 <- c(0, 0, 0.1, 0.1, -0.1, beta0, c1)
    
    fit.m <- mixmeta::mixmeta(cbind(y1,y2),S=cbind(v1, rep(0, n), v2), method="ml")
    
    if(!inherits(fit.m, "try-error")) {
      
      if(fit.m$converged){
        
        p1 <- sqrt(fit.m$Psi[1])
        p2 <- sqrt(fit.m$Psi[4])
        p.r<- fit.m$Psi[3]/(p1*p2)
        
        start7 <- c(fit.m$coefficients, p1, p2, p.r, beta0, c1)
        
      }
      
    }
    
  } else start7 <- c(reitsma.par0, beta0, c1)
  
  names(start7) <- c("mu1", "mu2", "tau1", "tau2", "rho", "beta", "c1")
  
  
  if(fix.c){
    fn <- function(par) .llk.o(par = c(par[1:6], c1), y1 = data$y1, y2 = data$y2,v1 = data$v1,v2 = data$v2,n = n,
                               p = p, alpha.interval = alpha.interval, alpha.root.extendInt = alpha.root.extendInt, 
                               show.warn.message = show.warn.message, ...)
    opt <- try(nlminb(start7[1:6],
                      fn,
                      lower = c(-5, -5, eps, eps,-1, beta.interval[1]),
                      upper = c( 5,  5,   3,   3, 1, beta.interval[2])
    ),silent = TRUE)
  }else{
    fn <- function(par) .llk.o(par , y1 = data$y1, y2 = data$y2,v1 = data$v1,v2 = data$v2,n = n,
                               p = p, alpha.interval = alpha.interval, alpha.root.extendInt = alpha.root.extendInt, 
                               show.warn.message = show.warn.message, ...)
    opt <- try(nlminb(start7,
                      fn,
                      lower = c(-5, -5, eps, eps,-1, beta.interval[1], 0),
                      upper = c( 5,  5,   3,   3, 1, beta.interval[2], 1)
    ),silent = TRUE)
  }
  if (!inherits(opt, "try-error")) {
    u1 <- opt$par[1]
    se <- plogis(u1)
    u2 <- opt$par[2]
    sp <- plogis(u2)
    t1 <- opt$par[3]
    t11 <- t1^2
    t2 <- opt$par[4]
    t22 <- t2^2
    r <- opt$par[5]
    t12 <- t1 * t2 * r
    b <- opt$par[6]
    if(!fix.c) c1  <- opt$par[7]
    c11 <- c1^2
    c22 <- 1-c11   
    c2 <- sqrt(c22)
    t.ldor <- c11 * t11 + c22 * t22 + 2 * c1 * c2 * t12
    u.ldor <- c1 * u1 + c2 * u2
    se.ldor2 <- c11 * v1 + c22 * v2
    se.ldor <- sqrt(se.ldor2)
    sq <- sqrt(1 + b^2 * (1 + t.ldor/se.ldor2))
    hes <- numDeriv::hessian(fn, opt$par)
    rownames(hes) <- colnames(hes) <- c("mu1", "mu2", "tau1", 
                                        "tau2", "rho", "beta", "c1")[1:ncol(hes)]
    if (p == 1) 
      inv.I.fun.m <- solve(hes[1:5, 1:5])
    else inv.I.fun.m <- solve(hes)
    #else if(fix.c)inv.I.fun.m <- solve(hes[1:6,1:6])
    
    opt$var.ml <- inv.I.fun.m
    var.matrix <- inv.I.fun.m[1:5, 1:5]
    opt$sauc.ci<-c(NA,NA,NA)
    sauc.ci<-try(SAUC.ci(u1 = u1, u2 = u2, t1 = t1, t2 = t2, 
                         r = r, var.matrix = var.matrix, sauc.type = sauc.type,
                         ci.level = ci.level))
    if(class(sauc.ci)!="try-error"){
      opt$sauc.ci<-sauc.ci
    }
    sauc <- opt$sauc.ci[1]
    if (p == 1) 
      opt$beta.ci <- c(NA, NA, NA)
    else {
      b.se <- suppressWarnings(sqrt(inv.I.fun.m[6, 6]))
      b.lb <- b + qnorm((1 - ci.level)/2, lower.tail = TRUE) * 
        b.se
      b.ub <- b + qnorm((1 - ci.level)/2, lower.tail = FALSE) * 
        b.se
      opt$beta.ci <- c(b, b.lb, b.ub)
    }
    names(opt$beta.ci) <- c("beta", "beta.lb", "beta.ub")
    if (p == 1) 
      a.opt <- NA
    else {
      a.p <- function(a) {
        sum(1/pnorm((a + b * u.ldor/se.ldor)/sq), na.rm = TRUE) - 
          n/p
      }
      if (!show.warn.message) 
        a.opt.try <- suppressWarnings(try(uniroot(a.p, 
                                                  interval = alpha.interval, extendInt = alpha.root.extendInt), 
                                          silent = TRUE))
      else a.opt.try <- try(uniroot(a.p, interval = alpha.interval, 
                                    extendInt = alpha.root.extendInt), silent = TRUE)
      a.opt <- a.opt.try$root
    }
    opt$alpha <- c(alpha = a.opt)
    u1.se <- suppressWarnings(sqrt(inv.I.fun.m[1, 1]))
    u1.lb <- u1 + qnorm((1 - ci.level)/2, lower.tail = TRUE) * 
      u1.se
    u1.ub <- u1 + qnorm((1 - ci.level)/2, lower.tail = FALSE) * 
      u1.se
    opt$mu1.ci <- c(u1, u1.lb, u1.ub, se, plogis(u1.lb), 
                    plogis(u1.ub))
    names(opt$mu1.ci) <- c("mu1", "mu1.lb", "mu1.ub", "sens", 
                           "se.lb", "se.ub")
    u2.se <- suppressWarnings(sqrt(inv.I.fun.m[2, 2]))
    u2.lb <- u2 + qnorm((1 - ci.level)/2, lower.tail = TRUE) * 
      u2.se
    u2.ub <- u2 + qnorm((1 - ci.level)/2, lower.tail = FALSE) * 
      u2.se
    opt$mu2.ci <- c(u2, u2.lb, u2.ub, sp, plogis(u2.lb), 
                    plogis(u2.ub))
    names(opt$mu2.ci) <- c("mu2", "mu2.lb", "mu2.ub", "spec", 
                           "sp.lb", "sp.ub")
    opt$par.all <- c(u1, u2, t11, t22, t12, c1^2, c2^2, 
                     b, a.opt, sauc, se, sp)
    names(opt$par.all) <- c("mu1", "mu2", "tau1^2", "tau2^2", 
                            "tau12", "c1^2", "c2^2", "beta", "alpha", sauc.type, 
                            "sens", "spec")
    opt$l.data <- data
    class(opt) <- "dtametasa"
  }else{
    opt<-list()
    opt$par<-c(NA,NA,NA,NA,NA,NA,NA)
    names(opt$par)<-c("mu1", "mu2", "tau1", 
                      "tau2", "rho", "beta", "c1")
    opt$sauc.ci<-c(NA,NA,NA)
    
    class(opt) <- "dtametasa"
  }
  opt
}