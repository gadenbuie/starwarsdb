test_that("connects and disconnects to duckdb in memory", {
  con <- starwars_connect(dbdir = ":memory:")
  expect_equal(con@driver@dbdir, ":memory:")
  expect_setequal(DBI::dbListTables(con), names(starwarsdb_tables()))
  expect_true(inherits(con, "duckdb_connection"))
  expect_true(DBI::dbIsValid(con))
  starwars_disconnect(con)
  expect_false(DBI::dbIsValid(con))
})

test_that("connects and disconnects to duckdb using dbdir file", {
  con <- starwars_connect(dbdir = starwars_db())
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
