# Checks if a Shiny module is loaded

This function checks if the ui() and server() parts of a Shiny module
are available in the global environment.

## Usage

``` r
module.exists(base_name)
```

## Arguments

- base_name:

  The name of the module (without '\_ui' nor '\_server' suffixes)

## Value

A boolean

## Examples

``` r
path <- system.file("workflow/PipelineDemo", package = "MagellanNTK")
source_wf_files(path) 
#> [1] TRUE
module.exists('PipelineDemo_Process2')
#> [1] TRUE
```
