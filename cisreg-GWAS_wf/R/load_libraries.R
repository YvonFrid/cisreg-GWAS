
#' @title Load required libraries and install them if required
#' @author Yvon Mbouamboua and Jacques van Helden
#' @description Load the libraries required for cisreg-GWAS from CRAN + BioConductor + github
#' @param cran.libraries.to.install a vector with the names of CRAN libraries to install (default list is used if not specified)
#' @param bioconductor.libraries.to.install a vector with names of the BioConductor libraries to instal (default list is used if not specified)
#' @param github.libraries.to.install a named vector with the names of libraries to install from github (names of the vector elements), and the corresponding accounts (values of the vector elements)
#' @param auto.install=FALSE automatically install the missing libraries
#' @examples
#' 
#' ## Load all the R librairies required for the cisreg-GWAS 
#' ## workflow and install the missing ones
#' LoadLibraries(auto.install = TRUE)
#' 
#' @export
LoadLibraries <- function(cran.libraries.to.install=c("yaml",
                                                      "dplyr",   
                                                      "devtools",
                                                      "qqman",
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
                            # "grImport2",
                            "DOSE"),
                          github.libraries.to.install = c("ReMapEnrich" = "remap-cisreg"),
                          auto.install = FALSE) {
  
  
  
  #### Load CRAN packages (install them if required) ####
  message("Loading required libraries gor cisreg-GWAS workflow")

  message("\tLoading CRAN libraries")
  for (lib in cran.libraries.to.install) {
    if (require(lib, character.only = TRUE, quietly = TRUE)) {
      message("\t\tLoaded library\t", lib)
    } else {
      if (auto.install) {
        message("\t\tInstalling CRAN library\t", lib)
        install.packages(lib, dependencies = TRUE)
      } else {
        message("\t\tMissing CRAN library: ", lib)
      }
    }
    require(lib, character.only = TRUE, quietly = TRUE)
  }
  
  #### Load Bioconductor packages (install them if required) ####
  message("\tLoading Bioconductor libraries")
  for (lib in bioconductor.libraries.to.install) {
    if (require(lib, character.only = TRUE, quietly = TRUE)) {
      message("\t\tLoaded library\t", lib)
    } else {
      if (auto.install) {
        message("\t\tInstalling Bioconductor library\t", lib)
        if (!("BiocManager" %in% rownames(installed.packages()))) {
          install.packages("BiocManager")
        } 
        
        BiocManager::install(lib, dependencies = TRUE, ask = FALSE)
        if (!require(lib, character.only = TRUE, quietly = TRUE)) {
          stop("Could not install and load package ", lib)
        }
      } else {
        message("\t\tMissing BioConductor library: ", lib)
      }
    }
    #   require(lib, character.only = TRUE, quietly = TRUE)
  }
  
  #### Load some specific R packages from github with devtools ####
  
  ## For github libraries we need to know the account for each package -> we encode this as a named vector
  message("\tLoading github libraries")
  for (lib in names(github.libraries.to.install)) {
    if (require(lib, character.only = TRUE, quietly = TRUE)) {
      message("\t\tLoaded library\t", lib)
    } else {
      if (auto.install) {
        library(devtools)
        message("\t\tInstalling github library\t", lib)
        github.path <- paste(sep = "/", github.libraries.to.install[lib], lib)
        install_github(github.path, dependencies = TRUE)
        #    install_github(github.path, dependencies = TRUE, force = TRUE)
      } else {
        message("\t\tMissing github library: ", lib)
      }
    }
    require(lib, character.only = TRUE, quietly = TRUE)
  }
  
}
