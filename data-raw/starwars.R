library(tidyverse)

raw <- list(
  films = read_rds(here::here("data-raw", "films.rds")),
  starships = read_rds(here::here("data-raw", "starships.rds")),
  vehicles = read_rds(here::here("data-raw", "vehicles.rds")),
  species = read_rds(here::here("data-raw", "species.rds")),
  planets = read_rds(here::here("data-raw", "planets.rds")),
  people = read_rds(here::here("data-raw", "people.rds"))
)

schema <-
  raw %>%
  map("schema") %>%
  map(function(schema) {
    schema$properties <- schema$properties %>%
      map_dfr(identity, .id = "variable") %>%
      list()
    schema[c("title", "description", "properties")]
  }) %>%
  map_dfr(as_tibble, .id = "endpoint") %>%
  rename(endpoint_title = title, endpoint_description = description)

row_vehicles <- which(schema$endpoint == "vehicles")
row_starships <- which(schema$endpoint == "starships")

schema$endpoint_description[[row_vehicles]] <- "A Starship or vehicle"
schema$properties[[row_vehicles]] <-
  bind_rows(schema$properties[[row_vehicles]], schema$properties[[row_starships]]) %>%
  group_by(variable) %>%
  slice(1)

schema <- schema[-row_starships, ]

zero_to_na <- function(x) {
  map(x, function(item) {
    if (length(item) == 0) {
      if (is.list(item)) list(NA_character_) else NA_character_
    } else {
      item
    }
  })
}

auto_unnest <- function(x) {
  check_unnestable <- function(.x) is.null(.x) || is.na(.x) || length(.x) <= 1
  is_unnestable <- map_lgl(x, ~ is.list(.x) && all(map_lgl(.x, check_unnestable)))
  unnestable <- names(x)[is_unnestable]
  x %>%
    mutate_at(vars(all_of(unnestable)), zero_to_na) %>%
    unnest(all_of(unnestable), keep_empty = TRUE)
}

swapi_url_to_id <- function(x) {
  str_remove(str_extract(x, "\\d+/$"), "/")
}

swapi_extract_url_ids <- function(x) {
  swapi_cols <- c(names(raw), "homeworld", "url", "characters", "pilots", "people", "residents")
  for (endpoint in intersect(names(x), swapi_cols)) {
    x[[endpoint]] <- if (is.list(x[[endpoint]])) {
      map(x[[endpoint]], swapi_url_to_id)
    } else {
      swapi_url_to_id(x[[endpoint]])
    }
  }
  x
}

starwars <-
  raw %>%
  map("results") %>%
  map_depth(2, map_dfr, enframe, .id = "id") %>%
  map(map_dfr, pivot_wider) %>%
  map_at("species", . %>% mutate(people = map(people, flatten_chr))) %>%
  map(swapi_extract_url_ids) %>%
  map(auto_unnest) %>%
  map(. %>% select(-id) %>% rename(id = url) %>% relocate(id)) %>%
  map_at("people", replace_na, list(species = 1)) %>%
  map_at("people", . %>% mutate(birth_year = str_remove(birth_year, "BBY"))) %>%
  map_at("starships", . %>% mutate(max_atmosphering_speed = str_remove_all(max_atmosphering_speed, "km"))) %>%
  map(. %>% mutate_if(is.character, ~ if_else(.x %in% c("n/a", "NA", "N/A", "unknown"), NA_character_, .x))) %>%
  map(type_convert)

## Find nested tables that need to be pulled out
# starwars %>%
#   map_depth(2, map_int, ~ max(length(.))) %>%
#   map(map_int, max) %>%
#   map(~ .x[.x > 1])

starwars$vehicles <-
  starwars[c("starships", "vehicles")] %>%
  map_dfr(mutate_if, function(x) !is.list(x), as.character, .id = "type") %>%
  mutate(
    type = str_remove(type, "s$"),
    class = coalesce(starship_class, vehicle_class)
  ) %>%
  type_convert() %>%
  select(id, name, type, class, everything(), -ends_with("_class"))

starwars$starships <- NULL

starwars$pilots <-
  starwars$vehicles %>%
  select(name, pilots) %>%
  unnest(pilots) %>%
  type_convert() %>%
  left_join(starwars$people[c("id", "name")], by = c(pilots = "id")) %>%
  select(pilot = name.y, vehicle = name.x)

extract_tables <- function(starwars, table, column, reference = column, id_column = NULL) {
  col_sym <- rlang::sym(column)
  ref_sym <- rlang::sym(reference)

  id_column <- id_column %||% str_remove(table, "s$")
  id_sym <- rlang::sym(id_column)

  starwars[[table]] %>%
    select(!!id_sym, !!col_sym) %>%
    unnest(all_of(column)) %>%
    mutate(!!column := as.numeric(!!col_sym)) %>%
    rename(.name = !!id_sym) %>%
    left_join(starwars[[reference]][c("id", "name")], by = set_names("id", column)) %>%
    select(!!id_column := .name, !!ref_sym := name)
}

starwars$films_people <-
  starwars %>%
  extract_tables("films", "characters", "people", "title") %>%
  rename(character = people)

starwars$films_planets <-
  starwars %>%
  extract_tables("films", "planets", "planets", "title") %>%
  rename(planet = planets)

starwars$films_vehicles <-
  bind_rows(
    extract_tables(starwars, "films", "starships", "vehicles", "title"),
    extract_tables(starwars, "films", "vehicles", "vehicles", "title")
  ) %>%
  rename(vehicle = vehicles)

replace_lookup <- function(x, y, x_col, y_ref, y_replacement) {
  y <- y[c(y_ref, y_replacement)]
  names(y)[2] <- ".replacement"

  x %>%
    left_join(y, by = set_names(y_ref, x_col)) %>%
    relocate(.replacement, .before = !!rlang::sym(x_col)) %>%
    select(-!!rlang::sym(x_col)) %>%
    rename(!!x_col := .replacement)
}

# Sourced from dplyr/data-raw/starwars.R to replicate sex/gender columns
# https://github.com/tidyverse/dplyr/blob/4c58f65db6599b662df50525cb3dde1d10af144f/data-raw/starwars.R#L62-L69
genders <- c(
  "C-3PO" = "masculine",  # https://starwars.fandom.com/wiki/C-3PO
  "BB8" = "masculine",    # https://starwars.fandom.com/wiki/BB-8
  "IG-88" = "masculine",  # https://starwars.fandom.com/wiki/IG-88
  "R5-D4" = "masculine",  # https://starwars.fandom.com/wiki/R5-D4
  "R2-D2" = "masculine",  # https://starwars.fandom.com/wiki/R2-D2
  "R4-P17" = "feminine",  # https://starwars.fandom.com/wiki/R4-P17
  "Jabba Desilijic Tiure" = "masculine" # https://starwars.fandom.com/wiki/Jabba_Desilijic_Tiure
)

starwars$people <-
  starwars$people %>%
  replace_lookup(starwars$planets, "homeworld", "id", "name") %>%
  replace_lookup(starwars$species, "species", "id", "name") %>%
  mutate(
    sex = gender,
    sex = ifelse(sex == "hermaphrodite", "hermaphroditic", sex),
    species = ifelse(name == "R4-P17", "Droid", species), # R4-P17 is a droid
    sex = ifelse(species == "Droid", "none", sex),        # Droids don't have biological sex
    gender = case_when(
      sex == "male" ~ "masculine",
      sex == "female" ~ "feminine",
      TRUE ~ unname(genders[name])
    )
  )

starwars <-
  starwars %>%
  map(. %>% select(-any_of("id"))) %>%
  map_at("films", . %>% select(-characters:-species, -created:-edited)) %>%
  map_at("vehicles", . %>% select(-pilots:-films, -created:-edited)) %>%
  map_at("vehicles", . %>% mutate(
    cargo_capacity = recode(cargo_capacity, "none" = "0"),
    cargo_capacity = as.numeric(cargo_capacity)
  )) %>%
  map_at("species", . %>% select(-people:-films, -created:-edited)) %>%
  map_at("planets", . %>% select(-residents:-films, -created:-edited) %>% filter(!is.na(name))) %>%
  map_at("people", . %>% select(-films, -vehicles, -starships, -created:-edited))

## Started cleaning the data but then decided against that
# as_days <- function(x) {
#   map_dbl(str_split(x, " "), function(s) {
#     if (length(s) == 1 && is.na(s)) return(NA_integer_)
#     if (length(s) == 1 && tolower(s) %in% c("0", "none")) return(0L)
#     if (length(s) > 2) return(NA_integer_)
#     s_time <- as.numeric(s[1])
#     multiplier <- switch(
#       s[2],
#       years = 365,
#       week = ,
#       weeks = 7,
#       month =,
#       months = 365/12,
#       hour =,
#       hours = 1/24,
#       1
#     )
#     as.integer(round(s_time * multiplier))
#   })
# }
#
# starwars$starships %>%
#   mutate(
#     consumables = as_days(consumables),
#     starship_class = str_to_title(starship_class)
#   )
#
# starwars$vehicles %>%
#   mutate(
#     consumables = as_days(consumables),
#     cargo_capacity = recode(cargo_capacity, "none" = "0"),
#     cargo_capacity = if_else(!is.na(cargo_capacity), as.numeric(cargo_capacity), NA_real_),
#     across(c(name, model, manufacturer, vehicle_class), str_to_title)
#   )

starwars %>% iwalk(function(data, name) {
  assign(name, data)
  eval(parse(text = glue::glue("usethis::use_data({name}, overwrite = TRUE)")))
})

usethis::use_data(schema, overwrite = TRUE)
