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

  A \`character()\` as the id of the Shiny module

- dataIn:

  An instance of the class \`MultiAssayExperiment\`

- filename:

  internal

- remoteReset:

  A \`logical(1)\` which acts as a remote command to reset the module to
  its default values. Default is FALSE.

- is.enabled:

  A \`boolean\`. This variable is used as a remote command to specify if
  the corresponding module is enabled (TRUE) or disabled (FALSE). For
  more details, please refer to the document 'Inside MagellanNTK'?

## Value

NA

## Examples

``` r
if (interactive()){
data(lldata, package = "MagellanNTK")
shiny::runApp(download_dataset(lldata))
}

```
