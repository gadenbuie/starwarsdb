starwarsdb_tables <- function() {
  films <- tibble::as_tibble(starwarsdb::films)
  list(
    films = starwarsdb::films,
    people = starwarsdb::people,
    planets = starwarsdb::planets,
    species = starwarsdb::species,
    vehicles = starwarsdb::vehicles,
    pilots = starwarsdb::pilots,
    films_people = starwarsdb::films_people,
    films_planets = starwarsdb::films_planets,
    films_vehicles = starwarsdb::films_vehicles
  )
}


#' Films
#'
#' Films in the Star Wars movie franchise.
#'
#' @template swapi
#' @format A data frame with 6 rows and 6 variables:
#' \describe{
#'   \item{\code{title}}{The title of this film.}
#'   \item{\code{episode_id}}{The episode number of this film.}
#'   \item{\code{opening_crawl}}{The opening crawl text at the beginning of this film.}
#'   \item{\code{director}}{The director of this film.}
#'   \item{\code{producer}}{he producer(s) of this film.}
#'   \item{\code{release_date}}{The release date at original creator country.}
#' }
"films"

#' People
#'
#' Characters within the Star Wars universe.
#'
#' @template swapi
#' @format A data frame with 82 rows and 10 variables:
#' \describe{
#'   \item{\code{name}}{The name of this person.}
#'   \item{\code{height}}{The height of this person in meters.}
#'   \item{\code{mass}}{The mass of this person in kilograms.}
#'   \item{\code{hair_color}}{The hair color of this person.}
#'   \item{\code{skin_color}}{The skin color of this person.}
#'   \item{\code{eye_color}}{The eye color of this person.}
#'   \item{\code{birth_year}}{The birth year of this person. BBY (Before the Battle of Yavin) or ABY (After the Battle of Yavin).}
#'   \item{\code{sex}}{The biological sex of the character. One of `male`, `female`, `hermaphroditic`, or `none`.}
#'   \item{\code{gender}}{The gender role or gender identity of the character.}
#'   \item{\code{homeworld}}{The planet the character was born on.}
#'   \item{\code{species}}{The species of the character.}
#' }
"people"


#' Planets
#'
#' Planets in the Star Wars universe.
#'
#' @template swapi
#' @format A data frame with 59 rows and 9 variables:
#' \describe{
#'   \item{\code{name}}{The name of this planet.}
#'   \item{\code{rotation_period}}{The number of standard hours it takes for this planet to complete a single rotation on its axis.}
#'   \item{\code{orbital_period}}{The number of standard days it takes for this planet to complete a single orbit of its local star.}
#'   \item{\code{diameter}}{The diameter of this planet in kilometers.}
#'   \item{\code{climate}}{The climate of this planet. Comma-seperated if diverse.}
#'   \item{\code{gravity}}{A number denoting the gravity of this planet. Where 1 is normal.}
#'   \item{\code{terrain}}{The terrain of this planet. Comma-seperated if diverse.}
#'   \item{\code{surface_water}}{The percentage of the planet surface that is naturally occurring water or bodies of water.}
#'   \item{\code{population}}{The average population of sentient beings inhabiting this planet.}
#' }
"planets"

#' Species
#'
#' Species within the Star Wars universe.
#'
#' @template swapi
#' @format A data frame with 37 rows and 10 variables:
#' \describe{
#'   \item{\code{name}}{The name of this species.}
#'   \item{\code{classification}}{The classification of this species.}
#'   \item{\code{designation}}{The designation of this species.}
#'   \item{\code{average_height}}{The average height of this person in centimeters.}
#'   \item{\code{skin_colors}}{A comma-seperated string of common skin colors for this species, none if this species does not typically have skin.}
#'   \item{\code{hair_colors}}{A comma-seperated string of common hair colors for this species, none if this species does not typically have hair.}
#'   \item{\code{eye_colors}}{A comma-seperated string of common eye colors for this species, none if this species does not typically have eyes.}
#'   \item{\code{average_lifespan}}{The average lifespan of this species in years.}
#'   \item{\code{homeworld}}{The URL of a planet resource, a planet that this species originates from.}
#'   \item{\code{language}}{The language commonly spoken by this species.}
#' }
"species"

#' Starships or Vehicles
#'
#' A Starship or vehicle in the Star Wars universe.
#'
#' @template swapi
#' @format A data frame with 75 rows and 14 variables:
#' \describe{
#'   \item{\code{name}}{The name of this vehicle. The common name, such as Sand Crawler.}
#'   \item{\code{type}}{The type of the vehicle: starship or vehicle.}
#'   \item{\code{class}}{The class of the vehicle, source from \code{starship_class} or \code{vehicle_class}.}
#'   \item{\code{model}}{The model or official name of this vehicle. Such as All Terrain Attack Transport.}
#'   \item{\code{manufacturer}}{The manufacturer of this vehicle. Comma seperated if more than one.}
#'   \item{\code{cost_in_credits}}{The cost of this vehicle new, in galactic credits.}
#'   \item{\code{length}}{The length of this vehicle in meters.}
#'   \item{\code{max_atmosphering_speed}}{The maximum speed of this vehicle in atmosphere.}
#'   \item{\code{crew}}{The number of personnel needed to run or pilot this vehicle.}
#'   \item{\code{passengers}}{The number of non-essential people this vehicle can transport.}
#'   \item{\code{cargo_capacity}}{The maximum number of kilograms that this vehicle can transport.}
#'   \item{\code{consumables}}{The maximum length of time that this vehicle can provide consumables for its entire crew without having to resupply.}
#'   \item{\code{hyperdrive_rating}}{The class of this starships hyperdrive.}
#'   \item{\code{MGLT}}{The Maximum number of Megalights this starship can travel in a standard hour. A Megalight is a standard unit of distance and has never been defined before within the Star Wars universe. This figure is only really useful for measuring the difference in speed of starships. We can assume it is similar to AU, the distance between our Sun (Sol) and Earth.}
#' }
"vehicles"

#' Pilots
#'
#' Links `people` to the `vehicles` they have piloted.
#'
#' @template swapi
#' @format A data frame with 43 rows and 2 variables:
#' \describe{
#'   \item{\code{pilot}}{The name of the person who piloted the vehicle.}
#'   \item{\code{vehicle}}{The name of the vehicle that was piloted.}
#' }
"pilots"

#' People in Films
#'
#' Links characters (`people`) to the `films` in which they appear.
#'
#' @template swapi
#' @format A data frame with 162 rows and 2 variables:
#' \describe{
#'   \item{\code{title}}{The title of the film.}
#'   \item{\code{character}}{The name of the character who appeared in the film.}
#' }
"films_people"

#' Planets in Films
#'
#' Links `planets` to the `films` in which they appear.
#'
#' @template swapi
#' @format A data frame with 33 rows and 2 variables:
#' \describe{
#'   \item{\code{title}}{The title of the film.}
#'   \item{\code{planet}}{The name of the planet that appeared in the film.}
#' }
"films_planets"

#' Vehicles in Films
#'
#' Links `vehicles` to the `films` in which they appear
#'
#' @template swapi
#' @format A data frame with 104 rows and 2 variables:
#' \describe{
#'   \item{\code{title}}{The title of the film.}
#'   \item{\code{vehicle}}{The name of the vehicle that appeared in the film.}
#' }
"films_vehicles"



#' Star Wars Data Schema
#'
#' Includes information about the schema of the tables that were sourced from
#' [SWAPI](https://swapi.dev), the _Star Wars API_. Not all properties returned
#' from the API are columns in the data in this package: some properties were
#' refactored into separate tables. For example, I combined the `starships/`
#' and `vehicles/` endpoint into a single table. Both API endpoints returned a
#' "pilots" property, which is described in the schema as an array of people
#' who piloted the vehicle. The information in this property has been extracted
#' into a separate table called `pilots` in the \pkg{starwarsdb} package.
#'
#' @template swapi
#' @format A data frame with 5 rows and 4 variables:
#' \describe{
#'   \item{\code{endpoint}}{The name of the SWAPI endpoint.}
#'   \item{\code{endpoint_title}}{The title of the SWAPI endpoint.}
#'   \item{\code{endpoint_description}}{The description of the SWAPI endpoint.}
#'   \item{\code{properties}}{The properties of the endpoint as a nested table containing the `variable`, the data `type`, a `description` and the `format` of the property.}
#' }
"schema"
