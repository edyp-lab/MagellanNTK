# Basic check workflow directory

This function checks if the directory contains well-formed directories
and files It must contains 3 directories: 'md', 'R' and 'data'. The 'R'
directory must contains two directories: \* 'workflows' that contains
the source files for workflows, \* 'other' that contains additional
source files used by workflows. This directory can be empty. For each
file in the 'R/workflows' directory, there must exists a \*.md file with
the same filename in the 'md' directory. The 'data' directory can be
empty.

For a full description of the nomenclature of workflows filename, please
refer to xxx.

## Usage

``` r
CheckWorkflowDir(path)
```

## Arguments

- path:

  A \`character(1)\`

## Value

A \`boolean(1)\`

## Examples

``` r
NULL
#> NULL
```
