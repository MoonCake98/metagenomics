""" Snake pipeline for running an analysis of bioplastic minION data """

# Requires Snakemake ... 

configfile: "config/config.yaml"

# Parameters from config.yaml
INPUT_DIR = config["INPUT_DIR"]
OUTPUT_DIR = config["OUTPUT_DIR"]
SAMPLES = config["SAMPLES"]
# Final output files 
rule all:
    input:
        # Run QC 
        expand(
            "/students/2024-2025/Thema07/metagenomics/bioplastic/minion_qc_{sample}",
            sample = SAMPLES
        )


# All the rules that is used.

# Preprocessing check QC 
include: "workflow/rules/minion_qc.smk"