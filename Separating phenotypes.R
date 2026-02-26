# Load necessary libraries
library(readxl)
library(dplyr)

# Read the Excel file
file_path <- "/Users/yossefbaidi/Documents/Beroukhim Lab Documents/R Documents/Side_Effect_Severity_Zeros_Removed_PatientIDTwice.xlsx"
df <- read_excel(file_path)

# Loop through each column (excluding the first column which is 'Patient ID')
for(col in names(df)[-1]) {
  # Select 'Patient ID' and the current column
  selected_df <- df %>% select(`Patient ID`, all_of(col))
  
  # Create a unique file name
  file_name <- paste0("Patient_ID_with_", gsub("[^[:alnum:]_]", "", col), ".txt")
  
  selected_df = selected_df[which(selected_df$`Patient ID` != "N/A"),]
  # Write the data to txt
  write.table(selected_df, file_name, row.names = FALSE, col.names = TRUE)
  
}

