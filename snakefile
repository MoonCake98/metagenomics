""" Snake pipeline for running an analysis of bioplastic minION data """

# Requires Snakemake ... 

configfile: "config/config.yaml"

# Parameters from config.yaml
INPUT_DIR = config["INPUT_DIR"]
OUTPUT_DIR = config["OUTPUT_DIR"]
SEQUENCE_SUMMARY_FILE = config["SEQUENCE_SUMMARY_FILE"]
SAMPLES = config["SAMPLES"]
CHOCO_DB = config["CHOCO_PATH"]
UNIREF_DB = config["UNIREF_PATH"]
BARCODES = config["BARCODES"]
BARCODE_DIR = config["BARCODE_DIR"]
TAXON_PROFILE = config["TAXON_PROFILE"]

# Final output files 
rule all:
    input:
        # Run QC 
        expand(
            "{output_dir}/minion_qc/minion_qc_{sample}",
            output_dir=OUTPUT_DIR, sample = SAMPLES),
        # Merge for every barcode every file in the folder
        expand("{output_dir}/data/combined_wgs_{barcode}.fastq",
                output_dir = OUTPUT_DIR, barcode = BARCODES),
        # Convert Kraken output to MPA output to use for HUMAnN
        expand("{output_dir}/mpa/{barcode}.mpa.txt", 
                output_dir = OUTPUT_DIR, barcode = BARCODES),
        # Sorts the mpa files to an MPA that Humann takes
        expand("{output_dir}/mpa/{barcode}_mpa.mpa.txt",
                output_dir=OUTPUT_DIR, barcode=BARCODES),
        # Combines MPA files to one combined file
        expand("{output_dir}/mpa/sorted_combined_mpa.mpa.txt",
                output_dir=OUTPUT_DIR),
        # Run HUMAnN
        expand("{output_dir}/humann/{barcode}_genefamilies.tsv",
               barcode = BARCODES, output_dir = OUTPUT_DIR)

# All the rules that is used.
# Preprocessing check QC 
include: "workflow/rules/minion_qc.smk",
# Merge the files in every barcode folder
include: "workflow/rules/combine_wgs.smk",
# Convert Kraken output to MPA format 
include: "workflow/rules/kraken2mpa.smk",
# HUMAnN functional analysis
include: "workflow/rules/humann.smk"

