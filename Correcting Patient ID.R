install.packages("readxl")
install.packages("writexl")
library(readxl)
library(writexl)
data <- read_excel("/Users/yossefbaidi/Documents/Beroukhim Lab Documents/R Documents/Side_Effect_Severity with Patient ID.xlsx")

# Replace underscores with hyphens in the "Patient ID" column
data$`Patient ID` <- gsub("_", "-", data$`Patient ID`)

#write.table(data, "Side_Effect_Severity_with_Patient_ID_corrected.txt", sep = "\t", row.names = FALSE, col.names = TRUE, quote = FALSE)
write_xlsx(data, path = "Side_Effect_Severity_with_Patient_ID_corrected.xlsx")
