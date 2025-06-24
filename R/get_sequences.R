
#' Load genome sequences as a `DNAStringSet` object
#'
#' @param species Character vector of PLAZA species IDs.
#' 
#' @return A `DNAStringSet` object for a single species, or a list
#' of `DNAStringSet` objects for multiple species.
#'
#' @importFrom Biostrings readDNAStringSet
#' @rdname get_genome
#' @export
#' @examples
#' species <- "cre"
#' seq <- get_genome(species)
get_genome <- function(species) {
    
    # Construct URL
    burl <- base_url(species)
    furl <- file.path(burl, "Genomes", paste0(species, ".fasta.gz"))
    
    # Retrieve data
    seq <- lapply(furl, function(x) {
        return(readDNAStringSet(bfcrpath(BiocFileCache(), x)))
    })
    names(seq) <- species
    if(length(furl) == 1) { seq <- seq[[1]] }
    
    return(seq)
}


#' Get sequences for genomic loci as a `DNAStringSet` object
#'
#' @param species Character vector of PLAZA species IDs.
#' @param type Character indicating what type of locus to extract.
#' One of 'CDS', 'transcript', or 'protein'.
#' @param transcripts Character indicating what genes for which sequences will
#' be extracted. One of 'all' (for each gene, all transcripts and 
#' associated features), or 'longest' (for each gene, only longest transcripts
#' and associated features).
#'
#' @return A `DNAStringSet` object for a single species, or a list
#' of `DNAStringSet` objects for multiple species.
#'
#' @importFrom Biostrings readAAStringSet
#' @export
#' @rdname get_sequences
#' @examples
#' species <- "cre"
#' seq <- get_sequences(species, type = "protein", transcripts = "longest") 
get_sequences <- function(
        species,
        type = c("CDS", "transcript", "protein"),
        transcripts = c("all", "longest")
) {
    
    vtype <- validate_input(type, c("CDS", "transcript", "protein"))
    vtx <- validate_input(transcripts, c("all", "longest"))
    
    # Construct URL
    burl <- base_url(species)
    seqtype <- ifelse(
        type == "CDS", "cds", 
        ifelse(type == "transcript", "transcripts", "proteome")
    )
    tx <- ifelse(transcripts == "all", ".all_transcripts", ".selected_transcript")
    
    furl <- file.path(
        burl, "Fasta", paste0(seqtype, tx, ".", species, ".fasta.gz")
    )
    
    # Retrieve data
    read_func <- ifelse(type == "protein", readAAStringSet, readDNAStringSet)
    seq <- lapply(furl, function(x) {
        return(read_func(bfcrpath(BiocFileCache(), x)))
    })
    names(seq) <- species
    if(length(furl) == 1) { seq <- seq[[1]] }
    
    return(seq)
}