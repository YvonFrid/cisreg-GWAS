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
#' @param skip=NULL Skip the N first variations of the input file. This option is useful to run quick tests, or to split an analysis in separate tasks.
#' @param last=NULL Stop after the N first variations of the list. This option is useful to run0 quick tests, or to split an analysis in separate tasks.
#' @param rest.root="http://rsat-tagc.univ-mrs.fr/rsat/rest/" URL of the root of RSAT REST web services
#' @param outFile=NULL If not null, save the result in the specified file
#' @examples 
#' 
#' ## Get info for a vector of query IDs
#' ids <- c("rs554219", "rs1542725","rs1859961", "rs7895676", "rs6983267")
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
                                  skip = NULL,
                                  last = NULL,
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
  }

  
  ## Prepare the list of optins
  optionList <- list(i_string = queryString,
                     i_string_type = queryType)
  if (!is.null(release)) {
    optionList[["release"]] = release
  }
  if (!is.null(variationTypes)) {
    optionList[["type"]] = paste(collapse = ",", variationTypes)
  }
  if (!is.null(idColumn)) {
    optionList[["col"]] = idColumn
  }
  if (!is.null(skip)) {
    optionList[["skip"]] = skip
  }
  if (!is.null(last)) {
    optionList[["last"]] = last
  }
  
  ## Submit a query to variation-info via the REST interface
  runtime <- system.time(
    rest.result <- POST(file.path(rest.root, "variation-info", species, assembly),
                    body = optionList)
  )
  # View(rest.result)
  
  
  # View(rest.result)
  message("\tvariation-info\tTotal runtime on server side: ", 
          signif(digits = 3, rest.result$times[["total"]]), "s")
  message("\tvariation-info\tElapsed time on client side: ", 
          signif(digits = 3, runtime["elapsed"]), "s")
  
  ## If HTTP returned an error, stop and report the error message
  if (httr::http_error(rest.result)) {
    message("ERROR in RsatVariationInfoRest()\n\t",
            httr::content(rest.result, as = "parsed", encoding = "UTF-8")$message, 
            "\n\t", 
            httr::content(rest.result, as = "parsed", encoding = "UTF-8")$errors)
    stop(paste(collapse = "\n\t", httr::http_status(rest.result)))
  }
  
  
  ## Extract the content from the REST response
  result.content <- httr::content(rest.result, as = "text", encoding = "UTF-8")
  # class(content)
  
  ## Parse the JSON content
  result.fromJSON <- fromJSON(result.content)
  # names(fromJSON)
  URL <- result.fromJSON$result_url
  server.path <- result.fromJSON$result_path
  
  ## Extract the result table from the JSON output
  resultTable <- StringToDataFrame(x = result.fromJSON$output)
  
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
      skip = skip,
      last = last,
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