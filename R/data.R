
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


#' Phylogenetic tree with relationships between species in all PLAZA instances
#'
#' Trees were obtained from the home page of each PLAZA instance and combined
#' to include all (non-redundant) species.
#' 
#' @name plaza_tree
#' @format A `phylo` object with tip labels corresponding to PLAZA species IDs.
#' Lengths of all branches are 0.05 and do not represent any meaningful
#' measure of time (neither absolute not accumulated substitutions).
#' @examples 
#' data(plaza_tree)
#' @usage data(plaza_tree)
"plaza_tree"
