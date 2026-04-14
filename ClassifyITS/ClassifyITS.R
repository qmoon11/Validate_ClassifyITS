#load required ClassifyITS package
library(ClassifyITS)


#Assign initial taxonomy 
ITS_taxonomy <- ClassifyITS::ITS_assignment(
  blast_file = "megablast_ITS2_ClassifyITS.tsv",
  rep_fasta  = "dna-sequences_ITS_Antrim.fasta",
  outdir     = "ClassifyITS_outputs"
)

