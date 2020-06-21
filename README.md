## Introduction 

This the code repository for the paper

> Kim, S. J., Lim, J., & Won, J. H. (2018). Nonparametric Sharpe Ratio Function Estimation in Heteroscedastic Regression Models via Convex Optimization. In International Conference on Artificial Intelligence and Statistics (pp. 1495-1504).

available at [the Proceedings of Machine Learning Research
](http://proceedings.mlr.press/v84/kim18b.html).


Here we provide codes for reproducing Examples 1 and 2, and the Term structure modeling in the paper.

## Requirements

The codes are written ins MATLAB and R. MATLAB version R2018b or higher is required, and R version 3.6 or higher is needed.

For MATLAB, the following toolboxes must be installed and on the search path:

* [CVX](http://cvxr.com)  (Version 2.1, Build 1127 (95903bf)                  Sat Dec 15 18:52:07 2018)
* [fdaM by J. O. Ramsey](http://www.psych.mcgill.ca/misc/fda/downloads/FDAfuns/Matlab/)  (Current version dated 2017-08-08 10:16)

For R, the following is the tested `sessionInfo()` that also reveals required packages and versions for smooth execution:

```
> sessionInfo()
R version 3.6.3 (2020-02-29)
Platform: x86_64-pc-linux-gnu (64-bit)
Running under: Ubuntu 16.04.6 LTS

Matrix products: default
BLAS:   /usr/lib/openblas-base/libblas.so.3
LAPACK: /usr/lib/libopenblasp-r0.2.18.so

locale:
 [1] LC_CTYPE=ko_KR.UTF-8       LC_NUMERIC=C
 [3] LC_TIME=ko_KR.UTF-8        LC_COLLATE=ko_KR.UTF-8
 [5] LC_MONETARY=ko_KR.UTF-8    LC_MESSAGES=ko_KR.UTF-8
 [7] LC_PAPER=ko_KR.UTF-8       LC_NAME=C
 [9] LC_ADDRESS=C               LC_TELEPHONE=C
[11] LC_MEASUREMENT=ko_KR.UTF-8 LC_IDENTIFICATION=C

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base

other attached packages:
[1] knitr_1.28     tidyr_1.1.0    dplyr_0.8.5    R.matlab_3.6.2 ggplot2_3.3.0
[6] locpol_0.7-0

loaded via a namespace (and not attached):
 [1] Rcpp_1.0.4.6      magrittr_1.5      tidyselect_1.1.0  munsell_0.5.0
 [5] colorspace_1.4-1  R6_2.4.1          rlang_0.4.6       tools_3.6.3
 [9] grid_3.6.3        gtable_0.3.0      xfun_0.14         R.oo_1.23.0
[13] withr_2.2.0       ellipsis_0.3.0    assertthat_0.2.1  tibble_3.0.1
[17] lifecycle_0.2.0   crayon_1.3.4      purrr_0.3.4       vctrs_0.3.1
[21] R.utils_2.9.2     glue_1.4.1        compiler_3.6.3    pillar_1.4.3
[25] scales_1.1.0      R.methodsS3_1.8.0 pkgconfig_2.0.3
```

## Directory structure

The root directory contains the following key .m files that implement the method of the paper.

* `joint_Bernstein.m`: main implementation of the convex optimization method for joint estimation of the Sharpe ratio and the nuisance variance function.

* `joint_Bernstein_boot.m`: a bootstrapped version of `joint_Bernstein.m`.

* `joint_Bernstein_example.m`: a simple example code for demonstrating how to use `joint_Bernstein.m`.

There are three subdirectories:

* `Example1`: codes for generating plots and tables for Example 1 of the paper.

* `Example2`: codes for generating plots and tables for Example 2 of the paper.

* `Tbill`: codes for generating plots for the "Term structure modeling" section of the paper, which analyzed the 1735 weekly observations of the yields of the three-month US Treasury Bill from the secondary market rates, taken from January 5, 1962 to March 31, 1995. 

In order the run the examples, both `joint_Bernstein.m` and `joint_Bernstein_boot.m` must be in the MATLAB search path.


