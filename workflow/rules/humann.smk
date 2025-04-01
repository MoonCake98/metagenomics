
rule humann:
    """
    Runs the Humann2
    """
    input:
        choco_db="/students/2024-2025/Thema07/metagenomics/wastewater/data/chocophlan/chocophlan",
        uniref_db="/students/2024-2025/Thema07/metagenomics/wastewater/data/uniref90_diamond/uniref",
        fastq="/students/2024-2025/Thema07/metagenomics/bioplastic/data/combined_wgs_{barcode}.fastq"
    output:
        temp_dir=temp(directory("/students/2024-2025/Thema07/metagenomics/bioplastic/humann/{barcode}_temp")),
        gene_fam="/students/2024-2025/Thema07/metagenomics/bioplastic/humann/{barcode}_genefamilies.tsv",
        path_cov="/students/2024-2025/Thema07/metagenomics/bioplastic/humann/{barcode}_pathcoverage.tsv",
        path_abu="/students/2024-2025/Thema07/metagenomics/bioplastic/humann/{barcode}_pathabundance.tsv"

    #conda:
     #   "workflow/env/humann.yaml"
    log:
        "workflow/logs/humann3/{barcode}_humann.log"
    threads: 32
    shell:
        """
        mkdir -p {output.temp_dir}
        humann \
        --input {input.fastq} \
        --output  {output.temp_dir}\
        --threads 32 \
        --taxonomic-profile "humann_test_data/new_test_data.mpa.txt" \
        --nucleotide-database {input.choco_db} \
        --protein-database  {input.uniref_db} \
        --output-basename {wildcards.barcode} \
        > log 2>&1

        cp {output.temp_dir}/{wildcards.barcode}_genefamilies.tsv {output.gene_fam}
        cp {output.temp_dir}/{wildcards.barcode}_pathcoverage.tsv {output.path_cov}
        cp {output.temp_dir}/{wildcards.barcode}_pathabundance.tsv {output.path_abu}
        """

