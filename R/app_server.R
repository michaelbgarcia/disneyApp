#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom dplyr filter
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  live_data <- reactive({
    get_data_live(parks_data)
  })

  live_data_park <- reactive({
    req(input$park_select)
    live_data() %>%
      dplyr::filter(parks_name %in% input$park_select)
  }) %>%
    bindEvent(input$park_select)

  mod_map_main_server("map_main_1", data = live_data_park)
  mod_table_main_server("table_main_1", data = live_data_park)
}
