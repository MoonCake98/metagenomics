# This script will combine the bracken files and merges it into 1 file

import argparse
import pandas as pd

def combine_bracken_files(bracken_files, sample_names, output_file):
    # Empty df
    combined_data = pd.DataFrame()
    
    # Loop through the files and add them
    for file, name in zip(bracken_files, sample_names):
        print(f"Processing file: {file} for barcode: {name}")
        
        # Read Bracken file
        df = pd.read_csv(file, sep='\t', header=None)
        
        # Add column for sample name
        df['Barcode'] = name
        
        # Combinde data
        combined_data = pd.concat([combined_data, df], ignore_index=True)
    
    # Write it to output file
    combined_data.to_csv(output_file, sep='\t', index=False)
    print(f"Merged Bracken data is saved to: {output_file}")

def main():
    # Usage of parameters with argparse
    parser = argparse.ArgumentParser(description="Combine Bracken files into a single output.")
    parser.add_argument('--files', type=str, nargs='+', required=True, help="List of Bracken files to combine")
    parser.add_argument('--names', type=str, required=True, help="Comma-separated list of sample names")
    parser.add_argument('--output', type=str, required=True, help="Output file path")
    
    args = parser.parse_args()
    
    # Divide the samples
    sample_names = args.names.split(',')
    
    # Call function to combine the files
    combine_bracken_files(args.files, sample_names, args.output)

if __name__ == "__main__":
    main()
