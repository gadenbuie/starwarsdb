library(DBI)
library(duckdb)
pkgload::load_all(here::here())

db_file <- here::here("inst/db/starwars.duckdb")

con <- dbConnect(duckdb(), dbdir = db_file, read_only = FALSE)

dm::copy_dm_to(con, starwars_dm(), set_key_constraints = TRUE, temporary = FALSE)

dbDisconnect(con, shutdown=TRUE)

