# Predefined modal

Displays of formatted modal-dialog with 'Cancel' and 'Ok' buttons.

## Usage

``` r
mod_bsmodal_ui(id)

mod_bsmodal_server(
  id,
  label = "Edit md",
  title = NULL,
  width = NULL,
  uiContent = NULL,
  shiny.module = NULL
)

mod_bsmodal(
  title = "test",
  ui.func = NULL,
  ui.params = list(),
  server.func = NULL,
  server.params = list()
)
```

## Arguments

- id:

  A \`character(1)\` which is the id of the instance of the module

- label:

  xxx

- title:

  A \`character(1)\`

- width:

  A \`character(1)\` indicating the size of the modal window. Can be "s"
  for small (the default), "m" for medium, or "l" for large.

- uiContent:

  The content of the modal dialog.

- shiny.module:

  xxx

- ui.func:

  xxx

- ui.params:

  xxx

- server.func:

  xxx

- server.params:

  xxx

## Value

A Shiny modal-dialog

## Examples

``` r
if (interactive()) {
    shiny::runApp(mod_bsmodal())
}
```
