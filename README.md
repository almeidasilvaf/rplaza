
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rplaza <img src="man/figures/logo.png" align="right" height="139" alt="" />

<!-- badges: start -->

[![GitHub
issues](https://img.shields.io/github/issues/almeidasilvaf/rplaza)](https://github.com/almeidasilvaf/rplaza/issues)
[![check-bioc](https://github.com/almeidasilvaf/rplaza/actions/workflows/check-bioc.yml/badge.svg)](https://github.com/almeidasilvaf/rplaza/actions/workflows/check-bioc.yml)
[![Codecov test
coverage](https://codecov.io/gh/almeidasilvaf/rplaza/branch/devel/graph/badge.svg)](https://app.codecov.io/gh/almeidasilvaf/rplaza?branch=devel)
<!-- badges: end -->

The goal of **rplaza** is to provide users with an R interface to the
PLAZA database of plant comparative genomics. **rplaza** can be used to
retrieve PLAZA data (e.g., genome and locus sequences, genome
annotation, functional annotation, homology, etc) directly from an R
session using standard R/Bioconductor data classes.

## Overview

**rplaza** functions and the data they retrieve are summarized below:

| fnc | desc | bioc_class |
|:---|:---|:---|
| *get_genome()* | Genome sequences | *DNAStringSet* |
| *get_sequences()* | Locus sequences (proteins, transcripts, CDS) | *DNAStringSet* / *AAStringSet* |
| *get_annotation()* | Genomic coordinates of genes | *GRanges* |
| *get_functional_annotation()* | Functional annotation (GO, InterPro, MapMan) | *data.frame* |
| *get_tx2gene()* | Transcript-to-gene ID mapping | *data.frame* |
| *get_id_conversions()* | Correspondence between alternative gene IDs | *data.frame* |
| *get_descriptions()* | Short gene descriptions | *data.frame* |
| *get_family_assignments()* | Gene family assignments | *data.frame* |
| *get_family_functions()* | Overrepresented functions for gene families | *data.frame* |
| *get_block_duplicates()* | Block (segmental or whole-genome) duplicates | *data.frame* |

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
#> To cite package 'rplaza' in publications use:
#> 
#>   Almeida-Silva F, Van de Peer Y (2025). _rplaza: R Interface to the
#>   PLAZA Database for Plant Comparative Genomics_. R package version
#>   0.99.0, <https://github.com/almeidasilvaf/rplaza>.
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Manual{,
#>     title = {rplaza: R Interface to the PLAZA Database for Plant Comparative Genomics},
#>     author = {Fabrício Almeida-Silva and Yves {Van de Peer}},
#>     year = {2025},
#>     note = {R package version 0.99.0},
#>     url = {https://github.com/almeidasilvaf/rplaza},
#>   }
```

If you use **rplaza**, please also cite:

> Van Bel, M., Silvestri, F., Weitz, E. M., Kreft, L., Botzki, A.,
> Coppens, F., & Vandepoele, K. (2022). PLAZA 5.0: extending the scope
> and power of comparative and functional genomics in plants. Nucleic
> Acids Research, 50(D1), D1468-D1474.

## Code of Conduct

Please note that the `rplaza` project is released with a [Contributor
Code of Conduct](http://bioconductor.org/about/code-of-conduct/). By
contributing to this project, you agree to abide by its terms.
