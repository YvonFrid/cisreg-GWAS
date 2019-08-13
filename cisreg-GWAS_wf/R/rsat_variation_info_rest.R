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
#' 
#' ## Get info for a vector of query IDs
#' ids <- c("rs554219", "rs1542725", "SNP195", "rs1859961", "rs7895676", "rs6983267")
#' snp.info <- RsatVariationInfoRest(query = ids, queryType = "text")
#' 
#' ## Extract thge information from the result
#' names(snp.info)
#' 
#' ## Show the data frame with SNP coordinates
#' snp.info$resultTable
#' 
#' ## Print the execution time
#' snp.info$time
#' 
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
  message("\tREST root: ", rest.root)
  message("\tQuery type: ", queryType)
  
  ## Build a query string by concatenating the query IDs
  if (queryType == "text") {
    queryString <- paste(collapse = ",", query)
    message("\tQuery: contains ", length(query), " IDs")
    string.type <- "text"
  }

  ## Submit a query to variation-info via the REST interface
  runtime <- system.time(
    rest.result <- POST(file.path(rest.root, "variation-info", "Homo_sapiens", "GRCh38"),
                    body = list(i_string = queryString,
                                i_string_type = queryType))
  )
  
  # View(rest.result)
  message("\tElapsed time to get variation-info results from RSAT REST: ", 
          signif(digits=3, runtime["elapsed"]), "s")
  
  ## Extract the content from the REST response
  content <- httr::content(rest.result, as = "text", encoding = "UTF-8")
  # class(content)
  
  ## Parse the JSON content
  fromJSON <- fromJSON(content)
  # names(fromJSON)
  URL <- fromJSON$result_url
  server.path <- fromJSON$result_path
  
  ## Extract the result table from the JSON output
  resultTable <- StringToDataFrame(x = fromJSON$output)
  
  ## Download variation info result and store it to a local file if specified
  if (!is.null(outFile)) {
    download.file(url = URL, destfile = outFile)
    message("\tRSAT variation-info result saved to file\n\t", outFile)
  }
  
  ## Return the relevant information
  result <- list(
    ## Report all the parameter values in the result, for the sake of traceability
    parameters = list(
      query = query,
      queryType = queryType,
      format = format,
      species = species,
      assembly = assembly,
      release = release,
      variationTypes = variationTypes,
      idColumn = idColumn,
      rest.root = rest.root,
      outFile = outFile),
    restResult = rest.result,
    URL = URL,
    server.path = server.path,
    time = runtime,
    resultTable = resultTable
  )
  return(result)
}