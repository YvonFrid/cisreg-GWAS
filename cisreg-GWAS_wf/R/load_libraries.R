
#' @title Load required libraries and install them if required
#' @author Yvon Mbouamboua and Jacques van Helden
#' @description Load the libraries required for cisreg-GWAS from CRAN + BioConductor + github
#' @param cran.libraries.to.install a vector with the names of CRAN libraries to install (default list is used if not specified)
#' @param bioconductor.libraries.to.install a vector with names of the BioConductor libraries to instal (default list is used if not specified)
#' @param github.libraries.to.install a named vector with the names of libraries to install from github (names of the vector elements), and the corresponding accounts (values of the vector elements)
#' @param install.if.required=TRUE automatically install the missing libraries
#' 
#' @export
LoadLibraries <- function(cran.libraries.to.install=c("yaml",
                                                      "dplyr",   
                                                      "devtools",
                                                      "ggplot2", 
                                                      "gridExtra",
                                                      "cowplot",
                                                      "scales",
                                                      "tidyr",
                                                      #"VSE",
                                                      "DiagrammeR",
                                                      "VennDiagram",
                                                      "jsonlite",
                                                      "httr",
                                                      "xml2",
                                                      "RCurl",
                                                      "data.table"),
                          bioconductor.libraries.to.install = c(
                            "biomaRt",
                            "GenomicRanges",
                            "ChIPpeakAnno",
                            "ChIPseeker",
                            "TxDb.Hsapiens.UCSC.hg38.knownGene",
                            "ReactomePA",
                            "enrichplot",
                            #"rGREAT",
                            "XGR",  ## For xEnrichSNPs and related graph representations
                            #"FunciSNP",
                            "TissueEnrich",
                            "grImport2",
                            "DOSE"),
                          github.libraries.to.install = c("ReMapEnrich" = "remap-cisreg"),
                          install.if.required = TRUE) {
  
  
  
  #### Load CRAN packages (install them if required) ####
  message("Loading required libraries")

  message("Loading CRAN libraries")
  for (lib in cran.libraries.to.install) {
    if (require(lib, character.only = TRUE, quietly = TRUE)) {
      message("\tLoaded library\t", lib)
    } else {
      if (install.if.required){
        message("Installing CRAN library\t", lib)
        install.packages(lib, dependencies = TRUE)
      }
    }
    require(lib, character.only = TRUE, quietly = TRUE)
  }
  
  #### Load Bioconductor packages (install them if required) ####
  message("Loading Bioconductor libraries")
  for (lib in bioconductor.libraries.to.install) {
    if (!require(lib, character.only = TRUE, quietly = TRUE)) {
      #   message("\tLoaded library\t", lib)
      # } else {
      if (install.if.required) {
        message("Installing Bioconductor library\t", lib)
        if (!("BiocManager" %in% rownames(installed.packages()))) {
          install.packages("BiocManager")
        } 
        
        BiocManager::install(lib, dependencies = TRUE, ask = FALSE)
        if (!require(lib, character.only = TRUE, quietly = TRUE)) {
          stop("Could not install and load package ", lib)
        }
      }
    }
    #   require(lib, character.only = TRUE, quietly = TRUE)
  }
  
  #### Load some specific R packages from github with devtools ####
  
  ## For github libraries we need to know the account for each package -> we encode this as a named vector
  message("Loading github libraries")
  for (lib in names(github.libraries.to.install)) {
    if (require(lib, character.only = TRUE, quietly = TRUE)) {
      message("\tLoaded library\t", lib)
    } else {
      if (install.if.required) {
        library(devtools)
        message("Installing github library\t", lib)
        github.path <- paste(sep = "/", github.libraries.to.install[lib], lib)
        install_github(github.path, dependencies = TRUE)
        #    install_github(github.path, dependencies = TRUE, force = TRUE)
      }
    }
    require(lib, character.only = TRUE, quietly = TRUE)
  }
  
}
