#' @param polline_df pollin df
#' @return plot of most prominent pollin on the swiss map
#' @export

library(sf)
library(ggplot2)
library(dplyr)
library(terra)
library(tidyr)

world <- sf::read_sf('2025_GEOM_TK/01_INST/Gesamtfla╠êche_gf/K4_kant20220101_gf/K4kant20220101gf_ch2007Poly.shp')
l1   <- st_read('2025_GEOM_TK/00_TOPO/K4_seenyyyymmdd/k4seenyyyymmdd11_ch2007Poly.shp')
l2   <- st_read('2025_GEOM_TK/00_TOPO/K4_seenyyyymmdd/k4seenyyyymmdd22_ch2007Poly.shp')


plot_most_canton <- function(polline_df) {
  dominant_polline_df <- polline_df %>%
    pivot_longer(cols = ends_with("_pollin"), names_to = "type", values_to = "val") %>%
    mutate(type = gsub("_pollin", "", type)) %>%
    group_by(canton, type) %>%
    summarise(mean_val = mean(val), .groups = "drop") %>%
    group_by(canton) %>%
    slice_max(mean_val, n = 1, with_ties = FALSE)

  world_colored <- world %>%
    left_join(dominant_polline_df, by = c("name" = "canton"))

  # Plot
  ggplot() +
    geom_sf(data = world, fill = "grey90", color = "black", linewidth = 0.3) +
    geom_sf(data = world_colored %>% filter(!is.na(type)),
            aes(fill = type), color = "black", linewidth = 0.3) +
    geom_sf(data = l1, fill = "lightblue", color = NA) +
    geom_sf(data = l2, fill = "lightblue", color = NA) +
    scale_fill_manual(
      values = c(grass = "#66c2a5", tree = "#fc8d62", weed = "#8da0cb"),
      name = "Dominant pollen type"
    ) +
    labs(title = "Dominant pollen type by canton") +
    theme_minimal()
}
