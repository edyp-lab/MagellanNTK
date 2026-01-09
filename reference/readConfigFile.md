# Read pipelines configuration files

xxx

## Usage

``` r
readConfigFile(path, usermod = "user")
```

## Arguments

- path:

  xxx

- usermod:

  xxxxx

## Value

NA

## Examples

``` r
path <- system.file("workflow/PipelineDemo", package = "MagellanNTK")
readConfigFile(path)
#> $funcs
#> $funcs$convert_dataset
#> NULL
#> 
#> $funcs$open_dataset
#> [1] "MagellanNTK::open_dataset"
#> 
#> $funcs$open_demoDataset
#> [1] "MagellanNTK::open_demoDataset"
#> 
#> $funcs$view_dataset
#> [1] "MagellanNTK::view_dataset"
#> 
#> $funcs$download_dataset
#> NULL
#> 
#> $funcs$export_dataset
#> NULL
#> 
#> $funcs$build_report
#> NULL
#> 
#> $funcs$infos_dataset
#> [1] "MagellanNTK::infos_dataset"
#> 
#> $funcs$history_dataset
#> NULL
#> 
#> $funcs$addDatasets
#> [1] "MagellanNTK::addDatasets"
#> 
#> $funcs$keepDatasets
#> [1] "MagellanNTK::keepDatasets"
#> 
#> 
#> $verbose
#> [1] TRUE
#> 
#> $UI_view_debugger
#> [1] TRUE
#> 
#> $UI_view_open_pipeline
#> [1] TRUE
#> 
#> $UI_view_convert_dataset
#> [1] TRUE
#> 
#> $UI_view_change_Look_Feel
#> [1] TRUE
#> 
#> $UI_view_change_core_funcs
#> [1] TRUE
#> 
#> $extension
#> NULL
#> 
#> $class
#> NULL
#> 
#> $package
#> NULL
#> 
#> $demo_package
#> NULL
#> 
#> $URL_manual
#> NULL
#> 
#> $URL_ReleaseNotes
#> NULL
#> 
```
