#Take rep-seqs and assign taxonomy using DADA2 in R
# This was run on interactive HPC
# Load Packages
library(dada2)
library(Biostrings)

# Query sequences
seqs <- readDNAStringSet("dna-sequences_ITS_Antrim.fasta")

# UNITE DADA2-formatted
train_fasta <- "/scratch/tyjames_root/tyjames0/qmoon/AgeDiversityDistance/MoonITS2/UNITE/euk/sh_general_release_dynamic_s_all_19.02.2025.fasta"


# Run ONCE
res <- assignTaxonomy(
  seqs,
  train_fasta,
  multithread = TRUE,
  minBoot = 0,
  outputBootstraps = TRUE,
  verbose = TRUE
)

tax_mat  <- res$tax
boot_mat <- res$boot

# --- NEW: save the unfiltered (minBoot=0) assignments ---
tax0_df <- as.data.frame(tax_mat, stringsAsFactors = FALSE)
tax0_df$FeatureID <- names(seqs)
write.csv(tax0_df, "taxonomy_dada2_unite_minBoot0.csv", row.names = FALSE)

# optional: save bootstraps once too
boot_df <- as.data.frame(boot_mat, stringsAsFactors = FALSE)
boot_df$FeatureID <- names(seqs)
write.csv(boot_df, "bootstraps_dada2_unite.csv", row.names = FALSE)

# mask assignments below a bootstrap threshold, rank-by-rank
apply_minboot <- function(tax_mat, boot_mat, minBoot) {
  out <- tax_mat
  out[boot_mat < minBoot] <- NA
  out
}

thresholds <- c(50, 60, 70, 80)

for (mb in thresholds) {
  tax_thr <- apply_minboot(tax_mat, boot_mat, mb)
  tax_df <- as.data.frame(tax_thr, stringsAsFactors = FALSE)
  tax_df$FeatureID <- names(seqs)
  write.csv(tax_df, sprintf("taxonomy_dada2_unite_minBoot%d.csv", mb),
            row.names = FALSE)
}
