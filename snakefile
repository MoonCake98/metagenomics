""" Snake pipeline for running an analysis of bioplastic minION data """

# Requires Snakemake ... 

configfile: "config/config.yaml"

# Parameters from config.yaml
MINION_QC = config["MINIONQC_PATH"]
RESULTS = config["RESULTS"]
INPUT_FOLDER = config["INPUT_FOLDER"]

# Final output files 
rule all:
    input:
        # Run QC 
#        expand(
#            "{results}/minion_qc",
#            results = RESULTS
#
#        ),
        # bracken run:
        expand("{results}/bracken/{sample}.bracken", results=RESULTS, sample=SAMPLE)

# All the rules that is used.

# Preprocessing check QC 
include: "workflow/rules/minion_qc.smk"

# minimap rule
include: "workflow/rules/bracken.smk"
