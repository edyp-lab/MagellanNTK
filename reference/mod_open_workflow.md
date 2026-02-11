# mod_open_workflow_ui and mod_open_workflow_server

A shiny Module.

## Usage

``` r
open_workflow_ui(id)

open_workflow_server(id)

open_workflow()
```

## Arguments

- id:

  A \`character()\` as the id of the Shiny module

## Value

A shiny App

## Examples

``` r
if (interactive()) {
shiny::runApp(open_workflow())
}
```
