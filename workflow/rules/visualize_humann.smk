rule eggnog:
    input:
        gene_fam=f"{OUTPUT_DIR}/humann/{{barcode}}_genefamilies.tsv",
    output:
        egg_nog=f"{OUTPUT_DIR}/eggnog_plots/{{barcode}}_eggnog.tsv"
    log:
        f"{OUTPUT_DIR}/logs/eggnog_plots/{{barcode}}_eggnog.log"
    shell:
        """
        mkdir -p "{OUTPUT_DIR}/eggnog_plots"
        humann_regroup_table \
        --i {input.gene_fam} \
        --o {output.egg_nog} \
        --g uniref90_eggnog
        """

rule visualize_eggnog:
    input:
        eggnog = expand(f"{OUTPUT_DIR}/eggnog_plots/{{barcode}}_eggnog.tsv", barcode = BARCODES) 
    output:
        f"{OUTPUT_DIR}/eggnog_plots/{{barcode}}_eggnog.png"
    log:
        f"{OUTPUT_DIR}/logs/eggnog_plots/{{barcode}}_plot_eggnog.log"
    shell:
        """
        python workflow/scripts/visualize_humann.py \
        {input.eggnog} \
        {output}
        """
        
