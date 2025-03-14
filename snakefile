""" Snake pipeline for running an analysis of bioplastic minION data """

# Requires Snakemake ... 

configfile: "config/config.yaml"

# Parameters from config.yaml
MINION_QC = config["MINIONQC_PATH"]
RESULTS = config["RESULTS"]

# Final output files 
rule all:
    input:
        # Run QC 
        expand(
            "{results}/minion_qc",
            results = RESULTS

        )


# All the rules that is used.

# Preprocessing check QC 
include: "workflow/rules/minion_qc.smk"
