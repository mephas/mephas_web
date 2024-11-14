### Introduction of _CSTE_ (ver 1.0.0)

_CSTE_ provides a uniform statistical inferential tool for estimating individualized treatment rule.

_CSTE_ estimates differences of average outcomes between different treatment groups conditional on patients characteristics and provides the corresponding simultaneous confidence bands. Based on the CSTE curve and the simultaneous confidence bands, one can decide the subgroups of patients that benefit from each treatment and then make individualized treatment selections.

**The current _CSTE_ can analyze the following types of datasets:**

*   Datasets with binary outcomes, 2-arm treatments, and single or multiple (even high-dimensional) covariates.[\[1-2\]](#1)
    
*   Datasets with right censored time-to-event outcomes, multi-arm treatments, and a single covariate of the biomarker.[\[3-4\]](#4)
    

_CSTE_ will consider more types of datasets in the future.

### R package

CSTE: Covariate Specific Treatment Effect (CSTE) Curve ([https://CRAN.R-project.org/package=CSTE](https://CRAN.R-project.org/package=CSTE))

--------

#### References

\[1\] Han K, Zhou X, Liu B. CSTE curve for selection of the optimal treatment when outcome is binary. SCIENTIA SINICA Mathematica. 2017;47(4):497–514.

\[2\] Guo W, Zhou XH, Ma S. Estimation of optimal individualized treatment rules using a covariate-specific treatment effect curve with high-dimensional covariates. Journal of the American Statistical Association. 2021;116(533):309–21. [https://doi.org/10.1080/01621459.2020.1865167](https://doi.org/10.1080/01621459.2020.1865167)

\[3\] Zhou XH, Ma Y. BATE curve in assessment of clinical utility of predictive biomarkers. Science China Mathematics. 2012 Aug 18;55(8):1529–52. [http://link.springer.com/10.1007/s11425-012-4473-0](http://link.springer.com/10.1007/s11425-012-4473-0)

\[4\] Ma Y, Zhou XH. Treatment selection in a randomized clinical trial via covariate-specific treatment effect curves. Statistical Methods in Medical Research. 2017 Feb;26(1):124–41. [http://journals.sagepub.com/doi/10.1177/0962280214541724](http://journals.sagepub.com/doi/10.1177/0962280214541724)

-----

#### Contact

yzhou\_at\_pku.edu.cn

-----

<h4 id="release-history">Release history</h4>
<style type="text/css">
.tg  {border-collapse:collapse;border-spacing:0;}
.tg td{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
  overflow:hidden;padding:10px 5px;word-break:normal;}
.tg th{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
  font-weight:normal;overflow:hidden;padding:10px 5px;word-break:normal;}
.tg .tg-0pky{border-color:inherit;text-align:left;vertical-align:top}
</style>
<table class="tg">
<thead>
  <tr>
    <th class="tg-0pky">Date</th>
    <th class="tg-0pky">Version</th>
    <th class="tg-0pky">Details</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-0pky">2023-09-30 </td>
    <td class="tg-0pky">0.9.0</td>
    <td class="tg-0pky">First release</td>
  </tr>
  <tr>
    <td class="tg-0pky">2024-05-02</td>
    <td class="tg-0pky">1.0.0</td>
    <td class="tg-0pky">Update</td>
  </tr>
</tbody>
</table>

