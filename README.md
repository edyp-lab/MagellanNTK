
# MagellanNTK

<!-- badges: start -->
[![Project Status: Active](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![R-CMD-check-bioc](https://github.com/edyp-lab/MagellanNTK/actions/workflows/check-bioc.yml/badge.svg)](https://github.com/edyp-lab/DaparToolshed/actions/workflows/check-bioc.yml)
[![R-CMD-check](https://github.com/edyp-lab/MagellanNTK/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/edyp-lab/MagellanNTK/actions/workflows/R-CMD-check.yaml)
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![license](https://img.shields.io/badge/license-Artistic--2.0-brightgreen.svg)](https://opensource.org/licenses/Artistic-2.0)
<!-- badges: end -->


The package `MagellanNTK` is a Shiny application which provides the 
infrastructure for the configuration, the execution and the surveillance of a 
defined sequence of computational tasks for data analysis, hereafter called 
"pipelines". It builds graphical pipelines based on third party packages, 
developed as Shiny modules. It proposes a framework to navigate between steps 
of a complex data processing tool when the succession of processes is mostly 
chronological.

For example, if a process is composed of three steps, then it is very easy to 
run the first step, then the second and finally the last one. It is like a 
dataflow manager.

Moreover, this navigation system, which is at the core of MagellanNTK, can by 
used at several levels. It can then be possible to define, for example, a 
super-process (i.e. a pipeline) in which each step is a whole process 
containing itself several steps.


## Installation

To install `MagellanNTK`:

```{r install, eval = FALSE}
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("MagellanNTK")
```


## Using MagellanNTK


**Launching a pipeline**

In the following example, the pipeline called PipelineDemo is launched.

```
library(MagellanNTK)
wf.path <- system.file('workflow/PipelineDemo', package = 'MagellanNTK')
MagellanNTK(wf.path, 'PipelineDemo')

```

**Launching a single process**

In the following example, only the Preprocessing process is launched.

```
library(MagellanNTK)
wf.path <- system.file('workflow/PipelineDemo', package = 'MagellanNTK')
MagellanNTK(wf.path, 'PipelineDemo_Preprocessing')

```

