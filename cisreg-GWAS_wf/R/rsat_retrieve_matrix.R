#' @title Retrieve a subset of position-specific scoring matrices from a collection. 
#' @author Jacques van Helden
#' @description Retrieve a subset of position-specific scoring matrices (PSSM) from a collection. 
#' The collection can be specified as a local file (which will be uploaded to the RSAT server)
#' or as the URL of a collection available on the Web. PSSM should be provided in transfac format. 
#' @param collectionFile=NULL file containing the collection of matrices
#' @param collectionString=NULL string describing the collection location (URL) or its content (text)
#' @param collectionType=NULL indicate the way to provide the collection. Supported: file, url, text
#' @param queryIDs=NULL a vector of query IDs. 
#' @param queryFile=NULL a file containing the query IDs (text file with one row per query)
#' @param rest.root="http://rsat-tagc.univ-mrs.fr/rsat/rest/" URL of the root of RSAT REST web services
#' @param outFile=NULL If not null, save the result in the specified file
#' @examples
#' 
#' ## Specify the IDs
#' ids <- c("CEBPA", "CEBPB", "ELF1", "ERG", "ETS1", 
#'      "ETV4", "FOXA1", "FOXA2", "GABPA", "GATA2", 
#'      "GFI1B", "POU2F2", "RUNX2", "RUNX3", "ZNF384")
#' 
#' ## Define the URL of the matrix collection
#' collectionURL <- file.path("http://metazoa.rsat.eu",
#'    "motif_databases",
#'    "JASPAR",
#'    "Jaspar_2018", 
#'    "nonredundant",
#'    "JASPAR2018_CORE_vertebrates_non-redundant_pfms_transfac.tf")
#'    
#' matrices <- RsatRetrieveMatrix(
#'   queryIDs = ids, 
#'   collectionString = collectionURL,
#'   collectionType = "url")
#' 
#' @export
RsatRetrieveMatrix <- function(collectionFile = NULL,
                           collectionString = NULL,
                           collectionType = NULL,
                           queryIDs = NULL,
                           queryFile = NULL,
                           rest.root = "http://rsat-tagc.univ-mrs.fr/rsat/rest/",
                           outFile = NULL) {
 

  #### Check required parameters  ####

  ## Matrix collection
  if (is.null(collectionFile) & is.null(collectionString)) {
    stop("RetrieveMatrix() requires to specify either collectionFile or collectionString")
  }
  
  ## Query IDs
  if (is.null(queryIDs) & is.null(queryFile)) {
    stop("RetrieveMatrix() requires to specify either queryIDs or queryFile")
  }
  
  #### Prepare the lisgt of options for RSAT REST query ####
  optionList <- list()
  
  ## Query file
  if (!is.null(queryFile)) {
    optionList$id <- paste0("@", queryFile, ";type=text/plain")
  }
  
  ## Query IDs
  if (!is.null(queryIDs)) {
    optionList$id <- paste(collapse = ",", queryIDs)
  }
  
  ## Collection
  if (!is.null(collectionString)) {
    optionList$i_string <- collectionString
    optionList$i_string_type <-   tolower(collectionType)
  }
  
  ## Submit the POST query to the RSAT REST server
  runtime <- system.time(
    rest.result <- POST(file.path(rest.root, "retrieve-matrix"),
                        body = optionList)
  )
  # View(rest.result)
  message("\tretrieve-matrix\tTotal runtime on server side: ", 
          signif(digits = 3, rest.result$times[["total"]]), "s")
  message("\tretrieve-matrix\tElapsed time on client side: ", 
          signif(digits = 3, runtime["elapsed"]), "s")
  
  ## If HTTP returned an error, stop and report the error message
  if (httr::http_error(rest.result)) {
    message("ERROR in RsatRetrieveMatrix()\n\t",
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
  
  ## Extract the result table from the JSON output
  matrices <- strsplit(x = result.fromJSON$output, split = "\n")
#  resultTable <- StringToDataFrame(x = result.fromJSON$output)
  
  ## Download variation info result and store it to a local file if specified
  if (!is.null(outFile)) {
    download.file(url = URL, destfile = outFile)
    message("\tRSAT retrieve-matrix result saved to file\n\t", outFile)
  }
  
  ## Return the relevant information
  result <- list(
    
    ## Report all the parameter values in the result, for the sake of traceability
    # parameters = list(
    #   queryIDs = queryIDs,
    #   queryFile = queryFile,
    #   rest.root = rest.root,
    #   outFile = outFile),
    URL = result.fromJSON$result_url,
    server.path = result.fromJSON$result_path,
    restResult = rest.result,
    time = runtime,
    output = result.fromJSON$output
  )
  
  result$matrices <- matrices
  
  return(result)
}

