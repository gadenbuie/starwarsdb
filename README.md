
<!-- README.md is generated from README.Rmd. Please edit that file -->

# starwarsdb

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/starwarsdb)](https://CRAN.R-project.org/package=starwarsdb)
[![CI by
{tic}](https://github.com/gadenbuie/starwarsdb/workflows/CI%20by%20%7Btic%7D/badge.svg)](https://github.com/gadenbuie/starwarsdb/actions)
<!-- badges: end -->

**starwarsdb** provides data from the [Star Wars API](https://swapi.dev)
as a set of relational tables, or as an in-package
[DuckDB](https://duckdb.org) database.

![](man/figures/README-starwars-data-model-1.png)

**Formats:** [Metadata](#star-wars-data), [Local Tables](#local-tables),
[Remote Tables](#remote-tables), [Data Model (dm)](#dm-tables), [API
(rwars)](#api)

## Installation

You can install **starwarsdb** from GitHub with
[remotes](https://remotes.r-lib.org):

``` r
# install.packages("remotes")

remotes::install_github("gadenbuie/starwarsdb")

# For remotes <= 2.1.0
remotes::install_github("gadenbuie/starwarsdb@main")
```

## Star Wars Data

All of the tables are available when you load **starwarsdb**

``` r
library(dplyr)
library(starwarsdb)
```

or via

``` r
data(package = "starwarsdb")
```

The `schema` table includes information about the tables that were
sourced from [SWAPI](https://swapi.dev).

``` r
schema
#> # A tibble: 5 x 4
#>   endpoint endpoint_title endpoint_description                  properties      
#>   <chr>    <chr>          <chr>                                 <list>          
#> 1 films    Film           A Star Wars film                      <tibble [14 × 4…
#> 2 vehicles Starship       A Starship or vehicle                 <tibble [19 × 4…
#> 3 species  People         A species within the Star Wars unive… <tibble [15 × 4…
#> 4 planets  Planet         A planet.                             <tibble [14 × 4…
#> 5 people   People         A person within the Star Wars univer… <tibble [16 × 4…
```

``` r
schema %>% 
  filter(endpoint == "films") %>% 
  pull(properties)
#> [[1]]
#> # A tibble: 14 x 4
#>    variable     type    description                                      format 
#>    <chr>        <chr>   <chr>                                            <chr>  
#>  1 starships    array   The starship resources featured within this fil… <NA>   
#>  2 edited       string  the ISO 8601 date format of the time that this … date-t…
#>  3 planets      array   The planet resources featured within this film.  <NA>   
#>  4 producer     string  The producer(s) of this film.                    <NA>   
#>  5 title        string  The title of this film.                          <NA>   
#>  6 url          string  The url of this resource                         uri    
#>  7 release_date string  The release date at original creator country.    date   
#>  8 vehicles     array   The vehicle resources featured within this film. <NA>   
#>  9 episode_id   integer The episode number of this film.                 <NA>   
#> 10 director     string  The director of this film.                       <NA>   
#> 11 created      string  The ISO 8601 date format of the time that this … date-t…
#> 12 opening_cra… string  The opening crawl text at the beginning of this… <NA>   
#> 13 characters   array   The people resources featured within this film.  <NA>   
#> 14 species      array   The species resources featured within this film. <NA>
```

## Local Tables

Ask questions, like *who flew an X-Wing?*

``` r
x_wing_pilots <- pilots %>% filter(vehicle == "X-wing")
x_wing_pilots
#> # A tibble: 4 x 2
#>   pilot             vehicle
#>   <chr>             <chr>  
#> 1 Luke Skywalker    X-wing 
#> 2 Biggs Darklighter X-wing 
#> 3 Wedge Antilles    X-wing 
#> 4 Jek Tono Porkins  X-wing

people %>% semi_join(x_wing_pilots, by = c(name = "pilot"))
#> # A tibble: 4 x 11
#>   name  height  mass hair_color skin_color eye_color birth_year gender homeworld
#>   <chr>  <dbl> <dbl> <chr>      <chr>      <chr>          <dbl> <chr>  <chr>    
#> 1 Luke…    172    77 blond      fair       blue              19 mascu… Tatooine 
#> 2 Bigg…    183    84 black      light      brown             24 mascu… Tatooine 
#> 3 Wedg…    170    77 brown      fair       hazel             21 mascu… Corellia 
#> 4 Jek …    180   110 brown      fair       blue              NA mascu… Bestine …
#> # … with 2 more variables: species <chr>, sex <chr>
```

## Remote Tables

**starwarsdb** also includes the entire data set as a DuckDB database,
appropriate for teaching and practicing remote database access with
[dbplyr](https://dbplyr.tidyverse.org/).

``` r
con <- starwars_connect()

people_rmt <- tbl(con, "people")
pilots_rmt <- tbl(con, "pilots")
pilots_rmt
#> # Source:   table<pilots> [?? x 2]
#> # Database: duckdb_connection
#>    pilot             vehicle          
#>    <chr>             <chr>            
#>  1 Chewbacca         Millennium Falcon
#>  2 Han Solo          Millennium Falcon
#>  3 Lando Calrissian  Millennium Falcon
#>  4 Nien Nunb         Millennium Falcon
#>  5 Luke Skywalker    X-wing           
#>  6 Biggs Darklighter X-wing           
#>  7 Wedge Antilles    X-wing           
#>  8 Jek Tono Porkins  X-wing           
#>  9 Darth Vader       TIE Advanced x1  
#> 10 Boba Fett         Slave 1          
#> # … with more rows

x_wing_pilots <- pilots_rmt %>% filter(vehicle == "X-wing")
x_wing_pilots
#> # Source:   lazy query [?? x 2]
#> # Database: duckdb_connection
#>   pilot             vehicle
#>   <chr>             <chr>  
#> 1 Luke Skywalker    X-wing 
#> 2 Biggs Darklighter X-wing 
#> 3 Wedge Antilles    X-wing 
#> 4 Jek Tono Porkins  X-wing

people_rmt %>% semi_join(x_wing_pilots, by = c(name = "pilot"))
#> # Source:   lazy query [?? x 11]
#> # Database: duckdb_connection
#>   name  height  mass hair_color skin_color eye_color birth_year gender homeworld
#>   <chr>  <dbl> <dbl> <chr>      <chr>      <chr>          <dbl> <chr>  <chr>    
#> 1 Luke…    172    77 blond      fair       blue              19 mascu… Tatooine 
#> 2 Bigg…    183    84 black      light      brown             24 mascu… Tatooine 
#> 3 Wedg…    170    77 brown      fair       hazel             21 mascu… Corellia 
#> 4 Jek …    180   110 brown      fair       blue              NA mascu… Bestine …
#> # … with 2 more variables: species <chr>, sex <chr>
```

## DM Tables

Finally, **starwarsdb** provides a function that returns a
pre-configured [dm](https://krlmlr.github.io/dm/) object. The `dm`
package wraps local data frames into a complete relational data model.

``` r
library(dm, warn.conflicts = FALSE)

sw_dm <- starwars_dm()
sw_dm
#> ── Metadata ────────────────────────────────────────────────────────────────────
#> Tables: `films`, `people`, `planets`, `species`, `vehicles`, … (9 total)
#> Columns: 58
#> Primary keys: 5
#> Foreign keys: 10

sw_dm %>%
  dm_select_tbl(pilots, people) %>%
  dm_filter("pilots", vehicle == "X-wing") %>%
  dm_apply_filters() %>%
  dm_zoom_to("people") %>%
  semi_join(pilots)
#> # Zoomed table: people
#> # A tibble:     4 x 11
#>   name  height  mass hair_color skin_color eye_color birth_year gender homeworld
#>   <chr>  <dbl> <dbl> <chr>      <chr>      <chr>          <dbl> <chr>  <chr>    
#> 1 Luke…    172    77 blond      fair       blue              19 mascu… Tatooine 
#> 2 Bigg…    183    84 black      light      brown             24 mascu… Tatooine 
#> 3 Wedg…    170    77 brown      fair       hazel             21 mascu… Corellia 
#> 4 Jek …    180   110 brown      fair       blue              NA mascu… Bestine …
#> # … with 2 more variables: species <chr>, sex <chr>
```

``` r
dm_draw(sw_dm)
```

<img src="man/figures/README-starwars-data-model-1.png" width="100%" />

## API

For API access from R, check out the
[rwars](https://github.com/Ironholds/rwars) package by Oliver Keyes. Big
thanks to `rwars` for making it easy to access the Star Wars API\!
