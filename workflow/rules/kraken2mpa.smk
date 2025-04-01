rule kraken2mpa:
    """
    Convert Kraken2 output to MPA format per barcode.
    """
    input:
        kraken_output = f"{OUTPUT_DIR}/kraken2_output/combined_wgs_{{barcode}}_report.kreport2"
    output:
        mpa_output = f"{OUTPUT_DIR}/data/{{barcode}}.mpa.txt"
    log:
        f"{OUTPUT_DIR}/logs/kraken2mpa_{{barcode}}.log"
    shell:
        """
        python workflow/scripts/kreport2mpa.py \
        -r {input.kraken_output} \
        -o {output.mpa_output}
        
        """
