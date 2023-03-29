# Preparation----
# load library
library(tidyverse)
library(rredlist)
library(rcites)

# load example of species list
urlfile1<-'https://raw.githubusercontent.com/ryanavri/GetTaxonCS/main/sp_list.csv'
sp_list <- read.csv(urlfile1)

# set token from CITES
set_token("3yTXsqrceqKHF") #WARNING! this is just an example, use your own token

# set token from IUCN
Sys.setenv(IUCN_KEY = "qNdBxkZRQi5V54ZYyauKacIzT7csLlUaVxi") #WARNING! this is just an example, use your own token
apikey <- Sys.getenv("IUCN_KEY")

# download the function
devtools::source_url("https://raw.githubusercontent.com/ryanavri/GetTaxonCS/main/iucn_cites_fn.R")

# Get unique species from a species list
Species <- unique(sp_list$Species)

# Create a data frame with 'Species' as the header
Species_df <- data.frame(Species)

# Produce dataframe with IUCN and CITES status----
# retrieve IUCN data
sp1 <- retrieve_IUCN_data(Species_df$Species)

# retrieve CITES data
sp2 <- retrieve_CITES_data(Species_df$Species)

# retrieve CITES legislation
sp3 <- spp_cites_legislation(taxon_id = sp2$taxon_id, verbose = FALSE)
sp3 <- as.data.frame (sp3[["cites_listings"]])

# Merge information from IUCN, CITES and Protected Species by GOI
species_list <- left_join(sp1, sp2, by='Species') %>%
  left_join(., sp3, by='taxon_id') %>%
  left_join(., db,  by="Species") %>%
  select(Class, Order, Family, Species, Status, Trend, appendix, Protected, Endemic, Migratory) %>%
  mutate_at(vars(Class, Order, Family),tolower) %>%
  mutate_at(vars(Class, Order, Family),str_to_title) %>%
  rename(Appendix = appendix)
