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
  filename = "myDataset",
  excel.style = NULL,
  remoteReset = reactive({
     0
 }),
  is.enabled = reactive({
     TRUE
 })
)

download_dataset(dataIn = NULL, filename = "myDataset")
```

## Arguments

- id:

  internal

- dataIn:

  internal

- filename:

  internal

- excel.style:

  xxx

- remoteReset:

  A \`logical(1)\` which acts as a remote command to reset the module to
  its default values. Default is FALSE.

- is.enabled:

  xxx

## Value

NA

## Examples

``` r
if (interactive()){
data(lldata, package = "MagellanNTK")
shiny::runApp(download_dataset(lldata))
}

```
