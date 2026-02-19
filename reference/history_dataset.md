# history_dataset_ui and history_dataset_server

A shiny Module.

## Usage

``` r
history_dataset_ui(id)

history_dataset_server(
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

history_dataset(obj)
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
data(lldata)
shiny::runApp(history_dataset(lldata))
}
```
