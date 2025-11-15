# mod_homepage_ui and mod_homepage_server

A shiny Module.

## Usage

``` r
mod_homepage_ui(id)

mod_homepage_server(
  id,
  mdfile = file.path(system.file("app/md", package = "MagellanNTK"), "Presentation.Rmd")
)

mod_homepage()
```

## Arguments

- id:

  shiny id

- mdfile:

  xxx

## Value

NA

## Examples

``` r
if (interactive()) {
    shiny::runApp(mod_homepage())
}
```
