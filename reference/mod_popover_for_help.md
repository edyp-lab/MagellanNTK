# mod_popover_for_help_ui and mod_popover_for_help_server

A shiny Module.

## Usage

``` r
mod_popover_for_help_ui(id)

mod_popover_for_help_server(id, title, content)

popover_for_help(title, content)
```

## Arguments

- id:

  A \`character()\` as the id of the Shiny module

- title:

  xxxx

- content:

  xxx

## Value

NA

## Examples

``` r
if (interactive()) {
    shiny::runApp(popover_for_help("myTitle", "myContent"))
}
```
