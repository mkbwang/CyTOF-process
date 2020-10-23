# summarize the population distribution across samples

library(optparse)
library(data.table)

# parse in arguments

option_list = list(
  make_option(c("-f", "--file"), type="character", default=NULL, 
              help="combined fcs file", metavar="character")
);

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

gated_totaldata <- fread(opt$file, header=TRUE)

(gated_totaldata[, .(count = .N, liveprop = mean(live_proportion)), by = file])
