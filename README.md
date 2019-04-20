# A workflow to analyse disease-associated regulatory variants


## Project proponent

- [Yvon Mbouamboua](https://github.com/yvonfrid), Aix-Marseille Université (AMU), France

## Expected participants

- Jacques van Helden
- Benoît Ballester
- Aziz Kahn
- Thomas Rosnet
- Thuy Nga Thi Nguyen
- ... additional participants will register during the hackathon

## Motivation

The aim of the project is to apply bioinformatic methods to detect non-coding disease-associated variant that may affect transcriptional regulation by modifying transcription factor binding sites. The approach is based on the integration of information elements collected automatically from various genomic databases (BioMart, dbSNP, Ensembl, HalpoReg), and on the selection of variations that may affect regulation, by combining specialized bioinformatic tools: Regulatory Sequence Analysis Tools (RSAT) and ChIP-seq (ReMap) data. 

For this, we develop an analysis workflow in the R statistical language, with BioConductor and CRAN libraries, to invoke remote resources (Web services). The tool is designed generically, and can be adapted for the study of regulatory variants of any disease documented in the GWAS catalog. 

In order to facilitate its use by a biologist, the tool automatically generates (in R markdown) an analysis report illustrated by figures and tables.

### Interoperability issues

- interfaces
    - Currently there is no Web services for Remap
    - RSAT Web services were originally based on SOAP/WSDL, which is not supported anymore by R
    - We are currently developing a REST interface (and the efforts are put on the tools that will be used for this hackathon)
    - ...
    
- IDs
    - Cross-lins between factor names in ReMap, matrix names from RSAT, matrices from Jaspar, proteins in Uniprot, genes in Ensembl, ...
    

## Mobilized resources

The table below provides the URL of each resource mobilised by the workflow, and indicates their API if availeble. 


| Resource name | Data types |  URL | Access mode in the workflow |
|--------------|--------------------|----------------------------------------|-------------------|
| GWAS catalog | SNPs associated to a query disease | <https://www.ebi.ac.uk/gwas/> | ftp download |
| HaploReg |Collect the SNPs in linkage desiquilibrium (LD) | <https://pubs.broadinstitute.org/mammals/haploreg/> | R package|
| BioMart | Collect SNP missing data| <http://www.biomart.org> | R package|
| ReMap | Collect transcriptional regulators ChIP-seq experiments | <http://remap.cisreg.eu/> | Web interface, to be converted to REST |
| Jaspar |Collect all matrices corresponding to transcription factor names| <http://jaspar2018.genereg.net> | ftp download, to be converted to REST |
| RSAT | Prediction of polymorphic variations affecting trnascription factor binding | <http://rsat.sb-roscoff.fr/> | Web interface, to be converted to REST |

## Languages, libraires and tools used in the workflow

The workflow is written in R code embedded in a R markdown document, which automatically generates a report in HTML , pdf or Word .docs format.                                                                                           

Main R packages
    
- bedR
- biomaRt
- haploR
- GenomicRanges
- ReMapEnrich
- XGR


## Needs

- Replace the downloads and manual analyses by programmatic accesses

    - Use R JASPAR package or RESTful API  to download all matrices
    - REST interface for RSAT
    - REST interface for ReMap

- Cross-references between RSAT and Jaspar matrices 
- Cross-references between ReMap factors and Jaspar
- Understand ReMap and RSAT variation-scan SNPs IDs disparities


## Requested skills for the hacking

- REST API development
- Shiny interface
- Occasional help of the developers of the mobilized resources


## Expectated deliveries

### Final goal

At the end of the hackathon, we aim at providing a fully automated workflow relying as much as possible on APIs wihout having to download the full datasetsa dn parse them locally. 


### Intermediate goals and milestones

After day 1, ...

After day 2, ...

### Deliverables

- A workflow integrated in an R markdown document that automatically runs the analysis and generates a report
- A yaml-base management of the parameters of the workflow
- Examples of utiliation with selected study cases
- A Shiny-based Web interface to the workflow
- Full code of the workflow available in github
- A user documentation enabling biologists to run the anlayses on  their own computer

