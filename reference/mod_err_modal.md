# xxx

xxx

## Usage

``` r
mod_errorModal_ui(id)

mod_errorModal_server(
  id,
  title = NULL,
  text = NULL,
  footer = modalButton("Close")
)

mod_errorModal(title = NULL, text = NULL)
```

## Arguments

- id:

  A \`character()\` as the id of the Shiny module

- title:

  xxxx

- text:

  xxx

- footer:

  xxx

## Value

NA

## Examples

``` r
if (interactive()) {
    shiny::runApp(mod_errorModal("myTitle", "myContent"))
}
```
