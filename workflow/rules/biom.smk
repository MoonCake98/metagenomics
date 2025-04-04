"""
kraken-biom rule

runs kraken-biom on bracken output to generate tsv files for phyloseq.
"""

rule biom:
    input:
        # bracken output as input
        "{RESULTS}/bracken/{SAMPLE}.kreport2"
    output:
        # tsv output tables
        "{RESULTS}/biom/{SAMPLE}.biom"
    message:
        "braken was executed using {input.database} on {input.kreport} to generate {output.bracken} and {output.species}"
    log:
        # I must use the sample wildcard, so a log file will be created for each sample
        "{RESULTS}/logs/{SAMPLE}_kraken-biom.log"
    conda:
        # relative path to config
        "./../../envs/biom_config.yaml"
    shell:
        # run kraken-biom
        "kraken-biom {input} -o {output} | 2> {log}"


