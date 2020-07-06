#' Identify symptom spikes
#'
#' @param data Data in wide format with one row for each participant and one column for each repeated measure
#' @param id_var Variable that identifies each participant
#' @param repeated_measures List of repeated measures
#' @param spike_cutoff Minimum number of symptom decrease that would be considered as a spike.
#' @param tx_phases NOT SUPPORTED AT THE MOMENT. List specifying treatment phases.
#' @param min_between_spike_interval Minimum number of sessions between multiple spikes experiences by the same participant
#' @param max_spike_interval Maximum number of repeated measures between symptom deterioration and improvement that would still be considered a spike.
#'
#' @return
#' @export
identidy_spikes <- function(data, id_var, repeated_measures, spike_cutoff, tx_phases, min_between_spike_interval, max_spike_interval) {

  id_var <- rlang::enquo(id_var)

  # Select all ids for later
  all_ids <- data %>%
    dplyr::select(!!id_var)

  # Select data for identifying spikes
  # Do this by treatment phase as specified in repeated_measures list
  data_select <- data %>%
    dplyr::select(!!id_var, repeated_measures)

  # Create long data set for further calculations
  data_long <- tidyr::pivot_longer(data = data_select, cols = dplyr::all_of(repeated_measures), names_to = "measure_time", values_to = "value") %>%
    tidyr::separate(col = measure_time, into = c("measure", "time")) %>%
    dplyr::mutate(time = as.numeric(time))

  # Create data with all information about spikes
  data_spikes <- data_long %>%
    # Group by ID so all calculations are performed for each ID
    dplyr::group_by(!!id_var) %>%
    dplyr::mutate(value_lag = dplyr::lag(value),
           diff = value - value_lag,
           spike = diff >= spike_cutoff,
           time_spike = time * spike,
           time_spike = dplyr::na_if(time_spike, 0),
           value_spike = spike * value,
           value_spike = dplyr::na_if(value_spike, 0),
           value_return = value_spike - value_lag,
           sum_spike = sum(spike, na.rm = TRUE)) %>%
    # Fill missing values (down) for further calculations
    tidyr::fill(time_spike, .direction = "down") %>%
    tidyr::fill(value_spike, .direction = "down") %>%
    tidyr::fill(value_return, .direction = "down") %>%
    # Drop observations with no sx deterioration and all time points before the sx deterioration
    tidyr::drop_na(time_spike) %>%
    # Count number of all spikes per ID
    dplyr::mutate(num_spike = cumsum(ifelse(time_spike != dplyr::lag(time_spike) | is.na(dplyr::lag(time_spike)), 1, 0))) %>%
    # Add number of spike to grouping variables so further calculations are performed within potential spike and ID
    dplyr::group_by(num_spike, .add = TRUE) %>%
    # Check if the return value is reached at some point later
    dplyr::mutate(return = value <= value_return,
                  time_return = which(return == TRUE)[1] + time_spike) %>%
    # Only keep spikes that reach return value
    tidyr::drop_na(time_return) %>%
    dplyr::ungroup()

  # Anything that involves selection criteria around changes in symptom scores needs to happen here
  # Using the data_spikes as this contains all information


  # Now create smaller data
  data_spikes_filter <- data_spikes %>%
    dplyr::ungroup() %>%
    dplyr::select(!!id_var, sum_spike_byperson = sum_spike, time_spike, time_return, value_pre_spike = value_return, value_spike) %>%
    dplyr::distinct() %>%
    dplyr::mutate(spike = TRUE,
           id_spike = paste0("id", !!id_var, "_t", time_spike)) %>%
    dplyr::select(!!id_var, id_spike, dplyr::everything()) %>%
    dplyr::group_by(!!id_var) %>%
    dplyr::mutate(diff_time_spike = time_spike - dplyr::lag(time_spike),
           interval_spike = time_return - time_spike) %>%
    dplyr::filter(diff_time_spike >= min_between_spike_interval | is.na(diff_time_spike) == TRUE) %>%
    dplyr::filter(interval_spike <= max_spike_interval) %>%
    dplyr::ungroup()


# Get all ids without spikes
  nospike_ids <- all_ids %>%
    dplyr::anti_join(data_spikes_filter) %>%
    dplyr::select(!!id_var)

  # join with spike variables only
  data__spike_return <- data_spikes_filter %>%
    dplyr::full_join(nospike_ids) %>%
    tidyr::replace_na(list(spike = FALSE)) %>%
    dplyr::arrange(!!id_var)

  data__spike_return %>%
    dplyr::left_join(data_select)



}

