#' @title Compare pollen levels between two cities
#'
#' @param city1_name Name of the first city
#' @param city2_name Name of the second city
#' @param city1_lat Latitude of the first city
#' @param city1_lon Longitude of the first city
#' @param city2_lat Latitude of the second city
#' @param city2_lon Longitude of the second city
#'
#' @return A string with the name of the city that has the least pollen
#'
#' @name compare_pollen_levels
#'
#' @examples
#' city1_name <- "Zurich"
#' city1_lat <- 47.3769
#' city1_lon <- 8.5417
#'
#' city2_name <- "Geneva"
#' city2_lat <- 46.2044
#' city2_lon <- 6.1432
#' result <- compare_pollen_levels(city1_name, city2_name, city1_lat, city1_lon, city2_lat, city2_lon)
#'
#' @export

compare_pollen_levels <- function(city1_name, city2_name, city1_lat, city1_lon, city2_lat, city2_lon) {

  df_city1 <- get_pollen_forecast_with_cache(city1_lat, city1_lon)
  df_city2 <- get_pollen_forecast_with_cache(city2_lat, city2_lon)

  # Summarize pollen levels (e.g., sum of index_value for all pollen types in each city)
  city1_pollen_total <- sum(df_city1$index_value, na.rm = TRUE)
  city2_pollen_total <- sum(df_city2$index_value, na.rm = TRUE)

  # Compare and return the city with less pollen
  if (city1_pollen_total < city2_pollen_total) {
    return(paste(city1_name, "has less pollen"))
  } else if (city1_pollen_total > city2_pollen_total) {
    return(paste(city2_name, "has less pollen"))
  } else {
    return("Both cities have the same pollen levels")
  }
}

