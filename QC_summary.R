
QC_summary <- function(folder, spade_save = FALSE){
  # first gating
  gating(folder, output_name = "combined")
  
  # then spade analysis
  spade_analysis(filename = file.path(folder, "combined.fcs"),
                 patient_id = file.path(folder, "combined_index.txt"),
                 intermediate = spade_save)
  
}
