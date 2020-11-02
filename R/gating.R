#' Apply gating to a set of raw fcs files in a specified folder.
#' This function applies filter to a number of fcs files in the folder and combine them into a single
#' fcs file and another text file (a table) that matches each cell event to the original patient file.
#' The two files are named by default as "output".
#'
#' @param folder
#' The folder where the function probes through all the fcs files.
#'
#' @param output_name
#' The output file name for the fcs file.
#'
#' @return
#' A vector with the two output filenames
#'
#'
#' @export
#' @importFrom flowCore read.flowSet fsApply write.FCS
#' @importFrom Biobase AnnotatedDataFrame
#' @importFrom methods new
#' @importFrom utils read.table write.table
#'
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

  c(fcs_filename, index_filename)
}

