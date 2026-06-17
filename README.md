
# MagellanNTK

<!-- badges: start -->
[![Project Status: Active](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![R-CMD-check-bioc](https://github.com/edyp-lab/MagellanNTK/actions/workflows/check-bioc.yml/badge.svg)](https://github.com/edyp-lab/DaparToolshed/actions/workflows/check-bioc.yml)
[![R-CMD-check](https://github.com/edyp-lab/MagellanNTK/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/edyp-lab/MagellanNTK/actions/workflows/R-CMD-check.yaml)
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![license](https://img.shields.io/badge/license-Artistic--2.0-brightgreen.svg)](https://opensource.org/licenses/Artistic-2.0)
<!-- badges: end -->

The MagellanNTK package is a workflow management engine that allows 
you to run a series of analysis processes on datasets.
It contains generic dataset input/output functions that are 
suited to data formats such as MultiAssayExperiment.

To use MagellanNTK's features, you must use 
workflows that are either saved on your computer or available in a package

The main strength of this package is that these native functions 
are fully configurable. MagellanNTK offers workflow management.


## Installation

You can install the development version of MagellanNTK from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("edyp-lab/MagellanNTK")
```

  
# MagellanNTK

MagellanNTK is a R package which proposes a framework to navigate between steps 
of a complex data processing tool when the succession of processes is mostly 
chronological.

For example, if a process is composed of three steps, then it is very easy to 
run the first step, then the second and finally the last one. It is like a 
dataflow manager.

Moreover, this navigation system, which is at the core of MagellanNTK, can by 
used at several levels. It can then be possible to define, for example, a 
super-process (i.e. a pipeline) in which each step is a whole process 
containing itself several steps.


## Install

```
devtools::install_github('edyp-lab/MagellanNTK')
```

## Using MagellanNTK



**Launching a pipeline**

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

