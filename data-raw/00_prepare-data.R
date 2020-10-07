pkg_path <- function(...) here::here(...)

fs::dir_delete(pkg_path("data"))
if (fs::dir_exists(pkg_path("inst", "db"))) {
  fs::dir_delete(pkg_path("inst", "db"))
}

fs::dir_create(pkg_path("inst", "db"), recurse = TRUE)

if (!fs::file_exists(pkg_path("data-raw", "films.rds"))) {
  callr::rscript(pkg_path("data-raw", "starwars_raw.R"))
}

callr::rscript(pkg_path("data-raw", "starwars.R"))
callr::rscript(pkg_path("data-raw", "duckdb.R"))
