
#' Get transcript-to-gene mapping
#'
#' @param species Character vector of PLAZA species IDs.
#' @param transcripts Character indicating what transcripts to use for each 
#' gene. One of 'all' (all transcripts for each gene), or 'longest' 
#' (only longest transcript for each gene).
#' 
#' @return A 2-column data frame with columns
#' \strong{transcript_id} (character) and \strong{gene_id} (character)
#'
#' @export
#' @rdname get_tx2gene
#' @examples
#' species <- "ota"
#' tx2gene <- get_tx2gene(species, "all")
get_tx2gene <- function(species, transcripts = c("all", "longest")) {
    
    # Construct URL
    burl <- base_url(species)
    tx <- ifelse(transcripts == "all", ".all_transcripts", ".selected_transcript")
    furl <- file.path(
        burl, "TranscriptMapping", 
        paste0("transcript_mapping", tx, ".", species, ".csv.gz")
    )
    
    # Retrieve data
    delims <- get_delim(species)
    if(length(furl) == 1) {
        tx2gene <- read.delim(
            bfcrpath(BiocFileCache(), furl), sep = delims, comment.char = "#",
            col.names = c("transcript_id", "gene_id")
        )
    } else {
        tx2gene <- lapply(seq_along(furl), function(x) {
            return(
                read.delim(
                    bfcrpath(BiocFileCache(), furl[[x]]), sep = delims[x], 
                    comment.char = "#",
                    col.names = c("transcript_id", "gene_id")
                )
            )
        })
        names(tx2gene) <- species
    }
    
    return(tx2gene)
}


#' Get short, one-line gene descriptions
#'
#' @param species Character vector of PLAZA species IDs.
#'
#' @return A 2-column data frame with columns \strong{gene} (character)
#' and \strong{description} (character).
#'
#' @rdname get_descriptions
#' @export
#' @examples
#' des <- get_descriptions("ota")
get_descriptions <- function(species) {
    
    # Construct URL
    burl <- base_url(species)
    furl <- file.path(
        burl, "Descriptions", paste0("gene_description.", species, ".csv.gz")
    )
    
    # Retrieve data
    delims <- get_delim(species)
    if(length(furl) == 1) {
        des_df <- read.delim(
            bfcrpath(BiocFileCache(), furl), sep = delims, 
            comment.char = "#", col.names = c("gene", "type", "description")
        )[, c("gene", "description")]
    } else {
        des_df <- lapply(seq_along(furl), function(x) {
            return(
                read.delim(
                    bfcrpath(BiocFileCache(), furl[[x]]), sep = delims[x], 
                    comment.char = "#", col.names = c("gene", "type", "description")
                )[, c("gene", "description")]
            )
        })
        names(des_df) <- species
    }
    
    return(des_df)
}


#' Get mapping between alternative IDs
#'
#' @param species Character vector of PLAZA species IDs.
#'
#' @return A 2-column data frame with columns \strong{original_id} (character),
#' \strong{alt_id_type} (character), and \strong{alt_id} (character).
#'
#' @rdname get_id_conversions
#' @export
#' @examples
#' ids <- get_id_conversions("ota")
get_id_conversions <- function(species) {
    
    # Construct URL
    burl <- base_url(species)
    furl <- file.path(
        burl, "IdConversion", paste0("id_conversion.", species, ".csv.gz")
    )
    
    # Retrieve data
    delims <- get_delim(species)
    if(length(furl) == 1) {
        id_df <- read.delim(
            bfcrpath(BiocFileCache(), furl), sep = delims, 
            comment.char = "#", 
            col.names = c("original_id", "alt_id_type", "alt_id")
        )
    } else {
        id_df <- lapply(seq_along(furl), function(x) {
            return(
                read.delim(
                    bfcrpath(BiocFileCache(), furl[[x]]), sep = delims[x], 
                    comment.char = "#", 
                    col.names = c("original_id", "alt_id_type", "alt_id")
                )
            )
        })
        names(id_df) <- species
    }
    
    return(id_df)
}

