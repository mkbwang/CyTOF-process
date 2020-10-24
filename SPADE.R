# spade analysis on fcs files

library(optparse)
library(flowCore)
library(spade)

# parse in arguments

option_list = list(
  make_option(c("-f", "--folder"), type="character", default=NULL, 
              help="folder with the target FCS file", metavar="character"),
  make_option(c("-i", "--fcsin"), type="character", default="readin.fcs", 
              help="FCS file to run SPADE analysis", metavar="character"),
  make_option(c("-o", "--output"), type="character", default="out", 
              help="output directory name", metavar="character")
)

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

# needs to be changed
markers <- c('CD66b', 'CD16', 'CD15', 'CD19', 'CD20', 
             'CD27', 'CD38', 'CD3', 'CD4', 'CD8', 
             'HLA-DR', 'CD56', 'CD123', 'CD11c', 
             'CD14', 'CD45RA', 'CCR7')

SPADE.driver(file.path(opt$folder, opt$fcsin), out_dir = file.path(opt$folder, opt$output),
             cluster_cols = markers, transforms=flowCore::arcsinhTransform(a=0, b=0.2),
             layout=SPADE.layout.arch, downsampling_target_number = 20000, 
             k= 50, clustering_samples = 20000)
