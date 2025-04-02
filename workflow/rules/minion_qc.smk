"""
Makes a quality metrics using minion_qc.
Minionqc uses sequence summary file to generate a quality control on the fastq files.
"""


rule minion_qc:
    input:
        "/commons/Themas/Thema07/metagenomics/bioplastic/soil_metagenomics/Ariana/20240418_1521_MN35459_FAX77312_60832f1a/sequencing_summary_FAX77312_60832f1a_527e8671.txt"
    output:
        directory("/students/2024-2025/Thema07/metagenomics/bioplastic/minion_qc/{sample}")
    log:
        "/students/2024-2025/Thema07/metagenomics/bioplastic/logs/minionqc_{sample}.log"
    threads:
        1
    message:
        "Executing minionqc on {input} to generate {output}"
    
    shell:
        """
        Rscript workflow/scripts/MinIONQC.R \
        -i {input} \
        -o {output} -s TRUE -p 2 2> {log} \
        echo "finished running minionqc"
        """
        
