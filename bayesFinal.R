library(faraway)
library(dplyr)
library(ggplot2)
library(tidyr)

# Display the first few rows of the diabetes dataset
head(diabetes)

# Summarise the number of NAs in each column
diabetes %>% 
  summarise_all(~ sum(is.na(.)))

# We have 262 patients that did not show up for a follow up visit
diabetes %>% 
  dplyr::select(-c(id, location, gender, frame)) %>% 
  pairs()


# Select relevant columns and filter out rows with NA values
diabetes_clean <- diabetes %>% 
  dplyr::select(-c(id, location, gender, frame)) %>% 
  filter(complete.cases(.))

# Compute the correlation matrix
cor_matrix <- cor(diabetes_clean)

# Convert the correlation matrix to a long format
cor_data <- as.data.frame(as.table(cor_matrix))

# Plot the heat map
ggplot(cor_data, aes(Var1, Var2, fill = Freq)) +
  geom_tile() +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1, 1), space = "Lab", 
                       name="Correlation") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, 
                                   size = 12, hjust = 1)) +
  coord_fixed()

# There is some high corelation between the blood pressure measurments as well as between waist and hip, and waist and weight. 
# to deal with the missing vaues in our data, we may want to consider using a knn aproach. 


diabetes_with_na <- diabetes %>% 
  dplyr::select(-c(id, location, gender)) %>% 
  filter(if_any(c(chol, hdl, ratio, glyhb, height, weight, frame, bp.1s, bp.1d, waist, hip, time.ppn), is.na))
