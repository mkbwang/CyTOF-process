
#' Apply SPADE analysis on an fcs file combined with its metadata and offer summary of cell counts
#' for each patient. The metadata contains information about the patient each cell belongs to.
#'
#' @param filename
#' The input fcs file name
#' @param intermediate
#' Whether to save the intermediate files generate through the SPADE.driver function in the spade package
#' developed at Garry Nolan's lab
#'
#' @param patient_id
#' The input patient ID txt file corresponding to the fcs file
#'
#' @param output
#' The output folder that stores the spade analysis results
#'
#' @return
#' A tibble dataframe that summarizes the number of cells in each patient
#'
#' @export
#' @import Rclusterpp
#' @import igraph
#' @importFrom spade SPADE.driver
#' @importFrom flowCore arcsinhTransform read.FCS exprs
#' @importFrom dplyr group_by summarise n %>%
#' @importFrom tidyr spread
#' @importFrom utils read.table write.table
#'
spade_analysis <- function(filename, intermediate = FALSE, patient_id, output = "SPADE_out"){
  directories <- unlist(strsplit(filename, '/'))
  directories[length(directories)] <- output

  out_directory <- paste(directories, collapse = '/')
  # spade analysis on gated data
  markers <- c('CD66b', 'CD16', 'CD15', 'CD19', 'CD20',
               'CD27', 'CD38', 'CD3', 'CD4', 'CD8',
               'HLA-DR', 'CD56', 'CD123', 'CD11c',
               'CD14', 'CD45RA', 'CCR7')

  SPADE.driver(filename, out_dir = out_directory,
               cluster_cols = markers, transforms=arcsinhTransform(a=0, b=0.2),
               downsampling_target_number = 30000, downsampling_exclude_pctile = 0.01,
               k= 80, clustering_samples = 25000)

  node_fcs <- list.files(out_directory, pattern = "*.density.fcs.cluster.fcs$")
  expression_node <- read.FCS(file.path(out_directory, node_fcs))
  node_summary <- read.table(file.path(out_directory, 'clusters.table'), header=TRUE)

  # annotate all the nodes with a cell type
  node_cell <- apply(node_summary, 1, annotate)

  # apply the annotation to the expression data
  allnodes <- exprs(expression_node)[,"cluster"]
  cells <- node_cell[allnodes]

  # read in patients ID
  patientsID <- read.table(patient_id, header=TRUE)

  patient_cells <- cbind(patientsID, cells)

  count_summarize <- patient_cells %>% group_by(file, cells) %>% summarise(count = n()) %>%
    spread(key = file, value=count)

  if (!intermediate){
    unlink(out_directory, recursive = TRUE, force = TRUE)
  }

  count_summarize
}
