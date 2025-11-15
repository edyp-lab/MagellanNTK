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

  internal

- msg:

  xxxx

## Value

NA

## Examples

``` r
if (interactive()) {
    shiny::runApp(errorModal("my error text"))
}
```
