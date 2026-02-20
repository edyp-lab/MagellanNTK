# A shiny app to display a modal

This module is not directly used by MagellanNTK core functions. It is
rather a useful tool for third part pipelines and processes.

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

  The title to be displayed in the window

- text:

  The titmessage to be displayed in the window

- showClipBtn:

  A \`boolean\` to indicates if the copy to clipboard button is shown or
  not.

- type:

  A \`character()\` for the type of message: 'error', 'warning', etc..

## Value

A shiny App

## Examples

``` r
if (interactive()) {
    shiny::runApp(mod_SweetAlert("my title", "my message"))
}
```
