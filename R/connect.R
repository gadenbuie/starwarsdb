#' Connect to the Star Wars Database
#'
#' Provides a connection to a DuckDB database of the Star Wars data.
#' Alternatively, you can use `starwars_db()` to manually connect to the
#' database using [DBI::dbConnect()] and [duckdb::duckdb()].
#'
#' @return A connection to the Star Wars database, or the path to the database.
#'
#' @examples
#' # Manually connect using {duckdb} and {DBI}
#' con <- DBI::dbConnect(
#'   duckdb::duckdb(),
#'   dbdir = starwars_db(),
#'   read_only = TRUE
#' )
#'
#' if (requireNamespace("dplyr", quietly = TRUE)) {
#'   dplyr::tbl(con, "films")
#' }
#'
#' # Disconnect from that database (shutdown is specific to duckdb)
#' DBI::dbDisconnect(con, shutdown = TRUE)
#'
#' # Or connect without worrying about connection details
#' con <- starwars_connect()
#'
#' if (requireNamespace("dplyr", quietly = TRUE)) {
#'   dplyr::tbl(con, "films")
#' }
#'
#' # Similarly, disconnect quickly without worrying about duckdb arguments
#' starwars_disconnect(con)
#'
#' @param con A connection to the Star Wars database
#' @name starwars_db
NULL


#' @describeIn starwars_db Connect to the DuckDB database
#' @export
starwars_connect <- function() {
  DBI::dbConnect(
    duckdb::duckdb(),
    dbdir = starwars_db(),
    read_only = TRUE
  )
}

#' @describeIn starwars_db Disconnect from the DuckDB database
#' @export
starwars_disconnect <- function(con) {
  was_valid <- DBI::dbIsValid(con)
  DBI::dbDisconnect(con, shutdown = TRUE)
  if (inherits(con, "duckdb_connection") && was_valid) {
    unlink(dirname(con@driver@dbdir), recursive = TRUE)
  }
}

#' @describeIn starwars_db Returns the path to the starwarsdb database
#' @export
starwars_db <- function() {
  temp_db <- tempfile("starwarsdb")
  dir.create(temp_db)
  file.copy(
    dir(system.file("db", package = "starwarsdb"), full.names = TRUE),
    temp_db
  )
  file.path(temp_db, "starwars.duckdb")
}
