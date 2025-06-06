
#' @param list_cities list of cities
#' @return tibble with city name, canton, lat, lng, pollin level
#' @export


source("read_pollen_with_cache.R")

get_pollin_for_list_cities <- function(list_cities) {

  swiss_cities <- readr::read_csv("SwissCities.csv")
  swiss_cities_df <- tibble::tibble(swiss_cities)

  pollin_level_df <- tibble::tibble()

  for (city in list_cities) {

    # Get city info once
    city_info <- dplyr::filter(swiss_cities_df, city == !!city)

    lat <- city_info$lat
    lng <- city_info$lng
    cant <- city_info$admin_name

    # Get pollen data
    pollen_data <- get_pollen_forecast_with_cache(latitude = lat, longitude = lng)

    grs_pol <- dplyr::filter(pollen_data, plant == "Grass") |> dplyr::pull(index_value)
    tree_pol <- dplyr::filter(pollen_data, plant == "Tree") |> dplyr::pull(index_value)
    weed_pol <- dplyr::filter(pollen_data, plant == "Weed") |> dplyr::pull(index_value)

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


# df = get_pollin_for_list_cities(c("Geneva"))
# print(df)
