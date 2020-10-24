# read in the FCS file and do the pregating

library(rjson)
library(optparse)
library(Biobase)
library(flowCore)

# parse in arguments

option_list = list(
  make_option(c("-f", "--folder"), type="character", default=NULL, 
              help="folder with fcs files", metavar="character"),
  make_option(c("-o", "--out"), type="character", default="out", 
              help="output csv and index file name [default= %default]", metavar="character")
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

# carry out gating on all the flowframes and combine them into one data table
gated_totaldata <- Reduce(function(...) merge(..., all = TRUE), fsApply(fcs_raw, pregating))

# extract out the file information and store the data table back into a flowframe
index_data <- gated_totaldata[, "file"]
gated_mat <- as.matrix(gated_totaldata[, file:=NULL])

meta <- data.frame(name=dimnames(gated_mat)[[2]],
                   desc=dimnames(gated_mat)[[2]])

meta$range <- apply(apply(gated_mat, 2, range), 2, diff)
meta$minRange <- apply(gated_mat, 2, min)
meta$maxRange <- apply(gated_mat, 2, max)

combined_fcs <- new("flowFrame", exprs = gated_mat,
                    parameters = AnnotatedDataFrame(meta))

fcs_filename <- paste0(opt$out, ".fcs")
index_filename <- paste0(opt$out, "_index.txt")

write.FCS(combined_fcs, file.path(foldername, fcs_filename))
write.table(index_data, file.path(foldername, index_filename), 
            row.names = FALSE, quote=FALSE)

# fwrite(gated_totaldata, file.path(foldername, opt$out))
