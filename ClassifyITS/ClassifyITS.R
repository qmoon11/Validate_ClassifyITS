#load required ClassifyITS package
library(ClassifyITS)


#Assign initial taxonomy 
ITS_taxonomy <- ClassifyITS::ITS_assignment(
  blast_file = "megablast_ITS2_ClassifyITS.tsv",
  rep_fasta  = "dna-sequences_ITS_Antrim.fasta",
  outdir     = "ClassifyITS_outputs"
)

# Read in BLAST results and assignments
blast <- read.table("megablast_ITS2_ClassifyITS.tsv", sep = "\t", header = TRUE) #user provided BLAST results
assignments <- read.csv("ClassifyITS_outputs/initial_assignments.csv", stringsAsFactors = FALSE) #preliminary taxonomy assignments from ClassifyITS
View(assignments)

# Subset assignments to fungal OTUs unclassified at class level
unclassified_class_otus <- assignments$qseqid[
  (assignments$kingdom == "Fungi" | is.na(assignments$kingdom) | assignments$kingdom == "NA") &
    (is.na(assignments$class) | assignments$class == "" | assignments$class == "Unclassified")
]
 #list of OTUs to inspect manually
unclassified_class_otus
