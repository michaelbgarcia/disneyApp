#' table_main UI Function
#'
#' @description A shiny Module for displaying live data in a reactable.
#'
#' @param id,input,output,session,data Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @importFrom bslib card card_header
#' @importFrom reactable reactable reactableOutput renderReactable colDef
#' @importFrom reactablefmtr fivethirtyeight merge_column pill_buttons
mod_table_main_ui <- function(id){
  ns <- NS(id)
  card(
    card_header("Ride Detail"),
    reactableOutput(ns("table"))
  )
}

#' table_main Server Functions
#'
#' @noRd
mod_table_main_server <- function(id, data){
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    output$table <- renderReactable({
      reactable::reactable(
        data = data(),
        theme = reactablefmtr::fivethirtyeight(centered = TRUE, header_font_size = 11),
        pagination = TRUE,
        showSortIcon = FALSE,
        highlight = TRUE,
        compact = TRUE,
        selection = "single",
        onClick = "select",
        defaultSelected = 1,
        columns = list(
          id = colDef(show = FALSE),
          parks_name = colDef(show = FALSE),
          latitude = colDef(show = FALSE),
          longitude = colDef(show = FALSE),
          name = colDef(
            align = "left",
            cell = reactablefmtr::merge_column(data(), "parks_name", merged_position = "below"),
          ),
          status = colDef(
            maxWidth = 150,
            name = "Status",
            align = "center",
            cell = reactablefmtr::pill_buttons(data(), color_ref = "status_cols", opacity = 0.7),
          ),
          status_cols = colDef(show = FALSE),
          wait_time = colDef(
            maxWidth = 50,
            name = "Wait (min.)",
            align = "center"
          ),
          ll_time = colDef(
            name = "Next LL Time"
          ),
          lastUpdated = colDef(
            name = "Last Updated"
          )
        )
      )
    })
  })
}

## To be copied in the UI
# mod_table_main_ui("table_main_1")

## To be copied in the server
# mod_table_main_server("table_main_1")
