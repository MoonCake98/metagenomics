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
        # Run Kraken2
        expand("{output_dir}/kraken2_output/combined_wgs_barcode{barcode}_report.kreport2",
                barcode=BARCODES), # kreport2s
        expand("{output_dir}/kraken2_output/combined_wgs_barcode{barcode_number}_output.txt", 
                barcode=BARCODES), # _output.txt
        expand("{output_dir}/kraken2_output/combined_wgs_barcode{barcode_number}_kraken_log.txt", 
                barcode=BARCODES), # kraken2 logs

        # Bracken output
        expand("{result}/bracken_output/{sample}.bracken", result = OUTPUT_DIR, sample = SAMPLES)
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
        # Run eggnog 
        expand("{output_dir}/eggnog_plots/{barcode}_eggnog.tsv",
                output_dir = OUTPUT_DIR, barcode=BARCODES),
        expand("{output_dir}/eggnog_plots/{barcode}_eggnog.png",
                output_dir = OUTPUT_DIR, barcode = BARCODES)
        

# All the rules that is used.
# Preprocessing check QC 
include: "workflow/rules/minion_qc.smk",
# Merge the files in every barcode folder
include: "workflow/rules/combine_wgs.smk",
# Kraken rule
rule kraken2:
    input:
        "/students/2024-2025/Thema07/metagenomics/bioplastic/data/combined_wgs_{barcode}.fastq" # input fastq file
    output:
        kreport="/students/2024-2025/Thema07/metagenomics/bioplastic/kraken2_output/combined_wgs_0{barcode_number}_report.kreport2", # kreport filename
        output_txt="/students/2024-2025/Thema07/metagenomics/bioplastic/kraken2_output/combined_wgs_0{barcode_number}_output.txt" # output.txt filename
    threads: 32 # threadcount (used to decide the speed at which kraken2 will run)
    log: "/students/2024-2025/Thema07/metagenomics/bioplastic/kraken2_output/combined_wgs_barcode0{barcode_number}_kraken_log.txt" # log filename
    conda: "envs/kraken2.yaml" # env file for kraken2
    shell:
        "kraken2 --db /data/datasets/KRAKEN2_INDEX/k2_standard "
        "--threads {threads} " # specify thread count
        "--report {output.kreport} " # specify kreport2 location and name 
        "--output {output.output_txt} " # specify output.txt location and name 
        "{input} 2> {log}" # specify log location and name

# Bracken rule
include: "workflow/rules/bracken.smk"


# Convert Kraken output to MPA format 
include: "workflow/rules/kraken2mpa.smk",
# HUMAnN functional analysis
include: "workflow/rules/humann.smk"
# Visualize with eggnog output
include: "workflow/rules/visualize_humann.smk"
