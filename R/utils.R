
#' Get base URL for a PLAZA instance
#'
#' @param instance Character scalar with name of PLAZA instance for which
#' base URL will be extracted. One of 'Dicots', 'Monocots', 'Diatoms',
#' or 'Pico'.
#'
#' @return A character scalar with the base URL of the specified PLAZA
#' instance.
#' @noRd
instance2url <- function(instance) {
    
    if(instance == "Dicots") {
        u <- "https://ftp.psb.ugent.be/pub/plaza/plaza_public_dicots_05"
    } else if(instance == "Monocots") {
        u <- "https://ftp.psb.ugent.be/pub/plaza/plaza_public_monocots_05"
    } else if(instance == "Diatoms") {
        u <- "ftp://ftp.psb.ugent.be/pub/plaza/plaza_diatoms_01"
    } else if(instance == "Pico") {
        u <- "ftp://ftp.psb.ugent.be/pub/plaza/plaza_pico_03"
    } else {
        stop("Invalid PLAZA instance. Use one of 'Dicots', 'Monocots', 'Diatoms', or 'Pico'.")
    }
    
    return(u)
}



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
    if(nrow(inst_df) == 0) { 
        stop("None of the input species IDs match PLAZA species IDs.") 
    }
    inst_df <- inst_df[match(species, inst_df$PLAZA_ID), ]
    
    urls <- vapply(inst_df$instance, instance2url, character(1))
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

#' Helper function to validate input to function parameters
#'
#' @param parameter Character indicating the parameter's name.
#' @param valid_options Character indicating allowed input options to
#' parameter specified in \strong{parameter}
#' 
#' @noRd
validate_input <- function(parameter, valid_options) {
    
    if(!parameter %in% valid_options) {
        stop(paste0("Invalid input to parameter '", parameter, "'."))
    }
    
    return(TRUE)
}


