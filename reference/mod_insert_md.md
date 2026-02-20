# insert_md_ui and insert_md_server

A shiny Module.

## Usage

``` r
insert_md_ui(id)

insert_md_server(id, url)

insert_md(url)
```

## Arguments

- id:

  A \`character()\` as the id of the Shiny module

- url:

  The path to the Rmd file to display. It can be a path to a file on the
  computer or a link to a file over internet.

## Value

A shiny App

## Examples

``` r
if (interactive()) {
    base <- system.file("app/md", package = "MagellanNTK")
    url <- file.path(base, "presentation.Rmd")
    shiny::runApp(insert_md(url))
}
```
