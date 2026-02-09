# R code to update the 'config' variable of a process module

This function generates the necessary code to modify the variable
'config' (slots steps and mandatory). It adds a 'Description' step and a
TRUE value at the beginning of the 'steps' and 'mandatory' list, erases
all white spaces for the names of the steps.

This function generates the necessary code to modify the variable
'config' (slots steps and mandatory). It adds a 'Description' step and a
TRUE value at the beginning of the 'steps' and 'mandatory' list, erases
all white spaces for the names of the steps.

This function create the source code needed inside a module to declare
the reactive variable called 'widgets.default.values'. \# Declaration of
the variables that will contain the values of the widgets To avoid
confusion, the first string is the name of the step while the second is
the name of the widget

This function create the source code needed inside a module to declare
the reactive variable called 'rv.custom.default.values'. \# Declaration
of the variables that will contain the values of the user variables. To
avoid confusion, the first string is the name of the step while the
second is the name of the widget

This function xxx \# Generate dynamically the observeEvent function for
each widget

This function xxx \# Generate dynamically the observeEvent function for
each widget

This function createxxx

Returned value of the process

xxx

xxx

xxx

xxx

xxx

This function xxx \# Generate dynamically the observeEvent function for
each widget

This function xxx \# Generate dynamically the observeEvent function for
each widget

This function xxx \# Generate dynamically the observeEvent function for
each widget

This function generates dynamically the observeEvent function for each
widget

## Usage

``` r
Get_Code_Update_Config_Variable()

Get_Code_Declare_widgets(widgets.names = NULL)

Get_Code_Declare_rv_custom(rv.custom.names = NULL)

Get_Code_for_Initialize_History(widgets.names = NULL)

Get_Code_for_ObserveEvent_widgets(widgets.names = NULL)

Get_Code_for_rv_reactiveValues()

Get_Code_for_dataOut()

Get_Code_for_General_observeEvents()

Get_Code_for_remoteReset(
  widgets = TRUE,
  custom = TRUE,
  dataIn = "dataIn()",
  addon = ""
)

Get_Code_for_resetting_widgets()

Get_Code_for_resetting_custom()

Get_Code_for_newDataset(
  widgets = TRUE,
  custom = TRUE,
  dataIn = "dataIn()",
  addon = ""
)

Module_Return_Func()

AdditionnalCodeForExternalModules(w.names = NULL, rv.custom.names = NULL)

Get_Workflow_Core_Code(
  mode = NULL,
  name = NULL,
  w.names = NULL,
  rv.custom.names = NULL
)

Get_AdditionalModule_Core_Code(w.names = NULL, rv.custom.names = NULL)
```

## Arguments

- widgets.names:

  A \`list\` containing the names of the widgets in all steps of the
  module.

- rv.custom.names:

  xxx

- widgets:

  xxx

- custom:

  xxx

- dataIn:

  An instance of the \`QFeatures\` or \`SummarizedExperiment\` classes

- addon:

  xxx

- w.names:

  xxx

- mode:

  xxx

- name:

  xxx

## Value

A \`string\` containing some R code

NA

NA

NA

NA

A \`string\` containing some R code

NA

NA

NA

NA

NA

NA

NA

NA

NA

NA

## Author

Samuel Wieczorek
