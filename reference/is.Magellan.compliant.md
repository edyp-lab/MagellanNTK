# \# example code \#' @title Checks if the object is compliant with MagellanNTK

Checks and accept the following data formats: \* An instance of class
\`MSnSet\` (which is a list of \`data.frame()\`) \* An instance of class
\`MultiAssayExperiment\` (which is a list of \`SummarizedExperiment()\`)
\* An instance of class \`SummarizedExperiment\` \* An instance of class
\`data.frame\` \* An instance of class \`matrix\` \* A \`list\` of
instances of class \`MSnSet\` \* A \`list\` of instances of class
\`SummarizedExperiment\` \* A \`list\` of instances of class
\`data.frame\` \* A \`list\` of instances of class \`matrix\`

## Usage

``` r
is.Magellan.compliant(obj)
```

## Arguments

- obj:

  The R object to be tested

## Value

A \`boolean\`

## Examples

``` r
is.Magellan.compliant(data.frame())
#> [1] TRUE


ll <- list(data.frame(), data.frame())
is.Magellan.compliant(ll)
#> [1] TRUE

```
