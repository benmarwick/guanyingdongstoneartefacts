
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Last-changedate](https://img.shields.io/badge/last%20change-2016--11--30-brightgreen.svg)](https://github.com/benmarwick/guanyingdongstoneartefacts/commits/master) [![minimal R version](https://img.shields.io/badge/R%3E%3D-3.3.1-brightgreen.svg)](https://cran.r-project.org/) [![Licence](https://img.shields.io/github/license/mashape/apistatus.svg)](http://choosealicense.com/licenses/mit/) [![Travis-CI Build Status](https://travis-ci.org/benmarwick/guanyingdongstoneartefacts.png?branch=master)](https://travis-ci.org/benmarwick/guanyingdongstoneartefacts) [![ORCiD](https://img.shields.io/badge/ORCiD-0000--0001--7879--4531-green.svg)](http://orcid.org/0000-0001-7879-4531)

Research compendium for a report on stone artefacts from Guanyingdong, China
----------------------------------------------------------------------------

### Compendium DOI:

<http://dx.doi.org/xxxxxxx>

The files at the URL above will generate the results as found in the publication. The files hosted at github.com/benmarwick/guanyingdongstoneartefacts are the development versions and may have changed since the report was published

### Authors of this repository:

Ben Marwick (<benmarwick@gmail.com>) Hu Yue

### Published in:

xxxxx

### Overview of contents

This repository is our research compendium for our analysis of stone artefacts from Guanyingdong, China. The compendium contains all data, code, and text associated with the publication. The `Rmd` file in the `analysis/paper/` directory contain details of how all the analyses reported in the paper were conducted, as well as instructions on how to rerun the analysis to reproduce the results. The `data/` directory in the `analysis/` directory contains all the raw data.

### The supplementary files

The `analysis/` directory contains:

-   the manuscript as submitted (in MS Word format) and its Rmd source file
-   all the data files (in CSV format, in the `data/` directory)
-   all the figures that are included in the paper (in the `figures/` directory)

### The R package

This repository is organized as an R package. We use the R package structure to help manage dependencies, to take advantage of continuous integration for automated code testing, and so we didn't have to think too much about how to organise the files.

To download the package source as you see it on GitHub, for offline browsing, use this line at the shell prompt (assuming you have Git installed on your computer):

``` r
git clone https://github.com/benmarwick/guanyingdongstoneartefacts.git
```

Once the download is complete, open the `guanyingdongstoneartefacts.Rproj` in RStudio to begin working with the package and compendium files.

The package has a number of dependencies on other R packages, and programs outside of R. These are listed in the docx file in the `/analysis/paper` directory. Installing these can be time-consuming and complicated, so we've done two things to simpify access to the compendium. First is the packrat directory, which contains the source code for all the packages we depend on. If all works well, these will be installed on your computer when you open `guanyingdongstoneartefacts.Rproj` in RStudio. Second is our Docker image that includes all the necessary software, code and data to run our analysis. The Docker image may give a quicker entry point to the project, and is more self-contained, so might save some fiddling with installing things.

### The Docker image

A Docker image is a lightweight GNU/Linux virtual computer that can be run as a piece of software on Windows and OSX (and other Linux systems). To capture the complete computational environment used for this project we have a Dockerfile that specifies how to make the Docker image that we developed this project in. The Docker image includes all of the software dependencies needed to run the code in this project, as well as the R package and other compendium files. To launch the Docker image for this project, first, [install Docker](https://docs.docker.com/installation/) on your computer. At the Docker prompt, enter:

    docker run -dp 8787:8787 benmarwick/guanyingdongstoneartefacts

This will start a server instance of RStudio. Then open your web browser at localhost:8787 or or run `docker-machine ip default` in the shell to find the correct IP address, and log in with rstudio/rstudio.

Once logged in, use the Files pane (bottom right) to navigate to `/` (the root directory), then open the folder for this project, and open the `.Rproj` file for this project. Once that's open, you'll see the `analysis/paper` directory in the Files pane where you can find the R markdown document, and knit them to produce the results in the paper. More information about using RStudio in Docker is avaiable at the [Rocker](https://github.com/rocker-org) [wiki](https://github.com/rocker-org/rocker/wiki/Using-the-RStudio-image) pages.

We developed and tested the package on this Docker container, so this is the only platform that We're confident it works on, and so recommend to anyone wanting to use this package to generate the vignette, etc.

### Licenses

Manuscript: [CC-BY-4.0](http://creativecommons.org/licenses/by/4.0/)

Code: [MIT](http://opensource.org/licenses/MIT) year: 2016, copyright holders: Ben Marwick & Hu Yue

Data: [CC-0](http://creativecommons.org/publicdomain/zero/1.0/) attribution requested in reuse

### Dependencies

See the colophon section of the docx file in `analysis/paper` for a full list of the packages that this project depends on.

### Contact

Ben Marwick, Senior Research Scientist Centre for Archaeologica Science University of Wollongong <benmarwick@gmail.com>
