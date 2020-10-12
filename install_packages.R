# install relevant packages

install.packages(c('devtools', 'dplyr', 'ggplot2', 'data.table',
                   'optparse', 'rjson', 'Rtsne', 'BiocManager'), repos = "http://cran.rstudio.com/")

BiocManager::install('flowCore')
