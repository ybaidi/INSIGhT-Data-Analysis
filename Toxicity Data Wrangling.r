install.packages("readxl")
install.packages("dplyr")
install.packages("tidyr")
install.packages("writexl")
library(readxl)
library(dplyr)
library(tidyr)
library(writexl)

# Read Excel File
df <- read_excel("/Users/yossefbaidi/Downloads/AE.xlsx")

#Combine subject with side effect
df$id = paste0(df$`Subject Number`,"_",df$`Tox Description`)

df$toxicity_grade2 = sapply(df$`itmToxGrade ~ Toxicity Grade`,
                              function(x) unlist(strsplit(x,"-",fixed="TRUE"))[1])
df$toxicity_grade2 = as.numeric(gsub("0","",df$toxicity_grade2))

#Getting the unique side effect
new_df = data.frame()
for (id in unique(df$id)) {
  sub_df = df[which(df$id == id),]
  sub_df = sub_df[which(sub_df$toxicity_grade2 == max(sub_df$toxicity_grade2)),]
  new_df = rbind(new_df, sub_df[1,])
  
} 

#Adding the information for the side effect severity
grade_matrix = matrix(0, ncol = length(unique(new_df$`Tox Description`)),
                      nrow = length(unique(new_df$`Subject Number`)))

colnames(grade_matrix) = unique(new_df$`Tox Description`)
rownames(grade_matrix) = unique(new_df$`Subject Number`)

# For each side effect match to the subject
  for (i in 1:ncol(grade_matrix)) {
    issue = colnames(grade_matrix)[i]
    subjects = new_df$`Subject Number`[which(new_df$`Tox Description` == issue)]
    sub_df = new_df[which(new_df$`Subject Number` %in% subjects),]
    sub_df = sub_df[which(sub_df$`Tox Description` == issue),]
    toxicity_grade = sub_df$toxicity_grade2
    row_ix = match(subjects, rownames(grade_matrix))
    grade_matrix[row_ix,i] = toxicity_grade
    
}

grade_matrix = cbind(rownames(grade_matrix),grade_matrix)
write.csv(grade_matrix,
          file="Side_Effect_Severity.csv",quote=F, row.names=F, col.names=T)