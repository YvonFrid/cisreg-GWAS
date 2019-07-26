#' @title collect annotations about TFMBs from JASPAR 
#' @author: Aziz Kahn, Jacques van Helden, Yvon Mbouamboua
#' @description collect detailed information about transcription factor  binding motifs (TFBM) from the JASPAR database, using the REST API. 
#' @param outdir output directory (will be crearted if it does not exist)
#' @param tax.group="vertebrates" taxonomic group of interest
#' @param collection="CORE" JASPAR collection 
#' @param save.pssm=TRUE if TRUE, save each matrix in a separate file (jaspar format)
#' @param save.logos=TRUE if TRUE, save the matrix logos in separate files (svg format)
#' @param overwrite=FALSE if TRUE, overwrite existing files (matrices and logos), if FALSE, save files only if missing
#' @export
CollectJasparAnnotations <- function(outdir, 
                                     tax.group = "vertebrates",
                                     collection = "CORE",
                                     save.pssm = TRUE,
                                     save.logos = TRUE,
                                     overwrite = FALSE) {

  
  ## Created on January 11, 2018
  ## Author: <Aziz Khan>aziz.khan@ncmm.uio.no
  ## Adapted by : Jacques van Helden and Yvon Mbouamboua
  
  
  ## Create output directory if required  
  dir.create(outdir,  
             showWarnings = FALSE, 
             recursive = TRUE)
  
  #### Get basic information table sabout JASPAR matrices ####
  ## restricted to a collection specified in the parameters.
  message("Getting annotations for Jaspar matrices")
  
  jaspar.collection.url <- paste0(
    parameters$jaspar.rest.root,
    "matrix/?",
    "collection=", collection,
    "&tax_group=", tax.group, 
    "&order=name&version=latest&page_size=10000&format=json")
  message("\tURL to get information about all JASPAR matrices\n", 
          "\t\t", jaspar.collection.url)
  
  jaspar.collection.result <- fromJSON(jaspar.collection.url)
  # View(jaspar.collection.result)
  
  ## Get all the matrix IDs
  jaspar.collection.table <- jaspar.collection.result$results
  # View(jaspar.collection.table)
  matrix.ids <- jaspar.collection.table$matrix_id
  nbMatrices <- length(matrix.ids)
  message("\tJaspar collection ", collection, " ", tax.group, " contains ", nbMatrices, " matrices")
  
  ## Export JASPAR annotations in a tab-separated values (tsv) file
  jaspar.collection.file <- file.path(
    outdir,
    paste0("jaspar_", collection, "_", tax.group, "_info.tsv"))
  write.table(jaspar.collection.table,
              jaspar.collection.file, 
              sep = "\t", 
              col.names = TRUE, row.names = FALSE, quote = FALSE)
  
  message("\tJaspar collection info\t", jaspar.collection.file)
  
  #### Download individual matrices from JASPAR  and collect detailed annotations ####
  
  ## Create a fodler for individual PSSM from JASPAR
  if (save.pssm) {
    pssm.dir <- file.path(outdir,  'pssm')
    message("\tCollectJasparAnnotations()",
            "\tSaving individual matrices in dir\n\t\t", 
            pssm.dir)
    dir.create(pssm.dir, 
               showWarnings = FALSE, 
               recursive = TRUE)
  }
  
  
  
  # # Create the vector of matrix.id from variation-scan
  # varscanMatrix <- varScanJaspar$X.ac_motif
  # inter.matrix.ids <- intersect.Vector(varscanMatrix, matrix.ids)
  
  jaspar.annotation.table <- data.frame()
  message("\tDownloading ", nbMatrices, " individual matrices from JASPAR REST web services")
  i <- 1
  for (i in 1:length(matrix.ids)) {
    matrix.id <- matrix.ids[i]

    ## Define the URL of JASPAR REST service to get the matrix
    jaspar.matrix.url <- paste0(parameters$jaspar.rest.root, "matrix/", matrix.id,".json")
    jaspar.matrix.result <- fromJSON(jaspar.matrix.url)
    message("\tmatrix\t", i, "/", nbMatrices, "\t", matrix.id, "\tdonwloaded from ", jaspar.matrix.url)
    
    ## Add a row with the annotations of the  current matrix
    ## to the matrix annotation table 
    jaspar.matrix.row <- data.frame(
      matrix.id = jaspar.matrix.result$matrix_id, 
      base.id = jaspar.matrix.result$base_id,
      version = jaspar.matrix.result$version,
      symbol = paste(collapse = "; ", unlist(jaspar.matrix.result$symbol)), 
      name = paste(collapse = "; ", unlist(jaspar.matrix.result$name)),
      alias = paste(collapse = "; ", unlist(jaspar.matrix.result$alias)), 
      remap.tf.name = paste(collapse = "; ", unlist(jaspar.matrix.result$remap_tf_name)),
      class = paste(collapse = "; ", unlist(jaspar.matrix.result$class)), 
      species = paste(collapse = "; ", unlist(jaspar.matrix.result$species)), 
      uniprot.ids = paste(collapse = "; ", unlist(jaspar.matrix.result$uniprot_ids)), 
      pubmed.ids = paste(collapse = "; ", unlist(jaspar.matrix.result$pubmed_ids)), 
      source = paste(collapse = "; ", unlist(jaspar.matrix.result$pubmed_ids)),
      type = paste(collapse = "; ", unlist(jaspar.matrix.result$type)))
    
    if (i == 1) {
      jaspar.annotation.table = jaspar.matrix.row
    }  else {
      jaspar.annotation.table = rbind(jaspar.annotation.table, jaspar.matrix.row)
      
    } 
    
    ## Save matrix counts in jaspar format  
    if (save.pssm) {
      
      ## Define the path of the local file  
      pssm.file <- file.path(pssm.dir, paste0(matrix.id, ".txt"))
      
      if (file.exists(pssm.file) & !overwrite) {
        message("\tmatrix ", i, "/", nbMatrices, "\t", matrix.id, "\tfile exists\t", pssm.file)
      } else {
        cat(paste0(">",matrix.id, " ", jaspar.matrix.result$name,"\n"), file = pssm.file)
        write.table(t(as.data.frame.list(jaspar.matrix.result$pfm[c("A", "C", "G","T")])), 
                    pssm.file, sep = "\t", 
                    col.names = FALSE, 
                    row.names = FALSE, 
                    append = TRUE)
        message("\tmatrix ", i, "/", nbMatrices, "\t", matrix.id, "\tsaved to file\t", pssm.file)
      }
    }
  }
  # View(jaspar.annotation.table)
  
  ## Export variation-scan file in tsv format
  jaspar.annotation.file <- file.path(
    outdir,
    paste0("jaspar_", collection, "_", tax.group, "_matrix_annotations.tsv"))

  write.table(x = jaspar.annotation.table,
              file = jaspar.annotation.file,
              quote = FALSE,
              sep = "\t",
              row.names = FALSE,
              col.names = TRUE)
  message("Exported matrix annotations to file\n\t\t", jaspar.annotation.file)
  #system(paste("open", result.dir.path["RSAT"]))
  
  return(jaspar.annotation.table)
}

