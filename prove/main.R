#!/usr/bin/env Rscript
#' Simple Main Script to Test Pollen Functions

# Load required libraries
library(devtools)
library(dplyr)
library(ggplot2)
library(httr2)
library(readr)
library(tibble)

# Load the package
cat("Loading PollenDistributionSwiss package...\n")
devtools::load_all(".", quiet = TRUE)
cat("Package loaded!\n\n")

# Test 1: Get pollen data for a single city
cat("=== Test 1: Get pollen forecast ===\n")
zurich_data <- get_pollen_forecast(47.3769, 8.5417)  # Zurich coordinates
print(zurich_data)
cat("\n")

# Test 2: Get pollen data with cache
cat("=== Test 2: Get pollen forecast with cache ===\n")
zurich_cached <- get_pollen_forecast_with_cache(47.3769, 8.5417)
print(zurich_cached)
cat("\n")

# Test 3: Get pollen data for multiple cities
cat("=== Test 3: Get pollen for multiple cities ===\n")
swiss_cities <- c("Zurich", "Geneva", "Bern")
pollen_data <- get_pollin_for_list_cities(swiss_cities)
print(pollen_data)
cat("\n")

# Test 4: Compare two cities
cat("=== Test 4: Compare pollen levels ===\n")
comparison <- compare_pollen_levels(
  "Zurich", "Geneva", 
  47.3769, 8.5417,   # Zurich
  46.2044, 6.1432    # Geneva
)
cat("Comparison result:", comparison, "\n\n")

# Test 5: Create visualization maps
cat("=== Test 5: Create visualizations ===\n")
if(nrow(pollen_data) > 0) {
  
  # Grass pollen map
  cat("Creating grass pollen map...\n")
  grass_plot <- average_pollen_by_canton(pollen_data, pollen_type = "grass")
  ggsave("grass_pollen_map.png", grass_plot, width = 10, height = 8)
  cat("✓ Grass pollen map saved\n")

  # Tree pollen map  
  cat("Creating tree pollen map...\n")
  tree_plot <- average_pollen_by_canton(pollen_data, pollen_type = "tree")
  ggsave("tree_pollen_map.png", tree_plot, width = 10, height = 8)
  cat("✓ Tree pollen map saved\n")

  # Weed pollen map
  cat("Creating weed pollen map...\n")
  weed_plot <- average_pollen_by_canton(pollen_data, pollen_type = "weed")
  ggsave("weed_pollen_map.png", weed_plot, width = 10, height = 8)
  cat("✓ Weed pollen map saved\n")

  # Dominant pollen map
  cat("Creating dominant pollen map...\n")
  dominant_plot <- plot_dominant_pollin(pollen_data)
  ggsave("dominant_pollen_map.png", dominant_plot, width = 10, height = 8)
  cat("✓ Dominant pollen map saved\n")
  
} else {
  cat("No pollen data available for visualization\n")
}

# Test 6: Simple summary
cat("\n=== Test 6: Summary ===\n")
if(nrow(pollen_data) > 0) {
  cat("Total cities:", nrow(pollen_data), "\n")
  cat("Average grass pollen:", round(mean(pollen_data$grass_pollin, na.rm = TRUE), 2), "\n")
  cat("Average tree pollen:", round(mean(pollen_data$tree_pollin, na.rm = TRUE), 2), "\n")
  cat("Average weed pollen:", round(mean(pollen_data$weed_pollin, na.rm = TRUE), 2), "\n")
}

cat("\n🌿 All tests completed!\n") 