test_that("starwars_dm local full", {
  dm_local <- starwars_dm()

  expect_true(inherits(dm_local, "dm"))
  expect_error(dm::dm_get_con(dm_local))
  expect_equal(
    sort(dm::dm_get_all_pks(dm_local)$table),
    c("films", "people", "planets", "species", "vehicles")
  )
  expect_true(nrow(dm::dm_get_all_fks(dm_local)) > 0)
  expect_equal(
    sort(unique(dm::dm_get_all_fks(dm_local)$parent_table)),
    c("films", "people", "planets", "species", "vehicles")
  )
})

test_that("starwars_dm local unconfigured", {
  dm_local <- starwars_dm(configure_dm = FALSE)

  expect_true(inherits(dm_local, "dm"))
  expect_error(dm::dm_get_con(dm_local))
  expect_equal(dm::dm_get_all_pks(dm_local)$table, character())
  expect_equal(nrow(dm::dm_get_all_fks(dm_local)), 0)
})

test_that("starwars_dm remote full", {
  dm_remote <- starwars_dm(remote = TRUE)
  con <- dm::dm_get_con(dm_remote)
  on.exit(starwars_disconnect(con))

  expect_true(inherits(dm_remote, "dm"))
  expect_true(inherits(con, "duckdb_connection"))
  expect_equal(
    sort(dm::dm_get_all_pks(dm_remote)$table),
    c("films", "people", "planets", "species", "vehicles")
  )
  expect_true(nrow(dm::dm_get_all_fks(dm_remote)) > 0)
  expect_equal(
    sort(unique(dm::dm_get_all_fks(dm_remote)$parent_table)),
    c("films", "people", "planets", "species", "vehicles")
  )
})

test_that("starwars_dm remote unconfigured", {
  dm_remote <- starwars_dm(remote = TRUE, configure_dm = FALSE)
  con <- dm::dm_get_con(dm_remote)
  on.exit(starwars_disconnect(con))

  expect_true(inherits(dm_remote, "dm"))
  expect_true(inherits(con, "duckdb_connection"))
  expect_equal(dm::dm_get_all_pks(dm_remote)$table, character())
  expect_equal(nrow(dm::dm_get_all_fks(dm_remote)), 0)
})

test_that("starwars_dm requires {dm}", {
  testthat::with_mock(
    "starwarsdb::has_dm" = function(...) FALSE,
    expect_error(starwars_dm(), "starwars_dm.+requires.+dm")
  )
  testthat::with_mock(
    "starwarsdb::has_dm" = function(...) FALSE,
    expect_error(requires_dm(), "requires the.+dm")
  )
})
