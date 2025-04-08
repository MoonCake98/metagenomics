# This script is to generate a barplot with the top 10 taxa for all the barcodes combined

library(tidyverse)
library(viridis)

args <- commandArgs(trailingOnly = TRUE)

# Input and output file
input_file <- args[1]
output_file <- args[2]

# read file
lines <- readLines(input_file)

# Look for headers
header_lines <- grep("^name\\s+taxonomy_id", lines)
split_indices <- c(header_lines, length(lines) + 1)
df_list <- list()

# Parse each section
for (i in seq_along(header_lines)) {
  start <- split_indices[i] + 1
  end <- split_indices[i + 1] - 1
  
  barcode <- str_trim(str_split(lines[header_lines[i]], "\t")[[1]][8])
  
  subdata <- read_tsv(paste(lines[start:end], collapse = "\n"),
                      col_names = c("name", "taxonomy_id", "taxonomy_lvl", "kraken_assigned_reads", 
                                    "added_reads", "new_est_reads", "fraction_total_reads", "barcode"))
  subdata$barcode <- barcode  
  df_list[[i]] <- subdata
}

# combine barcodes
df <- bind_rows(df_list)

# Calculate top 20 taxa 
top_taxa <- df %>%
  group_by(name) %>%
  summarise(total_abundance = sum(fraction_total_reads, na.rm = TRUE)) %>%
  slice_max(total_abundance, n = 20) %>%
  pull(name)

# Filter only top 20 and plot them
plot <- df %>%
  filter(name %in% top_taxa) %>%
  mutate(name = str_replace(name, "_", " ")) %>%
  group_by(name, barcode) %>%
  summarise(abundance = sum(fraction_total_reads, na.rm = TRUE), .groups = "drop") %>%
  ggplot(aes(x = name, y = abundance, fill = barcode)) +
  geom_bar(stat = "identity", position = "stack") +
  ylab("Relative Abundance") +
  xlab("Taxon") +
  ggtitle("Top 20 taxa from all barcodes combined") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 40, hjust = 1, size = 8),
        axis.text.y = element_text(size = 10),
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        legend.text = element_text(size = 10),
        legend.title = element_text(size = 12, face = "bold"),
        plot.title = element_text(hjust = 0.5, size = 14, face = "bold")) +
  scale_fill_viridis_d(option = "D") +
  scale_x_discrete(expand = c(0.01, 0.01)) +
  scale_y_continuous(breaks = seq(0, 1, by = 0.25))

# save plot
ggsave(output_file, plot, width = 20, height = 11)
