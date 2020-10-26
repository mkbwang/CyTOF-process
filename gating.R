# read in the FCS file and do the pregating

library(rjson)
library(Biobase)
library(flowCore)
library(data.table)


gating <- function(folder, output_name = "output"){
  fcs_files = file.path(folder, list.files(folder, pattern = "\\.fcs$"))
  fcs_raw <- read.flowSet(fcs_files, transformation = FALSE, 
                          truncate_max_range = FALSE)
  # carry out gating on all the flowframes and combine them into one data table
  gated_totaldata <- Reduce(function(...) merge(..., all = TRUE), fsApply(fcs_raw, single_cell_filtering))
  
  # extract out the file information and store the data table back into a flowframe
  index_data <- gated_totaldata[, "file"]
  
  # convert the expression file from matrix into fcs file
  gated_mat <- as.matrix(gated_totaldata[, file:=NULL])
  
  meta <- data.frame(name=dimnames(gated_mat)[[2]],
                     desc=dimnames(gated_mat)[[2]])
  
  meta$range <- apply(apply(gated_mat, 2, range), 2, diff)
  meta$minRange <- apply(gated_mat, 2, min)
  meta$maxRange <- apply(gated_mat, 2, max)
  
  combined_fcs <- new("flowFrame", exprs = gated_mat,
                      parameters = AnnotatedDataFrame(meta))
  
  
  fcs_filename <- paste0(output_name, ".fcs")
  index_filename <- paste0(output_name, "_index.txt")
  
  write.FCS(combined_fcs, file.path(folder, fcs_filename))
  write.table(index_data, file.path(folder, index_filename), 
              row.names = FALSE, quote=FALSE)
}

