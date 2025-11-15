# mod_bug_report_ui and mod_bug_report_server

A shiny Module.

## Usage

``` r
mod_bug_report_ui(id)

mod_bug_report_server(id)

bug_report()
```

## Arguments

- id:

  shiny id

## Value

NA

## Examples

``` r
if (interactive()) {
    shiny::runApp(bug_report())
}
```
