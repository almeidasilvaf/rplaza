
#' Construct base PLAZA URLs based on species IDs
#'
#' @param species Character with PLAZA species IDs.
#'
#' @return A character scalar or vector with base URLs for the right
#' PLAZA instances where data input species can be found.
#' 
#' @noRd
base_url <- function(species) {
    
    inst <- sp2instance$instance[sp2instance$PLAZA_ID %in% species]
    
    urls <- vapply(inst, function(x) {
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
