#' Relational Data from the Star Wars API for Learning and Teaching
#'
#' \pkg{starwarsdb} provides tables about the films, characters, planets and
#' vehicles in the Star Wars movie franchise universe. The package and the
#' tables have been organized to facilitate learning relational database
#' concepts, like joins. It also includes functions that connect to a local
#' DuckDB (file-based) database for teaching and practice working with remote
#' databases via \pkg{dplyr}, \pkg{DBI}, and \pkg{dm}.
#'
#' @section Tables:
#'
#' - [films]
#' - [people]
#' - [planets]
#' - [species]
#' - [vehicles]
#' - [pilots]
#' - [films_people]
#' - [films_planets]
#' - [films_vehicles]
#' - [schema]
#'
#' @template swapi
#' @seealso The [rwars](https://github.com/Ironholds/rwars) package by Oliver
#'   Keyes.
#' @keywords internal
"_PACKAGE"

# The following block is used by usethis to automatically manage
# roxygen namespace tags. Modify with care!
## usethis namespace: start
## usethis namespace: end
NULL
