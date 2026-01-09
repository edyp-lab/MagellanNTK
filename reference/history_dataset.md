# history_dataset_ui and history_dataset_server

A shiny Module.

## Usage

``` r
history_dataset_ui(id)

history_dataset_server(
  id,
  dataIn = reactive({
     NULL
 })
)

history_dataset(dataIn)
```

## Arguments

- id:

  xxx

- dataIn:

  xxx

## Value

NA

## Examples

``` r
if (interactive()) {
    shiny::runApp(history_dataset(lldata))
}
```
