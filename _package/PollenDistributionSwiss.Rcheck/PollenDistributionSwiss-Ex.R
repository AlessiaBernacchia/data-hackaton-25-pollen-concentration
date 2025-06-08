pkgname <- "PollenDistributionSwiss"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('PollenDistributionSwiss')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("compare_pollen_levels")
### * compare_pollen_levels

flush(stderr()); flush(stdout())

### Name: compare_pollen_levels
### Title: Compare pollen levels between two cities
### Aliases: compare_pollen_levels

### ** Examples

city1_name <- "Zurich"
city1_lat <- 47.3769
city1_lon <- 8.5417

city2_name <- "Geneva"
city2_lat <- 46.2044
city2_lon <- 6.1432
result <- compare_pollen_levels(city1_name, city2_name, city1_lat, city1_lon, city2_lat, city2_lon)




cleanEx()
nameEx("get_pollen_for_list_cities")
### * get_pollen_for_list_cities

flush(stderr()); flush(stdout())

### Name: get_pollen_for_list_cities
### Title: Get data pollen of a given city
### Aliases: get_pollen_for_list_cities

### ** Examples

## Not run: 
##D tibble_test <- get_pollen_for_list_cities(c("Lugano", "Geneva"), "SwissCities.csv")
## End(Not run)




cleanEx()
nameEx("get_pollen_forecast")
### * get_pollen_forecast

flush(stderr()); flush(stdout())

### Name: get_pollen_forecast
### Title: Getting the pollen data from the API
### Aliases: get_pollen_forecast

### ** Examples

latitude <- 47.3769
longitude <- 8.5417

df_test <- get_pollen_forecast(latitude, longitude)




cleanEx()
nameEx("get_pollen_forecast_with_cache")
### * get_pollen_forecast_with_cache

flush(stderr()); flush(stdout())

### Name: get_pollen_forecast_with_cache
### Title: Read data from the API (no caching)
### Aliases: get_pollen_forecast_with_cache

### ** Examples

latitude <- 47.3769
longitude <- 8.5417

df_test <- get_pollen_forecast_with_cache(latitude, longitude)




cleanEx()
nameEx("plot_most_canton")
### * plot_most_canton

flush(stderr()); flush(stdout())

### Name: plot_most_canton
### Title: Plot the Pollins in the Swiss Map
### Aliases: plot_most_canton

### ** Examples

## Not run: 
##D city_df <- get_pollen_for_list_cities(c("Geneva", "Lugano"))
##D plot_most_canton(city_df)
## End(Not run)




cleanEx()
nameEx("plot_specific_pollen")
### * plot_specific_pollen

flush(stderr()); flush(stdout())

### Name: plot_specific_pollen
### Title: Calculation of average pollen by canton
### Aliases: plot_specific_pollen

### ** Examples

## Not run: 
##D df <- data.frame(canton = c("Zürich", "Bern"),
##D                  grass_pollin = c(30, 50),
##D                  tree_pollin = c(10, 20),
##D                  weed_pollin = c(5, 15))
##D 
##D plot_specific_pollen(df, pollen_type = "grass", PATH='2025_GEOM_TK')
## End(Not run)




### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
