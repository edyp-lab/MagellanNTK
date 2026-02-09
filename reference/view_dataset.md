# mod_open_demo_dataset_ui and mod_open_demo_dataset_server

A shiny Module.

## Usage

``` r
view_dataset_ui(id)

view_dataset_server(id, dataIn = NULL, ...)

view_dataset(dataIn, ...)
```

## Arguments

- id:

  A \`character()\` as the id of the Shiny module

- dataIn:

  An instance of class xxx

- ...:

  Additional parameters

## Value

NA

NA

## Examples

``` r
if (interactive()) {
    shiny::runApp(view_dataset(lldata))
}
```
