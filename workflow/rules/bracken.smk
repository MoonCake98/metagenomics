"""
bracken

run bracken on the output of kraken2
"""

rule bracken:
    input:
        # input database
        database="/data/datasets/KRAKEN2_INDEX/k2_standard",
        # kraken2 output as input
        kreport="{RESULTS}/kraken2_output/{SAMPLE}.kreport2"
    output:
        # output files
        bracken="{RESULTS}/bracken_output/{SAMPLE}.bracken",
        species="{RESULTS}/bracken_output/{SAMPLE}_bracken_species.kreport2"
    message:
        "braken was executed using {input.database} on {input.kreport} to generate {output.bracken} and {output.species}"
#    log:
#        # I must use the sample wildcard, so a log file will be created for each sample
#        "{RESULTS}/logs/{SAMPLE}_bracken.log"
    conda:
        "./../../envs/bracken_config.yaml"
    shell:
        # run bracken
        "bracken -d {input.database} -i {input.kreport} -w {output.species} -o {output.bracken} -l S -t 10"


