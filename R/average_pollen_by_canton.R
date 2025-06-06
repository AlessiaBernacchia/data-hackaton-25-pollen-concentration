#' @param polline_df pollin df
#' @param pollen_type pollen type (tree, weed, grass)
#' @return plot of most prominent pollin on the swiss map
#' @export


world <- sf::read_sf('2025_GEOM_TK/01_INST/Gesamtfla╠êche_gf/K4_kant20220101_gf/K4kant20220101gf_ch2007Poly.shp')
l1    <- sf::st_read('2025_GEOM_TK/00_TOPO/K4_seenyyyymmdd/k4seenyyyymmdd11_ch2007Poly.shp')
l2    <- sf::st_read('2025_GEOM_TK/00_TOPO/K4_seenyyyymmdd/k4seenyyyymmdd22_ch2007Poly.shp')

plot_specific_pollen <- function(polline_df, pollen_type = "grass") {
  pollen_col <- paste0(pollen_type, "_pollin")

  avg_df <- dplyr::group_by(polline_df, canton) |>
    dplyr::summarise(mean_val = mean(.data[[pollen_col]], na.rm = TRUE), .groups = "drop")

  world_colored <- dplyr::left_join(world, avg_df, by = c("name" = "canton"))

  centroids <- world_colored |>
    dplyr::filter(!is.na(mean_val)) |>
    sf::st_centroid()

  ggplot2::ggplot() +
    ggplot2::geom_sf(data = world, fill = "grey90", color = "black", linewidth = 0.3) +
    ggplot2::geom_sf(data = dplyr::filter(world_colored, !is.na(mean_val)),
                     ggplot2::aes(fill = mean_val), color = "black", linewidth = 0.3) +
    ggplot2::geom_sf(data = l1, fill = "lightblue", color = NA) +
    ggplot2::geom_sf(data = l2, fill = "lightblue", color = NA) +
    ggplot2::geom_sf_label(data = centroids, ggplot2::aes(label = name),
                           size = 3, fill = "white", alpha = 0.7, label.size = 0.2) +
    ggplot2::scale_fill_viridis_c(name = paste("Level of", pollen_type, "pollen")) +
    ggplot2::labs(title = paste("Average", pollen_type, "pollen by canton")) +
    ggplot2::theme_minimal()
}

