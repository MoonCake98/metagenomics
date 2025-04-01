import glob

barcode_dir = config["BARCODE_DIR"]

rule combined_wgs:
    """
    Combine WGS barcode data
    """
    input:
        lambda wildcards: glob.glob(f"{barcode_dir}/{wildcards.barcode}/*.fastq.gz") 
    output:
        combined_wgs = "/students/2024-2025/Thema07/metagenomics/bioplastic/data/combined_wgs_{barcode}.fastq"
    log:
        "workflow/logs/{barcode}.log" 
    shell:
        """
        zcat {input} > {output.combined_wgs} 2> {log}  
        """
