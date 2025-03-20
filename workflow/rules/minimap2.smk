"""
minimap2


"""

rule minimap2:
    input:
        ref="/data/dataprocessing/MinIONData/all_bacteria.mmi",
        ali=expand("{input_folder}/{sample}.fastq.gz", input_folder=INPUT_FOLDER, sample=EXAMPLE_SAMPLE)
    output:
        expand("{result}/minimap2/{sample}.sam", result=RESULTS, sample=EXAMPLE_SAMPLE)
    message:
        "example message"
#    conda:
#        "put path to conda config here"
    shell:
        "minimap2 -a {input.ref} {input.ali} > {output}"


