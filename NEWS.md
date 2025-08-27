# starwarsdb (development version)

# starwarsdb 0.1.3

* Small fix in starwarsdb tests to use `testthat::local_mocked_bindings()`.

# starwarsdb 0.1.2

* starwarsdb creates the duckdb database on connection, rather than shipping the
  `.duckdb` files. This makes the package more resilient to changes in the
  underlying format of duckdb database files.

# starwarsdb 0.1.1

* Released on CRAN!
