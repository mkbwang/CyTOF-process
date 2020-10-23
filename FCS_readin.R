# read in the FCS file and do the pregating

library(rjson)
library(optparse)

# parse in arguments

option_list = list(
  make_option(c("-f", "--folder"), type="character", default=NULL, 
              help="folder with fcs files", metavar="character"),
  make_option(c("-o", "--out"), type="character", default="out.txt", 
              help="output csv file name [default= %default]", metavar="character")
);

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

if (is.null(opt$folder)){
  print_help(opt_parser)
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
}

foldername = opt$folder

fcs_files = paste0(foldername, list.files(foldername, pattern = "\\.fcs$"))

# match the detector name with marker names
detector_marker_match = unlist(fromJSON(file="detector_marker_match.json"))

library(flowCore)
library(data.table)

source('Gating_function.R')

fcs_raw <- read.flowSet(fcs_files, transformation = FALSE, 
                        truncate_max_range = FALSE)

gated_totaldata <- Reduce(function(...) merge(..., all = TRUE), fsApply(fcs_raw, pregating))

# gated_totaldata[, .(count = .N, liveprop = mean(live_proportion)), by = file]

fwrite(gated_totaldata, file.path(foldername, opt$out))
