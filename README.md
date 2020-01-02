# MEPHAS 
<!-- MarkdownTOC -->

- [Introduction](#introduction)
- [The structure of MEPHAS web](#the-structure-of-mephas-web)
  - [Eight categories of statistics](#eight-categories-of-statistics)
- [The main functionality in each applications](#the-main-functionality-in-each-applications)
- [The help files](#the-help-files)

<!-- /MarkdownTOC -->


<a id="introduction"></a>
## Introduction

MEPHAS integrates the medical and pharmaceutical data analysis methods in order to facilitate researchers analyze or explore their data.

<a id="the-brandly-new-site-is-here"></a>
#### Please find the new site [here](https://alain003.phs.osaka-u.ac.jp/mephas/).

<a id="source-code-is-here"></a>
#### Find source code [here](https://github.com/mephas/mephas_web)

<a id="the-r-package-mephas-is-here"></a>
#### The R package `mephas` is [here](https://mephas.github.io/mephas/)

~~The old site is [here](http://www.gen-info.osaka-u.ac.jp/MEPHAS/).~~

<a id="the-structure-of-mephas-web"></a>
## The structure of MEPHAS web

<a id="eight-categories-of-statistics"></a>
### Eight categories of statistics

<a id="1-probability-distributions"></a>
#### 1.1. [Probability Distributions](https://alain003.phs.osaka-u.ac.jp/mephas_web/1_1MFScondist/)

  - Continuous Random Variable
  
    + Normal/Gaussian distribution
    + Exponential Distribution
    + Gamma Distribution
    + Beta Distribution
    + Student's t Distribution
    + Chi-square Distribution
    + F Distribution

#### 1.2. [Probability Distributions](https://alain003.phs.osaka-u.ac.jp/mephas_web/1_2MFSdisdist/)

  - Discrete Random Variable
    + Binomial Distribution
    + Poisson Distribution
       
<a id="2-t-test"></a>
#### 2. [T Test](https://alain003.phs.osaka-u.ac.jp/mephas_web/2MFSttest/)
  
  - One Sample t-Test
  
  - Two Samples t-Test
  
  - Paired Samples

<a id="3-non-parametric-tests"></a>
#### 3. [Non-parametric Tests](https://alain003.phs.osaka-u.ac.jp/mephas_web/3MFSnptest/)

  - One Sample t-Test
  
    + Wilcoxon Signed-Rank Test
    
  - Two Samples t-Test
  
    + Wilcoxon Rank-Sum Test (Mann-Whitney U Test)
    
  - Paired Samples
  
    + Wilcoxon Signed-Rank Test

<a id="4-test-for-binomial-proportions"></a>
#### 4. [Test for Binomial Proportions](https://alain003.phs.osaka-u.ac.jp/mephas_web/4MFSproptest/)

  - One Single Proportion
  
    + Exact Binomial Test
  
  - Two Independent Proportions
  
    + Chi-square Test
  
  - Over Two Independent Proportions
  
    + Chi-square Test

  - Trend in Over Two Independent Proportions
  
    + Chi-square Trend Test

<a id="5-test-for-contingency-table"></a>
#### 5. [Test for Contingency Table](https://alain003.phs.osaka-u.ac.jp/mephas_web/5MFSrctabtest/)

  - Chi-square Test (2x2 Table)

  - Fisher Exact Test (2x2 Table)
  
  - McNemar Test for Paired Data (2x2 Table)

  - Chi-square Test (2xC Table)

  - Chi-square Test (RxC Table)

  - Kappa Statistic (2xK Table)

  - Kappa Statistic (KxK Table)

  - Mantel-Haenszel Test for confounding data (2x2 table under K confounding)

  - Cochran-Mantel-Haenszel Test for confounding data (RxC table under K confounding)

<a id="6-analysis-of-variance"></a>
#### 6. [Analysis of Variance](https://alain003.phs.osaka-u.ac.jp/mephas_web/6MFSanova/)

  - One-way ANOVA

  - Multiple Comparison for One-way ANOVA
  
  - Two-way ANOVA

  - Multiple Comparison for Two-way ANOVA
  
  - Kruskal-Wallis Test 

  - Multiple Comparison for Kruskal-Wallis Test

<a id="7-regression-model"></a>
#### 7. Regression Models

  - 7.1. [Linear Regression](https://alain003.phs.osaka-u.ac.jp/mephas_web/7_1MFSlr/)
  
  - 7.2. [Logistic Regression](https://alain003.phs.osaka-u.ac.jp/mephas_web/7_2MFSlogit/)
  
  - 7.3. [Cox Regression](https://alain003.phs.osaka-u.ac.jp/mephas_web/7_3MFSsurv/)

<a id="8-principal-components"></a>
#### 8. [Principal Components](https://alain003.phs.osaka-u.ac.jp/mephas_web/8MFSpcapls/)

  - Principle Component Analysis (PCA)
  
  - Partial Least Square Regression (PLS-R)
  
  - Sparse Partial Least Square Regression (SPLS)

<a id="more-apllications-are-still-under-construction"></a>
##### More applications are still under construction.

<a id="the-main-functionality-in-each-applications"></a>
## The main functionality in each applications

<a id="1-data-preparation-manual-input-or-upload-csv-file"></a>
#### 1. Data preparation (manual input or upload CSV file)

<a id="2-parameter-input"></a>
#### 2. Parameter input

<a id="3-data-display"></a>
#### 3. Data display

<a id="3-datas-descriptive-statistics"></a>
#### 3. Descriptive statistics

<a id="4-models-results"></a>
#### 4. Model's results

<a id="5-statistical-tables-and-figures-downloadable"></a>
#### 5. Statistical tables and figures (downloadable)

<a id="the-help-files"></a>
## The help files

<a id="1-probability-distributions-1"></a>
#### 1. [Probability Distributions](https://alain003.phs.osaka-u.ac.jp/mephas/help1.html)
 
<a id="2-t-test-1"></a>
#### 2. [T Test](https://alain003.phs.osaka-u.ac.jp/mephas/help2.html/)

<a id="3-non-parametric-tests-1"></a>
#### 3. [Non-parametric Tests](https://alain003.phs.osaka-u.ac.jp/mephas/help3.html/)

<a id="4-test-for-binomial-proportions-1"></a>
#### 4. [Test for Binomial Proportions](https://alain003.phs.osaka-u.ac.jp/mephas/help4.html/)

<a id="5-test-for-contingency-table-1"></a>
#### 5. [Test for Contingency Table](https://alain003.phs.osaka-u.ac.jp/mephas/help5.html/)

<a id="6-analysis-of-variance-1"></a>
#### 6. [Analysis of Variance](https://alain003.phs.osaka-u.ac.jp/mephas/help6.html/)

<a id="7-regression-model-1"></a>
#### 7. [Regression Model](https://alain003.phs.osaka-u.ac.jp/mephas/help7.html/)

<a id="8-principal-components-1"></a>
#### 8. [Principal Components](https://alain003.phs.osaka-u.ac.jp/mephas/help8.html/)

