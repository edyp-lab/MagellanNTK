# A modal window to display messages

This module is not directly used by MagellanNTK core functions. It is
rather a useful tool for third part pipelines and processes.

## Usage

``` r
mod_errorModal_ui(id)

mod_errorModal_server(
  id,
  title = NULL,
  text = NULL,
  footer = modalButton("Close")
)

mod_errorModal(title = NULL, text = NULL)
```

## Arguments

- id:

  A \`character()\` as the id of the Shiny module

- title:

  A \`character()\` as the title of the modal

- text:

  A \`character()\` as the content of the modal

- footer:

  The content of the footer . May be UI content

## Value

A shiny App

## Examples

``` r
if (interactive()) {
    shiny::runApp(mod_errorModal("myTitle", "myContent"))
}
```
