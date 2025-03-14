"""
Makes a quality metrics using minion_qc.
Minionqc uses sequence summary file to generate a quality control on the fastq files.
"""


rule minion_qc:
    input:
        "/commons/docent/Thema07/metagenomics/bioplastic/soil_metagenomics/Ariana/20240418_1521_MN35459_FAX77312_60832f1a/sequencing_summary_FAX77312_60832f1a_527e8671.txt"
    output:
        "{RESULTS}/minion_qc",
    log:
        "{RESULTS}/logs/minionqc.log"
    threads:
        1
    message:
        "executing minionqc on {input} to generate {output}"
    run:
        shell(
            """
            Rscript ../scripts/MinIONQC.R -i {input} -o {output} | 2> {log}
            echo "finished running minionqc"
            """
        )
        
