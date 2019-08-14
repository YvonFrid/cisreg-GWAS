#' @title Run RSAT retrieve-variation-seq to retrieves the sequence surrounding the variant
#' @author Yvon Mbouamboua and Jacques van Helden
#' @description Get the sequence for each allele by sending a request 
#' to *retrieve-variation-seq* via the REST interface of RSAT (<http://rsat.eu>).
#' @param species="Homo_sapiens" species name (e.g. Homo_sapiens). Must be supported on the RSAT server. 
#' @param assembly="GRCh38" genome assembly (e.g. GRCh38). Must be supported on the RSAT server. 
#' @param release=NULL Optional: Ensembl release. If not specified, 
#' the Ensmebl release is the default one of the RSAT server.
#' @param queryFile=NULL a file containing the queries
#' @param queryURL=NULL a string with the URL for the query file
#' @param queryFile=NULL a file containing the queries
#' @param format="varBed" of the query. Supported: varBed
#' @param rest.root="http://rsat-tagc.univ-mrs.fr/rsat/rest/" URL of the root of RSAT REST web services
#' @param outFile=NULL If not null, save the result in the specified file
#' @example 






RsatRetrieveVariationSeqRest <- function(queryFile = NULL,
                                  queryURL = varInfo$server.path,
                                  queryType = 'piping',
                                  format = "varBed",
                                  species = "Homo_sapiens",
                                  assembly = "GRCh38",
                                  release = NULL,
                                  rest.root = "http://rsat-tagc.univ-mrs.fr/rsat/rest/",
                                  outFile = NULL
) {
}



