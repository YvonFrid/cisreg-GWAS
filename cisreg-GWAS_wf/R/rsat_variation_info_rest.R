#' @title Run RSAT variation-info to collect the coordinates of variations.
#' @author Yvon Mbouamboua and Jacques van Helden
#' @description Get the coordinates from a list of variation identifiers by sending a request 
#' to *variation-info* via the REST interface of RSAT (<http://rsat.eu>). 
#' @param species="Homo_sapiens" species name (e.g. Homo_sapiens). Must be supported on the RSAT server. 
#' @param assembly="GRCh38" genome assembly (e.g. GRCh38). Must be supported on the RSAT server. 
#' @param queries=NULL a vector of variations IDs
#' @param queryURL=NULL a string with the URL fo the query file
#' @param queryFile=NULL a file containing the queries
#' @param format="id" of the query. Supported: id, varBed, bed
#' @param release=NULL Optional: Ensembl release. If not specified, the Ensmebl release is the default one of the RSAT server. 
#' @param variationTypes=NULL Optional vector with the accepted types of variation. 
#' @param idColumn=NULL Optional value indicating the column of the input file containing the variation IDs
#' @param rest.root="http://rsat-tagc.univ-mrs.fr/rsat/rest/" URL of the root of RSAT REST web services
#' @param outFile=NULL If not null, save the result in the specified file
#' @examples 
#' ## Get info for a vector of query IDs
#' ids <- c("rs554219", "rs1542725", "SNP195", "rs1859961", "rs7895676", "rs6983267")
#' snp.info <- RsatVariationInfoRest(query = ids, queryType = "text")
RsatVariationInfoRest <- function(query,
                                  queryType = "text",
                                  format = "id",
                                  species = "Homo_sapiens",
                                  assembly = "GRCh38",
                                  release = NULL,
                                  variationTypes = NULL,
                                  idColumn = NULL,
                                  rest.root = "http://rsat-tagc.univ-mrs.fr/rsat/rest/",
                                  outFile = NULL
                                  ) {
  
  message("Sending variation-info query to RSAT REST services")
  
  ## Build a query string by concatenating the query IDs
  if (queryType == "text") {
    queryString <- paste(collapse = ",", query)
    message("Query type: vector of ", length(query), " IDs")
    string.type <- "text"
  }

  ## Submit a query to variation-info via the REST interface
  varInfo.time <- system.time(
    varInfo <- POST(file.path(rest.root, "variation-info", "Homo_sapiens", "GRCh38"),
                    body = list(i_string = queryString,
                                i_string_type = queryType))
  )
  
  # View(varInfo)
  message("\tElapsed time to get variation-info results from RSAT REST: ", 
          signif(digits=3, varInfo.time["elapsed"]), "s")
  
  ## Extract the content from the REST response
  varInfo.content <- httr::content(varInfo, as = "text", encoding = "UTF-8")
  # class(varInfo.content)
  
  ## Parse the JSON content
  varinfo.fromJSON <- fromJSON(varInfo.content)
  # names(varinfo.fromJSON)
  varInfo.URL <- varinfo.fromJSON$result_url
  varInfo.server.path <- varinfo.fromJSON$result_path
  
  ## Download variation info result and store it to a local file if specified
  if (!is.null(outFile)) {
    download.file(url = varInfo.URL, destfile = outFile)
    message("\tRSAT variation-info result saved to file\n\t", outFile)
  }
  
  ## Return the relevant information
  result <- list(
    restResult = varInfo,
    URL = varInfo.URL,
    server.path = varInfo.server.path,
    resultTable = varinfo.fromJSON
  )
  return(result)
}