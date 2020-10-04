# read in the FCS file and do the pregating

library(rjson)
foldername = '/net/wonderland/home/wangmk/CyTOF/data/20200909'

fcs_files = paste0(foldername, list.files(foldername))
# match the detector name with marker names
detector_marker_match = unlist(fromJSON(file="detector_marker_match.json"))

library(flowCore)
library(data.table)

source('Gating_function.R')

fcs_raw <- read.flowSet(fcs_files, transformation = FALSE, 
                        truncate_max_range = FALSE)

gated_totaldata <- Reduce(function(...) merge(..., all = TRUE), fsApply(fcs_raw, pregating))

# gated_totaldata[, .(count = .N, liveprop = mean(live_proportion)), by = file]

fwrite(gated_totaldata, "/net/wonderland/home/wangmk/CyTOF/data/combined_fcs_20200909.csv")
