Data acquisition
================

``` r
library(tidyverse)
library(taxize)
library(rvest)
library(httr)
library(ggtree)
library(ape)

set.seed(123)
```

# `data/`

Here we will describe the code used to create package data in `data/`.
We will start by defining some helper functions.

``` r
#' Format a `classification` object (from taxize) into a data frame
format_classification <- function(class_list) {
    
    class_df <- Reduce(rbind, lapply(seq_along(class_list), function(x) {
        
        cdf <- class_list[[x]]
        fn <- function(x) { return(ifelse(length(x) == 0, NA, x)) } 
        
        df <- data.frame(
            ncbi_species = fn(cdf$name[cdf$rank == "species"]),
            family = fn(cdf$name[cdf$rank == "family"]),
            order = fn(cdf$name[cdf$rank == "order"]),
            class = fn(cdf$name[cdf$rank == "class"]),
            superclass = fn(cdf$name[cdf$rank == "superclass"]),
            subphylum = fn(cdf$name[cdf$rank == "subphylum"]),
            phylum = fn(cdf$name[cdf$rank == "phylum"])
        )
        
        return(df)
    }))
    
    return(class_df)
}
```

## *plaza_metadata*

This data frame contains a list of species in PLAZA instances and
associated metadata, including taxonomic information.

``` r
# Dicots ----
## PLAZA metadata
dicots_plaza <- read_tsv(
    "https://ftp.psb.ugent.be/pub/plaza/plaza_public_dicots_05/SpeciesInformation/species_information.csv.gz",
    show_col_types = FALSE, comment = "# "
) |>
    rename(PLAZA_ID = `#species`)

## Taxonomic information
dicots_tax <- taxize::classification(dicots_plaza$tax_id, db = "ncbi") |>
    format_classification()


# Monocots ----
## PLAZA metadata
monocots_plaza <- read_tsv(
    "https://ftp.psb.ugent.be/pub/plaza/plaza_public_monocots_05/SpeciesInformation/species_information.csv.gz",
    show_col_types = FALSE, comment = "# "
) |>
    rename(PLAZA_ID = `#species`)

## Taxonomic information
monocots_tax <- taxize::classification(monocots_plaza$tax_id, db = "ncbi") |>
    format_classification()


# Pico ----
## PLAZA metadata
pico_plaza <- read_delim(
    "ftp://ftp.psb.ugent.be/pub/plaza/plaza_pico_03/SpeciesInformation/species_information.csv.gz",
    delim = ";", show_col_types = FALSE, comment = "# "
) |>
    rename(PLAZA_ID = 1)

## Taxonomic information
pico_tax <- taxize::classification(pico_plaza$tax_id, db = "ncbi") |>
    format_classification()

# Diatoms ----
## PLAZA metadata
diatoms_plaza <- read_delim(
    "ftp://ftp.psb.ugent.be/pub/plaza/plaza_diatoms_01/SpeciesInformation/species_information.csv.gz",
    delim = ";", show_col_types = FALSE, comment = "# "
) |>
    rename(PLAZA_ID = 1)

## Taxonomic information
diatoms_tax <- taxize::classification(diatoms_plaza$tax_id, db = "ncbi") |>
    format_classification()

# Create final list of data frames
plaza_metadata <- list(
    Dicots = cbind(dicots_plaza, dicots_tax),
    Monocots = cbind(monocots_plaza, monocots_tax),
    Diatoms = cbind(diatoms_plaza, diatoms_tax),
    Pico = cbind(pico_plaza, pico_tax)
)

plaza_metadata <- lapply(plaza_metadata, function(x) {
    
    df <- x |>
        dplyr::select(
            PLAZA_ID, common_name, NCBI_name = ncbi_species, 
            NCBI_taxid = tax_id, family, order, class, source, 
            data_provider, pubmed_id
        )
    
    return(df)
})

# Save object
usethis::use_data(plaza_metadata, compress = "xz")
```

## *plaza_tree*

This object contains a `phylo` object with a phylogenetic tree for all
unique species in all PLAZA instances (Dicots, Monocots, Diatoms,
Pico-PLAZA). To create it, we first defined the following helper
functions:

``` r
# Helper functions

#' Extract tree from PLAZA as a `phylo` object
extract_plaza_tree <- function(page_url) {
    
    plaza_tree <- GET(page_url) |>
        content(as = "text") |>
        read_html() |>
        html_elements("script") |>
        html_text() |>
        (\(scripts) scripts[str_detect(scripts, "var tt")])() |>
        (\(script) str_match(script, "var tt\\s*=\\s*\"((?:.|\n)*?)\";")[,2])() |>
        (\(nwk) ape::read.tree(text = nwk))()
    
    return(plaza_tree)
}

#' Get node labels and their corresponding IDs
#' 
node_id_table <- function(tree) {
    
    df <- data.frame(
        id = 1:(length(tree$tip.label) + tree$Nnode),
        label = c(tree$tip.label, tree$node.label)
    )
    
    return(df)
}

#' Combine trees based on some nodes
#' 
#' Replace node X of tree X with subtree from node Y of tree Y
combine_trees <- function(tree_x, node_x, tree_y, node_y) {
    
    # Get subtree to add
    subtree_add <- extract.clade(tree_y, node = node_y)
    
    # Tag tips that should be removed after merging
    toremove <- extract.clade(tree_x, node = node_x)$tip.label
    toremove_labels <- paste0(toremove, "XX")
    tree_x$tip.label <- ifelse(
        tree_x$tip.label %in% toremove, 
        paste0(tree_x$tip.label, "XX"), 
        tree_x$tip.label
    )
    
    # Combine trees and remove old node
    new_tree <- bind.tree(tree_x, subtree_add, where = node_x)
    new_tree <- drop.tip(new_tree, toremove_labels)
    
    return(new_tree)
}
```

Then, we extracted trees with the following code.

``` r
# Get trees from HTML pages
tree_dicots <- extract_plaza_tree(
    "https://bioinformatics.psb.ugent.be/plaza.dev/instances/dicots_05/configuration/draw_species_tree"
)

tree_monocots <- extract_plaza_tree(
    "https://bioinformatics.psb.ugent.be/plaza.dev/instances/monocots_05/configuration/draw_species_tree"
)

tree_diatoms <- extract_plaza_tree(
    "https://bioinformatics.psb.ugent.be/plaza/versions/plaza_diatoms_01/"
)

tree_pico <- extract_plaza_tree(
    "https://bioinformatics.psb.ugent.be/plaza/versions/plaza_pico_03/"
)
```

Finally, we combined trees with the following code.

``` r
# Combine trees together ---

#' Helper to find node numbers
#' 
#' p <- ggtree(tree_monocots,  branch.length = "none") +
#'     geom_text(aes(label = ifelse(!isTip, node, ""))) +
#'     geom_tiplab()
#' 

# In Dicots, replace 'Liliopsida' with Monocots version (expanded) ----
lilio <- bind_rows(
    node_id_table(tree_dicots), node_id_table(tree_monocots)
) |>
    filter(label == "Liliopsida") |> 
    pull(id)
    
ctree1 <- combine_trees(tree_dicots, lilio[1], tree_monocots, lilio[2])

# In Pico, replace 'Embryophyta' with 'Streptophytina' from `ctree1` ----
strepto <- bind_rows(
    node_id_table(tree_pico) |> filter(label == "Embryophyta"),
    node_id_table(ctree1) |> filter(label == "Streptophytina"),
) |>
    pull(id)

ctree2 <- combine_trees(tree_pico, strepto[1], ctree1, strepto[2])


# In `ctree2`, replace 'Diatoms' with Diatoms version (expanded) ----
diatoms <- bind_rows(
    node_id_table(ctree2), node_id_table(tree_diatoms)
) |>
    filter(label == "Diatoms") |> 
    pull(id)

ctree3 <- combine_trees(ctree2, diatoms[1], tree_diatoms, diatoms[2])

# Add 'Prasinoderma coloniale' (pco) to node that splits Cbrauni from Chlorophyta
plaza_tree <- phytools::bind.tip(
    ctree3, "pco", 0.05, where = 186
)

usethis::use_data(plaza_tree, compress = "xz")
```

# Internal data

## sp2instance

This object contains a data frame of PLAZA species IDs and the PLAZA
instance where they can be found. If a species is found in multiple
PLAZA instances (e.g., *Arabidopsis thaliana*), the following priority
scheme is used:

Dicots \> Monocots \> Diatoms \> Pico.

The object `sp2instance` contains a data frame with 2 columns: -
`PLAZA_ID` (character): PLAZA species IDs as in `plaza_metadata`. -
`instance` (character): PLAZA instance. One of ‘Dicots’, ‘Monocots’,
‘Diatoms’, or ‘Pico’.

``` r
data("plaza_metadata")
sp2instance <- plaza_metadata |>
    bind_rows(.id = "instance") |>
    select(PLAZA_ID, instance) |>
    distinct(PLAZA_ID, .keep_all = TRUE)

usethis::use_data(sp2instance, compress = "xz", internal = TRUE)
```
