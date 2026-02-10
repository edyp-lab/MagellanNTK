# Source workflow files

This function goes into the 'R' directory of the file structure of a
pipeline and load into memory the source code of the R scripts (which
contains the interfaces of the process)

## Usage

``` r
source_wf_files(dirpath, verbose = FALSE)
```

## Arguments

- dirpath:

  A \`character()\` which is the path to the directory which contains
  the files and directories of the pipeline.

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
