# Set argument for the functions

#IUCN 
get_iucn_species_data <- function(api, species_df, wait_time = 0.5) {
  
  # Download IUCN assessments
  iucn_as <- map2_dfr(
    species_df$genus,
    species_df$species,
    ~ assessments_by_name(api, genus = .x, species = .y)
  )
  
  # Filter latest global assessments
  iucn_as_latest <- iucn_as %>%
    filter(latest == TRUE, scopes_code == 1)
  
  # Download full assessment data
  full_data <- assessment_data_many(
    api,
    unique(iucn_as_latest$assessment_id),
    wait_time = wait_time
  )
  
  # Extract components
  full_taxon <- extract_element(full_data, "taxon")
  full_rlc <- extract_element(full_data, "red_list_category")
  common_name <- extract_element(full_data, "taxon_common_names") %>%
    filter(main == TRUE, language == "eng")
  
  # Join and clean
  final_species_df <- full_taxon %>%
    inner_join(full_rlc, by = "assessment_id") %>%
    inner_join(common_name, by = "assessment_id") %>%
    rename(
      Species = scientific_name,
      Class = class_name,
      Order = order_name,
      Family = family_name,
      Status = code,
      `Common name` = name
    )
  return(final_species_df)
}

# CITES 
retrieve_CITES_data <- function(speciesList) {
  # Helper function to process one species
  get_cites_status <- function(sp) {
    CITES_search <- spp_taxonconcept(query_taxon = sp)
    
    if (length(CITES_search$all_id) == 0) {
      message(sp, " ----- CHECK (not found)")
      tibble(Species = sp, taxon_id = NA_character_)
    } else {
      tibble(Species = CITES_search$all_id$full_name, 
             taxon_id = CITES_search$all_id$id)
    }
  }
  
  # Apply the helper to all species
  CITES_status <- map_dfr(speciesList, get_cites_status)
  
  return(CITES_status)
}

#load database for Indonesian protected species
urlfile<-'https://raw.githubusercontent.com/ryanavri/GetTaxonCS/main/PSG_v3.csv'
db <- read.csv(urlfile)
