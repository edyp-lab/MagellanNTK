# PipelineDemo User Manual – a vignette template to accompany data analysis pipeline deployed with MagellanNTK

Abstract

This vignette presents the capabilities of the ‘MagellanNTK’ package,
from the perspective of someone using a data analysis workflow built on
top of ‘MagellanNTK’.

## Introduction

### Objectives of the vignette

The package `MagellanNTK` is a Shiny application which provides the
infrastructure for the configuration, the execution and the surveillance
of a defined sequence of computational tasks for data analysis,
hereafter called “pipelines”. It builds graphical pipelines based on
third party packages, developed as Shiny modules.

The main vignette accompanying `MagellanNTK` is referred to as “Build a
pipeline with MagellanNTK” and is intended for bioinformaticians seeking
to deploy application-specific pipelines using `MagellanNTK`; and which
will subsequently be used by a pool of data analyst. Such
application-specific pipelines may be complex enough to require their
own vignette, explaining both the specificities of the pipeline, and
some general concerns that are shared by all MagellanNTK-based
pipelines. This vignette mimics such a situation by describing a simple
pipeline termed `PipelineDemo`, which illustrates the capabilities of
`MagellanNTK`. Therefore, this vignette fulfils two goals: First it
provides a literate counterpart to the `PipelineDemo` illustration of
`MagellanNTK` capabilities. Second, it provides a template that can be
used by bioinformaticians deploying a pipeline, so that they can more
easily document it and facilitate its handling by the targeted users.

### Intuitive overview of the PipelineDemo app

Contrarily to most “real” `MagellanNTK` pipelines, which should be build
using third party Shiny modules, the ‘PipelineDemo’ example pipeline is
provided within the `MagellanNTK` package. Its code is stored in the
folder ‘inst/workflow/PipelineDemo’. It is a toy pipeline which allows
the user to generate data, to apply a couple preprocessing, and to
perform cluster analysis. These steps appear in the timeline of the
graphical user interface, where they are preceded by a ‘Description’
step and a ‘Save’ step that respectively define the beginning and the
end of the pipeline.

Before delving into the details of this toy pipeline, let us define some
specific `MagellanNTK` features.

### Installation

To install `MagellanNTK` :

``` r

if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("MagellanNTK")
```

``` r

library(MagellanNTK)
```

    ## Warning: replacing previous import 'S4Arrays::makeNindexFromArrayViewport' by
    ## 'DelayedArray::makeNindexFromArrayViewport' when loading 'SummarizedExperiment'

## MagellanNTK jargon

### Objects

The key terms used throughout this documentation are defined as follow
(Fig. @ref(fig:keytermsOrganisation)) :

- **Pipeline** : The complete structure that includes the workflow along
  with all related elements (e.g., FAQ, Convert module, etc).
- **Workflow** : The ordered sequence of processes of the pipeline.
- **Process or step** : An individual step within a workflow. Each
  process corresponds to a dedicated Shiny module and is implemented in
  its own file.
- **Sub-step** : An individual step within a process. A process may have
  as many sub-step as needed.

![Visual representation of key terms](figs/keytermsOrganisation.png)

Visual representation of key terms

In the example pipeline `PipelineDemo`, `PipelineDemo` refers to the
complete pipeline. Its workflow consists of three data-processing steps,
in addition to an initial Description step and a final Save step. Each
of these steps contains one or more sub-steps (Fig.
@ref(fig:pipelinedemoOrganisation)).

![PipelineDemo's organisation](figs/pipelinedemoOrganisation.png)

PipelineDemo’s organisation

Each step or sub-step can have several associated states, which can
change during the workflow :

- **Mandatory/Not mandatory**: Indicates whether a step or sub-step must
  be completed before continuing the workflow. Mandatory steps cannot be
  skipped. As long as a mandatory step/sub-step remains undone, all
  subsequent steps/sub-steps are disabled. Once validated, the following
  steps/sub-steps become enabled, up to the next mandatory one, if
  applicable.
- **Validated/Undone/Skipped**: Describes the execution status of a step
  or sub-step. A step/sub-step can be validated if completed, undone if
  not yet executed, or skipped if bypassed. Skipping is only possible
  for non-mandatory steps/sub-steps and occurs when a later
  step/sub-step has been validated.
- **Enabled/Disabled**: Indicates whether a step or sub-step can
  currently be executed, i.e., whether its UI is active or inactive.

The state of a step or sub-step can be observed on the timeline (see
Section 2.2).

Workflow steps are always organized linearly, meaning they follow a
predefined order and can only be executed sequentially. However,
non-mandatory steps may be skipped if needed. The same logic applies to
the sub-steps within each process. This structure helps ensure the
consistency and quality of the analysis while guiding users through a
validated statistical workflow.

### Timelines

Timelines provide a graphical representation of the steps that make up a
process or the workflow. Each step is represented by a node displayed as
a bullet labeled with its corresponding name. The appearance of each
node reflects the state of the associated step :

- **Line style** : Solid for enabled steps, dashed for disabled steps.
- **Line color** : Red for mandatory steps, black for non-mandatory
  steps.
- **Fill color** : White for undone steps, green for validated steps,
  and grey for skipped steps.

The possible states are the following :

| Bullet | Property | State | Validated/Undone/Skipped |
|:--:|:--:|:--:|:--:|
| ![](figs/bullet_mandatory_enabled_undone.png) | Mandatory | Enabled | Undone |
| ![](figs/bullet_mandatory_disabled_undone.png) | Mandatory | Disabled | Undone |
| ![](figs/bullet_mandatory_disabled_done.png) | Mandatory | Disabled | Validated |
| ![](figs/bullet_Notmandatory_enabled_undone.png) | Not Mandatory | Enabled | Undone |
| ![](figs/bullet_Notmandatory_disabled_undone.png) | Not Mandatory | Disabled | Undone |
| ![](figs/bullet_Notmandatory_disabled_done.png) | Not Mandatory | Disabled | Validated |
| ![](figs/bullet_Notmandatory_disabled_skipped.png) | Not Mandatory | Disabled | Skipped |

At any point during the workflow, the current step is indicated by an
underline beneath the step name.

Two distinct timelines are displayed in the interface. The first,
located at the top of the screen, is the horizontal workflow timeline,
which contains all steps of the workflow. The second, located in the
process sidebar on the left, is a vertical timeline displaying all
sub-steps of the currently active process. Everything described
previously applies to both timelines.

In the example in Fig. @ref(fig:timelinelayout), the different steps of
`PipelineDemo` are displayed in the horizontal timeline at the top. The
current step is ‘Preprocessing’, indicated by the underline beneath its
name, and its sub-steps are displayed in the vertical timeline on the
left, with ‘Description’ being the current sub-step.

![(a) Horizontal workflow timeline, (b) Vertical step
timeline](figs/timelinelayout.png)

1.  Horizontal workflow timeline, (b) Vertical step timeline

### Navigation

`MagellanNTK` is designed so that every part of a pipeline remains
accessible at all times. However, most of these, including the workflow
itself, are disabled until a dataset is loaded. This ensures that the
analysis can only begin when a valid dataset has been provided.

The workflow always starts with the ‘Description’ step, which must be
validated before subsequent steps become enabled. It then follows a
strictly linear structure, meaning that each step must be executed in a
predefined order, never in parallel or out of order. However, some steps
or sub-steps may be skipped if they are not mandatory.

The navigation in the workflow is flexible. It is always possible to
move between any steps or sub-steps at any time, even if they are
disabled. This makes it possible to explore upcoming steps of the
workflow or look at previous results or parameters, without affecting
the current state or execution of the workflow.

When a step is validated, it is marked as validated and becomes
disabled. At the same time, all subsequent steps are automatically
enabled up to the next mandatory step, if one exists.

A step can only be executed once. If a mistake has been made or the
parameters should be changes, the step must be reset (see Section 4.1).
This restores both the dataset and the step to the state they were in
before the step was run. The step is re-enabled and all widgets return
to their default values. Resetting a step automatically resets all
subsequent steps. Individual sub-steps cannot be reset independently,
only entire step.

If a dataset that has already passed either fully or partially through
the pipeline is loaded, it retains information about which steps and
sub-steps have already been validated. As a result, the workflow
automatically marks those steps as validated and resumes from the next
undone step.

### Data format requirements

`MagellanNTK` relies on `MultiAssayExperiment` (MAE) objects to store
and manage data throughout the pipeline. A MAE can be viewed as a
container that holds one or more datasets, called `SummarizedExperiment`
(SE). At each step, rather than modifying an existing dataset, the
results of the process is added to the MAE as a new SE. As a result, all
intermediate and final results are stored in a single object. Thus, this
structure makes it possible to keep track of the different steps of the
analysis while preserving previous results.

Because the pipeline is built around this format, datasets must be
available as MAE objects before they can be processed. However, it is
not necessary for the original data to already be in this format. The
‘Convert’ process can be configured to import other file types (such as
.csv or .txt) and convert them into a valid MAE, making them compatible
with the rest of the pipeline (see Section 3.5.1).

Along with adding a new SE at the end of each step, the values of the
parameters used during the analysis are recorded in a history table.
This history provides a complete record of the actions performed on the
dataset, making it possible to review the entire analysis and ensure
full traceability of the workflow. Each entry in the history contains
the name of the step, the name of the sub-step, the parameter name, and
its corresponding value.

### General user interface

The user interface is divided into two main sections (Fig.
@ref(fig:mainInterface)) :

- **The main sidebar**, located on the left, which provides access to
  the general menus.
- **The main interface**, which displays the pipeline.

![General user interface : (a) Main sidebar, (b) Main
interface](figs/mainInterface.png)

General user interface : (a) Main sidebar, (b) Main interface

#### Main sidebar

The main sidebar, located on the left side of the general interface,
provides access to the general menus. It automatically expands when the
mouse cursor hovers over it and collapses otherwise. The sidebar is
organized into several main menus, each of which may contains submenus
(Fig. @ref(fig:menuSidebar)).

![The general menus of the main sidebar](figs/menuSidebar.png)

The general menus of the main sidebar

The different menus are as follows:

- **Home** : Displays general information about the pipeline.

- **Dataset** :

  - **Open file** : Allows a dataset to be loaded into the pipeline,
    either from a local file or from an existing dataset provided by a
    selected package.
  - **Import** : Provides access to the conversion module, which can be
    used to transform external data files into a compatible format.
  - **Save as** : Allows the current dataset to be exported.

- **Workflow** :

  - **Run** : Opens the workflow interface. This interface is always
    accessible, even when no dataset has been loaded. In that case, all
    widgets remain disabled until a valid dataset is available.
  - **FAQ** : Displays the FAQ document associated with the current
    pipeline.
  - **Manual** : Opens the user manual for the current pipeline.
  - **Release notes** : Displays the release notes associated with the
    current pipeline.

#### Main interface

The content of the main panel depends on the selected menu. In most
cases, the interface remains relatively simple and contains only a few
elements. However, within a workflow, this interface is more elaborate
and include elements related to the execution and navigation of the
workflow.

The interface within a workflow can be separated in 3 parts (Fig.
@ref(fig:mainInterfaceGeneral)) :

- **Process sidebar**
- **Workflow header**
- **Content area**

![Main interface during a workflow : (a) Process sidebar, (b) Workflow
header, (c) Content area](figs/mainInterfaceGeneral.png)

Main interface during a workflow : (a) Process sidebar, (b) Workflow
header, (c) Content area

##### Process sidebar

The process sidebar can be separated in 3 parts (Fig.
@ref(fig:mainInterfaceSidebar)) :

- The **pipeline name** : The name of the current pipeline.
- The **process timeline** : The timeline of the current process (see
  Section 2.2), as well as the buttons used to navigate through and
  reset the process.
- The **parameters** : The parameters and associated widgets for the
  current process.

The process timeline is specific to each process, while the parameters
vary across sub-steps.

![Composition of the process sidebar : (a) Pipeline name, (b) Process
timeline, (c) Parameters](figs/mainInterfaceSidebar.png)

Composition of the process sidebar : (a) Pipeline name, (b) Process
timeline, (c) Parameters

There are 5 navigation buttons (Fig.
@ref(fig:mainInterfaceSidebarButtons)). The first one and last ones are
respectively the ‘Previous’ and ‘Next’ buttons, which allow navigation
to the previous or next sub-step within the current step. The ‘Reset’
button is used to reset the current step (see Section 4.1). The ‘Run’
and ‘Run -\>’ button are both used to validate the current sub-step, but
differ in behavior : ‘Run’ simply validates the sub-step, whereas ‘Run
-\>’ validates the sub-step and automatically moves to the next
sub-step.

![The process sidebar's buttons : (a) 'Previous' button, (b) 'Reset'
button, (c) 'Run' button, (d) 'Run -\>' button, (e) 'Next'
button](figs/mainInterfaceSidebarButtons.png)

The process sidebar’s buttons : (a) ‘Previous’ button, (b) ‘Reset’
button, (c) ‘Run’ button, (d) ‘Run -\>’ button, (e) ‘Next’ button

##### Workflow header

The workflow header can be separated in 2 parts (Fig.
@ref(fig:mainInterfaceHeader)) :

- The **workflow timeline** : The timeline of the current workflow (see
  Section 2.2), as well as the buttons used to navigate through the
  workflow.
- The **EDA button** : The button to access the Exploratory Data
  Analyzer (EDA) (see Section 3.3).

![Composition of the workflow header : (a) Workflow timeline, (b) EDA
button](figs/mainInterfaceHeader.png)

Composition of the workflow header : (a) Workflow timeline, (b) EDA
button

There are 3 navigation buttons (Fig.
@ref(fig:mainInterfaceHeaderButtons)). The first one is the ‘Go back to
start’ button, which allows to return to the ‘Description’ step in a
single click. The other two buttons are used to navigate to the previous
or next step in the workflow.

![The workflow header's buttons : (a) 'Go back to start' button, (b)
'Previous' and 'Next' buttons](figs/mainInterfaceHeaderButtons.png)

The workflow header’s buttons : (a) ‘Go back to start’ button, (b)
‘Previous’ and ‘Next’ buttons

##### Content area

The content area is the section of the interface where tables or
graphical outputs (such as plots) are displayed throughout the workflow.

## Step-by-step discovery of PipelineDemo

### Launch the pipeline

`PipelineDemo` can be launched by typing the following command in a R
console :

``` r

library(MagellanNTK)
wf.path <- system.file('workflow/PipelineDemo', package = 'MagellanNTK')
MagellanNTK(wf.path, 'PipelineDemo')
```

This will open a new tab in your default web browser with this url :
<http://127.0.0.1:3838>

After a short loading screen, the pipeline will be open on the home page
(Fig. @ref(fig:homePage)).

![Home page](figs/homePage.png)

Home page

### Open a dataset

When the application opens, no dataset is loaded. To load one, hover
over the main sidebar menu and go to ‘Dataset’ -\> ‘Open file’. If you
haven’t exported a dataset from MagellanNTK yet, select the ‘package
dataset’ option in ‘Dataset source’ to choose one of the datasets
included in the `MagellanNTK` package. For this example, we select the
‘lldata’ dataset which consists of one SE containing an empty 100 x 6
matrix as assay. Once a dataset is chosen, a short summary of the
dataset is displayed (Fig. @ref(fig:opendataset)).

![Open a dataset](figs/UI_mod_open_dataset.png)

Open a dataset

### Exploratory Data Analyzer (EDA)

The Exploratory Data Analysis (EDA) tool is designed to provide a range
of information and visualizations about the current dataset at any point
during the workflow. It allows the dataset to be examined at any stage
of the workflow, including its content, the operations that have been
performed on it, and the results obtained so far. The EDA tool is
accessible at any time during the workflow via the EDA button located in
the top-right corner.

It contains 3 tabs :

- **Info** : Presents general information about the dataset (Fig.
  @ref(fig:EDA1)).
- **History** : Displays the dataset history, which include all
  parameter values recorded during the analysis (see Section 2.4) (Fig.
  @ref(fig:EDA2)).
- **EDA** : Provides various visualizations for exploring the dataset
  and the results obtained at the any step of the workflow (Fig.
  @ref(fig:EDA3)).

![EDA 'Infos' tab](figs/UI_EDA1.png)

EDA ‘Infos’ tab

![EDA 'History' tab](figs/UI_EDA2.png)

EDA ‘History’ tab

![EDA 'EDA' tab](figs/UI_EDA3.png)

EDA ‘EDA’ tab

### Workflow

#### ‘Description’ step

The first step, ‘Description’, serves as an introduction to the pipeline
and displays a brief overview of its purpose. When a dataset is loaded,
this step is automatically marked as validated (Fig.
@ref(fig:pipelinedescription)).

![Description step](figs/UI_PipelineDemo_Description.png)

Description step

No particular action needs to be taken here. Click on the ‘Next’ button
in the timeline of the pipeline so as to change the current step to
‘Data Generation’.

#### ‘DataGeneration’ step

The first data processing step is ‘DataGeneration’. This step is set as
mandatory, meaning that all subsequent processes remain disabled until
it has been validated. Like all other processes (with the exception of
the ‘Description’ and ‘Save’ processes, respectively at the beginning
and the end of the workflow), it includes an initial ‘Description’
sub-step and a final ‘Save’ sub-step. Between these two, there is only
one data processing sub-step in this step, called ‘DataGeneration’. As
the whole step is mandatory and contains only one data processing
sub-step, ‘DataGeneration’ is mandatory as well.

The ‘Description’ sub-step serves as a starting point of the process,
with a short text displayed describing the process purpose. This
sub-step behavior is the same for every process, only the displayed text
differs.

The ‘DataGeneration’ sub-step generates a dataset from two Gaussian
distributions. The user can specify the standard deviation (sd) to use
for these distributions, and a table allows to preview the dataset after
it has been created. Once the desired standard deviation has been
selected, clicking on ‘Run’ validates the sub-step and displays the
generated dataset in the table (Fig. @ref(fig:datageneration3)).
Alternatively, clicking ‘Run -\>’ validates the sub-step and
automatically proceeds to the next one.

!['Data generation' sub-step](figs/UI_PipelineDemo_DataGeneration3.png)

‘Data generation’ sub-step

The ‘Save’ sub-step allows to validate the whole process. Once
validated, a new SummarizedExperiment is added to the dataset, which can
be verified through the EDA window (see Section 3.3), and the history is
also updated with information about the parameters used in the process
(see Section 2.4). Once this sub-step has been validated, the whole
process is validated as well, and the workflow can proceed to the next
step. Note that, since ‘Save’ is the last sub-step of the process, the
‘Run -\>’ button is disabled.

#### ‘Preprocessing’ step

The second step is ‘Preprocessing’. This step is set as mandatory,
meaning that all subsequent processes remain disabled until it has been
validated. There are two sub-steps in this step, in addition to
‘Description’ and ‘Save’ : ‘Filtering’ and ‘Normalization’. While the
‘Preprocessing’ step is mandatory, only the ‘Normalization’ sub-step is
also mandatory, making it possible to skip the ‘Filtering’ sub-step.

The ‘Filtering’ sub-step allows rows to be filtered based on either the
mean or the sum of their values. The user can choose the method (Mean or
Sum), the operator and the threshold value used for the filtering. A
plot displays the distribution of sum/mean row values in the dataset.
Once the parameters have been set, clicking on ‘Run’ validates the
sub-step and updates the plot to reflect the filtered dataset.
Alternatively, clicking ‘Run -\>’ validates the sub-step and
automatically proceeds to the next one (Fig.
@ref(fig:UIPipelineDemoPreprocessing2)). Since this sub-step is not
mandatory, if the subsequent sub-step is validated while ‘Filtering’ is
not, it will become disabled.

!['Filtering' sub-step](figs/UI_PipelineDemo_Preprocessing2.png)

‘Filtering’ sub-step

The ‘Normalization’ sub-step allows columns to be normalized using
either the mean or the sum of their values. The user can select the
normalization method (Mean or Sum), and a boxplot displays the
distribution of column values. Once the parameters have been set,
clicking on ‘Run’ validates the sub-step and updates the plot to reflect
the normalized dataset (Fig. @ref(fig:UIPipelineDemoPreprocessing3)).
Alternatively, clicking ‘Run -\>’ validates the sub-step and
automatically proceeds to the next one.

!['Normalization' sub-step](figs/UI_PipelineDemo_Preprocessing3.png)

‘Normalization’ sub-step

#### ‘Clustering’ step

The third step is ‘Clustering’. This step is not mandatory and can be
skipped. There is only one sub-step in this step, in addition to
‘Description’ and ‘Save’, called ‘Clustering’.

The ‘Clustering’ sub-step performs data clustering to help identify the
two Gaussian distributions previously used for data generation. The user
can select the clustering method (kmeans or hclust) and the number of
cluster to create. A table is provided to preview the resulting
clusters, along with a PCA plot visualizing the observations. Once the
parameters have been set, clicking on ‘Run’ validates the sub-step and
updates the plot and table to reflect the clustered dataset (Fig.
@ref(fig:UIPipelineDemoClustering2)). Alternatively, clicking ‘Run -\>’
validates the sub-step and automatically proceeds to the next one.

!['Clustering' sub-step](figs/UI_PipelineDemo_Clustering2.png)

‘Clustering’ sub-step

#### ‘Save’ step

The last step is ‘Save’, which mainly serves as a ending point, with a
short text marking the end of the pipeline. Technically, this step does
not need to be validated as it does not change the dataset, which can be
downloaded in ‘Dataset’ -\> ‘Save as’.

### Other parts of the pipeline

#### ‘Convert’ process

The ‘Convert’ process is accessible from the ‘Dataset’ -\> ‘Import’ tab.
Its purpose is to import data from external formats and convert them
into a `MultiAssayExperiment`, which is the format required by the
pipeline (see Section 2.4). This makes it possible to work with raw data
files such as .csv, .txt, and other supported formats. Although the
‘Convert’ process is structured in the same way as a workflow step, with
its own sub-steps and interface, it is not part of the workflow itself.
Instead, it is a standalone process that belongs to the pipeline and
serves as an entry point for preparing datasets before they enter the
workflow.

In this pipeline, the ‘Convert’ process is intentionally left empty and
does not perform any conversion. This is by choice, as `PipelineDemo` is
intended solely as a demonstration pipeline and does not rely on any
real input datasets that would need to be imported or converted
@ref(fig:convertProcess)).

![Convert process](figs/convertProcess.png)

Convert process

#### ‘Save as’ tab

The ‘Save as’ tab allows to download the dataset at any point during the
workflow. Several output formats may be available depending on the
configuration. Only validated steps are recorded in the dataset, meaning
that any ongoing or unvalidated steps are not included in the exported
output. As such, the exported file always corresponds to the last
validated state of the workflow, and not any unfinished step.

!['Save as' tab](figs/saveProcess.png)

‘Save as’ tab

#### ‘Manual’, ‘FAQ’ and ‘Release Notes’ tabs

The ‘Manual’, ‘FAQ’, and ‘Release Notes’ tabs provide access to the
pipeline documentation. They contain, respectively, the user manual,
frequently asked questions, and the release notes describing changes and
updates made to the pipeline over time.

## Other functionalities

### Resetting a step

If, at any point, an incorrect parameter is selected or you wish to try
a different configuration, a process can be reset using the ‘Reset’
button. Resetting a process restores it to its default state, as if it
were being launched for the first time. This action also resets all
downstream processes in the workflow and removes any
SummarizedExperiment created by those processes. As a result, the
dataset is reverted to its initial state, as if the process had never
been executed, allowing the analysis to be rerun from that point (Fig.
@ref(fig:resetastepbef) and @ref(fig:resetastepaft)).

Please note that this action is irreversible. If the pipeline is reset
unintentionally, the analysis will need to be restarted from that point
onward.

![Before resetting the 'Preprocessing'
process](figs/beforeResetingProcess.png)

Before resetting the ‘Preprocessing’ process

![After resetting the 'Preprocessing'
process](figs/afterresetPreprocessing.png)

After resetting the ‘Preprocessing’ process

To reset the entire pipeline easily, click the ‘Go back to start’ button
located to the left of the workflow timeline (see 2.5). This
automatically returns the workflow to the first process, which is
‘Description’. From there, clicking the ‘Reset’ button will reset all
processes in the pipeline at once.

### Running a single process

MagellanNTK also allows individual processes to be run independently,
without launching the entire workflow. This can be useful when only a
specific process is needed for an analysis, as it is faster than
starting the full pipeline and manually navigating to the desired step.

To launch a process, the command lines are quite similar to those for
launching a pipeline; one just have to specify the name of the process
to run. For example, the process ‘Preprocessing’ can be launched by
typing the following command in a R console :

``` r

library(MagellanNTK)
wf.path <- system.file('workflow/PipelineDemo', package = 'MagellanNTK')
MagellanNTK(wf.path, 'PipelineDemo_Preprocessing')
```

This will open a new tab in your default web browser with this url :
<http://127.0.0.1:3838>

Most of the interface remains identical to that of the full pipeline.
The main difference is that the application behaves as if the workflow
only contained the ‘Preprocessing’ step. As a result, only the vertical
timeline is displayed, since the horizontal workflow timeline is not
needed in this case.

!['Preprocessing' process when launched as a single
process](figs/singleprocess.png)

‘Preprocessing’ process when launched as a single process

One important point concerns dataset loading. When a
`MultiAssayEpxeriment` is loaded, only its last `SummarizedExperiment`
is kept and automatically renamed to ‘Convert’.

## Session information

``` r

sessionInfo()
```

    ## R version 4.6.0 (2026-04-24)
    ## Platform: x86_64-pc-linux-gnu
    ## Running under: Ubuntu 24.04.4 LTS
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
    ## [1] MagellanNTK_0.99.31 BiocStyle_2.40.0   
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] sass_0.4.10                 generics_0.1.4             
    ##  [3] SparseArray_1.12.2          stringi_1.8.7              
    ##  [5] lattice_0.22-9              digest_0.6.39              
    ##  [7] magrittr_2.0.5              grid_4.6.0                 
    ##  [9] evaluate_1.0.5              bookdown_0.47              
    ## [11] bs4Dash_2.3.5               fastmap_1.2.0              
    ## [13] Matrix_1.7-5                jsonlite_2.0.0             
    ## [15] promises_1.5.0              BiocManager_1.30.27        
    ## [17] textshaping_1.0.5           jquerylib_0.1.4            
    ## [19] abind_1.4-8                 cli_3.6.6                  
    ## [21] shiny_1.14.0                crayon_1.5.3               
    ## [23] rlang_1.2.0                 XVector_0.52.0             
    ## [25] Biobase_2.72.0              DelayedArray_0.38.2        
    ## [27] cachem_1.1.0                yaml_2.3.12                
    ## [29] otel_0.2.0                  S4Arrays_1.12.0            
    ## [31] tools_4.6.0                 httpuv_1.6.17              
    ## [33] DT_0.34.0                   SummarizedExperiment_1.42.0
    ## [35] BiocGenerics_0.58.1         MultiAssayExperiment_1.38.0
    ## [37] waiter_0.2.5.1              R6_2.6.1                   
    ## [39] mime_0.13                   matrixStats_1.5.0          
    ## [41] stats4_4.6.0                lifecycle_1.0.5            
    ## [43] stringr_1.6.0               Seqinfo_1.2.0              
    ## [45] S4Vectors_0.50.1            fs_2.1.0                   
    ## [47] htmlwidgets_1.6.4           IRanges_2.46.0             
    ## [49] shinyjs_2.1.1               ragg_1.5.2                 
    ## [51] desc_1.4.3                  pkgdown_2.2.0              
    ## [53] bslib_0.11.0                later_1.4.8                
    ## [55] glue_1.8.1                  Rcpp_1.1.1-1.1             
    ## [57] systemfonts_1.3.2           xfun_0.59                  
    ## [59] GenomicRanges_1.64.0        MatrixGenerics_1.24.0      
    ## [61] knitr_1.51                  xtable_1.8-8               
    ## [63] htmltools_0.5.9             rmarkdown_2.31             
    ## [65] compiler_4.6.0              shinyEffects_0.2.0         
    ## [67] markdown_2.0
