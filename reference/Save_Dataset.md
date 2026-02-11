# Load dataset shiny module

A shiny Module to load a dataset.

## Usage

``` r
Save_Dataset_ui(id)

Save_Dataset_server(id, data)

Save_Dataset(data)
```

## Arguments

- id:

  A \`character()\` as the id of the Shiny module

- data:

  The object to be saved

## Value

A shiny app

## Examples

``` r
if (interactive()) {
    shiny::runApp(Save_Dataset(lldata))
}
```
