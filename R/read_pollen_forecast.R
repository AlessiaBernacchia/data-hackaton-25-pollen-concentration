#' @param latitude Latitude of the location
#' @param longitude Longitude of the location
#' @return A data.frame with pollen forecast data
#' @export
#' @name get_pollen_forecast
#' @examples
#' df_test <- get_pollen_forecast(latitude=46.94, longitude=7.94)

get_pollen_forecast <- function(latitude, longitude) {
  url <- paste0(
    "https://pollen.googleapis.com/v1/forecast:lookup?",
    "key=", "AIzaSyABklcoTHFHA6Io2jCAZjHGUc4jphZB4RM",
    "&location.latitude=", latitude,
    "&location.longitude=", longitude,
    "&days=1"
  )
  #
  response <- httr2::request(url) |> httr2::req_perform()
  content <- httr2::resp_body_json(response)

  if (is.null(content$dailyInfo[[1]]$pollenTypeInfo)) {
    return(data.frame())
  }

  pollen_info <- content$dailyInfo[[1]]$pollenTypeInfo

  df <- do.call(rbind, lapply(pollen_info, function(x) {
    data.frame(
      plant = x$displayName,
      index_value = x$indexInfo$value,
      category = x$indexInfo$category,
      description = x$indexInfo$indexDescription,
      in_season = x$inSeason,
      stringsAsFactors = FALSE
    )
  }))

  return(df)
}


