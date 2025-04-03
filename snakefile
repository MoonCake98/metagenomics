#note that I have put 0 before all the barcodes because the fastq file is called 1 instead of 01, chould change it to 01 for consistency but I didn't want to mess with the filename because of everyone who uses the file.
configfile: "config.yaml"


rule all: #epected output of the snakefile
    input:
        expand("/students/2024-2025/Thema07/metagenomics/bioplastic/kraken2_output/combined_wgs_barcode{barcode_number}_report.kreport2", barcode_number=config["barcode_numbers"]), # kreport2s
        expand("/students/2024-2025/Thema07/metagenomics/bioplastic/kraken2_output/combined_wgs_barcode{barcode_number}_output.txt", barcode_number=config["barcode_numbers"]), # _output.txt
        expand("/students/2024-2025/Thema07/metagenomics/bioplastic/kraken2_output/combined_wgs_barcode{barcode_number}_kraken_log.txt", barcode_number=config["barcode_numbers"]), # kraken2 logs
        # expand("logs/zcat/combined_wgs_barcode{barcode_number}_zcat_log.txt", barcode_number=config["barcode_numbers"]) # zcat logs


# rule zcat:
#     input:
#         expand("/commons/Themas/Thema07/metagenomics/bioplastic/soil_metagenomics/Ariana/20240418_1521_MN35459_FAX77312_60832f1a/fastq_pass/barcode{barcode_number}/",barcode_number=config["barcode_numbers"])
#     log: "logs/zcat/combined_wgs_barcode{barcode_number}_zcat_log.txt"
#     output: "/students/2024-2025/Thema07/metagenomics/bioplastic/combined_raw_data/combined_wgs_barcode{barcode_number}.fastq"
#     shell:
#         "zcat {input}* > {output} 2> {log}"


rule kraken2:
    input:
        "/students/2024-2025/Thema07/metagenomics/bioplastic/combined_raw_data/combined_wgs_barcode{barcode_number}.fastq" # input fastq file
    output:
        kreport="/students/2024-2025/Thema07/metagenomics/bioplastic/kraken2_output/combined_wgs_barcode{barcode_number}_report.kreport2", # kreport filename
        output_txt="/students/2024-2025/Thema07/metagenomics/bioplastic/kraken2_output/combined_wgs_barcode{barcode_number}_output.txt" # output.txt filename
    threads: 32 # threadcount (used to decide the speed at which kraken2 will run)
    log: "/students/2024-2025/Thema07/metagenomics/bioplastic/kraken2_output/combined_wgs_barcode{barcode_number}_kraken_log.txt" # log filename
    conda: "envs/kraken2.yaml" # env file for kraken2
    shell:
        "kraken2 --db /data/datasets/KRAKEN2_INDEX/k2_standard "
        "--threads {threads} " # specify thread count
        "--report {output.kreport} " # specify kreport2 location and name 
        "--output {output.output_txt} " # specify output.txt location and name 
        "{input} 2> {log}" # specify log location and name 

