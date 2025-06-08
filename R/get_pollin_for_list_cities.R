#' @title Get data pollen of a given city
#'
#' @param list_cities list of cities in a string form
#' @param PATH path of the cities file
#'
#' @return A tibble with city name, canton, lat, lng, pollin level
#'
#' @name get_pollin_for_list_cities
#'
#' @description
#' Retrieve information about the pollen of given cities
#'
#' @examples
#'
#' tibble_test <- get_pollin_for_list_cities(c("Lugano", "Geneva"))
#'
#' @export


get_pollin_for_list_cities <- function(list_cities, PATH="SwissCities.csv") {

  swiss_cities <- readr::read_csv(PATH, show_col_types = FALSE)
  swiss_cities_df <- tibble::tibble(swiss_cities)

  pollin_level_df <- tibble::tibble()

  for (city in list_cities) {

    # Get city info using city_ascii column
    city_info <- dplyr::filter(swiss_cities_df, city_ascii == !!city)
    
    # Check if city was found
    if(nrow(city_info) == 0) {
      cat("Warning: City", city, "not found in database. Skipping...\n")
      next
    }

    lat <- city_info$lat[1]
    lng <- city_info$lng[1]
    cant <- city_info$admin_name[1]
    
    # Check if coordinates are valid
    if(is.na(lat) || is.na(lng)) {
      cat("Warning: Invalid coordinates for", city, ". Skipping...\n")
      next
    }

    # Get pollen data
    pollen_data <- get_pollen_forecast_with_cache(latitude = lat, longitude = lng)

    grs_pol <- dplyr::filter(pollen_data, plant == "Grass") |> dplyr::pull(index_value)
    tree_pol <- dplyr::filter(pollen_data, plant == "Tree") |> dplyr::pull(index_value)
    weed_pol <- dplyr::filter(pollen_data, plant == "Weed") |> dplyr::pull(index_value)

    # Handle empty results
    if(length(grs_pol) == 0) grs_pol <- NA
    if(length(tree_pol) == 0) tree_pol <- NA
    if(length(weed_pol) == 0) weed_pol <- NA

    # Create new row
    new_row <- tibble::tibble(
      city = city,
      canton = cant,
      lat = lat,
      lng = lng,
      grass_pollin = grs_pol,
      tree_pollin = tree_pol,
      weed_pollin = weed_pol
    )

    # Append to final dataframe
    pollin_level_df <- dplyr::bind_rows(pollin_level_df, new_row)
  }

  return(pollin_level_df)
}
