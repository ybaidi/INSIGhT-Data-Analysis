# Load necessary libraries
library(readxl)
library(dplyr)

# Read the Excel file
file_path <- "/Users/yossefbaidi/Documents/Beroukhim Lab Documents/R Documents/Side_Effect_Severity_Zeros_Removed_PatientIDTwice.xlsx"
df <- read_excel(file_path)

geno <- read.table("/xchip/beroukhimlab/Yossef/data/chr22_post.fam")

# Loop through each column (excluding the first two columns which are 'Patient ID 1' and 'Patient ID 2')
for(col in names(df)[-c(1,2,3)]) {
  # Select 'Patient ID 1', 'Patient ID 2' and the current column
  selected_df <- df %>% select(`Patient ID 1`, `Patient ID 2`, all_of(col))
  
  # Create a unique file name
  file_name <- paste0("Patient_ID_with_", gsub("[^[:alnum:]_]", "", col), ".txt")
  
  selected_df = selected_df[which(selected_df$`Patient ID 1` != "N/A"),]
  common_donors <- intersect(selected_df$`Patient ID 1`, geno$V1)
  selected_df <- selected_df[match(common_donors, selected_df$`Patient ID 1`),]
  
  # Write the data to txt
  write.table(selected_df, file = paste0("/xchip/beroukhimlab/Yossef/data/pheno_dir/",file_name), row.names = FALSE, col.names = FALSE, quote = FALSE)
}

