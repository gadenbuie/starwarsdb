#' Connect to the Star Wars Database
#'
#' Provides a connection to a DuckDB database of the Star Wars data.
#'
#' @return A connection to the Star Wars database
#'
#' @param con A connection to the Star Wars database
#' @name starwars_db
NULL


#' @describeIn starwars_db Connect to the DuckDB database
#' @export
starwars_connect <- function() {
  DBI::dbConnect(
    duckdb::duckdb(),
    dbdir = system.file("db/starwars.duckdb", package = "starwars"),
    read_only = TRUE
  )
}

#' @describeIn starwars_db Disconnect from the DuckDB database
#' @export
starwars_disconnect <- function(con) {
  DBI::dbDisconnect(con, shutdown = TRUE)
}
