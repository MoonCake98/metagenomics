"""
Run MEGAN6 (MEtaGenome ANalyzer) to visualise the output of Kraken2 & Bracken.
MEGAN6 needs a csv file to make a visualisation of the taxonomic lists of Bracken, thus it is necassary to convert
the Bracken output to the csv format.
"""

# Convert output of Bracken into csv file
rule convert_kraken_to_megan:
    input:
        "{INPUT_CONVERTING_FILE}"
    output:
        "{OUTPUT_CONVERTING_FILE}"
    message:
        "Converting {INPUT_CONVERTING_FILE} to a csv file"
    script:
        "python convert_tsv_to_csv.py"

# Run MEGAN6
#rule megan:
#    input:
#        "{RESULTS}/MEGAN/CONVERTED_FILES"
#    output:
#        "{RESULTS}/MEGAN/MEGAN_output"
#    log:
#        "{RESULTS}/MEGAN/LOGS"
#    threads:
#        1
#    message:
#        "Executing MEGAN6 on {input} to make {output}"
#    conda:
#        "./../../envs/megan6.yaml"
#    run:

