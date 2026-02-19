# MagellanNTK user manual

Abstract

The R package MagellanNTK (Magellan Navigation ToolKit) is a workflow
manager using Shiny modules. It is the perfect companion package to
build workflows and integrate them in your UI or run it standalone.

## Introduction

The package MagellanNTK provides the infrastructure for the
configuration, the execution and the surveillance of a defined sequence
of tasks. It builds graphical workflow based on third party tasks,
developed as Shiny modules.

This document covers the description and the use of the user interface
provided by MagellanNTK. It starts with a general overview of workflows
and their principles. Then , it focuses on the User Interface of
`MagellanNTK`.

For a more complete (and technical) information about MagellanNTK, it is
advised to see the `Inside MagellanNTK`

### Main features

MagellanNTK is a highly configurable workflow manager that offers a
qualitative workflow manager and follows a simple but robust strategy.
It allows you to work with data in the `MultiAssayExperiment` format as
well as data derived from it (e.g., `QFeatures`). As a result, it can
process and analyze experimental data from a wide variety of
disciplines. MagellanNTK uses the data structure provided by the
`MultiAssayExperiment` package, which allows experimental data resulting
from a series of processes to be stored. The results of the various data
processing operations are added to the current dataset so that a single
result file contains the information from the entire analysis.

The pipelines used with MagellanNTK are plugins in the form of Shiny
modules, whose code is stored in a directory specific to each pipeline.
These plugins are added to MagellanNTK when the application is launched.
The structure of these directories is described in the document ‘Inside
MagellanNTK’. MagellanNTK can run either a complete pipeline (with all
of its processes) or a single process. The latter option is useful for
developing a new process or for faster, more targeted data handling.

One of the key features of MagellanNTK is its high degree of
customization. To achieve this, Shiny modules are extensively used to
simplify the implementation. “Generic functions” in MagellanNTK are
functions that can come from MagellanNTK itself (by default), from
plugins containing pipelines, or from other packages. The choice of
these functions is specified in the configuration file (named
config.txt) for each plugin. In the example plugin provided in
MagellanNTK, we see that all these functions point to MagellanNTK
functions (default value).

## Discovering MagellanNTK

MagellanNTK is a R package which proposes a framework to navigate
between steps of a complex data processing tool when the sequence of
processes is mostly chronological.

For example, if a process is composed of three steps, then it is very
easy to run the first step, then the second and finally the last one. It
is like a dataflow manager.

Moreover, this navigation system, which is at the core of MagellanNTK,
can be used at several levels. It is then possible to define, for
example, a super-process (i.e. a pipeline) in which each step is a whole
process containing itself several steps.

### Pipelines, processes and steps

As any workflow manager, the aim of `MagellanNTK` is to execute a series
of ordered tasks over a dataset. The core of the datamanager implements
rules of navigation through the pipeline and processes which ensure the
quality of the whole analysis. This is intended to guide the user
through a validated statistical analysis workflow.

In MagellanNTK, a process is defined as a data analysis process that
performs a minimal and consistent set of operations (called ‘steps’) on
a dataset. Each process has its own input object and returns an object
as output.

In the MagellanNTK lexicon, a workflow (or pipeline) is a set of steps
for processing and analyzing a dataset. Each of these steps (or
processes) can also be composed of one or more sub-steps.

In the example provided with the `MagellanNTK` package, the pipeline is
called “PipelineDemo”. It contains 3 data processing steps:
DataGeneration (which contains 1 step), Preprocessing (with 2 steps:
Filtering and Normalization) and Clustering.

The input and the output of a process is an instance of
`MultiAssayExperiment` (MAE) which contains one or several
`SummarizedExperiment` (SE). The dataset is processed through a sequence
of treatments (defined by the steps) in a classical way for a workflow
manager:

- The steps of a process can be represented as a directional graph with
  no no branches nor cycles. This ensures that the sequence of steps can
  only be executed in a predefined order.
- Each step takes the full dataset as input, but the treatment is
  performed on the last SE instance.
- The output of any step is the same dataset as the input, but with an
  additional SE which corresponds to the result of the operations made
  in that step.

By default, any step can be skipped during the process. So as to ensure
the quality of the process and for mathematical reasons, we introduced a
tag ‘mandatory’ to indicates if a step can be skipped or not. While a
mandatory step is not validated, all subsequent steps are disabled. Once
the mandatory step has been validated, all the following steps are
enabled until the next mandatory one, if there is one.

The implementation of such features is made by mean of *properties* on
steps. Actually, four tags refines the possibilities of a step:

- **Mandatory**: indicates whether a task must be executed to be able to
  continue the workflow.

- **Done-Validated/Undone**: indicates whether a step has been executed
  and validated. If the final step (‘Save’) of a process is validated,
  the MAE dataset is returned with an additional SE compared to the
  input. All features in the MagellanTK UI (Exploratory Data Analyzer,
  ‘Save as’) are updated with this new dataset.

- **Skipped**: indicates whether a task has been skipped (i.e. it is not
  validated and there is at least one step further that has been
  validated). This is only possible with non-mandatory steps.

- **Enabled/disabled**: indicates whether the task is executable (UI is
  enabled or disabled).

Each time a step is validated, a new SE is added to the dataset. This
new dataset is then used as input for the following steps.

### Rules of navigation

Some rules are applied to guarantee the global strategy of the workflow
and the quality of the analysis process. This point is important to
understand the possibilities of navigation with MagellanNTK.

When the application is launched, no dataset is loaded. Consequently,
all pipelines, processes, and steps remain disabled until a dataset is
provided. Once a dataset is loaded, it is passed to the pipeline and the
analysis can begin.

**Start workflow at the beginning**.  
At the beginning, the first step (‘Description’) is the only one
enabled. This guarantees to always start from the first step. In the
timeline of the pipeline, the Description step is marked as VALIDATED
because the dataset already contains some information from the ‘Convert’
process.

**One way direction**. Tasks are executed sequentially in a single
direction, from the first to the last.

**A task operates on the most recent SE in the dataset**. As the results
of tasks are stored (SE) in the dataset in the order they have been
produced, the tasks are run over the last SE of the dataset. When a task
produces a new results (SE), it is appended to the end of the dataset
(MAE).

**Run tasks once.** Once a task has been validated, it is marked as DONE
and becomes DISABLED. This feature guarantees that the user cannot run
the same task multiple times on a SE. The only possibility is to reset
the task to restart it. (see xxx).

**Validating a task.** When a task is validated, its state becomes
disabled and all further tasks until the next mandatory one are
automatically enabled.

**Enabled/disabled tasks**. A task is marked as ENABLED because a rule
allow it to be executed at this time. This happens when:

- There is a previous task marked as VALIDATED and there is no MANDATORY
  and UNDONE task between them.
- A dataset has been loaded in MagellanNTK.

**Reset action**. Regardless of whether we consider a pipeline or a
process, the ‘Reset’ strategy is the same. Only the current task can be
reset. Resetting the current task also reset all further tasks. This
feature ensures the tasks are processed only once. When a task is
resetted (the current and any further one), several actions are done: \*
the dataset is resetted to its initial state at the beginning of the
task. Typically, it will only contain the results of previous validated
tasks. \* The UI of the task is re-enabled. \* The widgets go back to
their default values.

**Reset a sub-step of a process**. This is not implemented The only
possibility is to reset the whole process.

**Reset a process**. This can be done by clicking on the Reset button in
the command panel of the process.

**Reset an entire pipeline**. \* In the pipeline command panel, there is
no ‘Reset’ button. To reset a pipeline, the user goes back to the first
step (by clicking enough times on the ‘Prev’ button or by clicking on
the ‘Go back to start’ button). then, switch to the command panel of the
first task (on the vertical timeline) and click on the Reset button.

**Navigation between steps.** It is always possible to navigate between
all the steps event if they are disabled. This feature is useful if one
wants to see/discover the content of next steps or to remind the values
set in the previous widgets.

### Timelines

Timelines are a graphical representation of the set of steps which
compose the process or pipeline. Each node of the timeline is
represented by a bullet with its name. The style of bullets (the fill
color and the line) depends on the state of the corresponding step.

The available states are the following:

|                  Bullet                  |   Property    |  State   | Done/Undone |
|:----------------------------------------:|:-------------:|:--------:|:-----------:|
| ![](figs/bullet_empty_red_disabled.png)  |    Skipped    | Disabled |   Undone    |
| ![](figs/bullet_empty_red_disabled.png)  |   Mandatory   | Disabled |   Undone    |
|  ![](figs/bullet_empty_red_enabled.png)  |   Mandatory   | Enabled  |   Undone    |
| ![](figs/bullet_full_green_disabled.png) |      \-       | Disabled |    Done     |
| ![](figs/bullet_empty_red_disabled.png)  | Not mandatory |          |   Undone    |

At any time, the current step is identified by an underline below the
name of the step. The first step is always the current step at the
beginning of a process (launch) and after the ‘Reset’ action.

### Special case: Already-processed datasets

These are datasets that have already been processed by MagellanNTK and
may contain more than one `SummarizedExperiment`.

### First sight of the user interface

The MagellanNTK package is essentially based on the `shinydashboard`
package and has been adapted to simplify it (the header and control bar
on the right have been removed). The user interface consists of two
parts: the sidebar on the left and the main screen.

- Sidebar on the left containing the general menus.
- Main part that displays the workflow manager.

**Sidebar menu**. The sidebar contains the main menus. It expands when
the mouse hovers over it and retracts otherwise. The different menus are
as follows:

- Home: provides general information about MagellanNTK. By default,
  content is minimal.

- Dataset:

  - Open file: allows you to select a dataset to work on.
  - import: allows you to convert a results file into a format
    compatible with MagellanNTK.
  - Save as: displays the module called `download_dataset`, which allows
    to export the current dataset. The native MagellanNTK module allows
    exporting in .rdata format. This module is one of the configurable
    modules.

- Workflow:

  - Run: displays the data manager interface. This interface is
    displayed even if there is no dataset, but at that point, all
    widgets are disabled. They are enabled according to the logic
    implemented in this manager.
  - FAQ: opens an Rmd file for FAQ for the current pipeline. This file
    must be stored in the `md` directory within the folder of a
    pipeline.
  - Manual: displays the user manual for the current pipeline.
  - Release notes: displays the release notes file for the current
    pipeline.

**Main screen** The interfaces linked to the menu items are displayed in
the main screen. Specifically, the data manager will be displayed in
this main section. More details are provided later in this document.
This display is visible when you click on the Workflow/Run sidebar menu.
At this stage of the document, as no dataset has been loaded yet, all
workflow interfaces are disabled. However, the user can still navigate
in the pipeline to discover the various processes and parameters
available.

The user interface provided by MagellanNTK allows to work with processes
and pipelines as well. Thus, the interfaces for processes and pipelines
are very similar and share a lot of features. For this reason, this
section mainly focuses on a process workflow. Describing more complex
structures will be easier.

### Process user interface

The interface for a single process is mainly divided into two parts:

- A sidebar on the left which is always visible.
- All remaining space to show results (tabs, plots and any other stuff).

The sidebar itself always consists of three regions:

- **commands**: shows a panel containing five buttons which allow to
  interact and navigate through the different steps of the process:
  - Previous: xxx.
  - Reset: xxx.
  - Run: xxx.
  - Run and Proceed: xxx.
  - Next: xxx.
- **timeline** which represent the sequence of tasks composing the
  process, placed in the order they can be executed (from top to
  bottom).
- **parameters** of the current screen.

#### Parameters

In this part of the sidebar are displayed the parameters corresponding
to the current step. They are enabled or disabled whether the sate of
their step: if the step is disabled (resp. enabled), the widgets are
disabled (resp. enabled).

If the bullet of a step is enabled then all the widgets of this step are
enabled (as well as the Run buttons). In the contrary, a bullet that is
disabled means that all the widgets and the ‘Run’ buttons in the UI are
disabled.

### Process user interface

XXX

## Running a single process

For this section, we suggest following an example provided in
MagellanNTK to familiarize the user with the interfaces and how they
work). We guide the user step-by-step through using the MagellanNTK
interface and performing initial data processing. The example process
used is PipelineDemo_Preprocessing.

### Start the app

Plugins (or processes) for MagellanNTK are not directly installed in the
package. Plugin files are located in a special directory (see the
document ‘Inside MagellanNTK’) that can be stored elsewhere: this can be
on a user’s computer, in another R package.

To use a given plugin with MagellanNTK, its access path must be
specified via a parameter of the
[`MagellanNTK()`](https://edyp-lab.github.io/MagellanNTK/reference/magellanNTK.md)
function. For greater ease of use, it is possible to create a specific R
script to run a given plugin. In the following code, we have the
contents of a file called ‘PipelineDemo_Preprocessing.R’ which launches
MagellanNTK with the ‘Preprocessing’ module contained in the
‘PipelineDemo’ demonstration plugin (or pipeline).

First, we launch the application using the following commands:

``` r
library(MagellanNTK)
wf.name <- 'PipelineDemo_Preprocessing'
wf.path <- system.file('workflow/PipelineDemo', package = 'MagellanNTK')
MagellanNTK(wf.path, wf.name)
```

This will open a new tab in your default web browser. The default UI of
MagellanNTK is quite empty. The first action to perform is to load a
dataset. This can be done by clicking on the menu “Dataset” -\> “Open
file”. If you haven’t exported a dataset from MagellanNTK yet, select
the “demo datasets” option to choose one of the datasets included in the
`MagellanNTK` package. For this tutorial, we select the ‘lldata’ dataset
which consits of one SE containing an empty matrix as assay.

Once the dataset is loaded, click the menu “Workflow/Run” to launch the
plugin. In the main screen, its interface is displayed.

### User interface

#### Commands

**Previous**. A click on the ‘Prev’ button moves the cursor in the
timeline backward to enables the previous step. If the current step is
the first one, then the previous button is disabled.

**Reset**. This button is used to reset the entire process (all its
steps) to its initial state. Several actions follow:

- The dataset that has been loaded in the process is kept.
- All the analysis that may have been done are deleted. Thus, the
  bullets in the timeline go to the ‘UNDONE’ state, no matter what their
  state is at the moment the Reset button is clicked.
- The current step becomes the first one (the cursor in the timeline
  goes under the first step).
- All the widgets in each step are set to their initial values and
  become disabled (until a dataset is launched in the process).

**Run**. This action performs the analysis with the selected parameters.
If there are no sufficient parameters to perform the analysis, no
analysis is done and a modal info is displayed and invite the user to
adjust the parameters. Once the action has been done, the bullet in the
timeline changes its state and pass to ‘DONE’. After this calculation,
the current step stay unchanged to allow the user to view the result of
its action on the dataset. This button is disabled if the current step
is disabled (DONE or SKIPPED).

**Run and Proceed**. This is the same as the “Run” button but if the
calculation succeeded, the current step automatically goes to the next
step. This method is quicker than the previous one but has the
disadvantage that the user can not immediatly view the results and has
to click on the ‘Prev’ button to do so.

**Next**. Clicking on the ‘Next’ button moves the cursor in the timeline
forward to select the next step. If the current step is the last one,
then the next button is disabled

**Back to start** As we will see later in the document, pipelines have
only three commands : the already-known ‘Prev’ and ‘Next’, which have
the same function for a process or a pipeline, and another commands
called ‘Back to start’ which set the first step of a pipeline as the
current one (the underline goes under its name).

## Running a pipeline workflow

In this section, we describe how to use a pipeline workflow. As for the
process workflow, this is a step-by-step guide to be more familiar with
the interface. It can be followed by typing the following command in a R
console:

``` r
library(MagellanNTK)
wf.name <- 'PipelineDemo'
wf.path <- system.file('workflow/PipelineDemo', package = 'MagellanNTK')
MagellanNTK(wf.path, wf.name)
```

**Launch a pipeline**

When launching a pipeline workflow, two timelines appear: one for the
pipeline itself, at the top and the other which is embedded in the UI of
the process.

Note that the process called ‘Description’ of a pipeline does not have
any steps besides a Description one. This is an exception to the rule
that any process have at least one real step.

### User interface

In the case of a pipeline, the principle is the same. In the example in
Fig. xxx, the pipeline called ‘PipelineDemo’ has four steps
(Description, DataGeneration, Preprocessing and Clustering). Remark that
the content of the UI area of the pipeline is exactly the whole UI of
its current process (e.g. in Fig @ref(fig:layout)).

![(a) Horizontal layout, (b) Vertical layout](./figs/layout.png)

1.  Horizontal layout, (b) Vertical layout

Note that in a pipeline timeline, the first step is still ‘Description’
and the last step is called ‘Save’, as it is the case for any process
timeline. The ‘Save’ is technically not necessary as there is already a
‘Save’ step in the last process. Thus, when the user save its work in
the last process of the pipeline, this will automatically save the whole
object and return it to the caller program.

In the next figure (@ref(fig:demopipeline5)), the user has skipped
DataGeneration, has validated all sub-steps of Preprocessing and he is
ready to validate the Preprocessing process. Once done, the bullet for
Preprocessing will change to ‘Done’ and the bullet for ‘DataGeneration’
will change to ‘skipped’. This is the same behaviour as in
single-process workflows.

When using a pipeline level, there is only one ‘Reset’ button. If the
Reset button of a process is clicked, that affects the current process,
as well as all processes that may have been validated further.

**Resetting a pipeline**

If the Reset button is clicked while on the ‘Description’ process, this
will set back the entire pipeline to its default values. The object is
set back to the beginning, i.e. all the datasets added by the different
processes are deleted. In the pipeline’s timeline, the first step
(‘Description’) becomes the current one.

If the user goes backward on a previous step and validate this step,
then the following steps are automatically set to ‘UNDONE’ and have to
be rerun. This guarantees that the steps are always done in the same
order. This feature must be implemented in each module source code. It
cannot be coded in the navigation module (recursive loop on the listener
of isDone vector)

Similarly to a process, a pipeline is a workflow defined as a sequence
of processes (Fig @ref(fig:pipelineEV)). Thus, the way a pipeline works
is very similar to a process behaviour:

- Each process (task of a pipeline) in a pipeline has tags and
  properties (See xxx).

- There is a list of datasets in input and a list of datasets at output.

As shown in xxx, a pipeline is at third level of such a structure.

![A pipeline is a sequence of processes (eclated
view).](./figs/pipeline.png)

A pipeline is a sequence of processes (eclated view).

#### Commands

Three buttons are available to interact with the whole current step and
navigate through the different steps of the process:

![Commands (Previous step, Reset workflow, Next
step.](./figs/commands.png)

Commands (Previous step, Reset workflow, Next step.

- **Prev** changes the current step to set the previous one. This button
  is enabled only if there is at least one step backward,

- Similarly, **Next** (on the right) changes the current step to set the
  next one on the timeline. This button is enabled only if there is at
  least one step forwards,

- **Reset** sets the workflow in its original state: all the widgets are
  set to their default value, the current step becomes the first one and
  is enabled and all other steps become disabled).

### Rules

xxx

### Already-processed datasets

XXX

### Example (PipelineDemo)

#### Overview

The ‘PipelineDemo’ example pipeline is provided with the `MagellanNTK`
package. It contains three data processing steps:

- **DataGeneration**: creates a dataset using two Gaussian
  distributions.
- **Preprocessing**: contains two sub-steps:
  - **Filtering**: filter the rows based on the average or sum of their
    values.
  - **Normalization**: normalize the columns using the sum or average of
    the values in the column.
- **Clustering**: cluster the data in order to identify the two Gaussian
  distributions used to generate it.

Note that the ‘Description’ and ‘Save’ steps are not strictly speaking
data processing steps. The description step displays the contents of a
file in the workflow directory and allows you to view information about
the pipeline. The last step, ‘Save’, allows you to directly access the
module for downloading the processed dataset (the same as if you went
through the “Save as” sidebar).

‘PipelineDemo’ can be launch by typing the following command in a R
console:

``` r
library(MagellanNTK)
wf.name <- 'PipelineDemo'
wf.path <- system.file('workflow/PipelineDemo', package = 'MagellanNTK')
MagellanNTK(wf.path, wf.name)
```

------------------------------------------------------------------------

### Pipeline

### Interface of a step

The interface for each step contains the graphical elements implemented
by the developer of the workflow such as widgets, plots, textual
information, etc…).

MagellanNTK adds only one button to each interface: the Perform button.
This command is used to validate the step and trigger all the updates in
the workflow (disabling the current step, enabling further ones,
changing the style of bullets, etc..).

## Running a process workflow

This section aims at describing how to use the workflow UI when
processing a dataset. The goal is not to describe the different data
processing tools available but to explain the behaviour of the user
interface of what we call ‘MagellanNTK core’. The next of the section is
a step-by-step guide of working with he UI worklfow. It can be followed
by typing the following command in a R console:

``` r
library(MagellanNTK)
demo_workflow('PipelineA_Process1')
```

The workflow used in this tutorial is a process called ‘Process 1’ which
contains four steps: *Step1* and *Step2* are third party code and
specific to the process while the steps *Description* and *Save* are
added by MagellanNTK for xxx purpose. By default, it comes with a
horizontal layout.

**Starting the workflow**

Once the workflow manager is launched, a window containing the Shiny
application opens (Fig @ref(fig:demo1)). The current task is the first
one (‘Description’) and is enabled. At this time, the other steps are
yet disabled (this is because th Description step is mandatory and none
of the further steps is enabled until this steps is validated).

![UI process](./figs/demo_1.png)

UI process

However, it is possible to view the content of the other steps even if
they are disabled (Fig @ref(fig:demo12)).

![UI process](./figs/demo_1_2.png)

UI process

**Validating the ‘Description’ step**

The validation of the step (See Fig @(ref-fig:demo13) (by a click on the
‘Start’ button) leads to some changes:

- the bullet of the step change from ‘Undone’ to ‘Done’.

- The current step becomes disabled (all its widgets disabled). The
  forwarding steps are enabled if they respect the rule
  **‘Enabling/disabling tasks’** (See Section
  @ref(rules-of-navigation)). In this example, the steps ‘Step 1’ and
  ‘Step 2’ are enabled but not the step ‘Save’ because it is placed
  after a non-validated mandatory step.

![UI process](./figs/demo_1_3.png)

UI process

**Go to next step**

The user switches to ‘Step 1’ by clicking on the ‘Next’ button. It
becomes the new current step (Fig @ref(fig:demo2)).

![New current step](./figs/demo_2.png)

New current step

In this use case, one skip this step. The user do not click on the
‘Perform’ button and switch to the next step (‘Step 2’) by clicking on
the ‘Next’ button. The user set it own values to the widgets and then
validate his choices by clicking on the button ‘Perform’.

![UI process](./figs/demo_3.png)

UI process

The changes are the following (See Fig @ref(fig:demo33)):

- As for all current steps, the entire interface switch to a disabled
  state,

- the bullet changes to the style of Validated steps

- the next steps become enabled. In this case, there is only one last
  step (‘Save’)

- the style of bullets for previous steps is updated if necessary
  (e.g. ‘Step 1’ switch to the bullet ‘skipped’. Note: A step is really
  marked as skipped only if it has not been validated and a further one
  is validated. That means that one can begin to modify the widgets in a
  step *n*. If the user do not validate it and go to another step
  (*\>n*), then the values of the step *n* will be forgotten.

If one go back to the previous step (the one we have skipped), we can
see a blue area which informs the user that this step has been skipped
(it has been disabled even with no validation). As a skipped step is
disabled, it is not possible to run it despite resetting the whole
workflow and start it again from scratch. This is only true for
processes. We will see that the workflows for pipelines are a bit more
flexible.

![UI process](./figs/demo_3_3.png)

UI process

**Saving workflow result**

The last step ‘Save’ is now enabled (by the validation of the previous
step). It is time to save th result of the workflow by clicking on the
‘Save’ button (Fig @ref(Fig:demo4)). This will result in appending the
new dataset to the list of datasets passed as input to the workflow.

![UI process](./figs/demo_4.png)

UI process

Once this step has been validated, all the steps of the workflow are
disabled.

**Reset a process**

In the workflow of a process, it is not possible to reset one individual
step so as to restart the analysis from this particular step. In this
case, if the user wants to redo one or more steps, it has to reset the
entire workflow. This can be done by clicking on the button ‘Reset’
which set the workflow in its default state (the same state as when the
user launches the workflow). The list of datasets return to the one at
the beginning of the workflow. The reset can be done on every step. A
popup warns the user of the effects (Fig @ref(fig:demoreset)).

![UI process](./figs/demo_reset.png)

UI process

## Session information

``` r
sessionInfo()
```

    ## R version 4.5.2 (2025-10-31)
    ## Platform: x86_64-pc-linux-gnu
    ## Running under: Ubuntu 24.04.3 LTS
    ## 
    ## Matrix products: default
    ## BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
    ## LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.26.so;  LAPACK version 3.12.0
    ## 
    ## locale:
    ##  [1] LC_CTYPE=C.UTF-8       LC_NUMERIC=C           LC_TIME=C.UTF-8       
    ##  [4] LC_COLLATE=C.UTF-8     LC_MONETARY=C.UTF-8    LC_MESSAGES=C.UTF-8   
    ##  [7] LC_PAPER=C.UTF-8       LC_NAME=C              LC_ADDRESS=C          
    ## [10] LC_TELEPHONE=C         LC_MEASUREMENT=C.UTF-8 LC_IDENTIFICATION=C   
    ## 
    ## time zone: UTC
    ## tzcode source: system (glibc)
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ## [1] BiocStyle_2.38.0
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] digest_0.6.39       desc_1.4.3          R6_2.6.1           
    ##  [4] bookdown_0.46       fastmap_1.2.0       xfun_0.56          
    ##  [7] cachem_1.1.0        knitr_1.51          htmltools_0.5.9    
    ## [10] rmarkdown_2.30      lifecycle_1.0.5     cli_3.6.5          
    ## [13] sass_0.4.10         pkgdown_2.2.0       textshaping_1.0.4  
    ## [16] jquerylib_0.1.4     systemfonts_1.3.1   compiler_4.5.2     
    ## [19] tools_4.5.2         ragg_1.5.0          bslib_0.10.0       
    ## [22] evaluate_1.0.5      yaml_2.3.12         BiocManager_1.30.27
    ## [25] otel_0.2.0          jsonlite_2.0.0      rlang_1.1.7        
    ## [28] fs_1.6.6            htmlwidgets_1.6.4
