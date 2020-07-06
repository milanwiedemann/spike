#' Rename variables
#'
#' @param data Dataset in wide format
#' @param repeated_measures List of repeated measures
#'
#' @return Dataset in wide format with renamed variables
#' @export

rename_spike_vars <- function(data, repeated_measures){


  # Rename variables in repeated_measures list

    for (i in base::seq_along(repeated_measures)) {
      base::names(data)[base::names(data) == repeated_measures[i]] <- base::paste("measure", i, sep = "_")
    }

    # Return dataframe with renamed variables
    data

}
