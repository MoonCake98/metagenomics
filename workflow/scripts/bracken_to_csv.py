# This script is to convert the .bracken files (.txt) to CSV files. 
# By doing so, the files can be used as input for MEGAN6

import csv
import re

from snakemake import snakemake

input_file = snakemake.input[0]
output_file = snakemake.output[0]

# This file has alongside tabs, also spaces. We should first correct this file to a .tsv format
with open(input_file, 'r', encoding='utf-8') as tsvin, open(output_file, 'w', newline='', encoding='utf-8') as csvout:
    # Read the file and substitute spaces to tabs
    fixed_lines = [re.sub(r' {2,}', '\t', line) for line in tsvin]

    # Convert .tsv file to .csv
    reader = csv.reader(fixed_lines, delimiter='\t')
    writer = csv.writer(csvout, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

    for row in reader:
        writer.writerow(row)

print(f"Converted {input_file} --> {output_file}")
