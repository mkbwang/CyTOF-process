

#' Based on protein expressions, assign each cell to their category. This is achieved through
#' a predefined rule.
#'
#' @param medexpression
#' The expression profile of each cluster identified by spade
#'
#' @return
#' A vector of annotations for each cell
annotate <- function(medexpression){
  # rule based annotation

  expr_bin <- medexpression > 1

  celltypes <- c("Neutrophils", "Naive B", "B Memory", "Plasmablast",
                 "NK.CD16+", "NK.CD16-", "Classical Monocytes", "Non-classical Monocytes",
                 "pDC", "mDC", "Naive CD4", "CD4.CM", "CD4.EM", "CD4.TEM", "Naive CD8",
                 "CD8.CM", "CD8.EM", "CD8.TEM", "NKT")
  toggle <- rep(FALSE, length(celltypes))
  # neutrophils
  toggle[1] <- (expr_bin['CD66b'] & expr_bin['CD16']) |  (expr_bin['CD15'] & expr_bin['CD16'])
  # Naive B
  toggle[2] <- expr_bin['CD19'] & expr_bin['CD20'] & !expr_bin['CD27']
  # Memory B
  toggle[3] <- expr_bin['CD19'] & expr_bin['CD20'] & expr_bin['CD27']
  # Plasmablast
  toggle[4] <- expr_bin['CD19'] & !expr_bin['CD20'] & expr_bin['CD38'] & expr_bin['CD27']
  # NK Cells
  NKcells <- !expr_bin['CD20'] & !expr_bin['CD3'] & !expr_bin['HLA.DR'] & expr_bin['CD56']
  ## NK CD16+
  toggle[5] <- NKcells & expr_bin['CD16']
  ## NK CD16-
  toggle[6] <- NKcells & !expr_bin['CD16']
  # Monocytes
  monocytes <- !expr_bin['CD19'] & !expr_bin['CD3'] & !expr_bin['CD15-'] & !expr_bin['CD123'] & expr_bin['HLA.DR'] & expr_bin['CD11c']
  ## Classical Monocytes
  toggle[7] <- monocytes & expr_bin['CD14'] & !expr_bin['CD16']
  ## Non Classical Monocytes
  toggle[8] <- monocytes & !expr_bin['CD14'] & expr_bin['CD16']
  # Dendritic
  dendritic <- !expr_bin['CD19'] & !expr_bin['CD20'] & !expr_bin['CD3'] & !expr_bin['CD14'] & expr_bin['HLA.DR']
  ## pDC
  toggle[9] <- dendritic & !expr_bin['CD11c'] & expr_bin['CD123']
  ## mDC
  toggle[10] <- dendritic & expr_bin['CD11c'] & !expr_bin['CD123']
  # T CD4
  tcd4cell <- expr_bin['CD3'] & expr_bin['CD4']
  ## Naive T
  toggle[11] <- tcd4cell & expr_bin['CD45RA'] & expr_bin['CCR7']
  ## Central Memory
  toggle[12] <- tcd4cell & !expr_bin['CD45RA'] & expr_bin['CCR7']
  ## Effector Memory
  toggle[13] <- tcd4cell & !expr_bin['CD45RA'] & !expr_bin['CCR7']
  ## Terminal Differentiated Effector Memory
  toggle[14] <- tcd4cell & expr_bin['CD45RA'] & !expr_bin['CCR7']
  # T CD8
  tcd8cell <- expr_bin['CD3'] & expr_bin['CD8']
  ## Naive T
  toggle[15] <- tcd8cell & expr_bin['CD45RA'] & expr_bin['CCR7']
  ## Central Memory
  toggle[16] <- tcd8cell & !expr_bin['CD45RA'] & expr_bin['CCR7']
  ## Effector Memory
  toggle[17] <- tcd8cell & !expr_bin['CD45RA'] & !expr_bin['CCR7']
  ## Terminated Differentiated Effector Memory
  toggle[18] <- tcd8cell & expr_bin['CD45RA'] & !expr_bin['CCR7']
  # NKT
  toggle[19] <- expr_bin['CD3'] & expr_bin['CD56']

  labels <- paste(celltypes[which(toggle)], collapse = "/")
  if (labels == "") labels <- "Unidentified"

  labels
}
