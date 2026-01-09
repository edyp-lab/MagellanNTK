# Markdown editor module

Displays of formatted modal-dialog with 'Cancel' and 'Ok' buttons.

## Usage

``` r
mdEditor_ui(id)

mdEditor_server(id)

mdEditor()
```

## Arguments

- id:

  A \`character(1)\` which is the id of the instance of the module

## Value

A Shiny modal-dialog

A Shiny modal-dialog

## Examples

``` r
if (interactive()) {
shiny::runApp(mdEditor())
}
```
