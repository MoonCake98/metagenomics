"""
Makes a quality metrics using minion_qc.
Minionqc uses sequence summary file to generate a quality control on the fastq files.
"""


rule minion_qc:
    input:
        f"{SEQUENCE_SUMMARY_FILE}"
    output:
        directory("{output_dir}/minion_qc/minion_qc_{sample}")
    log:
        f"{OUTPUT_DIR}/logs/minion_qc/minionqc_{{sample}}.log"
    threads:
        1
    message:
        "Executing minionqc on {input} to generate {output}"
    
    shell:
        """
        Rscript workflow/scripts/MinIONQC.R \
        -i {input} \
        -o {output} -s TRUE -p 2 2> {log}
        echo "finished running minionqc"
        """