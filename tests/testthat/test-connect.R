test_that("connects and disconnects to duckdb", {
  con <- starwars_connect()
  expect_true(inherits(con, "duckdb_connection"))
  expect_true(basename(con@driver@dbdir) == "starwars.duckdb")

  expect_true(DBI::dbIsValid(con))
  starwars_disconnect(con)
  expect_false(DBI::dbIsValid(con))
})

test_that("starwars_db() creates a temporary copy of the database", {
  file <- starwars_db()
  on.exit(unlink(file))

  expect_true(basename(file) == "starwars.duckdb")
  expect_true(file.exists(file))
  expect_true(grepl("starwars", dirname(file)))
})
