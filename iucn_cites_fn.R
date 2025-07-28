# Set argument for the functions

#IUCN 
get_iucn_species_data <- function(api, species_df, wait_time = 0.5) {
  
  # Safely wrap assessments_by_name
  safe_assessments <- safely(function(genus, species) {
    assessments_by_name(api, genus = genus, species = species)
  }, otherwise = NULL)
  
  # Safely get assessments
  iucn_as_list <- pmap(
    list(species_df$genus, species_df$species),
    ~ {
      Sys.sleep(wait_time)
      result <- safe_assessments(..1, ..2)
      if (is.null(result$result)) {
        tibble(
          genus = ..1,
          species = ..2,
          assessment_id = NA,
          latest = NA,
          scopes_code = NA,
          status = "Not found"
        )
      } else {
        result$result %>%
          mutate(genus = ..1, species = ..2)
      }
    }
  )
  
  # Combine all results
  iucn_as <- bind_rows(iucn_as_list)
  
  # Filter for latest global assessments only
  iucn_as_latest <- iucn_as %>%
    filter(!is.na(assessment_id), latest == TRUE, scopes_code == 1)
  
  # Safely download full assessment data
  safe_assessment_data <- safely(assessment_data_many)
  full_data_result <- safe_assessment_data(
    api,
    unique(iucn_as_latest$assessment_id),
    wait_time = wait_time
  )
  
  full_data <- full_data_result$result
  if (is.null(full_data)) full_data <- list()
  
  # Extract elements (if available)
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
  
  # Handle "not found" cases only if such column exists
  if ("status" %in% colnames(iucn_as) && any(iucn_as$status == "Not found")) {
    not_found_df <- iucn_as %>%
      filter(status == "Not found") %>%
      transmute(
        Species = paste(genus, species),
        Class = NA,
        Order = NA,
        Family = NA,
        Status = "Not found",
        `Common name` = NA
      )
    final_species_df <- bind_rows(final_species_df, not_found_df)
  }
  
  return(final_species_df)
}


# CITES 
retrieve_CITES_data <- function(speciesList) {
  
  get_cites_status <- function(sp) {
    
    res <- spp_taxonconcept(query_taxon = sp, raw = TRUE)
    
    if (length(res) == 0 || is.null(res[[1]]$cites_listing)) {
      message(sp, " ----- CHECK (not found or no CITES listing)")
      tibble(Species = sp, CITES_Appendix = NA_character_)
      
    } else {
      tibble(
        Species = res[[1]]$full_name,
        CITES_Appendix = res[[1]]$cites_listing
      )
    }
  }
  
  purrr::map_dfr(speciesList, get_cites_status)
}


#load database for Indonesian protected species
urlfile<-'https://raw.githubusercontent.com/ryanavri/GetTaxonCS/main/PSG_v3.csv'
db <- read.csv(urlfile)
