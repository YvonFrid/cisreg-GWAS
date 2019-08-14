LoadLibraries <- function(cran.libraries.to.install = NULL,
                          bioconductor.libraries.to.install = NULL,
                          github.libraries.to.install = NULL,
                          install.if.required = TRUE) {
  
  
  
  #### Load CRAN packages (install them if required) ####
  message("Loading required libraries")
  if (is.null(cran.libraries.to.install)) {
    cran.libraries.to.install <- 
      c("yaml",
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
        "data.table"
        # "gProfileR"
      )     
  }    
  
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
  if (is.null(bioconductor.libraries.to.install)) {
    bioconductor.libraries.to.install <- c(
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
      "DOSE"
    )
  }  
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
  if (is.null(github.libraries.to.install)) {
    message("Temporarily disactivating the installatoion of remap-cisreg/ReMapEnrich due to system-wise library dependency of RMySQL")
#    github.libraries.to.install <- c("ReMapEnrich" = "remap-cisreg")
  }
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
