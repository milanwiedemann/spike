
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Identify spikes in repeated measures of symptoms

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

# Test rename variables function

``` r

# create list with variables
phq_variables <- c("phq_1", "phq_2", "phq_3", "phq_4", 
                   "phq_5", "phq_6", "phq_7", "phq_8", 
                   "phq_9", "phq_10", "phq_11", "phq_12", 
                   "phq_13", "phq_14", "phq_15")


rename_spike_vars(df_spikes, phq_variables)
#>   id measure_1 measure_2 measure_3 measure_4 measure_5 measure_6 measure_7
#> 1  1        10        11        24        25        14        12        11
#> 2  2        20        21        21        20        22        21        20
#> 3  3        10        11        10         9         9         9        10
#> 4  4        18        19        17        20        19        20        17
#> 5  5         5        15        16        17        15        12        11
#> 6  6        30        29        28        29        33        32        30
#>   measure_8 measure_9 measure_10 measure_11 measure_12 measure_13 measure_14
#> 1        10        10         11         10         20         21         10
#> 2        22        23         24         22         20         22         21
#> 3        11        12         10         10         11         11         12
#> 4        30        31         30         22         21         20         22
#> 5        17        16         10          9         10         10         11
#> 6        31        29         29         28         30         31         30
#>   measure_15 spike
#> 1          9     1
#> 2         20     0
#> 3         10     0
#> 4         20     1
#> 5         10     1
#> 6         29     0
```

``` r
# create list with variables
phq_variables_bad <- c("phqone", "ph2q", "phq3", "phq_four", 
                       "PQH_5", "pHq_6", "phq_7", "phQ8", 
                       "phnine", "phq_100", "phq_1q1", 
                       "phq12", "phq_13", "phq_t14", "phq_s15")

rename_spike_vars(df_spikes_bad, phq_variables_bad)
#>   id measure_1 measure_2 measure_3 measure_4 measure_5 measure_6 measure_7
#> 1  1        10        11        24        25        14        12        11
#> 2  2        20        21        21        20        22        21        20
#> 3  3        10        11        10         9         9         9        10
#> 4  4        18        19        17        20        19        20        17
#> 5  5         5        15        16        17        15        12        11
#> 6  6        30        29        28        29        33        32        30
#>   measure_8 measure_9 measure_10 measure_11 measure_12 measure_13 measure_14
#> 1        10        10         11         10         20         21         10
#> 2        22        23         24         22         20         22         21
#> 3        11        12         10         10         11         11         12
#> 4        30        31         30         22         21         20         22
#> 5        17        16         10          9         10         10         11
#> 6        31        29         29         28         30         31         30
#>   measure_15 spike
#> 1          9     1
#> 2         20     0
#> 3         10     0
#> 4         20     1
#> 5         10     1
#> 6         29     0
```

# Test with good variable names

``` r

# identify spikes
identidy_spikes(data = df_spikes,
                id_var = id, 
                # list of repeated measures
                repeated_measures = phq_variables, 
                cutoff_deterioration = 10, 
                cutoff_improvement = 5,
                # Minimum number of sessions between multiple spikes experiences by the same participant
                min_between_spike_interval = 9, 
                # Maximum number of repeated measures between symptom deterioration and improvement 
                # that would still be considered a spike
                max_spike_duration = 10
                ) %>% 
  print(n = 100)
#> Joining, by = "id"
#> # A tibble: 4 x 26
#>      id id_spike sum_spike_byper… time_spike time_improvement value_pre_spike
#>   <dbl> <chr>               <int>      <dbl>            <dbl>           <dbl>
#> 1     1 id1_t3                  2          3                5              13
#> 2     1 id1_t12                 2         12               14              10
#> 3     4 id4_t8                  1          8               11              13
#> 4     5 id5_t2                  1          2               10              10
#> # … with 20 more variables: value_spike <dbl>, min_value_improvement <dbl>,
#> #   spike <lgl>, diff_time_spike <dbl>, interval_spike <dbl>, phq_1 <dbl>,
#> #   phq_2 <dbl>, phq_3 <dbl>, phq_4 <dbl>, phq_5 <dbl>, phq_6 <dbl>,
#> #   phq_7 <dbl>, phq_8 <dbl>, phq_9 <dbl>, phq_10 <dbl>, phq_11 <dbl>,
#> #   phq_12 <dbl>, phq_13 <dbl>, phq_14 <dbl>, phq_15 <dbl>
```

# Test with bad variable names

``` r

# identify spikes
identidy_spikes(data = df_spikes_bad,
                id_var = id, 
                # list of repeated measures
                repeated_measures = phq_variables_bad, 
                cutoff_deterioration = 10, 
                cutoff_improvement = 5,
                # Minimum number of sessions between multiple spikes experiences by the same participant
                min_between_spike_interval = 9, 
                # Maximum number of repeated measures between symptom deterioration and improvement 
                # that would still be considered a spike
                max_spike_duration = 10
                ) %>% 
  print(n = 100)
#> Joining, by = "id"
#> # A tibble: 4 x 26
#>      id id_spike sum_spike_byper… time_spike time_improvement value_pre_spike
#>   <dbl> <chr>               <int>      <dbl>            <dbl>           <dbl>
#> 1     1 id1_t3                  2          3                5              13
#> 2     1 id1_t12                 2         12               14              10
#> 3     4 id4_t8                  1          8               11              13
#> 4     5 id5_t2                  1          2               10              10
#> # … with 20 more variables: value_spike <dbl>, min_value_improvement <dbl>,
#> #   spike <lgl>, diff_time_spike <dbl>, interval_spike <dbl>, phqone <dbl>,
#> #   ph2q <dbl>, phq3 <dbl>, phq_four <dbl>, PQH_5 <dbl>, pHq_6 <dbl>,
#> #   phq_7 <dbl>, phQ8 <dbl>, phnine <dbl>, phq_100 <dbl>, phq_1q1 <dbl>,
#> #   phq12 <dbl>, phq_13 <dbl>, phq_t14 <dbl>, phq_s15 <dbl>
```

# TODOs

  - add references
  - decide which direction to go to with this
