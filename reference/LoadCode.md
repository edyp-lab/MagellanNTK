# Load workflows functions

This function xx

## Usage

``` r
LoadCode(name, path, recursive = FALSE)
```

## Arguments

- name:

  A \`character()\` to indicate the name of the workflow. It can be
  either a single string (which represents a workflow without a parent)
  or two strings separated by '\_' (in that case, it is a workflow with
  a parent workflow).

- path:

  A \`character()\` to indicate the directory where to find the source
  files of all workflows. This directory must also contains a 'md'
  directory that contains the md files corresponding to the workflows.

- recursive:

  xxx

## Value

NA

## Examples

``` r
.path <- system.file('extdata/module_examples', package='MagellanNTK')

.name <- 'PipelineDemo_Process1'
LoadCode(name = .name, path = .path)

.path <- system.file('extdata/module_examples', package='MagellanNTK')
.name <- 'PipelineDemo'
LoadCode(name = .name, path = .path)
```
