# nikopechThesis/Genomic Data Integration

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/fpsom/nikopechThesis.git/master?urlpath=rstudio)

## Getting Started

Before running the algorithm, the following steps need to be followed

### Prerequisites

In order to run the integration algorithm, the following packages are required:

- biomaRt
(https://bioconductor.org/packages/release/bioc/html/biomaRt.html)
- IlluminaHumanMethylation450kanno.ilmn12.hg19 
(https://bioconductor.org/packages/release/data/annotation/html/IlluminaHumanMethylation450kanno.ilmn12.hg19.html)
- vcfR (https://cran.r-project.org/web/packages/vcfR/index.html)
- data.table
- gtools
- stringr / stringi

For plotting, the following packages are also required:

- karyoploteR (http://bioconductor.org/packages/release/bioc/html/karyoploteR.html)
- png (https://cran.r-project.org/web/packages/png/index.html)
- magick (https://cran.r-project.org/web/packages/magick/index.html)

### Installing

Download the files in a directory, set the directory as your working directory, and run the following command into Rstudio's console

```
source("bioCombine.R")
```

## Documentation

```
bioCombine(biodata, colCmb = NULL, scale = 100, chromosomes = NULL)
```
| Property    | Type            | Default | Description |
|:------------|:----------------|:--------|:------------|
| ```biodata``` | list of strings | required | List of all file paths that are going to be given as input to the algorithm (for the format of this variable, please see bellow). |
| ```colCmb``` | string          | NULL     | Path of the file that is going to be used for column integration. If NULL, column integration is not required (for the format of this variable, please see bellow). |                                                                                                                             
| ```scale``` | Numeric         | 100      | Number used for scaling of inputs. |                                                                                              
| ```chromosomes``` | string          | NULL     | Chromosome that is going to be used (given as a number, not 'chr1').|  

- ```biodata```: It is a list of strings that shows all paths to file-inputs. Supposing that each CSV file contains all columns of an array and each VCF/TXT file contains only one column of an array, then the following format in applied: Fist argument should be path to CSV files, second argument should be a list that contains paths to TXT files and third argument should be a list with paths to VCF files (```list(c("/path/to/csv/files"), list(c("/first/path/to/txt/files", "/second/path/to/txt/files")), list(c("/first/path/to/vcf/files", "/second/path/to/vcf/files"))))```

## Usage

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
