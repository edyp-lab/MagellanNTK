# Download_btns shiny module.

A shiny module that shows download buttons in different formats.

## Usage

``` r
download_btns_ui(id, settings = list())

download_btns_server(
  id,
  dataIn = reactive({
     NULL
 }),
  name,
  colors = reactive({
     NULL
 }),
  tags = reactive({
     NULL
 })
)

download_btns(dataIn)
```

## Arguments

- id:

  A \`character()\` as the id of the Shiny module

- settings:

  xxx

- dataIn:

  A data.frame

- name:

  xxxx\.

- colors:

  xxx

- tags:

  xxx

## Value

NA

## Examples

``` r
if (interactive()) {
    shiny::runApp(download_btns(lldata))
}
```
