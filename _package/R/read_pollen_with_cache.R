#' @title Read data from the API (no caching)
#'
#' @param latitude Latitude of the location
#' @param longitude Longitude of the location
#'
#' @return A data.frame with pollen forecast data
#'
#' @name get_pollen_forecast_with_cache
#'
#' @description
#' Fetches pollen forecast data from the API for the given location.
#'
#' @examples
#' latitude <- 47.3769
#' longitude <- 8.5417
#'
#' df_test <- get_pollen_forecast_with_cache(latitude, longitude)
#'
#' @export

get_pollen_forecast_with_cache <- function(latitude, longitude) {
  # Build URL
  url <- paste0(
    "https://pollen.googleapis.com/v1/forecast:lookup?",
    "key=AIzaSyABklcoTHFHA6Io2jCAZjHGUc4jphZB4RM",
    "&location.latitude=", latitude,
    "&location.longitude=", longitude,
    "&days=1"
  )

  # Try to request and parse API
  result <- tryCatch({
    response <- httr2::request(url) |> httr2::req_perform()
    content <- httr2::resp_body_json(response)

    if (is.null(content$dailyInfo[[1]]$pollenTypeInfo)) {
      df <- data.frame()
    } else {
      pollen_info <- content$dailyInfo[[1]]$pollenTypeInfo
      df <- do.call(rbind, lapply(pollen_info, function(x) {
        data.frame(
          plant = if (!is.null(x$displayName)) x$displayName else NA,
          index_value = if (!is.null(x$indexInfo$value)) x$indexInfo$value else NA,
          category = if (!is.null(x$indexInfo$category)) x$indexInfo$category else NA,
          description = if (!is.null(x$indexInfo$indexDescription)) x$indexInfo$indexDescription else NA,
          in_season = if (!is.null(x$inSeason)) x$inSeason else NA,
          stringsAsFactors = FALSE
        )
      }))
    }
    return(df)
  }, error = function(e) {
    message("Error fetching or parsing data: ", e$message)
    return(data.frame())
  })

  return(result)
}
