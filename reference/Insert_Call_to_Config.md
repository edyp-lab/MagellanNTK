# Insert source code for config()

Insert source code for config()

## Usage

``` r
Insert_Call_to_Config(name)
```

## Arguments

- name:

  The name of a pipeline nor a process

## Value

A \`character()\` containing R source code

## Examples

``` r
Insert_Call_to_Config("PipelineDemo")
#> [1] "config <- PipelineDemo_conf()\n  config@ll.UI <- setNames(\n      lapply(\n        names(config@steps),\n        function(x){\n          do.call(\"uiOutput\", list(ns(x)))\n        }\n      ), nm = paste0(\"screen_\", names(config@steps))\n    )"
```
