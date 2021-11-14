
<!-- README.md is generated from README.Rmd. Please edit that file -->

# econdash

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/RobWiederstein/econdash/workflows/R-CMD-check/badge.svg)](https://github.com/RobWiederstein/econdash/actions)
<!-- badges: end -->

The goal of econdash is to …

## Dashboards

Selecting individual economic metrics for a dashboard reflects the
values of a society. The challenges of measuring an economy’s success by
Gross Domestic Product (GDP) are and continue to be noted. The World
Economic Forum (WEF) is reviewing different economic measures because of
international concerns over sustainable development and changing
economies. The WEF stated that:

> Despite extensive efforts to anchor alternative measures of economic
> performance, GDP growth today remains a core economic policy objective
> and is still often treated as both a necessary and sufficient marker
> of success. Yet targeting a recovery and future trajectory of GDP
> growth alone will not be sufficient to advance the holistic economic
> and societal reset that is needed today.

> . . .

> \\\[A\\\]n accelerated international convergence on a dashboard of
> core metrics to steer consistent, forward-looking economic and social
> policy and business decisions will be critical.

-   [Dashboard for the New Economy]()

## Installation

You can install the released version of econdash from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("econdash")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(econdash)
## basic example code
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

``` r
summary(cars)
#>      speed           dist       
#>  Min.   : 4.0   Min.   :  2.00  
#>  1st Qu.:12.0   1st Qu.: 26.00  
#>  Median :15.0   Median : 36.00  
#>  Mean   :15.4   Mean   : 42.98  
#>  3rd Qu.:19.0   3rd Qu.: 56.00  
#>  Max.   :25.0   Max.   :120.00
```

You’ll still need to render `README.Rmd` regularly, to keep `README.md`
up-to-date. `devtools::build_readme()` is handy for this. You could also
use GitHub Actions to re-render `README.Rmd` every time you push. An
example workflow can be found here:
<https://github.com/r-lib/actions/tree/master/examples>.

You can also embed plots, for example:

<img src="man/figures/README-pressure-1.png" width="100%" />

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
