""" Snake pipeline for running an analysis of bioplastic minION data """

# Requires Snakemake ... 

configfile: "config/config.yaml"

# Parameters from config.yaml
MINION_QC = config["MINIONQC_PATH"]
RESULTS = config["RESULTS"]
INPUT_FOLDER = config["INPUT_FOLDER"]

# Final output files 
#rule all:

#    input:
        # Run QC 
#        expand(
#            "{results}/minion_qc",
#            results = RESULTS
#
#        ),
        # bracken run:
#        expand("{results}/bracken/{sample}.bracken", results=RESULTS, sample=SAMPLE)

# All the rules that is used.

# Preprocessing check QC 
#include: "workflow/rules/minion_qc.smk"

# minimap rule
#include: "workflow/rules/bracken.smk"


"""
Visualization of Bracken data
"""

BARCODES = config["BARCODES"]
BRACKEN_OUTPUT = config["BRACKEN_OUTPUT"]
KRAKEN_OUTPUT = config["KRAKEN_OUTPUT"]
MERGED_BRACKEN_FILES = config["MERGED_BRACKEN_FILES"]
STACKED_BARPLOT_BRACKEN = config["STACKED_BARPLOT_BRACKEN"]
HEATMAP_BRACKEN = config["HEATMAP_BRACKEN"]
STACKED_BARPLOT_BRACKEN_PER_BARCODE = config["STACKED_BARPLOT_BRACKEN_PER_BARCODE"]

rule all:
    input:
        expand("{MERGED_BRACKEN_FILES}/merged_bracken_S.txt",
               MERGED_BRACKEN_FILES=MERGED_BRACKEN_FILES,
               BRACKEN_OUTPUT=BRACKEN_OUTPUT, 
               barcodes=BARCODES),
        f"{config['STACKED_BARPLOT_BRACKEN']}/stacked_barplot_bracken.pdf",
        f"{HEATMAP_BRACKEN}/heatmap_bracken_top_20.pdf",
        f"{STACKED_BARPLOT_BRACKEN_PER_BARCODE}/stacked_barplot_bracken_top_20_per_barcode.pdf"


# Merge the bracken output files into 1 file
rule combine_files:
    input:
        bracken_files = expand(f"{BRACKEN_OUTPUT}/combined_wgs_{{barcode}}_report.bracken", barcode=BARCODES)
    output:
        "{MERGED_BRACKEN_FILES}/merged_bracken_S.txt"
    params:
        names = ",".join(BARCODES),
        files = lambda wildcards, input: " ".join(input.bracken_files)
    message:
        "Merging Bracken's output files"
    conda:
        "envs/pandas.yaml"
    shell:
        "python3 workflow/scripts/combine_bracken_outputs.py --files {params.files} --names {params.names} --output {output}"

# Generate a stacked barplot (top 20 taxa) for the merged Bracken files
rule stacked_barplot_bracken:
    input:
        f"{MERGED_BRACKEN_FILES}/merged_bracken_S.txt"
    output: 
        f"{STACKED_BARPLOT_BRACKEN}/stacked_barplot_bracken_top_20.pdf"
    shell: 
        "Rscript workflow/scripts/stacked_barplot_bracken.R {input} {output}"

# Generate a heatmap (top 20 taxa) for the merged Bracken files for the abundance of taxa each barcode
rule heatmap_bracken:
    input:
        f"{MERGED_BRACKEN_FILES}/merged_bracken_S.txt"
    output:
        f"{HEATMAP_BRACKEN}/heatmap_bracken_top_20.pdf"
    shell:
        "Rscript workflow/scripts/heatmap.R {input} {output}"

# Generate a stacked barplot (top 20 taxa) each barcode
rule stacked_barplot_bracken_per_barcode:
    input:
        f"{MERGED_BRACKEN_FILES}/merged_bracken_S.txt"
    output:
        f"{STACKED_BARPLOT_BRACKEN_PER_BARCODE}/stacked_barplot_bracken_top_20_per_barcode.pdf"
    shell:
        "Rscript workflow/scripts/stacked_barplot_per_barcode.R {input} {output}"
