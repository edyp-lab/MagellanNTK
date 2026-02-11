# Export dataset Shiyny app

A shiny Module.

## Usage

``` r
export_dataset_ui(id)

export_dataset_server(id, dataIn)

export_dataset(data)
```

## Arguments

- id:

  A \`character()\` as the id of the Shiny module

- dataIn:

  xxx

- data:

  xxx

## Value

A shiny App

## Examples

``` r
if (interactive()) {
    shiny::runApp(export_dataset(lldata))
}
```
