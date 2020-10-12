# Prepare `starwarsdb` data

library(tidyverse)
# remotes::install_github("gadenbuie/rwars@dev")
library(rwars)

get_root_resource <- function(endpoint) {
  if (!grepl("^/", endpoint)) endpoint <- paste0("/", endpoint)

  pages <- list()
  page <- list()

  while(!length(pages) || !is.null(page$`next`)) {
    Sys.sleep(1)
    n_page <- length(pages) + 1
    message("Page ", n_page)
    if (length(pages)) {
      page <- rwars:::query(page$`next`)
    } else {
      page <- rwars:::query(endpoint)
    }
    pages[[n_page]] <- page
  }

  x <- list(
    results = purrr::map(pages, "results"),
    schema = rwars:::query(paste0(endpoint, "/schema"))
  )
  readr::write_rds(
    x,
    here::here("data-raw", paste0(sub("/", "", endpoint), ".rds"))
  )
}


# films ----
films <- get_root_resource("films")
# starships ----
starships <- get_root_resource("starships")
# vehicles ----
vehicles <- get_root_resource("vehicles")
# species ----
species <- get_root_resource("species")
# planets ----
planets <- get_root_resource("planets")
# people ----
people <- get_root_resource("people")
