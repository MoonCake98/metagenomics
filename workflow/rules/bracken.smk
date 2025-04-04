"""
bracken

run bracken on the output of kraken2
"""

rule bracken:
    input:
        # input database
        database="/data/datasets/KRAKEN2_INDEX/k2_standard",
        # kraken2 output as input
        kreport="{OUTPUT_DIR}/kraken2_output/{SAMPLE}.kreport2"
    output:
        # output files
        bracken="{OUTPUT_DIR}/bracken_output/{SAMPLE}.bracken",
        species="{OUTPUT_DIR}/bracken_output/{SAMPLE}_bracken_species.kreport2"
    message:
        "braken was executed using {input.database} on {input.kreport} to generate {output.bracken} and {output.species}"
    log:
        # I must use the sample wildcard, so a log file will be created for each sample
        "{OUTPUT_DIR}/logs/{SAMPLE}_bracken.log"
    conda:
        "./../../envs/bracken_config.yaml"
    shell:
        # run bracken with defaults defined, so I can easily change it
        "bracken -d {input.database} -i {input.kreport} -w {output.species} -o {output.bracken} -l S -t 10 | 2> {log}"


