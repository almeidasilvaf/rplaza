
#' Metadata and taxonomic information for all species on PLAZA instances
#'
#' Data provenance metadata were obtained from PLAZA, and taxonomic 
#' information were obtained with the _taxize_ package.
#' 
#' @name plaza_metadata
#' @format A list of data frame with elements \strong{Dicots}, 
#' \strong{Monocots}, \strong{Diatoms}, and \strong{Pico}. Each data frame 
#' contains metadata for a specific PLAZA instance, with the following
#' variables:
#' \describe{
#'   \item{PLAZA_ID}{Character, PLAZA species ID.}
#'   \item{common_name}{Character, common species name.}
#'   \item{NCBI_name}{Character, NCBI species name.}
#'   \item{NCBI_taxid}{Numeric, NCBI Taxonomy ID of the species.}
#'   \item{family}{Character, plant family.}
#'   \item{order}{Character, plant order.}
#'   \item{class}{Character, plant class.}
#'   \item{source}{Character, genome accession or version.}
#'   \item{data_provider}{Character, data provider.}
#'   \item{pubmed_id}{Numeric, PubMed ID of the original publication.}
#' }
#' @examples 
#' data(plaza_metadata)
#' @usage data(plaza_metadata)
"plaza_metadata"

