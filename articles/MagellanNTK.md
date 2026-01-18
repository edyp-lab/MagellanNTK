# MagellanNTK user manual

Abstract

The R package MagellanNTK (Magellan Navigation ToolKit) is a workflow
manager using Shiny modules. It is the perfect companion package to
build workflows and integrate them in your UI or run it standalone.

## Introduction

The package MagellanNTK provides the infrastructure for the
configuration, the execution and the surveillance of a defined sequence
of tasks. It builds graphical workflow based on third party tasks,
developed as Shiny modules. As a Shiny application itself, MagellanNTK
runs standalone or embebbed in another Shiny application, as it is the
case with the package [Prostar 2](https://github.com/edyp-lab/Prostar2).

This document covers the description and the use of the user interface
provided by MagellanNTK. It starts with a general overview of workflows
and their principles. Then , it focuses on the User Interface of
`MagellanNTK`.

A more complete (and technical) information of how MagellanNTK works can
be www or if you intent to develop workflows or pipelines for
MagellanNTK, it is advised to see the xxx.

To go further in technical details, please refer to:

- ‘Configure MagellanNTK’

- Build a pipeline module

- Create a new pipeline tutorial

- Create complex workflow

- Inside MagellanNTK

## Installing and launching MagellanNTK

This is described in the README.

## Discovering MagellanNTK

The package MagellanNTK is based on the `shinydashboard` package. In
that sense, the user interface is composed of four parts:

- Sidebar
- Control bar
- Header panel
- Main part

### User interface

![A single task composed of data analysis functions and user
interface.](figs/MagellanNTK_annote.png)

A single task composed of data analysis functions and user interface.

### Sidebar

### Control bar

The control bar contains features to control the global behaviour of the
interface.

Console: A clikc on that link open the browser() in the R console which

### Header panel

### Main part

### Builtin functions

The package `MagellanNTK` comes with a series of generic functions, used
to do some basic tasks. These functions are the following:

- convert_dataset(): A Shiny module to convert any dataset to a format
  suitable for the pipeline used.
- open_dataset(): xxx
- open_demoDataset(): xxx
- view_dataset(): xxx
- infos_dataset(): xxx
- download_dataset(): xxx
- addDatasets(): xxx
- keepDatasets():

Each of these functions are Shiny modules and are loaded by default when
MagellanNTK is run.

These functions can be overridden by similar functions int third party
packages which contains workflows to be run with MagellanNTK.Learn more
on customizing these functions in xxx

## Workflow overview

As a workflow manager, the aim of `MagellanNTK` is to execute a series
of ordered tasks over a dataset.

### Single task

In MagellanNTK, a task (or step) is defined as a data analysis process
that performs a minimal and consistent in a set of operations on a
dataset (see Fig @ref(fig:singleTask)) and a user interface based on
Shiny modules. Each task has also its own input object and returns an
object as output. Within MagellanNTK, those objects are *lists* in which
each item is a dataset (several formats are possible).

![A single task composed of data analysis functions and user
interface.](figs/singleTask.png)

A single task composed of data analysis functions and user interface.

The data analysis process do not necessarly modify the input dataset,
for example in case of a visualization task the input object and the
output objects are the same.

A single task is the simplest workflow that may exist.

### Process

A more complex workflow consists in a sequence of several tasks, what
defines here a *process*. Processes are implemented as Shiny
applications and embed the functions and UI of each of their single
tasks.

![A process is a sequence of single tasks.](figs/process.png)

A process is a sequence of single tasks.

As for single tasks, a process take a list of datasets as input, execute
a series of tasks on the last dataset of the list (the more recent),
then returns a list of datasets. The output list may be:

- identical to the input list (same datasets) if the process did not
  modify it (vizualization functions for example),

- different if the program modifies the data. In this case, MagellanNTK
  adds the modified dataset to the end of the list of datasets rather
  than just updating the last dataset. The new list has one more
  dataset.. Thus, at any time, the list of datasets keeps the entire
  history of what happened to datasets.

In a process workflow, the sequence of tasks is one-way: it always
begins from the first task and ends up at the last one. The simplest
sequence of tasks is the one where each task is executed once, after its
previous neighboor has been executed. However, it may be interesting to
introduce some additional rules to customize this sequence of tasks. As
for example, a given task may be facultative (eventually under some
condition) while another one will be mandatory. The implementation of
such features is made by mean of *properties* on tasks. Actually, four
tags refines the possibilities of a task:

- Mandatory: indicates whether a task must be executed to be able to
  pursiue the workflow.

- Done: indicates whether a task has been executed

- Skipped: indicates whether a task has been skipped (i.e. it is not
  validated and there is at least one task further that has been
  validated)

- Enabled: indicates whether the task is runnable (UI is enabled or
  disabled).

In MagellanNTK, tasks are tagged with a combination of these four tags.
Different styles are used to identify them in the user interface (See
Tab xxx)

### Pipeline

Similarly to a process, a pipeline is a workflow defined as a sequence
of processes (Fig @ref(fig:pipelineEV)). Thus, the manner of pipeline
works will be very similar to a process behaviour:

- each process (task of a pipeline) in a pipeline has tags and
  properties (See xxx)

- there is a list of datasets in input and get a list of datasets at
  output

As shown in xxx, a pipeline is at third level of such a structure.

![A pipeline is a sequence of processes (eclated
view).](figs/pipeline.png)

A pipeline is a sequence of processes (eclated view).

### Rules of navigation

Some rules are applied to a workflow to guarantee the global strategy of
the workflow. This point is important to understand the possibilities of
navigation with MagellanNTK.

**Start workflow at the beginning**. When launching a workflow, the
first task is the only enabled task. This guarantees to always start
from the first one.

**One way direction**. The order in which tasks are executed is in one
direction: tasks are executed from the first one towards the last one.
Each iteration of time is a xxx. It is not possible de go back or rerun
a task that has already been validated (exception if reset, see xxx).

**Chronological order of datasets in the list**. The input object of a
workflow is a list of datasets but the workflow operates only on the
last one (the most recent one). When a workflow produces a new dataset,
this one is added at the end of the list.

**Tasks run once.** In the same way, once a task has been validated, it
becomes disabled. This is to avoid to rerun a task. In this case, that
would mean that a task could modify its own result (modify the dataset
it has already produced). This case is not possible in MagellanNTK

**Validating a task.** When a task is validated, its state becomes
disabled ans all the further tasks until the next mandatory one are
automatically enabled.

**Enabling/disabling tasks**. A disabled task means there is a rule
which do not allow it to be executed at this time. A task at rank *n* is
enabled if there is a previous task with rank *i* (*i \< n*) that has
been validated and if there is no mandatory task of rank *j* (with *i \<
j \< n*) that is not validated.

**Resetting tasks**. It is not possible to reset single tasks (the lower
level of tasks). Only whole processes and pipelines can be reseted. For
more details, see xxx.

**Navigation between steps.** It is always possible to navigate between
all the steps event if they are disabled. This feature is useful if one
wants to see/discover the content of next steps or to remind the values
set in the previous widgets.

## User interface

### Layout

The user interface provided by MagellanNTK allows to work with processes
and pipelines as well. Thus, the interfaces for processes and pipelines
are very similar and share a lot of features. For this reason, this
section mainly focuses on a process workflow. Describing more complex
structures will be easier.

The generic layout is composed of three areas (Fig xxx):

- A **timeline:** which represent the sequence of tasks composing the
  process, placed in the order they might be executed (from the left to
  the right). The timeline may be horizontal (Fig xxx a) or vertical
  (Fig xxx b)

- A **commands** panel (in two parts) containing three buttons (Next,
  Previous, Reset) which allow to interact and navigate through the
  different steps of the process.

- **UI of the current task** which is a third party code.

In the case of a pipeline, the principle is the same. In the example in
Fig. xxx, a pipeline called ‘Pipeline A’ has four steps (Description,
Process 1, Process 2 and Process 3). Remark that the content of the UI
area of the pipeline is exactly the whole UI of its current process
(e.g. in Fig @ref(fig:layout)).

![(a) Horizontal layout, (b) Vertical layout](figs/layout.png)

1.  Horizontal layout, (b) Vertical layout

Note that in a pipeline timeline, the first step is still ‘Description’
but there is not more step called ‘Save’ as it is the case for any
process timeline. The reason is because it is not necessary anymore due
to the fact that a ‘Save’ step exists in the last process. Thus, when
the user save its work in the last process of the pipeline, this will
automatically save the whole object and return it to the caller program.

### Timeline

In the timeline, steps are represented by bullets linked by lines. The
style of both bullets and line depends on the state of the corresponding
step. If the bullet of a step is enabled then all the widgets of this
step are enabled (as well as the Perform button). In the contrary, a
bullet that is disabled means that all the widgets and the ‘Perform’
button in the UI are disabled.

![Timeline example.](figs/timeline.png)

Timeline example.

At any time, the current step is marked with an underline below the name
of the step.

|                  Bullet                  |   Property    |  State   | Done/Undone |
|:----------------------------------------:|:-------------:|:--------:|:-----------:|
| ![](figs/bullet_empty_red_disabled.png)  |    Skipped    | Disabled |   Undone    |
| ![](figs/bullet_empty_red_disabled.png)  |   Mandatory   | Disabled |   Undone    |
|  ![](figs/bullet_empty_red_enabled.png)  |   Mandatory   | Enabled  |   Undone    |
| ![](figs/bullet_full_green_disabled.png) |      \-       | Disabled |    Done     |
| ![](figs/bullet_empty_red_disabled.png)  | Not mandatory |          |   Undone    |

### Commands

Three buttons are available to interact with the whole current step and
navigate through the different steps of the process:

![Commands (Previous step, Reset workflow, Next
step.](figs/commands.png)

Commands (Previous step, Reset workflow, Next step.

- **Prev** changes the current step to set the previous one. This button
  is enabled only if there is at least one step backward,

- Similarly, **Next** (on the right) changes the current step to set the
  next one on the timeline. This button is enabled only if there is at
  least one step forwards,

- **Reset** sets the workflow in its original state: all the widgets are
  set to their default value, the current step becomes the first one and
  is enabled and all other steps become disabled).

### Interface of a step

The interface for each step contains the graphical elements implemented
by the developer of the workflow such as widgets, plots, textual
information, etc…).

MagellanNTK adds only one button to each interface: the Perform button.
This command is used to validate the step and trigger all the updates in
the workflow (disabling the current step, enabling further ones,
changing the style of bullets, etc..).

## Process workflow

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

![UI process](figs/demo_1.png)

UI process

However, it is possible to view the content of the other steps even if
they are disabled (Fig @ref(fig:demo12)).

![UI process](figs/demo_1_2.png)

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

![UI process](figs/demo_1_3.png)

UI process

**Go to next step**

The user switches to ‘Step 1’ by clicking on the ‘Next’ button. It
becomes the new current step (Fig @ref(fig:demo2)).

![New current step](figs/demo_2.png)

New current step

In this use case, one skip this step. The user do not click on the
‘Perform’ button and switch to the next step (‘Step 2’) by clicking on
the ‘Next’ button. The user set it own values to the widgets and then
validate his choices by clicking on the button ‘Perform’.

![UI process](figs/demo_3.png)

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

![UI process](figs/demo_3_3.png)

UI process

**Saving workflow result**

The last step ‘Save’ is now enabled (by the validation of the previous
step). It is time to save th result of the workflow by clicking on the
‘Save’ button (Fig @ref(Fig:demo4)). This will result in appending the
new dataset to the list of datasets passed as input to the workflow.

![UI process](figs/demo_4.png)

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

![UI process](figs/demo_reset.png)

UI process

## Pipeline workflow

In this section, one describes how to use the pipeline workflow. As for
teh process workflow, this is a step-by-step guide to be more familiar
with the interface. It can be followed by typing the following command
in a R console:

``` r
library(MagellanNTK)
demo_workflow('PipelineA')
```

The workflow used in this section is a pipeline called ‘Pipeline A’
which contains four processes as steps: *Process 1, Process 2* and
*Process 3* are third party code and specific to the pipeline while the
first step *Description* is added by MagellanNTK for xxx purpose. By
default, it comes with a horizontal layout.

**Launch a pipeline**

When launching a pipeline workflow, two timelines appear: one for the
pipeline itself and the other which is embedded in the UI of the
processes.

Note that the process called ‘Description’ of a pipeline does not have
any steps besides a Description one. This is an exception to the rule
that any process have at least one real step.

![UI process2](figs/demo_pipeline_1.png)

UI process2

![UI process3](figs/demo_pipeline_1_3.png)

UI process3

In the next figure (@ref(fig:demopipeline5)), the user has skipped
Process1, has validated all steps of Process2 and he is ready to
validate the Process2. Once done, the bullet for Process2 will change to
‘Done’ and the bullet for ‘Process1’ will change to ‘skipped’. One have
the same behaviour as for processes workflows.

![UI process](figs/demo_pipeline_5.png)

UI process

When using a pipeline level, there are two ‘Reset’ Buttons: one for the
pipeline itself and one for the processes. If the Reset button of a
process is clicked, that affects only the current process.

**Resetting a process**

The behavior is the same as for processes (See xxx). The current step
becomes the first one (Description), all the widgets are set to their
default values and are disabled. The current process is still the same.

The process becomes Undone in the timeline of the pipeline and the
dataset is set to the same at before running the process

**Resetting a pipeline**

If the Reset button of a pipeline is clicked, this will set back the
entire pipeline to its default values. The object is set back to the
beginning, i.e. all the datasets added by the processes are deleted. In
the pipeline’s timeline, the first step (‘Description’) becomes the
current one.

If the user goes backward on a previous step and validate this step,
then the following steps are automatically set to ‘undone’ and have to
be rerun. This guarantees that the steps are always done in the same
way. This feature must be implemented in each module source code. It
cannot be coded in the navigation module (recursive loop on the listener
of isDone vector)

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
    ##  [4] bookdown_0.46       fastmap_1.2.0       xfun_0.55          
    ##  [7] cachem_1.1.0        knitr_1.51          htmltools_0.5.9    
    ## [10] rmarkdown_2.30      lifecycle_1.0.5     cli_3.6.5          
    ## [13] sass_0.4.10         pkgdown_2.2.0       textshaping_1.0.4  
    ## [16] jquerylib_0.1.4     systemfonts_1.3.1   compiler_4.5.2     
    ## [19] tools_4.5.2         ragg_1.5.0          bslib_0.9.0        
    ## [22] evaluate_1.0.5      yaml_2.3.12         BiocManager_1.30.27
    ## [25] otel_0.2.0          jsonlite_2.0.0      rlang_1.1.7        
    ## [28] fs_1.6.6            htmlwidgets_1.6.4
