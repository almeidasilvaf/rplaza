
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rplaza

<!-- badges: start -->

[![GitHub
issues](https://img.shields.io/github/issues/almeidasilvaf/rplaza)](https://github.com/almeidasilvaf/rplaza/issues)
<!-- badges: end -->

The goal of `rplaza` is to provide users with an R interface to the
PLAZA database of plant comparative genomics. `rplaza` can be used to
retrieve data from PLAZA (e.g., sequences, genome annotation, functional
annotation, etc) as R objects using standard Bioconductor data classes.

## Installation instructions

Get the latest stable `R` release from
[CRAN](http://cran.r-project.org/). Then install `rplaza` from
[Bioconductor](http://bioconductor.org/) using the following code:

``` r
if (!requireNamespace("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager")
}

BiocManager::install("rplaza")
```

And the development version from
[GitHub](https://github.com/almeidasilvaf/rplaza) with:

``` r
BiocManager::install("almeidasilvaf/rplaza")
```

## Citation

Below is the citation output from using `citation('rplaza')` in R.
Please run this yourself to check for any updates on how to cite
**rplaza**.

``` r
print(citation('rplaza'), bibtex = TRUE)
```

Please note that the `rplaza` was only made possible thanks to many
other R and bioinformatics software authors, which are cited either in
the vignettes and/or the paper(s) describing this package.

## Code of Conduct

Please note that the `rplaza` project is released with a [Contributor
Code of Conduct](http://bioconductor.org/about/code-of-conduct/). By
contributing to this project, you agree to abide by its terms.
