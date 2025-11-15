# infos_dataset_ui and infos_dataset_server

A shiny Module.

## Usage

``` r
infos_dataset_ui(id)

infos_dataset_server(
  id,
  dataIn = reactive({
     NULL
 })
)

infos_dataset(dataIn)
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
    shiny::runApp(infos_dataset(lldata))
}
```
