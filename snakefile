""" Snake pipeline for running an analysis of bioplastic minION data """

# Requires Snakemake ... 

configfile: "config/config.yaml"

# Parameters from config.yaml
MINION_QC = config["MINIONQC_PATH"]
RESULTS = config["RESULTS"]
INPUT_FOLDER = config["INPUT"]
EXAMPLE_SAMPLE = config["EXAMPLE_SAMPLE"]

# Final output files 
rule all:
    input:
        # Run QC 
#        expand(
#            "{results}/minion_qc",
#            results = RESULTS
#
#        ),
        # minimap2 output:
        expand("{results}/minimap2/{sample}", results = RESULTS, sample = EXAMPLE_SAMPLE)

# All the rules that is used.

# Preprocessing check QC 
include: "workflow/rules/minion_qc.smk"

# minimap rule
include: "workflow/rules/minimap2.smk"
