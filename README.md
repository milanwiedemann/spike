
<!-- README.md is generated from README.Rmd. Please edit that file -->

# spikes

<!-- badges: start -->

<!-- badges: end -->

working on some code for identifying symptom spikes with Asha

## Installation

``` r
# install.packages("devtools")
devtools::install_github("milanwiedemann/spike")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(spike)
```

``` r
# create list with variables
phq_variables <- c("phq_1", "phq_2", "phq_3", "phq_4", 
                   "phq_5", "phq_6", "phq_7", "phq_8", 
                   "phq_9", "phq_10", "phq_11", "phq_12", 
                   "phq_13", "phq_14", "phq_15")

# identify spikes
identidy_spikes(data = df_spikes,
                id_var = id, 
                # list of repeated measures
                repeated_measures = phq_variables, 
                spike_cutoff = 10, 
                # Minimum number of sessions between multiple spikes experiences by the same participant
                min_between_spike_interval = 9, 
                # Maximum number of repeated measures between symptom deterioration and improvement 
                # that would still be considered a spike
                max_spike_interval = 10
                )
#> Joining, by = "id"
#> Joining, by = "id"
#> Joining, by = "id"
#> # A tibble: 7 x 25
#>      id id_spike sum_spike_byper… time_spike time_return value_pre_spike
#>   <dbl> <chr>               <int>      <dbl>       <dbl>           <dbl>
#> 1     1 id1_t3                  2          3           7              13
#> 2     1 id1_t12                 2         12          15              10
#> 3     2 <NA>                   NA         NA          NA              NA
#> 4     3 <NA>                   NA         NA          NA              NA
#> 5     4 <NA>                   NA         NA          NA              NA
#> 6     5 id5_t2                  1          2          11              10
#> 7     6 <NA>                   NA         NA          NA              NA
#> # … with 19 more variables: value_spike <dbl>, spike <lgl>,
#> #   diff_time_spike <dbl>, interval_spike <dbl>, phq_1 <dbl>, phq_2 <dbl>,
#> #   phq_3 <dbl>, phq_4 <dbl>, phq_5 <dbl>, phq_6 <dbl>, phq_7 <dbl>,
#> #   phq_8 <dbl>, phq_9 <dbl>, phq_10 <dbl>, phq_11 <dbl>, phq_12 <dbl>,
#> #   phq_13 <dbl>, phq_14 <dbl>, phq_15 <dbl>
```
