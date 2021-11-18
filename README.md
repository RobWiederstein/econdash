
<!-- README.md is generated from README.Rmd. Please edit that file -->

# econdash

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/RobWiederstein/econdash/workflows/R-CMD-check/badge.svg)](https://github.com/RobWiederstein/econdash/actions)
[![Codecov test
coverage](https://codecov.io/gh/RobWiederstein/econdash/branch/main/graph/badge.svg)](https://app.codecov.io/gh/RobWiederstein/econdash?branch=main)
[![License:
MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://github.com/RobWiederstein/econdash/LICENSE.md)
[![Last Commit:
today](https://img.shields.io/github/last-commit/RobWiederstein/econdash.svg)](https://github.com/RobWiederstein/econdash/)

<!-- badges: end -->

The `econdash` package centralizes US economic and financial data on a
dashboard. The data is predominately from government sources like the
Federal Reserve Economic Data (“FRED”). The purpose was to provide a
quick overview of key performance indicators that are commonly relied
upon by economists to describe the state of the economy.

Dashboards are used in many contexts to display data. A survey of
economic dashboards reveal a diversity in user interfaces, content and
usability. The `econdash` package attempts to mimic the best features of
available dashboards, simplifying the visualizations, minimizing the use
of text, and promptly updating the data. The goal is for engaged
citizens to quickly understand the state of the U.S. economy.

## Dashboards

In designing the dashboard, a number of initiatives were reviewed. Given
the prevalence of dashboards, many institutions view their use as
important in informing and shaping public opinion. Some examples are
included below:

### World Economic Forum (WEF)

Selecting individual economic metrics for a dashboard reflects the
values of a society. The challenges of measuring an economy’s success by
Gross Domestic Product (GDP) are and continue to be noted. The WEF is
reviewing different economic measures because of international concerns
over sustainable development and changing economies. The WEF stated
that:

> Despite extensive efforts to anchor alternative measures of economic
> performance, GDP growth today remains a core economic policy objective
> and is still often treated as both a necessary and sufficient marker
> of success. Yet targeting a recovery and future trajectory of GDP
> growth alone will not be sufficient to advance the holistic economic
> and societal reset that is needed today.

> An accelerated international convergence on a dashboard of core
> metrics to steer consistent, forward-looking economic and social
> policy and business decisions will be critical.

The WEF report, [Platform for Shaping the Future of the New Economy and
Society: Dashboard for a New Economy Towards a New Compass for the
Post-COVID
Recovery](https://www3.weforum.org/docs/WEF_Dashboard_for_a_New_Economy_2020.pdf),
urged the adoption of new metrics.

### World Policy Forum

-   [The Recoupling Dashboard
    2021](https://www.global-solutions-initiative.org/recoupling-dashboard/)

## Data Sources

### [CIA World Factbook](https://raw.githubusercontent.com/iancoleman/cia_world_factbook_api/master/data/factbook.json)

## Installation

You can install the released version of econdash from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("econdash")
```

## Acknowledgements:

The following `R` packages proved invaluable and the author is grateful
for their creation:

-   `golem`
-   `usethis`
-   `shiny`
-   `dashboardPlus`
-   `pkgdown`

## Code of Conduct

Please note that the econdash project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
