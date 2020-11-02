
<!-- README.md is generated from README.Rmd. Please edit that file -->

# CyTOFprocess

<!-- badges: start -->

<!-- badges: end -->

The goal of CyTOFprocess is to process mass cytometry data in raw fcs
format. Currently we have `QC_summary` function that takes in a folder
name and then process all the fcs files in the folder to generate a cell
count summary for each patient.

## Installation

First install using `install_github` from `devtools` package, then try
the script below.

``` r
library(CyTOFprocess)
```

## Example

I have prepared a small example using three mock fcs files. Use the
following code to see the result

``` r
library(CyTOFprocess)
# generate the summary
knitr::kable(QC_summary(folder = system.file("extdata", package = "CyTOFprocess")))
#>   Estimated downsampling-I progress:  0% ...
#>   Estimated downsampling-I progress: 100% ...
```

| cells                              | mockp1.fcs | mockp2.fcs | mockp3.fcs |
| :--------------------------------- | ---------: | ---------: | ---------: |
| B Memory                           |        335 |        305 |        335 |
| CD4.CM                             |       3968 |       3933 |       3955 |
| CD4.CM/CD8.CM                      |         12 |          7 |          8 |
| CD4.EM                             |        182 |        174 |        177 |
| CD4.TEM                            |        422 |        432 |        431 |
| CD8.CM                             |        634 |        685 |        678 |
| CD8.EM                             |        233 |        229 |        254 |
| CD8.TEM                            |         74 |         75 |         61 |
| CD8.TEM/NKT                        |         57 |         57 |         64 |
| Naive B                            |        881 |        846 |        845 |
| Naive CD4                          |       1851 |       1810 |       1808 |
| Naive CD4/Naive CD8                |         27 |         31 |         36 |
| Naive CD8                          |        469 |        480 |        459 |
| Neutrophils                        |        296 |        297 |        297 |
| Neutrophils/B Memory/Naive CD4/NKT |          5 |          4 |          3 |
| NK.CD16-                           |        358 |        374 |        372 |
| NK.CD16+                           |         63 |         49 |         53 |
| NKT                                |        134 |        121 |        137 |
| pDC                                |        166 |        165 |        170 |
| Unidentified                       |       1478 |       1500 |       1535 |

``` r
# remove the output files
unlink(system.file("extdata", "combined.fcs", package = "CyTOFprocess"))
unlink(system.file("extdata", "combined_index.txt", package = "CyTOFprocess"))
```

The package is still under development by Mukai Wang.
