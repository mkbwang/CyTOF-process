
#' Quality control of a folder of raw fcs files. Combine them, apply filter and offer a summary of cell counts for each patient.
#'
#' @param folder
#' A folder where the fcs files live in
#'
#' @param spade_save
#' whether to save the intermediate files of spade analysis. By default false.
#'
#' @return
#' check out function 'gating' and 'spade_analysis'.
#'
#' @export
#'
#' @examples
#' QC_summary(folder = system.file("extdata", package = "CyTOFprocess"))
#'
#'
QC_summary <- function(folder, spade_save = FALSE){
  # first gating
  gating(folder, output_name = "combined")

  # then spade analysis
  spade_analysis(filename = file.path(folder, "combined.fcs"),
                 patient_id = file.path(folder, "combined_index.txt"),
                 intermediate = spade_save)

}
