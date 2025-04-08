# This script is to generate barplots from bracken to visualise the difference betweeen the samples and their plastics

library(tidyverse)
library(viridis)

args <- commandArgs(trailingOnly = TRUE)

# Input and output files
input_file <- args[1]
output_file <- args[2]

# Read file for each line
lines <- readLines(input_file)

# look for headers
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

# Combine all barcodes
df <- bind_rows(df_list)

# Caluclate top 20 taxa
top_taxa <- df %>% 
  group_by(name) %>% 
  summarise(total_abundance = sum(fraction_total_reads, na.rm = TRUE)) %>%
  slice_max(total_abundance, n = 20) %>% 
  pull(name)

# filter only the top 20 taxa for the heatmap
heatmap_data <- df %>% 
  filter(name %in% top_taxa) %>% 
  mutate(name = str_replace(name, "_", " ")) %>% 
  group_by(name, barcode) %>% 
  summarise(abundance = sum(fraction_total_reads, na.rm = TRUE), .groups = "drop")

# plot
heatmap_plot <- ggplot(heatmap_data, aes(x = name, y = barcode, fill = abundance)) +
  geom_tile() +
  scale_fill_viridis_c(option = "D") +
  theme_minimal() +
  labs(title = "Heatmap top 20 taxa for each barcode",
       x = "Taxon",
       y = "Barcode",
       fill = "Abundance") +
  theme(axis.text.x = element_text(angle = 40, hjust = 1, size = 8),
        axis.text.y = element_text(size = 10),
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        plot.title = element_text(hjust = 0.5, size = 14, face = "bold"))

# save file
ggsave(output_file, heatmap_plot, width = 20, height = 11)
