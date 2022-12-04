data=read.csv("anti-ccp.csv")

library(lme4)
###

GLMMmodel <- function(data){
  
  data$n1 <- data$TP+data$FN 
  data$n0 <- data$FP+data$TN 
  data$true1 <- data$TP 
  data$true0 <- data$TN 
  data$recordid <- 1:nrow(data)
  
  Y = reshape(data, 
              direction="long", 
              varying=list(c("n1", "n0"), 
                           c("true1", "true0")), 
              timevar="sens", 
              times=c(1,0), 
              v.names=c("n","true"))
  Y = Y[order(Y$id),] 
  Y$spec<- 1-Y$sens
  
  fit <- glmer(formula=cbind(true, n - true) ~ 0 + sens + spec + (0+sens + spec|id), 
               data=Y, family=binomial, nAGQ=1, verbose=0)
  summary(fit)
  
  
}

fit.glmm <- GLMMmodel(data)

SAUC(par)

lsens = fit.glmm$coeff[1,1] 
lspec = fit.glmm$coeff[2,1] 
se.lsens = fit.glmm$coeff[1,2] 
se.lspec = fit.glmm$coeff[2,2]


Sens = c(lsens, lsens-qnorm(0.975)*se.lsens, lsens+qnorm(0.975)*se.lsens) 
Spec = c(lspec, lspec-qnorm(0.975)*se.lspec, lspec+qnorm(0.975)*se.lspec) 


logit_sesp = rbind.data.frame(
  Sens,Spec
)
colnames(logit_sesp) <- c("Estimate", "Lower.CI", "Upper.CI")
rownames(logit_sesp) <- c("Sens", "Spec")



sesp <- rbind.data.frame(
  plogis(Sens),plogis(Spec)
  )

library(mada)
fit.reitsma <- reitsma(data, method = "ml")

par2 <- c(fit.reitsma$coeff[1], -fit.reitsma$coeff[2], 
          sqrt(fit.reitsma$Psi[1,1]), sqrt(fit.reitsma$Psi[2,2]), -fit.reitsma$Psi[1,2]/sqrt(fit.reitsma$Psi[1,1]*fit.reitsma$Psi[2,2]))
  

plot(NULL, xlim=c(0,1), ylim=c(0,1), xlab="FPR", ylab="TPR")

SROC(par, addon = TRUE)
SAUC(par)
SROC(par2, addon = TRUE)
SAUC(par2)

