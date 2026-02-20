# Opens a small tooltip info over a widget.

Actually, this module does not work because we do not allow the use of
the package \`shinyBS\` package (conflicts with BS versions). In the
future, one will fix this module with native functions in the package
\`bs4Dash\` (https://bs4dash.rinterface.com/reference/tooltip).

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

  The title of the tooltip window

- content:

  The main text of the tooltip window

## Value

A shiny App

## Examples

``` r
if (interactive()) {
    shiny::runApp(popover_for_help("myTitle", "myContent"))
}
```
