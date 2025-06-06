
#' @param list_cities list of cities
#' @return tibble with city name, canton, lat, lng, pollin level
#' @export

get_pollin_for_list_cities <- function(list_cities) {

  swiss_cities = read_csv("../SwissCities.csv")
  swiss_cities_df = tibble(swiss_cities)

  source("read_pollen_with_cache.R")

  pollin_level_df <- tibble()

  for (city in list_cities) {

    # Get city info once
    city_info <- swiss_cities_df |> filter(city == !!city)

    lat <- city_info$lat
    lng <- city_info$lng
    cant <- city_info$admin_name

    # Get pollen data
    pollen_data <- get_pollen_forecast_with_cache(latitude = lat, longitude = lng)

    grs_pol <- pollen_data |> filter(plant == "Grass") |> pull(index_value)
    tree_pol <- pollen_data |> filter(plant == "Tree") |> pull(index_value)
    weed_pol <- pollen_data |> filter(plant == "Weed") |> pull(index_value)

    # Create new row
    new_row <- tibble(
      city = city,
      canton = cant,
      lat = lat,
      lng = lng,
      grass_pollin = grs_pol,
      tree_pollin = tree_pol,
      weed_pollin = weed_pol
    )

    # Append to final dataframe
    pollin_level_df <- bind_rows(pollin_level_df, new_row)
  }

  return(pollin_level_df)
}
