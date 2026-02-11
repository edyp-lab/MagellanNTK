# dl

A shiny Module.

## Usage

``` r
download_dataset_ui(id)

download_dataset_server(
  id,
  dataIn = reactive({
     NULL
 }),
  widget.type = "Link",
  filename = "myDataset"
)

download_dataset(data, filename = "myDataset")
```

## Arguments

- id:

  A \`character()\` as the id of the Shiny module

- dataIn:

  internal

- widget.type:

  Available values are \`Button\` and \`Link\` (default).

- filename:

  xxx

- data:

  xxx

## Value

A shiny App

## Examples

``` r
if (interactive()) {
    shiny::runApp(download_dataset(lldata))

    shiny::runApp(download_dataset(lldata, filename = "myDataset"))
}
```
