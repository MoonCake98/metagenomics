rule kraken2mpa:
    """
    Convert Kraken2 output to MPA format per barcode.
    """
    input:
        bracken_output = f"{OUTPUT_DIR}/bracken_output/combined_wgs_{{barcode}}_report_bracken_species.kreport2"
    output:
        mpa_output = f"{OUTPUT_DIR}/mpa/{{barcode}}.mpa.txt"
    log:
        f"{OUTPUT_DIR}/logs/kraken2mpa/{{barcode}}.log"
    shell:
        """
        python workflow/scripts/kreport2mpa.py \
        -r {input.bracken_output} \
        -o {output.mpa_output} \
        2> {log}
        """

rule sort_mpa:
    """Sorts the MPA, so humann will take the input"""
    input:
        mpa_file = f"{OUTPUT_DIR}/mpa/{{barcode}}.mpa.txt",
    output:
        sorted_mpa_file = f"{OUTPUT_DIR}/mpa/{{barcode}}_mpa.mpa.txt"
    log:
        f"{OUTPUT_DIR}/logs/kraken2mpa/sorted_{{barcode}}.log"
    shell:
        """
        sort -k 2 -r -n {input.mpa_file} | \
        awk '{{printf("%s\\t\\n", $0)}}' | \
        awk 'BEGIN{{printf("#mpa_v30_CHOCOPhlAn_201901\\n")}}1' > {output.sorted_mpa_file} \
        2> {log}
        """

rule combine_mpa:
    """ Combines the MPA files to one file"""
    input:
        sorted_mpa = expand(f"{OUTPUT_DIR}/mpa/{{barcode}}_mpa.mpa.txt", barcode=BARCODES)
    output:
        sorted_combined_mpa = f"{OUTPUT_DIR}/mpa/sorted_combined_mpa.mpa.txt"
    log:
        f"{OUTPUT_DIR}/logs/kraken2mpa/sorted_combined_bracken_mpa.log"
    shell:
        """
        python workflow/scripts/combine_mpa.py \
        -i {input.sorted_mpa} \
        -o {output.sorted_combined_mpa} \
        2> {log}
        """