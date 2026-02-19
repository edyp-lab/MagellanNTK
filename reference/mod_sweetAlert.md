# A shiny app to display a modal

A shiny app to display a modal

## Usage

``` r
mod_SweetAlert_ui(id)

mod_SweetAlert_server(
  id,
  title = NULL,
  text = NULL,
  showClipBtn = TRUE,
  type = "error"
)

mod_SweetAlert(title, text, type = "warning")
```

## Arguments

- id:

  A \`character()\` as the id of the Shiny module

- title:

  xxx

- text:

  xxx

- showClipBtn:

  xxx

- type:

  xxx

## Value

A shiny App

## Examples

``` r
if (interactive()) {
    shiny::runApp(mod_SweetAlert("my title", "my message"))
}
```
