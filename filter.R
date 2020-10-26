# Filtering

single_cell_filtering = function(cytoframe){
  
  # raw FCS file filtering
  filename <- identifier(cytoframe)
  cytomat <- as.data.table(exprs(cytoframe))
  
  # match the detector name with marker names
  detector_marker_match = unlist(fromJSON(file="detector_marker_match.json"))
  colnames(cytomat) <- detector_marker_match[colnames(cytomat)]
  
  # filter away the beads
  cytomat <- cytomat[EQ4_beads < 10]
  
  # residual filtering
  res_avg <- mean(cytomat[Residual>10, Residual])
  res_sdv <- sd(cytomat[Residual>10, Residual])
  cytomat <- cytomat[Residual > res_avg-2*res_sdv & Residual < res_avg+2*res_sdv,]
  
  
  # center filtering
  ctr_avg <- mean(cytomat[, Center])
  ctr_sdv <- sd(cytomat[, Center])
  cytomat <- cytomat[Center > ctr_avg - 2*ctr_sdv & Center < ctr_avg + 2*ctr_sdv,]
  
  # offset filtering
  off_avg <- mean(cytomat[, Offset])
  off_sdv <- sd(cytomat[, Offset])
  cytomat <- cytomat[Offset > off_avg - 2*off_sdv & Offset < off_avg + 2*off_sdv,]
  
  # width filtering
  width_avg <- mean(cytomat[, Width])
  width_sdv <- sd(cytomat[, Width])
  cytomat <- cytomat[Width > width_avg - 2*width_sdv & Width < width_avg + 2*width_sdv,]
  
  # eventlength filtering
  cytomat <- cytomat[Event_length > 15 & Event_length < 60,]
  
  # DNA1 filtering
  DNA1_mean <- mean(cytomat[, DNA1])
  DNA1_sdv <- sd(cytomat[, DNA1])
  cytomat <- cytomat[DNA1 > DNA1_mean-2*DNA1_sdv & DNA1 < DNA1_mean + 2*DNA1_sdv, ]
  
  # DNA2 filtering
  DNA2_mean <- mean(cytomat[, DNA2])
  DNA2_sdv <- sd(cytomat[, DNA2])
  cytomat <- cytomat[DNA2 > DNA2_mean - 2*DNA2_sdv & DNA2 < DNA2_mean + 2*DNA2_sdv, ]
  
  # Live_Dead Filtering
  live_proportion = nrow(cytomat[Live_Dead < 100,]) / nrow(cytomat)
  cytomat <- cytomat[Live_Dead<100, ]
  
  # CD45 filtering
  cytomat <- cytomat[CD45 > 15, ]
  
  cytomat[,file:=filename]
  cytomat[,live_proportion:=live_proportion]
  
  # return the data table
  cytomat
}
