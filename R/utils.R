
#' Construct base PLAZA URLs based on species IDs
#'
#' @param species Character with PLAZA species IDs.
#'
#' @return A character scalar or vector with base URLs for the right
#' PLAZA instances where data input species can be found.
#' 
#' @noRd
base_url <- function(species) {
    
    inst_df <- sp2instance[sp2instance$PLAZA_ID %in% species, ]
    inst_df <- inst_df[match(species, inst_df$PLAZA_ID), ]
    
    urls <- vapply(inst_df$instance, function(x) {
        if(x == "Dicots") {
            u <- "https://ftp.psb.ugent.be/pub/plaza/plaza_public_dicots_05"
        } else if(x == "Monocots") {
            u <- "https://ftp.psb.ugent.be/pub/plaza/plaza_public_monocots_05"
        } else if(x == "Diatoms") {
            u <- "ftp://ftp.psb.ugent.be/pub/plaza/plaza_diatoms_01"
        } else {
            u <- "ftp://ftp.psb.ugent.be/pub/plaza/plaza_pico_03"
        }
    }, character(1))
    names(urls) <- species
    
    return(urls)
}


#' Automatically detect field delimiter for PLAZA CSV files
#'
#' @param species Character with PLAZA species IDs.
#'
#' @return A character scalar or vector with field delimiters for each
#' species.
#' 
#' @noRd
get_delim <- function(species) {
    
    inst_df <- sp2instance[sp2instance$PLAZA_ID %in% species, ]
    inst_df <- inst_df[match(species, inst_df$PLAZA_ID), ]
    
    delims <- ifelse(inst_df$instance %in% c("Pico", "Diatoms"), ";", "\t")
    names(delims) <- species
    
    return(delims)
}
