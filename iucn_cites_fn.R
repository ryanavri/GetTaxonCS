#Set argument for the functions#### 
retrieve_IUCN_data <- function(speciesList){
  IUCN_status <- data.frame(Species = character(), Status = character(), 
                            Trend = character(), Family = character(), Order = character(), 
                            Class = character(), stringsAsFactors=FALSE)
  for(sp in speciesList){
    IUCN_search <- rl_search(name = sp, key = apikey)
    if (length(IUCN_search$result) == 0){
      IUCN_status_sp <- data.frame(Species = sp, 
                                   Status = 'NA', 
                                   Trend = 'NA', 
                                   Family ='NA', 
                                   Order ='NA',
                                   Class = 'NA',
                                   stringsAsFactors=FALSE)
      IUCN_status <- rbind(IUCN_status, IUCN_status_sp)
      cat(sp,'----- CHECK\n')
    }
    else {
      IUCN_status_sp <- data.frame(Species = IUCN_search$result$scientific_name, 
                                   Status = IUCN_search$result$category, 
                                   Trend = IUCN_search$result$population_trend,
                                   Order = IUCN_search$result$order,
                                   Family = IUCN_search$result$family,
                                   Class = IUCN_search$result$class,
                                   stringsAsFactors=FALSE)
      IUCN_status <- rbind(IUCN_status, IUCN_status_sp)
    }
  }
  return(IUCN_status)
}

retrieve_CITES_data <- function(speciesList){
  CITES_status <- data.frame(Species = character(), taxon_id = character(), 
                             stringsAsFactors=FALSE)
  for(sp in speciesList){
    CITES_search <- spp_taxonconcept(query_taxon = sp)
    if (length(CITES_search$all_id) == 0){
      CITES_status_sp <- data.frame(Species = sp, 
                                    taxon_id = 'NA', 
                                    stringsAsFactors=FALSE)
      CITES_status <- rbind(CITES_status, CITES_status_sp)
      cat(sp,'----- CHECK\n')
    }
    else {
      CITES_status_sp <- data.frame(Species = CITES_search$all_id$full_name, 
                                    taxon_id = CITES_search$all_id$id, 
                                    stringsAsFactors=FALSE)
      CITES_status <- rbind(CITES_status, CITES_status_sp)
    }
  }
  return(CITES_status)
}

urlfile<-'https://raw.githubusercontent.com/ryanavri/GetTaxonCS/main/PSG_v2.csv'
db <- read.csv(urlfile)
