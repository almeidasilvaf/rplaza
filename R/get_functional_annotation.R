
#' Get mapping between alternative IDs
#'
#' @param species Character vector of PLAZA species IDs.
#' @param ontology Character indicating what ontology to use to extract
#' functional annotation. One of 'GO' (Gene Ontology), 'MapMan', 
#' or 'InterPro'.
#'
#' @return A data frame with functional annotation terms for all genes.
#'
#' @rdname get_functional_annotation
#' @export
#' @examples
#' fannot <- get_functional_annotation("ota", "MapMan")
get_functional_annotation <- function(
        species, ontology = c("GO", "MapMan", "InterPro")
) {
    
    burl <- base_url(species)
    furl <- file.path(
        burl, ontology, paste0(tolower(ontology), ".", species, ".csv.gz")
    )
    
    # Handle column names
    if(ontology == "MapMan") {
        cnames <- c(
            "id", "species", "gene_id", "mapman_id", "mapman_description"
        )
    } else if(ontology == "InterPro") {
        cnames <- c(
            "gene_id", "species", "motif_id", "description", 
            "start", "stop", "score", "comment"
        )
    } else {
        cnames <- c(
            "gene_id", "species", "go", "evidence", "go_source",
            "provider", "comment", "description", "propagated_from_child"
        )
    }
    
    # Retrieve data
    delims <- get_delim(species)
    fannot <- lapply(seq_along(furl), function(x) {
        return(
            read.delim(
                bfcrpath(BiocFileCache(), furl[[x]]), sep = delims[x], 
                comment.char = "#", col.names = cnames
            )
        )
    })
    names(fannot) <- species
    if(length(furl) == 1) { fannot <- fannot[[1]] }
    
    return(fannot)
}

