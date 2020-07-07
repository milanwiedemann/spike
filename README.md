
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Identify spikes in repeated measures of symptoms

<!-- badges: start -->

<!-- badges: end -->

Working together with Asha Ladwa on code for identifying (depression)
symptom spikes. This is currently work in progress and will eventually
be moved to Asha’s [GitHub](https://github.com/AshaLadwa) account.

## Installation

``` r
# install.packages("devtools")
devtools::install_github("milanwiedemann/symptomspikes")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(symptomspikes)
library(tidyverse)
#> ── Attaching packages ────────────────────────────────────────────────────────────────────────────────────────────── tidyverse 1.3.0 ──
#> ✓ ggplot2 3.3.2     ✓ purrr   0.3.4
#> ✓ tibble  3.0.1     ✓ dplyr   1.0.0
#> ✓ tidyr   1.1.0     ✓ stringr 1.4.0
#> ✓ readr   1.3.1     ✓ forcats 0.5.0
#> ── Conflicts ───────────────────────────────────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()
```

# Identify spikes

  - See the help file for more information `help(identidy_spikes)`

<!-- end list -->

``` r
# Define a list of repeated measures to be checked for depression spikes
phq_variables <- c("phq_1", "phq_2", "phq_3", "phq_4", 
                   "phq_5", "phq_6", "phq_7", "phq_8", 
                   "phq_9", "phq_10", "phq_11", "phq_12", 
                   "phq_13", "phq_14", "phq_15")

# Identify spikes and save to a new object
df_spikes_identify <- identidy_spikes(data = df_spikes,
                                      id_var = id, 
                                      repeated_measures = phq_variables, 
                                      cutoff_deterioration = 10, 
                                      cutoff_improvement = 5,
                                      min_between_spike_interval = 9, 
                                      max_spike_duration = 3)
#> Joining, by = "id"

# Print data frame with information about spikes
print(df_spikes_identify)
#> # A tibble: 3 x 26
#>      id id_spike sum_spike_byper… time_spike time_improvement value_pre_spike
#>   <dbl> <chr>               <int>      <dbl>            <dbl>           <dbl>
#> 1     1 id1_t3                  2          3                5              13
#> 2     1 id1_t12                 2         12               14              10
#> 3     4 id4_t8                  1          8               11              13
#> # … with 20 more variables: value_spike <dbl>, min_value_improvement <dbl>,
#> #   spike <lgl>, diff_time_spike <dbl>, spike_duration <dbl>, phq_1 <dbl>,
#> #   phq_2 <dbl>, phq_3 <dbl>, phq_4 <dbl>, phq_5 <dbl>, phq_6 <dbl>,
#> #   phq_7 <dbl>, phq_8 <dbl>, phq_9 <dbl>, phq_10 <dbl>, phq_11 <dbl>,
#> #   phq_12 <dbl>, phq_13 <dbl>, phq_14 <dbl>, phq_15 <dbl>
```
