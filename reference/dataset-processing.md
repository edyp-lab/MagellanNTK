# Datasets processing

This manual page describes manipulation methods using \[list\] objects.
In index or name \`i\` can be specified to define the array (by name of
index) on which to operate.

The following functions are currently available:

\- \`keepDatasets(object, range)\` keep datasets in object which are in
range

\- \`addDatasets(object, dataset, name)\` add the 'dataset' to the
object (of type list)

\- \`Save(object, file)\` stores the object to a .RData file

This function appends a dataset in the list with customization if
necessary

This function deletes the items not included in the range parameter

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

An processed object of the same class as \`object\`.

An processed object of the same class as \`object\`.

## Details

The object must be of type list. Thetwo functions are implemented here
for of the package which uses MagellanNTK

The object must be of type list. Thetwo functions are implemented here
for of the package which uses MagellanNTK

## Examples

``` r
data(lldata)
keepDatasets(lldata, 2:3)
#> $ProcessA
#> $ProcessA$assay
#>    A  B  C  D  E  F
#> 1  2  4  8 22  1  6
#> 2 27 30 14 15 10 25
#> 3 28  9 20  3 12 26
#> 4 19 16  7 23 24  5
#> 5 13 11 21 17 29 18
#> 
#> $ProcessA$metadata
#> list()
#> 
#> 
#> $ProcessB
#> $ProcessB$assay
#>    A  B  C  D  E  F
#> 1 12  3  1 20  7 26
#> 2 30  8  9 17 18 10
#> 3  5  2 29 21 13 27
#> 4 24 11 23 14  4 19
#> 5 28  6 15 16 22 25
#> 
#> $ProcessB$metadata
#> list()
#> 
#> 


NULL
#> NULL
```
