# Source workflow files

xxx

## Usage

``` r
source_wf_files(dirpath, verbose = FALSE)
```

## Arguments

- dirpath:

  xxx

- verbose:

  A \`boolean\` to indicate whether to turn off (FALSE) or ON (TRUE) the
  verbose mode for logs.

## Value

NA

## Examples

``` r
path <- system.file("workflow/PipelineDemo", package = "MagellanNTK")
source_wf_files(path)
#> [1] TRUE
```
