
#' Extract gene annotation as a `GRanges` object
#'
#' @param species Character vector of PLAZA species IDs.
#' @param transcripts Character indicating what genes for which ranges will
#' be extracted. One of 'all' (for each gene, all transcripts and 
#' associated features), or 'longest' (for each gene, only longest transcripts
#' and associated features).
#' @param features Character indicating what features to extract. One of
#' 'all' (all features, including exons, mRNAs, CDS, UTRs, etc), or 
#' 'exons' (only exon features).
#' 
#' @return A `GRanges` object for a single species, or a `GRangesList` object
#' for multiple species.
#'
#' @importFrom rtracklayer import
#' @importFrom BiocFileCache bfcrpath BiocFileCache
#' @importFrom GenomicRanges GRangesList
#'
#' @rdname get_annotation
#' @export
#' @examples
#' ranges <- get_annotation(
#'     species = c("aly", "ath"), 
#'     transcripts = "longest", features = "all"
#' )
get_annotation <- function(
        species, 
        transcripts = c("all", "longest"), 
        features = c("all", "exons")
) {
    
    vt <- validate_input(transcripts, c("all", "longest"))
    vf <- validate_input(features, c("all", "exons"))
    
    # Construct URL
    burl <- base_url(species)
    tx <- ifelse(transcripts == "all", ".all_transcripts", ".selected_transcript")
    ft <- ifelse(features == "all", ".all_features", ".exon_features")
    
    furl <- file.path(
        burl, "GFF", species, 
        paste0("annotation", tx, ft, ".", species, ".gff3.gz")
    )
    
    # Retrieve data
    ranges <- lapply(furl, function(x) {
        return(rtracklayer::import(bfcrpath(BiocFileCache(), x)))
    })
    names(ranges) <- species
    ranges <- GenomicRanges::GRangesList(ranges)
    if(length(furl) == 1) { ranges <- ranges[[1]] }
    
    return(ranges)
}
