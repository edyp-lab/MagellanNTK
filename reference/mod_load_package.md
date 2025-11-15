# Change the default functions in \`MagellanNTK\`

This module allows to change the default functions embedded in the
package \`MagellanNTK\`. These fucntions are the following: \*
convert_dataset: xxx \* view_dataset: xxx \* infos_dataset: xxx

## Usage

``` r
mod_load_package_ui(id)

mod_load_package_server(
  id,
  funcs = reactive({
     NULL
 })
)

load_package(funcs = NULL)
```

## Arguments

- id:

  shiny id

- funcs:

  A list

## Value

NA

## Author

Samuel Wieczorek

## Examples

``` r
if (interactive()) {
    funcs <- list(
        convert_dataset = "DaparToolshed::convert_dataset",
        open_dataset = "MagellanNTK::open_dataset",
        open_demoDataset = "MagellanNTK::open_demoDataset",
        view_dataset = "omXplore::view_dataset",
        infos_dataset = "MagellanNTK::infos_dataset",
        download_dataset = "MagellanNTK::download_dataset",
        export_dataset = "MagellanNTK::export_dataset",
        addDatasets = "MagellanNTK::addDatasets",
        keepDatasets = "MagellanNTK::keepDatasets"
    )
    shiny::runApp(load_package(funcs))

    shiny::runApp(load_package())
}
```
