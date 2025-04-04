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
        ),
        expand("/students/2024-2025/Thema07/metagenomics/bioplastic/kraken2_output/combined_wgs_barcode{barcode_number}_report.kreport2", barcode_number=config["barcode_numbers"]), # kreport2s
        expand("/students/2024-2025/Thema07/metagenomics/bioplastic/kraken2_output/combined_wgs_barcode{barcode_number}_output.txt", barcode_number=config["barcode_numbers"]), # _output.txt
        expand("/students/2024-2025/Thema07/metagenomics/bioplastic/kraken2_output/combined_wgs_barcode{barcode_number}_kraken_log.txt", barcode_number=config["barcode_numbers"]), # kraken2 logs


# All the rules that is used.

# Preprocessing check QC 
include: "workflow/rules/minion_qc.smk"

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
