# Clean up toy data set contained in refine.xlsx showing product purchases from an electronics store.
# Author: Bryon Kent

library(tidyr)
library(dplyr)

# 0. Load the data
refine_original <- read.csv("~/Desktop/refine_original.csv", header=TRUE, sep=",")
refine_modified <- refine_original

# 1. Clean up brand names
refine_modified$company <- tolower(refine_modified$company)
refine_modified$company <- gsub("(ph|f)(i|l){2,4}ps", "philips", refine_modified$company)
refine_modified$company <- gsub("ak\\s{0,1}z(0|o)", "akzo", refine_modified$company)
refine_modified$company <- gsub("unilver", "unilever", refine_modified$company)

# 2. Separate product code and number
# 3. Add product categories
# 4. Add full address for geocoding
# 5. Create dummy variables for company and product category
refine_modified <- refine_modified %>% 
  separate(Product.code...number, c("product_code","product_number"), sep="-") %>% 
  mutate(product_category = ifelse(product_code %in% "p", "Smartphone", 
                                   ifelse(product_code %in% "v", "TV", 
                                          ifelse(product_code %in% "x", "Laptop", 
                                                 ifelse(product_code %in% "q", "Tablet", "Other"))))) %>% 
  mutate(full_address = paste(address, city, country, sep = ", ")) %>%
  mutate(company_philips = ifelse(company %in% "philips", 1, 0)) %>%
  mutate(company_akzo = ifelse(company %in% "akzo", 1, 0)) %>%
  mutate(company_van_houten = ifelse(company %in% "van houten", 1, 0)) %>%
  mutate(company_unilever = ifelse(company %in% "unilever", 1, 0)) %>%
  mutate(product_smartphone = ifelse(product_category %in% "Smartphone", 1, 0)) %>%
  mutate(product_tv = ifelse(product_category %in% "TV", 1, 0)) %>%
  mutate(product_laptop = ifelse(product_category %in% "Laptop", 1, 0)) %>%
  mutate(product_tablet = ifelse(product_category %in% "Tablet", 1, 0))

# Write refine_modified as csv
write.csv(refine_modified, file = "refine_clean.csv")
