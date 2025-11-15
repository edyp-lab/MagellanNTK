# Module debugging

A shiny Module which shows the values of the datasets variables along
the different processes of a process nor pipeline.

## Usage

``` r
Debug_Infos_ui(id)

Debug_Infos_server(
  id,
  title = NULL,
  config = reactive({
     NULL
 }),
  rv.dataIn = reactive({
     NULL
 }),
  dataIn = reactive({
     NULL
 }),
  dataOut = reactive({
     NULL
 }),
  steps.enabled = reactive({
     NULL
 }),
  steps.status = reactive({
     NULL
 }),
  steps.skipped = reactive({
     NULL
 }),
  current.pos = reactive({
     NULL
 }),
  is.enabled = reactive({
     NULL
 })
)

Debug_Infos(obj)
```

## Arguments

- id:

  xxx

- title:

  The title of the Panel which contains the debugging tables

- config:

  An instance of the class \`Config\`

- rv.dataIn:

  xxx

- dataIn:

  A \`list()\` of data.frames

- dataOut:

  A \`list()\` of data.frames

- steps.enabled:

  A \`logical()\` xxxx

- steps.status:

  A \`logical()\` xxxx

- steps.skipped:

  A \`logical()\` xxxx

- current.pos:

  A \`integer(1)\` which is the indice of the active step.

- is.enabled:

  A \`logical(1)\` xxxx

- obj:

  xxx

## Value

NA

A shiny app

## Author

Samuel Wieczorek

## Examples

``` r
if (interactive()) {
    shiny::runApp(Debug_Infos(lldata))
}
```
