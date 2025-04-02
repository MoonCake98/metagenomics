""" Snake pipeline for running an analysis of bioplastic minION data """

# Requires Snakemake ... 

configfile: "config/config.yaml"

# Parameters from config.yaml
INPUT_DIR = config["INPUT_DIR"]
OUTPUT_DIR = config["OUTPUT_DIR"]
SAMPLES = config["SAMPLES"]
CHOCO_DB = config["CHOCO_PATH"]
UNIREF_DB = config["UNIREF_PATH"]
BARCODES = config["BARCODES"]
BARCODE_DIR = config["BARCODE_DIR"]
TAXON_PROFILE = config["TAXON_PROFILE"]

# Final output files 
rule all:
    input:
        # Merge for every barcode every file in the folder
        #expand("{output_dir}/data/combined_wgs_{barcode}.fastq",
         #       output_dir = OUTPUT_DIR, barcode = BARCODE),
        # Run QC 
        #expand(
         #   "{output_dir}/minion_qc/{sample}",
          #  sample = SAMPLES, output_dir = OUTPUT_DIR
        #),
        # Convert Kraken output to MPA output to use for HUMAnN
        #expand("{output_dir}/mpa/{barcode}.mpa.txt", 
        #        output_dir = OUTPUT_DIR, barcode = BARCODES),
        #expand("{output_dir}/mpa/{barcode}_mpa.mpa.txt",
          #      output_dir=OUTPUT_DIR, barcode=BARCODES),
        #expand("{output_dir}/mpa/sorted_combined_mpa.mpa.txt",
         #       output_dir=OUTPUT_DIR)
        # Run HUMAnN
        expand("{output_dir}/humann/{barcode}_genefamilies.tsv",
               barcode = BARCODES, output_dir = OUTPUT_DIR)
        


# All the rules that is used.
# Merge the files in every barcode folder
#include: "workflow/rules/combine_wgs.smk",
# Preprocessing check QC 
#include: "workflow/rules/minion_qc.smk",
# Convert Kraken output to MPA format 
#include: "workflow/rules/kraken2mpa.smk"
# HUMAnN technical analysis
include: "workflow/rules/humann.smk"

