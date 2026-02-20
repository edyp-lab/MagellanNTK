# lldata123 dataset

An instance of the class \`MultiAssayExperiment\` which contains two
assays (instance of class \`SummarizedExperiment\`): 'Convert': Contains
a data.frame with 6 columns and 100 rows fullfilled with '0'.
'DataGeneration' which stores the result of the 'DataGeneration' step of
the demo pipeline 'Preprocessing' which stores the result of the
'DataGeneration' and 'Preprocessing' steps of the demo pipeline
'Clustering' which stores the result of all the three steps of the demo
pipeline Each assay contains a slot 'history' in the metadata().

## Usage

``` r
data(lldata123)
```

## Format

An object of class \`MultiAssayExperiments\`
