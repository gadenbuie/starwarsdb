#' Create a Star Wars Data Model Object
#'
#' Creates a \pkg{dm} object with the starwarsdb tables.
#'
#' @param configure_dm If `TRUE` (default) the returned \pkg{dm} object is
#'   completely configured with all of the primary and foreign keys. Set to
#'   `FALSE` if you want to practice configuring the \pkg{dm} object yourself.
#' @param remote If `TRUE`, uses the internal DuckDB database rather than local
#'   tables, which is the default.
#'
#' @return A \pkg{dm} object
#'
#' @examples
#' # If the {dm} package is installed...
#' if (requireNamespace("dm", quietly = TRUE)) {
#'   # Create a full starwars {dm} object from local tables
#'   starwars_dm(remote = TRUE)
#'
#'   # Create a base starwars {dm} object from remote tables wihout keys
#'   starwars_dm(configure_dm = FALSE, remote = TRUE)
#' }
#'
#' @seealso [dm::dm()], [dm::dm_add_pk()], [dm::dm_add_fk()], [dm::dm_from_src()]
#' @export
starwars_dm <- function(configure_dm = TRUE, remote = FALSE) {
  requires_dm("starwars_dm()")

  x <- if (isTRUE(remote)) {
    dm::dm_from_src(starwars_connect(), learn_keys = FALSE)
  } else {
    dm::as_dm(starwarsdb_tables())
  }
  if (!isTRUE(configure_dm)) return(x)
  starwars_dm_configure(x)
}

#' @describeIn starwars_dm Configure the starwars \pkg{dm} object with primary
#'   and foreign keys and colors.
#' @param dm A \pkg{dm} object with the starwarsdb tables
#' @export
starwars_dm_configure <- function(dm) {
  requires_dm("starwars_dm_configure()")

  dm %>%
    dm::dm_add_pk("films", "title") %>%
    dm::dm_add_pk("people", "name") %>%
    dm::dm_add_pk("planets", "name") %>%
    dm::dm_add_pk("species", "name") %>%
    dm::dm_add_pk("vehicles", "name") %>%
    dm::dm_add_fk("films_people", "title", "films") %>%
    dm::dm_add_fk("films_people", "character", "people") %>%
    dm::dm_add_fk("films_planets", "title", "films") %>%
    dm::dm_add_fk("films_planets", "planet", "planets") %>%
    dm::dm_add_fk("films_vehicles", "title", "films") %>%
    dm::dm_add_fk("films_vehicles", "vehicle", "vehicles") %>%
    dm::dm_add_fk("pilots", "pilot", "people") %>%
    dm::dm_add_fk("pilots", "vehicle", "vehicles") %>%
    dm::dm_add_fk("people", "species", "species") %>%
    dm::dm_add_fk("people", "homeworld", "planets") %>%
    dm::dm_set_colors(
      "#C2C7B5" = paste0("films", c("", "_people", "_planets", "_vehicles")),
      "#6E989B" = c("people", "pilots"),
      "#BC8258" = "species",
      "#71503E" = "vehicles",
      "#BC4610" = "planets"
    )
}

requires_dm <- function(fn = NULL) {
  if (!has_dm()) {
    msg <- "requires the {dm} package: install.packages('dm')"
    if (!is.null(fn)) msg <- paste(fn, msg)
    stop(msg, call. = is.null(fn))
  }
}

has_dm <- function() {
  requireNamespace("dm", quietly = TRUE)
}
