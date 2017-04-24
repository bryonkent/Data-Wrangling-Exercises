# Work with data set contained in titanic3.xls that records verious attributes of passengers on the Titanic.
# Author: Bryon Kent

library(tidyr)
library(dplyr)

# Load titanic data
titanic_original <- read.csv("~/Desktop/titanic_original.csv", header = TRUE, sep = ",")
titanic_modified <- titanic_original

# 1. Port of embarkation
titanic_modified$embarked <- gsub(pattern = "^$", replacement = "S", titanic_modified$embarked)

# 2. Age
titanic_modified$age[is.na(titanic_modified$age)] <- mean(titanic_modified$age, na.rm = TRUE)

# 3. Lifeboat
titanic_modified$boat <- gsub(pattern = "^$", replacement = "NA", titanic_modified$boat)

# 4. Cabin
titanic_modified <- titanic_modified %>%
  mutate(has_cabin_number = ifelse(cabin %in% "", 0, 1))

# Write titanic_modified as csv
write.csv(titanic_modified, file = "titanic_clean.csv")