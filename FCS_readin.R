# read in the FCS file and do the pregating

library(rjson)
foldername = '/home/wangmk/UM/Biostatistics/CyTOF/data/20200909/'

fcs_files = paste0(foldername, list.files(foldername))
# match the detector name with marker names
detector_marker_match = unlist(fromJSON(file="/home/wangmk/UM/Biostatistics/CyTOF/CyTOF-process/detector_marker_match.json"))

library(flowCore)

fcs_raw <- read.flowSet(fcs_files, transformation = FALSE, 
                        truncate_max_range = FALSE)

# extract out one dataset from this experiment
example_data <- as.data.table(exprs(fcs_raw[[2]]))
colnames(example_data) <- detector_marker_match[colnames(example_data)]


# filter away the beads
example_data <- example_data[EQ4_beads < 10]

# residual filtering
res_avg <- mean(example_data[Residual>10, Residual])
res_sdv <- sd(example_data[Residual>10, Residual])

example_data <- example_data[Residual > res_avg-2*res_sdv & Residual < res_avg+2*res_sdv,]


# center filtering
ctr_avg <- mean(example_data[, Center])
ctr_sdv <- sd(example_data[, Center])

example_data <- example_data[Center > ctr_avg - 2*ctr_sdv & Center < ctr_avg + 2*ctr_sdv,]

# offset filtering
off_avg <- mean(example_data[, Offset])
off_sdv <- example_data[, Offset]

example_data <- example_data[Offset > off_avg - 2*off_sdv & Offset < off_avg + 2*off_sdv,]

# width filtering
width_avg <- mean(example_data[, Width])
width_sdv <- sd(example_data[, Width])

example_data <- example_data[Width > width_avg - 2*width_sdv & Width < width_avg + 2*width_sdv,]

# eventlength filtering

example_data <- example_data[Event_length > 20 & Event_length < 60,]

# DNA1 filtering
DNA1_mean <- mean(example_data[, DNA1])
DNA1_sdv <- sd(example_data[, DNA1])

example_data <- example_data[DNA1 > DNA1_mean-DNA1_sdv & DNA1 < DNA1_mean + 2*DNA1_sdv, ]

# DNA2 filtering

DNA2_mean <- mean(example_data[, DNA2])
DNA2_sdv <- sd(example_data[, DNA2])

example_data <- example_data[DNA2 > DNA2_mean - 2*DNA2_sdv & DNA2 < DNA2_mean + 2*DNA2_sdv, ]

# Live_Dead Filtering

live_proportion = nrow(example_data[Live_Dead < 100,]) / nrow(example_data)
example_data <- example_data[Live_Dead<100, ]

# CD45 filtering

example_data <- example_data[CD45 > 10, ]


result = list(outputdata = example_data,
     live_proportion = live_proportion)
