"""
bracken

run bracken on the output of kraken2
"""

rule bracken:
    input:
        # input database
        database="/data/datasets/KRAKEN2_INDEX/k2_standard",
        # kraken2 output as input
        kreport="{RESULTS}/kraken2/{SAMPLE}.kreport2"
    output:
        # output files
        "{RESULTS}/bracken/{SAMPLE}.bracken"
    message:
        "braken was executed using {input.database} on {input.kreport} to generate {output}"
    log:
        # I must use the sample wildcard, so a log file will be created for each sample
        "{RESULTS}/logs/{SAMPLE}_bracken.log"
    conda:
        "./../../envs/bracken_config.yaml"
    shell:
        # run bracken
        "bracken -d {input.database} -i {input.kreport} -o {output} -l S -t 10 | 2> {log}"


