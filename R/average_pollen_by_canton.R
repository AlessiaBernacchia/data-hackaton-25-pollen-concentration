#' @title Calculation of average pollen by canton
#'
#' @param polline_df A data frame containing pollen concentration data, including canton names
#'        and numeric columns for each pollen type (e.g., grass_pollin, tree_pollin, etc.).
#' @param pollen_type Character string indicating the type of pollen to visualize.
#'        Must correspond to a column prefix in polline_df (e.g., "grass", "tree", or "weed").
#'
#' @return plot of most prominent pollin on the swiss map
#'
#' @description
#' This function takes a data frame with pollen concentration data and generates
#' a thematic map of Switzerland, showing the average concentration of a specific
#' pollen type (tree, weed, or grass) across cantons. It overlays the pollen data
#' on top of canton shapefiles and lakes for context.
#'
#'
#' @examples
#' df <- data.frame(canton = c("Zürich", "Bern"),
#'                  grass_pollin = c(30, 50),
#'                  tree_pollin = c(10, 20),
#'                  weed_pollin = c(5, 15))
#'
#' average_pollen_by_canton(df, pollen_type = "grass")
#'
#'
#' @export

average_pollen_by_canton <- function(polline_df, pollen_type = "grass", PATH='2025_GEOM_TK') {
  world_path = paste0(PATH, '/01_INST/Gesamtfla╠êche_gf/K4_kant20220101_gf/K4kant20220101gf_ch2007Poly.shp')
  l_path = paste0(PATH, '/00_TOPO/K4_seenyyyymmdd/k4seenyyyymmdd11_ch2007Poly.shp' )

  world <- sf::read_sf(world_path)
  l1    <- sf::st_read(l_path)
  l2    <- sf::st_read(l_path)

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

