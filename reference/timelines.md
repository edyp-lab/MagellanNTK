# Timelines

xxx

## Usage

``` r
timeline_process_ui(id)

timeline_process_server(id, config, status, position, enabled)

timeline_pipeline_ui(id)

timeline_pipeline_server(id, config, status, position, enabled)
```

## Arguments

- id:

  A \`character()\` as the id of the Shiny module

- config:

  An instance of the class \`Config\`

- status:

  A boolean which indicates whether the current status of the process ,

- position:

  An integer which reflects the current position of the cursor within
  the steps.

- enabled:

  A vector of booleans with the same length as the number of steps ( See
  the slot steps in the config object). Each element indicates if the
  corresponding step is enabled (TRUE) or (DISABLED)

## Value

NA

A Shiny app

## Examples

``` r
NULL
#> NULL
```
