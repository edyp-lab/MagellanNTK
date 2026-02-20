# Error modal shiny module.

A shiny module that shows messages in modal.

## Usage

``` r
errorModal_ui(id)

errorModal_server(id, msg)

errorModal(msg)
```

## Arguments

- id:

  A \`character()\` as the id of the Shiny module

- msg:

  The text to display in the modal

## Value

A shiny App

## Examples

``` r
if (interactive()) {
    shiny::runApp(errorModal("my error text"))
}
```
