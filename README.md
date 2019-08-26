# nikopechThesis/Genomic Data Integration

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

## Usage

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
