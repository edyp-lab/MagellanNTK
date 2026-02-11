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

keepDatasets(object, range = seq(length(object)))
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
NULL
#> NULL
```
