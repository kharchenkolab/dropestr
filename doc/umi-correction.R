## ---- include=FALSE-----------------------------------------------------------
ggplot2::theme_set(ggplot2::theme_bw(base_size = 18) + ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5)))

## -----------------------------------------------------------------------------
library(dropestr)
data("reads_per_umi_per_cell")

## -----------------------------------------------------------------------------
cm <- CorrectUmiSequenceErrors(reads_per_umi_per_cell, mc.cores=5, verbosity.level=2)

## ---- fig.width=5-------------------------------------------------------------
umis_distribution <- GetUmisDistribution(reads_per_umi_per_cell$reads_per_umi)
umi_probabilities <- umis_distribution / sum(umis_distribution)

PlotUmisDistribution(reads_per_umi_per_cell$reads_per_umi)

## -----------------------------------------------------------------------------
umis_per_gene <- sapply(reads_per_umi_per_cell$reads_per_umi, length)

max_umi_per_gene <- max(umis_per_gene)
collision_info <- FillCollisionsAdjustmentInfo(umi_probabilities, max_umi_per_gene, verbose=T)
c(max_umi_per_gene, collision_info[max_umi_per_gene])

## -----------------------------------------------------------------------------
correction_info <- PrepareUmiCorrectionInfo(umi_probabilities, collision_info[max_umi_per_gene], 
                                            quants.num=50, verbosity.level=2)

## -----------------------------------------------------------------------------
cm <- CorrectUmiSequenceErrors(reads_per_umi_per_cell, umi.probabilities=umi_probabilities, collisions.info=collision_info, 
                               correction.info=correction_info, mc.cores=5, verbosity.level=2)

