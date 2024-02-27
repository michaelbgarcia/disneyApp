#' map_main UI Function
#'
#' @description A shiny Module for displaying leaflet map.
#'
#' @param id,input,output,session,data Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @importFrom bslib card card_header
#' @importFrom leaflet leaflet addTiles addCircleMarkers leafletOutput renderLeaflet
mod_map_main_ui <- function(id){
  ns <- NS(id)
  card(
    card_header("Ride Locations"),
    leafletOutput(ns("map"))
  )
}

#' map_main Server Functions
#'
#' @noRd
mod_map_main_server <- function(id, data){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    output$map <- renderLeaflet({
      leaflet::leaflet(data = data()) %>%
        leaflet::addTiles() %>%
        leaflet::addCircleMarkers(
          lat = ~latitude,
          lng = ~longitude,
          label = ~map_data_labels(name),
          color = ~status_cols,
          stroke = TRUE, fillOpacity = 0.75
        )
    })

  })
}

## To be copied in the UI
# mod_map_main_ui("map_main_1")

## To be copied in the server
# mod_map_main_server("map_main_1")
