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

Returned value of the process

This function generates dynamically the observeEvent function for each
widget

## Usage

``` r
Get_Code_Update_Config_Variable()

Get_Code_Declare_widgets(widgets.names = NULL)

Get_Code_Declare_rv_custom(rv.custom.names = NULL)

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

  A \`vector\` containing the names of the widgets in all steps of the
  module.

- rv.custom.names:

  A \`vector\` containing the names of the custom variables in all steps
  of the module.

- widgets:

  A \`list\` containing the names of the widgets in all steps of the
  module with their default values

- custom:

  A \`list\` of the custom variables used in the process. Each custom
  variable is accompanied with its default value

- dataIn:

  An instance of the \`QFeatures\` or \`SummarizedExperiment\` classes

- addon:

  xxx

- w.names:

  Same as widgets.names

- mode:

  A \`character()\` which indicates whether the current module is used
  as a 'process' nor a 'pipeline.' Default value is NULL

- name:

  The Shiny id of the process or pipeline

## Value

A \`string\` containing some R code

A \`character()\` containing R source code

A \`character()\` containing R source code

A \`character()\` containing R source code

A \`string\` containing some R code

A \`character()\` containing R source code

A \`character()\` containing R source code

A \`character()\` containing R source code

A \`character()\` containing R source code

A \`character()\` containing R source code

A \`character()\` containing R source code

A \`character()\` containing R source code

A \`character()\` containing R source code

A \`character()\` containing R source code

## Author

Samuel Wieczorek
