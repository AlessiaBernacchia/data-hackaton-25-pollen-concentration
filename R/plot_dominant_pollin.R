#' @param polline_df pollin df
#' @return plot of most prominent pollin on the swiss map
#' @export


world <- sf::read_sf('2025_GEOM_TK/01_INST/Gesamtfla╠êche_gf/K4_kant20220101_gf/K4kant20220101gf_ch2007Poly.shp')
l1    <- sf::st_read('2025_GEOM_TK/00_TOPO/K4_seenyyyymmdd/k4seenyyyymmdd11_ch2007Poly.shp')
l2    <- sf::st_read('2025_GEOM_TK/00_TOPO/K4_seenyyyymmdd/k4seenyyyymmdd22_ch2007Poly.shp')

plot_most_canton <- function(polline_df) {
  dominant_polline_df <- polline_df |>
    tidyr::pivot_longer(cols = dplyr::ends_with("_pollin"), names_to = "type", values_to = "val") |>
    dplyr::mutate(type = gsub("_pollin", "", type)) |>
    dplyr::group_by(canton, type) |>
    dplyr::summarise(mean_val = mean(val), .groups = "drop") |>
    dplyr::group_by(canton) |>
    dplyr::slice_max(mean_val, n = 1, with_ties = FALSE)

  world_colored <- dplyr::left_join(world, dominant_polline_df, by = c("name" = "canton"))

  centroids <- world_colored |>
    dplyr::filter(!is.na(type)) |>
    sf::st_centroid()

  ggplot2::ggplot() +
    ggplot2::geom_sf(data = world, fill = "grey90", color = "black", linewidth = 0.3) +
    ggplot2::geom_sf(data = dplyr::filter(world_colored, !is.na(type)),
                     ggplot2::aes(fill = type), color = "black", linewidth = 0.3) +
    ggplot2::geom_sf(data = l1, fill = "lightblue", color = NA) +
    ggplot2::geom_sf(data = l2, fill = "lightblue", color = NA) +
    ggplot2::geom_sf_label(data = centroids, ggplot2::aes(label = name),
                           size = 3, fill = "white", alpha = 0.7, label.size = 0.2) +
    ggplot2::scale_fill_manual(
      values = c(grass = "#66c2a5", tree = "#fc8d62", weed = "#8da0cb"),
      name = "Dominant pollen type"
    ) +
    ggplot2::labs(title = "Dominant pollen type by canton") +
    ggplot2::theme_minimal()
}

