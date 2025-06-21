
#' Get anchor pairs in intraspecies syntenic regions
#' 
#' @param species Character vector of PLAZA species IDs.
#'
#' @return A data frame (or list of data frames, in case of multiple species)
#' with the following variables:
#' \describe{
#'   \item{multiplicon_id}{Numeric, multiplicon ID.}
#'   \item{anchor1}{Character, gene ID of anchor 1.}
#'   \item{anchor2}{Character, gene ID of anchor 2.}
#'   \item{Ks}{Numeric, synonymous substitution rates. If not calculated,
#'             NA is used.}
#'   \item{level}{Numeric, multiplicon level.}
#' }
#' 
#' @rdname get_block_duplicates
#' @export
#' @examples
#' sd <- get_block_duplicates("lpe")
get_block_duplicates <- function(species) {
    
    # Construct URL
    burl <- base_url(species)
    furl <- file.path(
        burl, "AnchorpointsIntraSpecies", 
        paste0("anchorpoints_intra_species.", species, ".csv.gz")
    )
    
    # Retrieve data
    delims <- get_delim(species)
    block_df <- lapply(seq_along(furl), function(x) {
        
        df <- read.delim(
            bfcrpath(BiocFileCache(), furl[[x]]), sep = delims[x], 
            comment.char = "#", col.names = c(
                "multiplicon_id", "species_x", "anchor1", "species_y", 
                "anchor2", "Ks", "multiplicon_level"
            )
        )[, c("anchor1", "anchor2", "multiplicon_id", "multiplicon_level", "Ks")]
        n <- length(unique(df$Ks))
        if(nrow(df) >0 && n <=1) { df$Ks <- NA }

        return(df)
    })
    names(block_df) <- species
    if(length(furl) == 1) { block_df <- block_df[[1]] }
    
    return(block_df)
}


#' Get gene family assignments for all genes in a PLAZA instance
#' 
#' @param instance Character scalar with name of PLAZA instance for which
#' gene family assignments will be extracted. 
#' One of 'Dicots', 'Monocots', 'Diatoms', or 'Pico'.
#' @param type Character indicating the type of gene family to use. One of
#' 'homo' (homologous gene families) or 'ortho' (orthologous gene families).
#'
#' @return A data frame (or list of data frames, in case of multiple species)
#' with the following variables:
#' \describe{
#'   \item{family_id}{Character, gene family ID.}
#'   \item{species}{Character, species ID.}
#'   \item{gene_id}{Character, gene ID.}
#' }
#' 
#' @rdname get_family_assignments
#' @export
#' @examples
#' fams <- get_family_assignments("Diatoms", type = "ortho")
get_family_assignments <- function(
        instance = c("Dicots", "Monocots", "Diatoms", "Pico"), 
        type = c("homo", "ortho")
) {
    
    # Construct URL
    burl <- instance2url(instance)
    type_id <- ifelse(type == "homo", ".HOMFAM", ".ORTHOFAM")
    furl <- file.path(
        burl, "GeneFamilies", 
        paste0("genefamily_data", type_id, ".csv.gz")
    )
    
    # Retrieve data
    delim <- ifelse(instance %in% c("Pico", "Diatoms"), ";", "\t")
    fam_df <- read.delim(
        bfcrpath(BiocFileCache(), furl), sep = delim, 
        comment.char = "#", col.names = c(
            "family_id", "species", "gene_id"
        )
    )
    
    return(fam_df)
}


#' Get enriched functional terms in gene families of a PLAZA instance
#' 
#' @param instance Character scalar with name of PLAZA instance for which
#' gene family functions will be extracted. 
#' One of 'Dicots' or 'Monocots' (not available for 'Diatoms' and 'Pico').
#' @param type Character indicating the type of gene family to use. One of
#' 'homo' (homologous gene families) or 'ortho' (orthologous gene families).
#'
#' @return A data frame (or list of data frames, in case of multiple species)
#' with the following variables:
#' \describe{
#'   \item{family_id}{Character, gene family ID.}
#'   \item{term_id}{Character, functional term ID.}
#'   \item{term_description}{Character, functional term description.}
#'   \item{ontology}{Character, ontology from where term comes.}
#'   \item{score}{Numeric, enrichment score.}
#' }
#' 
#' @rdname get_family_functions
#' @export
#' @examples
#' fam_func <- get_family_functions("Dicots", type = "ortho")
get_family_functions <- function(
        instance = c("Dicots", "Monocots"),
        type = c("homo", "ortho")
) {
    
    if(!instance %in% c("Dicots", "Monocots")) {
        stop("Instance must be one of 'Dicots' or 'Monocots'")
    }
    
    # Construct URL
    burl <- instance2url(instance)
    type_id <- ifelse(type == "homo", ".HOMFAM", ".ORTHOFAM")
    furl <- file.path(
        burl, "GeneFamilies", 
        paste0("genefamily_enrichment", type_id, ".csv.gz")
    )
    
    # Retrieve data
    enr_df <- read.delim(
        bfcrpath(BiocFileCache(), furl), sep = "\t", 
        comment.char = "#", col.names = c(
            "family_id", "term_id", "ontology", "score", "term_description"
        )
    )[, c("family_id", "term_id", "term_description", "ontology", "score")]
    
    return(enr_df)
}
