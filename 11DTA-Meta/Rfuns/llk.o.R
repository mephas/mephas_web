##******************************************************************************
##
## LIKELIHOOD OF THE OBSERVED (NEGATIVE)
##
##******************************************************************************


.llk.o <- function(
  par,
  y1, y2, v1, v2,
  n, p,
  alpha.interval,
  alpha.root.extendInt,
  show.warn.message
){

  u1 <- par[1]
  u2 <- par[2]
  t1 <- par[3]
  t2 <- par[4]
  r  <- par[5]
  b  <- par[6]
  c1 <- par[7]  ## CAN BE EITHER PAR OR GIVEN VALUE

  t11 <- t1^2
  t22 <- t2^2
  t12 <- t1*t2*r

  c11 <- c1^2
  c22 <- 1-c11
  c2  <- sqrt(c22)

  ldor     <- c1*y1 + c2*y2
  se.ldor2 <- c11*v1+c22*v2
  se.ldor  <- sqrt(se.ldor2)

  u.ldor   <- c1*u1 + c2*u2
  t.ldor   <- c11*t11 + c22*t22 + 2*c1*c2*t12

  t        <- ldor/se.ldor

  ##
  ## FUNCTOIN b(Sigma) ----
  ##

  f.b <- function(a){

    if (!show.warn.message) sq <- suppressWarnings(sqrt(1 + b^2 * (1 + t.ldor/se.ldor2))) else sq <- sqrt(1 + b^2 * (1 + t.ldor/se.ldor2))

    pnorm( (a + b * u.ldor/se.ldor) / sq )

  }


  ##
  ## FIND THE ROOT OF a = a.opt ----
  ##

  a.p <- function(a) {sum(1/f.b(a), na.rm = TRUE) - n/p}

  a.opt.try <- try(uniroot(a.p, alpha.interval, extendInt=alpha.root.extendInt), silent = show.warn.message) 

  a.opt <- a.opt.try$root


  ##
  ##  LOGLIKELIHOOD-1 OF y|Sigma ----
  ##

  det.vec <- (v1+t11)*(v2+t22)-t12^2

  if (!show.warn.message) log.det.vec <- suppressWarnings(log(det.vec)) else log.det.vec <- log(det.vec)

  f.l1  <- ((y1-u1)^2*(v2+t22) - 2*(y2-u2)*(y1-u1)*t12 + (y2-u2)^2*(v1+t11)) / det.vec + log.det.vec

  s.l1  <- -0.5*sum(f.l1, na.rm = TRUE)


  ##
  ##  LOGLIKELIHOOD-2 OF a(a.opt) ----
  ##


  f.l2 <- pnorm(a.opt + b * t)

  s.l2 <- sum( log(f.l2), na.rm = TRUE )


  ##
  ##  LOGLIKELIHOOD-3 OF b(a.opt) ----
  ##

  f.l3 <- f.b(a.opt)

  s.l3 <- sum( log(f.l3), na.rm = TRUE )


  ##
  ##  FINAL LOGLIKELIHOOD ----
  ##

  return(-(s.l1 + s.l2 - s.l3)) ## NEGATIVE

}
