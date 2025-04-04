import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import argparse
import os

def main():
    parser = argparse.ArgumentParser(description="Plot HUMAnN Pathway Abundance from EggNOG output")
    parser.add_argument("input_file", help="Path to the EggNOG output file (TSV format)")
    parser.add_argument("output_file", help="Path to save the output plot (including filename)")
    args = parser.parse_args()

    # Read Eggnog output
    df = pd.read_csv(args.input_file, sep="\t")
    # Remove the "UNMAPPED" and "UNGROUPED" row and merge entries 
    df_cleaned = df[(df["# Gene Family"] != "UNMAPPED") &(df["# Gene Family"] != "UNGROUPED")]
    # Convert to format
    df_melted = df_cleaned.melt(id_vars=['# Gene Family'], var_name='Sample', value_name='Abundance')
    
    # Plot
    plt.figure(figsize=(12, 6))
    sns.barplot(x="Abundance", y="# Gene Family", data=df_melted, ci=None)
    plt.xlabel("Abundance")
    plt.ylabel("Pathway")
    plt.title("HUMAnN Pathway Abundance")
    plt.tight_layout()
    
    # Ensure output directory exists
    os.makedirs(os.path.dirname(args.output_file), exist_ok=True)
    plt.savefig(args.output_file)
    plt.show()
    
    print(f"Plot saved to {args.output_file}")

if __name__ == "__main__":
    main()
