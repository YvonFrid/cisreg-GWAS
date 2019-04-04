# A workflow to analyse disease-associated regulatory variants


## Project proponent

- [Yvon Mbouamboua](https://github.com/yvonfrid), Aix-Marseille Université (AMU), France

## Motivation

...

### Interoperability issues

- interfaces
    - Currently there is no Web services for Remap
    - RSAT Web services are based on SOAP/WSDL, which is not supported anymore by R
    - ...
    
- IDs
    - Cross-lins between factor names in ReMap, matrix names from RSAT, matrices from Jaspar, proteins in Uniprot, genes in Ensembl, ...
    

## Mobilized resources

The table below provides the URL of each resource mobilised by the workflow, and indicates their API if availeble. 


| Resource name | Data types |  URL | Access mode in the workflow |
|-----------------|----------------|----------------|-------------------|
| GWAS catalog | SNPs associated to a query disease | <https://www.ebi.ac.uk/gwas/> | ftp download |
| HaploReg |Collect the SNPs in linkage desiquilibrium (LD)|<https://pubs.broadinstitute.org/mammals/haploreg/haploreg.php>|R package|
| BioMart | |||
| ReMap |
| Jaspar |
| RSAT | 

## Languages, libraires and tools used in the workflow

The workflow is written in R code embedded in a R markdown document, which automatically generates a report n HTML , pdf or Word .docs format                                                                                                                   . 

Main R packages

    - bedR


## Needs

- Replace the downloads and manual analyses by programmatic accesses
- REST interface for RSAT
- REST interface for ReMap
- Cross-references between RSAT and Jaspar matrices 
- Cross-references between ReMap factors and Jaspar
- ...

## Requested skills for the hacking

- REST API development
- Shiny interface
- Occasional help of the developers of the mobilized resources

## Expected participants

- Jacques van Helden
- Benoît Ballester
- Aziz Kahn
- ....
...

## Expectated deliveries

### Final goal

At the end of the hackathon, we aim at providing a fully automated workflow relying as much as possible on APIs wihout having to download the full datasetsa dn parse them locally. 


### Intermediate goals and milestones

After day 1, ...

After day 2, ...

### Deliverables

- A workflow in R markdown document
- Examples of utiliation with selected study cases
- A Shiny-based Web interface to the workflow
- Full code of the workflow available in github
- A user documentation enabling biologists to run the anlayses on  their own computer

