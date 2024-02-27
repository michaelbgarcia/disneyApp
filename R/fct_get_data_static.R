#' get_data_static
#'
#' @description Get static data from themeparkr and transform. This should
#' be stored with the app.
#'
#' @return tibbles
#'
#' @noRd
#' @importFrom themeparkr tpr_destinations tpr_entity_children tpr_entity
#' @importFrom dplyr filter pull select left_join
#' @importFrom purrr map list_rbind

get_data_parks <- function() {
  print("Fetching parks data")
  themeparkr::tpr_destinations() %>%
    dplyr::select(parks_id, parks_name) %>%
    dplyr::mutate(
      parks_name = dplyr::recode(
        parks_name,
        "Disney's Animal Kingdom Theme Park" = "Animal Kingdom",
        "Disney's Hollywood Studios" = "Hollywood Studios",
        "EPCOT" = "Epcot",
        "Magic Kingdom Park" = "Magic Kingdom"
      )
    )
}

get_data_static <- function() {
  print("Fetching static data")
  themeparkr::tpr_destinations() %>%
    dplyr::filter(parks_name %in% c("Magic Kingdom Park", "EPCOT",
                                    "Disney's Hollywood Studios",
                                    "Disney's Animal Kingdom Theme Park")) %>%
    dplyr::pull(parks_id) %>%
    purrr::map(.f = tpr_entity_children) %>%
    purrr::list_rbind() %>%
    dplyr::filter(entityType == "ATTRACTION") %>%
    dplyr::pull(id) %>%
    purrr::map(.f = tpr_entity) %>%
    purrr::list_rbind() %>%
    dplyr::filter(attractionType == "RIDE") %>%
    dplyr::left_join(parks_ref, by = c("parkId" = "parks_id"))

}
