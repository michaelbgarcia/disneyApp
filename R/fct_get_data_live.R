#' get_data_live
#'
#' @description Get live data from themeparkr and transform.
#'
#' @return tibbles
#'
#' @noRd
#' @importFrom themeparkr tpr_destinations tpr_entity_children tpr_entity tpr_entity_live
#' @importFrom dplyr filter mutate case_match select arrange desc across all_of
#' @importFrom purrr map list_rbind map_int map_chr
#' @importFrom lubridate ymd_hms
get_data_live <- function(static_data, column = "parkId") {
  static_data %>%
    dplyr::left_join(
      static_data[[column]] %>%
        unique() %>%
        purrr::map(.f = themeparkr::tpr_entity_live) %>%
        purrr::list_rbind(),
      by = "id"
    ) %>%
    dplyr::filter(status %in% c("OPERATING", "DOWN")) %>%
    dplyr::mutate(
      status_cols = dplyr::case_match(status,
                               "OPERATING" ~ "blue",
                               "DOWN" ~ "orange"
      )
    ) %>%
    dplyr::mutate(
      wait_time = queue %>%
        purrr::map_int(purrr::pluck, "STANDBY", "waitTime", .default = NA_integer_),
      ll_time = queue %>%
        purrr::map_chr(purrr::pluck, "RETURN_TIME", "returnStart", .default = NA_character_)
    ) %>%
    # dplyr::left_join(parks_ref, by = c("parkId" = "parks_id")) %>%
    dplyr::select(parks_name, id, name, status, status_cols, ll_time,wait_time,lastUpdated, latitude, longitude) %>%
    dplyr::mutate(
      dplyr::across(
        .cols = dplyr::all_of(c("ll_time", "lastUpdated")),
        .fns = lubridate::ymd_hms
      )
    ) %>%
    dplyr::arrange(dplyr::desc(wait_time))
}
