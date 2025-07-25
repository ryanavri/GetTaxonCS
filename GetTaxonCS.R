# Preparation----

## Load library----
library(tidyverse)
library(iucnredlist)
library(rcites)
library(purrr)

# load example of species list
urlfile1<-'https://raw.githubusercontent.com/ryanavri/GetTaxonCS/main/sp_list.csv'
Species_df <- read.csv(urlfile1)

Species_df <- Species_df %>%
  mutate(
    genus = word(Species, 1),
    species = word(Species, 2))

# Check the structure, you need to have three columns as example below
glimpse(Species_df)

## Set up your token----

# IUCN
api <- init_api("T3SzxqvSwGgAQjfGuWKas6d51as5d11o1dcSoT") #WARNING! this is just an example, use your own token

# CITES
set_token("kUydW4HMDada1d651hxMwtt") #WARNING! this is just an example, use your own token

# Run the function----

## Download the function----
devtools::source_url("https://raw.githubusercontent.com/ryanavri/GetTaxonCS/main/iucn_cites_fn.R")

## Produce dataframe with IUCN and CITES status----

## Retrieve IUCN data----
sp1 <- get_iucn_species_data(api, Species_df)

## Retrieve CITES data----
sp2 <- retrieve_CITES_data(Species_df$Species) %>%
  distinct(Species, .keep_all = TRUE)

## Combine IUCN, CITES and PP106----
result <- left_join(sp1, sp2, by='Species') %>%
  left_join(., db, by="Species") %>%
  select(Class, Order, Family, Species, `Common name`, Status, CITES_Appendix, Protected, Endemic, Migratory) %>%
  mutate(across(c(Class, Order, Family), tolower)) %>%
  mutate(across(c(Class, Order, Family), tools::toTitleCase)) %>%
  rename(Appendix = CITES_Appendix) %>%
  arrange(Order, Family, Species)
