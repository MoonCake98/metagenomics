rule all:
    input:
        "combined_wgs_barcode01_report.kreport2",
        "combined_wgs_barcode01_output.txt",
        "logs/kraken2/kreaken_log.txt"



rule kraken2:
    input:
        "kraken2_test_data/combined_wgs_barcode1.fastq"
    output:
        kreport="combined_wgs_barcode01_report.kreport2",
        output_txt="combined_wgs_barcode01_output.txt"
    threads: 32
    log: "logs/kraken2/kreaken_log.txt"
    conda: "envs/kraken2.yaml"
    shell:
        "kraken2 --db /data/datasets/KRAKEN2_INDEX/k2_standard "
        "--threads {threads} "
        "--report {output.kreport} "
        "--output {output.output_txt} "
        "{input} 2> {log}"
