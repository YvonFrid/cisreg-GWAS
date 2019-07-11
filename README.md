# A workflow to analyse disease-associated regulatory variants


## Contributors

### Main developer of the workflow

- [Yvon Mbouamboua](https://github.com/yvonfrid), Aix-Marseille Université (AMU), France

### Co-developers

- [Jacques van Helden](https://github.com/jvanheld) for the design of the workflow and revision of the implementation
- Thuy Nga Thi Nguyen  (Ecole Normlale Supérieure, Paris, France), for the REST access to Regulatory Sequence Analysis Tools (RSAT; [http://rsat.eu/](http://rsat.eu/))
- Andrew Parton, for the REST access to [Ensembl](http://ensembl.org)
- Ferran Moratalla Navarro developed the Shiny interface.

### Help for the design

The following persons contributed to the conception of the workflow by sharing expertise and giving advice during the [GREEKC hackathon](https://github.com/GREEKC/hackathon-marseille) (May 23-26, 2019). 

- Aziz Kahn
- Thomas Rosnet

## Motivation

The aim of the workflow is to combine different bioinformatic resources (databases and tools) to detect non-coding disease-associated variant that may affect transcriptional regulation by modifying transcription factor binding sites. 

The workflow relies on the integration of information elements collected automatically from various genomic databases (BioMart, dbSNP, Ensembl), and on the selection of variations that may affect regulation, by combining specialized bioinformatic tools: Regulatory Sequence Analysis Tools (RSAT) and ChIP-seq (ReMap) data. 

The tool is designed generically, and can be adapted for the study of regulatory variants of any disease documented in the GWAS catalog. 

In order to facilitate its use by a biologist, the tool can be used with a graphical interface automatically. The results are described in a report illustrated by figures and tables.

## Implementation

The workflow relies on the **R** statistical language, with BioConductor and CRAN libraries. Remote resources are invoked by REST (Web services). 

The graphical interface relies on R-Shiny.

The analysis report is generated in R markdown, and can be exported in different formats (HTML, pdf, docx). 

## Mobilized resources

The table below provides the URL of each resource mobilised by the workflow, and indicates their API if availeble. 


| Resource name | Data types |  URL | Access mode in the workflow |
|--------------|--------------------|----------------------------------------|-------------------|
| GWAS catalog | SNPs associated to a query disease | <https://www.ebi.ac.uk/gwas/> | ftp download |
| BioMart | Collect SNP missing data| <http://www.biomart.org> | R package|
| ReMap | Collect transcriptional regulators ChIP-seq experiments | <http://remap.cisreg.eu/> | Web interface, to be converted to REST |
| Jaspar |Collect all matrices corresponding to transcription factor names| <http://jaspar2018.genereg.net> | ftp download, to be converted to REST |
| RSAT | Prediction of polymorphic variations affecting trnascription factor binding | <http://rsat.sb-roscoff.fr/> | Web interface, to be converted to REST |

