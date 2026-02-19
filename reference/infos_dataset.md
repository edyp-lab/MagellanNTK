# infos_dataset_ui and infos_dataset_server

A shiny Module.

## Usage

``` r
infos_dataset_ui(id)

infos_dataset_server(
  id,
  dataIn = reactive({
     NULL
 }),
  remoteReset = reactive({
     0
 }),
  is.enabled = reactive({
     TRUE
 })
)

infos_dataset(obj)
```

## Arguments

- id:

  shiny id

- dataIn:

  An instance of the class \`MultiAssayExperiment\`.

## Value

A shiny app

## Examples

``` r
if (interactive()){
data(lldata123)
shiny::runApp(infos_dataset(lldata123))
}
```
