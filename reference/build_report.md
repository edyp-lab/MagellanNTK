# dl

A shiny Module.

## Usage

``` r
build_report_ui(id)

build_report_server(
  id,
  dataIn = reactive({
     NULL
 }),
  filename = "myDataset"
)

build_report(data, filename = "myDataset")
```

## Arguments

- id:

  internal

- dataIn:

  internal

- filename:

  xxx

- data:

  xxx

## Value

NA

## Examples

``` r
if (interactive()) {
    shiny::runApp(build_report(lldata))

    shiny::runApp(build_report(lldata, filename = "myDataset"))
}

NULL
#> NULL
NULL
#> NULL
NULL
#> NULL
```
