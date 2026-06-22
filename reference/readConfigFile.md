# Read pipelines configuration files

Read the configuration file of a pipeline and extract formatted (as a
list) information

## Usage

``` r
readConfigFile(path, usermod = "user")
```

## Arguments

- path:

  A \`character()\` which is the path to the directory which contains
  the files and directories of the pipeline.

- usermod:

  A \`character()\` to specifies the running mode of MagellanNTK: 'user'
  (default) or 'dev'.

## Value

A list containing the following items: value \<- list( \* funcs = tmp,
\* verbose = get_data(lines, "verbose") == "enabled", \*
UI_view_debugger: a \`boolean\` to show (TRUE) of hide (FALSE) the
debugger interface \* UI_view_open_pipeline: a \`boolean\` to show
(TRUE) of hide (FALSE) the UI to open a pipeline \*
UI_view_convert_dataset a \`boolean\` to show (TRUE) of hide (FALSE) the
UI for convert/import a dataset \* UI_view_change_Look_Feel a
\`boolean\` to show (TRUE) of hide (FALSE) the UI to change the L&F \*
UI_view_change_core_funcs a \`boolean\` to show (TRUE) of hide (FALSE)
the UI to change the generic functions \* extension A \`character()\`
which specifies the extension file allowed to be processed in the
pipeline, \* class A \`character()\` which specifies the class of the
dataset to be processed in the pipeline, \* package A \`character()\`
which specifies the package which owns the pipeline \* demo_package A
\`character()\` which specifies a particular package to search \*
URL_manual The path to the Rmd file containing the user manual of the
pipeline. It can be a path to a file on the computer or a link to a file
over internet. \* URL_ReleaseNotes The path to the Rmd file containing
release notes about the pipeline. It can be a path to a file on the
computer or a link to a file over internet.

## Examples

``` r
path <- system.file("workflow/PipelineDemo", package = "MagellanNTK")
readConfigFile(path)
#> $funcs
#> $funcs$open_dataset
#> [1] "MagellanNTK::open_dataset"
#> 
#> $funcs$view_dataset
#> [1] "MagellanNTK::view_dataset"
#> 
#> $funcs$download_dataset
#> [1] "MagellanNTK::download_dataset"
#> 
#> $funcs$build_report
#> NULL
#> 
#> $funcs$infos_dataset
#> [1] "MagellanNTK::infos_dataset"
#> 
#> $funcs$history_dataset
#> [1] "MagellanNTK::history_dataset"
#> 
#> $funcs$addDatasets
#> [1] "MagellanNTK::addDatasets"
#> 
#> $funcs$keepDatasets
#> [1] "MagellanNTK::keepDatasets"
#> 
#> $funcs$InitializeHistory
#> [1] "MagellanNTK::InitializeHistory"
#> 
#> $funcs$Add2History
#> [1] "MagellanNTK::Add2History"
#> 
#> $funcs$GetHistory
#> [1] "MagellanNTK::GetHistory"
#> 
#> $funcs$SetHistory
#> [1] "MagellanNTK::SetHistory"
#> 
#> 
#> $verbose
#> logical(0)
#> 
#> $UI_view_debugger
#> logical(0)
#> 
#> $UI_view_open_pipeline
#> logical(0)
#> 
#> $UI_view_convert_dataset
#> logical(0)
#> 
#> $UI_view_change_Look_Feel
#> logical(0)
#> 
#> $UI_view_change_core_funcs
#> logical(0)
#> 
#> $extension
#> [1] ".RData"
#> 
#> $package
#> [1] "MagellanNTK"
#> 
#> $URL_manual
#> [1] "http://www.prostar-proteomics.org/md/versionNotes.md"
#> 
#> $URL_ReleaseNotes
#> [1] "http://www.prostar-proteomics.org/md/versionNotes.md"
#> 
```
