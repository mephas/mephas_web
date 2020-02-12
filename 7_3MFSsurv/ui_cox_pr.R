#****************************************************************************************************************************************************cox^pred

sidebarLayout(

sidebarPanel(

h4(tags$b("Prediction")),
p("Prepare model first"),
hr(),

h4(tags$b("Step 4. Test Set Preparation")),

tabsetPanel(

tabPanel("Example data", p(br()),

 h4(tags$b("Data: Diabetes / NKI70"))

  ),

tabPanel.upload.pr(file ="newfile2", header="newheader2", col="newcol2", sep="newsep2", quote="newquote2")

),
hr(),

h4(tags$b("Step 5. If the model and new data are ready, click the blue button to generate prediction results.")),
p(br()),
actionButton("B2.1", (tags$b("Show Prediction >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
p(br()),
p(br()),
hr()


),

mainPanel(
h4(tags$b("Output 3. Prediction Results")),

#actionButton("B2.1", h4(tags$b("Click 2: Output. Prediction Results / Refresh, given model and new data are ready. ")), style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
p(br()),
tabsetPanel(
tabPanel("Prediction Table",p(br()),
DT::DTOutput("pred2")
),

tabPanel("Brier Score",p(br()),
HTML(
"
<p>Brier score is used to evaluate the accuracy of a predicted survival function at given time series.
It represents the average squared distances between the observed survival status and the predicted survival probability and is always a number between 0 and 1,
with 0 being the best possible value.<p>

<p>The Integrated Brier Score (IBS) provides an overall calculation of the model performance at all available times.<p>
"
),
numericInput("ss", HTML("Set time series: start point"), value = 1, min = 0),
numericInput("ee", HTML("Set time series:end point"), value = 10, min = 1),
numericInput("by", HTML("Set time series: sequence"), value = 1, min = 0),

p(tags$i("The default setting give time series 1,2,...10")),
p(tags$b("Brier score at given time")),

plotly::plotlyOutput("bsplot"),
DT::DTOutput("bstab")

),

tabPanel("AUC",p(br()),
HTML(
"
<p><b> Explanations  </b></p>
AUC here is time-dependent AUC, which gives AUC at given time series.
<ul>
<li>Chambless and Diao:  assumed that lp and lpnew are the predictors of a Cox proportional hazards model.
(Chambless, L. E. and G. Diao (2006). Estimation of time-dependent area under the ROC curve for long-term risk prediction. Statistics in Medicine 25, 3474–3486.)</li>

<li>Hung and Chiang: assumed that there is a one-to-one relationship between the predictor and the expected survival times conditional on the predictor.
(Hung, H. and C.-T. Chiang (2010). Estimation methods for time-dependent AUC models with survival data. Canadian Journal of Statistics 38, 8–26.)</li>

<li>Song and Zhou: in this method, the estimators remain valid even if the censoring times depend on the values of the predictors.
(Song, X. and X.-H. Zhou (2008). A semiparametric approach for the covariate specific ROC curve with survival outcome. Statistica Sinica 18, 947–965.)</li>


<li>Uno et al.: are based on inverse-probability-of-censoring weights and do not assume a specific working model for deriving the predictor lpnew.
It is assumed that there is a one-to-one relationship between the predictor and the expected survival times conditional on the predictor.
(Uno, H., T. Cai, L. Tian, and L. J. Wei (2007). Evaluating prediction rules for t-year survivors with censored regression models. Journal of the American Statistical Association 102, 527–537.)</li>
</ul>

"
),

numericInput("ss1", HTML("Set time series: start point"), value = 1, min = 0),
numericInput("ee1", HTML("Set time series: end point"), value = 10, min = 1),
numericInput("by1", HTML("Set time series sequence"), value = 1, min = 0),

tags$i("The example time series: 1, 2, 3, ...,10"),

radioButtons("auc", "Choose one AUC estimator",
  choiceNames = list(
    HTML("Chambless and Diao"),
    HTML("Hung and Chiang"),
    HTML("Song and Zhou"),
    HTML("Uno et al.")
    ),
  choiceValues = list("a", "b", "c", "d")
  ),
p(tags$b("Time dependent AUC at given time")),
plotly::plotlyOutput("aucplot"),
DT::DTOutput("auctab")

)
)


)


)
