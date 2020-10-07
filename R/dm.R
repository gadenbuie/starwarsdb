#' Create a Star Wars Data Model Object
#'
#' Creates a \pkg{dm} object with the starwars tables.
#'
#' @param configure_dm If `TRUE` (default) the returned \pkg{dm} object is
#'   completely configured with all of the primary and foreign keys. Set to
#'   `FALSE` if you want to practice configuring the \pkg{dm} object yourself.
#' @param remote If `TRUE`, uses the internal DuckDB database rather than local
#'   tables, which is the default.
#'
#' @return A \pkg{dm} object
#'
#' @seealso [dm::dm()], [dm::dm_add_pk()], [dm::dm_add_fk()], [dm::dm_from_src()]
#' @export
starwars_dm <- function(configure_dm = TRUE, remote = FALSE) {
  x <- if (isTRUE(remote)) {
    dm::dm_from_src(starwars_connect())
  } else {
    dm::dm(
      films = starwars::films,
      people = starwars::people,
      planets = starwars::planets,
      species = starwars::species,
      vehicles = starwars::vehicles,
      pilots = starwars::pilots,
      films_people = starwars::films_people,
      films_planets = starwars::films_planets,
      films_vehicles = starwars::films_vehicles
    )
  }
  if (!isTRUE(configure_dm)) return(x)
  starwars_dm_configure(x)
}

#' @describeIn starwars_dm Configure the starwars \pkg{dm} object with primary
#'   and foreigns keys and colors.
#' @param dm A \pkg{dm} object with the starwars tables
#' @export
starwars_dm_configure <- function(dm) {
  dm %>%
    dm::dm_add_pk(films, title) %>%
    dm::dm_add_pk(people, name) %>%
    dm::dm_add_pk(planets, name) %>%
    dm::dm_add_pk(species, name) %>%
    dm::dm_add_pk(vehicles, name) %>%
    dm::dm_add_fk(films_people, title, films) %>%
    dm::dm_add_fk(films_people, character, people) %>%
    dm::dm_add_fk(films_planets, title, films) %>%
    dm::dm_add_fk(films_planets, planet, planets) %>%
    dm::dm_add_fk(films_vehicles, title, films) %>%
    dm::dm_add_fk(films_vehicles, vehicle, vehicles) %>%
    dm::dm_add_fk(pilots, pilot, people) %>%
    dm::dm_add_fk(pilots, vehicle, vehicles) %>%
    dm::dm_add_fk(people, species, species) %>%
    dm::dm_add_fk(people, homeworld, planets) %>%
    dm::dm_set_colors(
      "#C2C7B5" = starts_with("films"),
      "#6E989B" = c("people", "pilots"),
      "#BC8258" = "species",
      "#71503E" = "vehicles",
      "#BC4610" = "planets"
    )
}
