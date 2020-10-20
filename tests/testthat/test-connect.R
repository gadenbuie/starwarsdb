test_that("connects and disconnects to duckdb", {
  con <- starwars_connect()
  db_file <- con@driver@dbdir
  expect_true(inherits(con, "duckdb_connection"))
  expect_true(basename(db_file) == "starwars.duckdb")

  expect_true(DBI::dbIsValid(con))
  starwars_disconnect(con)
  expect_false(DBI::dbIsValid(con))
  expect_false(file.exists(dirname(db_file)))
})

test_that("starwars_db() creates a temporary copy of the database", {
  file <- starwars_db()
  on.exit(unlink(dirname(file), recursive = TRUE))

  expect_true(basename(file) == "starwars.duckdb")
  expect_true(file.exists(file))
  expect_true(grepl("starwars", dirname(file)))
})
