# Load Packages, UNITE ---------------------------------
library(Biostrings)

UNITE <- "sh_general_release_dynamic_s_all_19.02.2025.fasta"
UNITE_Fungi <- "sh_general_release_dynamic_19.02.2025_fungi.fasta"

UNITE <- readDNAStringSet(UNITE)

# Calculate percentage of fungal entries assigned to species in UNITE ---------------------------------
hdr_UNITE <- names(UNITE)

total <- length(hdr_UNITE)
fungi <- sum(grepl("k__Fungi", hdr_UNITE))
fungi_log <- grepl("k__Fungi", hdr_UNITE)

cat("total =", total, "\n")
#total is 266589 entries in UNITE, fungi = 168030, for pct_fungi = 63.03 %. 
cat("fungi =", fungi, "\n")
cat("pct_fungi =", round(100*fungi/total, 2), "%\n")



# Calculate number of unique species in UNITE ---------------------------------
# Extract species label
has_s <- grepl("s__[^;]+", hdr_UNITE)
species <- ifelse(has_s, sub(".*s__([^;]+).*", "\\1", hdr_UNITE), NA_character_)

# Define "species defined"
defined <- fungi_log & has_s &
  !grepl("_sp$", species, ignore.case = TRUE) &
  !grepl("Incertae|unidentified|uncultured|fungus|Fungi_sp", species, ignore.case = TRUE)

cat("fungi_total =", sum(fungi_log), "\n")
cat("fungi_species_defined =", sum(defined), "\n")
cat("pct_defined =", round(100 * sum(defined) / sum(fungi_log), 2), "%\n")

# Unique species count (among fungal, defined)
unique_species <- sort(unique(species[defined]))
cat("unique_fungal_species_defined =", length(unique_species), "\n")

#results: of the fungi = 168030 fungal entries, 52846 are defined at species (31.45 %), 34483 unique species (20.5%) (species hypothesises, SHs, in UNITE)

