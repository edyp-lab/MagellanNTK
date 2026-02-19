# Datasets processing

The following functions are currently available:

\- \`keepDatasets(object, range)\` keep datasets in object which are in
range

\- \`addDatasets(object, dataset, name)\` add the 'dataset' to the
object (of type list)

This manual page describes manipulation methods using \[list\] objects.
In index or name \`i\` can be specified to define the array (by name of
index) on which to operate.

The following functions are currently available:

\- \`keepDatasets(object, range)\` keep datasets in object which are in
range

\- \`addDatasets(object, dataset, name)\` add the 'dataset' to the
object (of type list)

\- \`Save(object, file)\` stores the object to a .RData file

## Usage

``` r
addDatasets(object, dataset, name)

keepDatasets(object = NULL, range = seq(length(object)))
```

## Arguments

- object:

  An object of class \`list\`.

- dataset:

  \`character()\` providing the base with respect to which logarithms
  are computed. Default is log2.

- name:

  A \`character()\` naming the new array name.

- range:

  A interval of integers

## Value

An instance of class \`MultiAssayExperiment\`.

An processed object of the same class as \`object\`.

## Details

The object must be of type list. Thetwo functions are implemented here
for of the package which uses MagellanNTK

The object must be of type list. Thetwo functions are implemented here
for of the package which uses MagellanNTK

## Examples

``` r
data(lldata)
obj.se <- lldata[[1]]
new.obj <- addDatasets(lldata, obj.se, 'mynewobj')

data(lldata123)
keepDatasets(lldata123, c(1,3))
#> harmonizing input:
#>   removing 12 sampleMap rows not in names(experiments)
#> A MultiAssayExperiment object of 2 listed
#>  experiments with user-defined names and respective classes.
#>  Containing an ExperimentList class object of length 2:
#>  [1] Convert: SummarizedExperiment with 100 rows and 6 columns
#>  [2] Preprocessing: SummarizedExperiment with 72 rows and 6 columns
#> Functionality:
#>  experiments() - obtain the ExperimentList instance
#>  colData() - the primary/phenotype DataFrame
#>  sampleMap() - the sample coordination DataFrame
#>  `$`, `[`, `[[` - extract colData columns, subset, or experiment
#>  *Format() - convert into a long or wide DataFrame
#>  assays() - convert ExperimentList to a SimpleList of matrices
#>  exportClass() - save data to flat files

NULL
#> NULL
```
