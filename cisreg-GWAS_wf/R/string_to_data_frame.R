#' @title parse a string with tab-separated values to extract a data.frame
#' @author Jacques van Helden
#' @param x input string
#' @param newline="\n" newline character
#' @param sep="\t" column separator
#' @param comment.char=";" character indicating comment lines (will be filtered out from the result lines)
#' @param header.char="#" character indicating the column header line. Will be use to define column names in the output data frame. 
#' @param rown.names=NULL if numeric, indicate a column to be used as row names
#' @export
StringToDataFrame <- function(x,
                              newline="\n",
                              sep="\t",
                              comment.char=";",
                              header.char="#",
                              row.names = NULL) {
  
  ## Extract the result table from the JSON output
  result.lines <- unlist(strsplit(x, split = newline))
  
  ## Suppress comment lines (in RSAT output, they start with ";")
  result.lines <- grep(x = result.lines, pattern = paste0("^", comment.char), perl = TRUE, invert = TRUE, value = TRUE)
  
  ## Suppress empty lines
  result.lines <- grep(x = result.lines, pattern = "^$", perl  = TRUE, invert = TRUE, value = TRUE)
  
  ## Get header line
  header.line <- grep(pattern = paste0("^", header.char), x = result.lines, perl = TRUE, value = TRUE)
  header.line <- sub(x = header.line, pattern = "^#", replacement = "", perl = TRUE)
  column.names <- unlist(strsplit(x = header.line, split = "\t"))
  
  ## Remove the header line from the result lines
  result.lines <- grep(pattern = paste0("^", header.char), x = result.lines, perl = TRUE, value = TRUE, invert = TRUE)
  
  ## Extract a data frame with the result table
  result.table <- t(as.data.frame.list(sapply(result.lines, strsplit, split = "\t"), stringsAsFactors = FALSE))
  colnames(result.table) <- column.names
  
  ## Extract row names
  if (!is.null(row.names)) {
    rownames(result.table) <- result.table[, row.names]
    result.table <- result.table[, -row.names]
  } else {
    rownames(result.table) <- NULL
  }
  
  ## Convert numeric columns to numeric values
  result.table <- transform(result.table, chr = as.numeric(chr))

  
  return(result.table)
}