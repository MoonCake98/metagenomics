#note that I have put 0 before all the barcodes because the fastq file is called 1 instead of 01, chould change it to 01 for consistency but I didn't want to mess with the filename because of everyone who uses the file.
configfile: "config.yaml"


rule all: #epected output of the snakefile
    input:
        expand("combined_wgs_barcode0{barcode_number}_report.kreport2", barcode_number=config["barcode_numbers"]), # kreport2s
        expand("combined_wgs_barcode0{barcode_number}_output.txt", barcode_number=config["barcode_numbers"]), # _output.txt
        expand("logs/kraken2/combined_wgs_barcode0{barcode_number}_kraken_log.txt", barcode_number=config["barcode_numbers"]) # logs



rule kraken2:
    input:
        "kraken2_test_data/combined_wgs_{barcode}.fastq" # input fastq file
    output:
        kreport="combined_wgs_0{barcode_number}_report.kreport2", # kreport filename
        output_txt="combined_wgs_0{barcode_number}_output.txt" # output.txt filename
    threads: 32 # threadcount (used to decide the speed at which kraken2 will run)
    log: "logs/kraken2/combined_wgs_barcode0{barcode_number}_kraken_log.txt" # log filename
    conda: "envs/kraken2.yaml" # env file for kraken2
    shell:
        "kraken2 --db /data/datasets/KRAKEN2_INDEX/k2_standard "
        "--threads {threads} " # specify thread count
        "--report {output.kreport} " # specify kreport2 location and name 
        "--output {output.output_txt} " # specify output.txt location and name 
        "{input} 2> {log}" # specify log location and name 
