# insert_md_ui and insert_md_server

A shiny Module.

## Usage

``` r
insert_md_ui(id)

insert_md_server(id, url, link_URL = NULL)

insert_md(url)
```

## Arguments

- id:

  A \`character()\` as the id of the Shiny module

- url:

  internal

- link_URL:

  xxx

## Value

NA

## Examples

``` r
if (interactive()) {
    base <- system.file("app/md", package = "MagellanNTK")
    url <- file.path(base, "presentation.Rmd")
    shiny::runApp(insert_md(url))
}
```
