#Preparation####
#load library
library(tidyverse)
library(rredlist)
library(rcites)

#load database for Indonesian protected species
urlfile<-'https://raw.githubusercontent.com/ryanavri/GetTaxonCS/main/ProtectedSpecies_by_GOI.csv'
db <- read.csv(urlfile)

#load example of species list
urlfile1<-'https://raw.githubusercontent.com/ryanavri/GetTaxonCS/main/sp_list.csv'
sp_list <- read.csv(urlfile1)


#set token from CITES
set_token("3yTXsqrceqKHF") #WARNING! this is just an example, use your own token

#set token from IUCN
Sys.setenv(IUCN_KEY = "qNdBxkZRQi5V54ZYyauKacIzT7csLlUaVxi") #WARNING! this is just an example, use your own token
apikey <- Sys.getenv("IUCN_KEY")


#Set argument for the functions#### 
retrieve_IUCN_data <- function(speciesList){
  IUCN_status <- data.frame(Species = character(), Status = character(), 
                            Trend = character(), Family = character(), Order = character(), stringsAsFactors=FALSE)
  for(sp in speciesList){
    UICN_search <- rl_search(name = sp, key = apikey)
    if (length(UICN_search$result) == 0){
      IUCN_status_sp <- data.frame(Species = sp, 
                                   Status = 'NA', 
                                   Trend = 'NA', 
                                   Family ='NA', 
                                   Order ='NA', stringsAsFactors=FALSE)
      IUCN_status <- rbind(IUCN_status, IUCN_status_sp)
      cat(sp,'----- CHECK\n')
    }
    else {
      IUCN_status_sp <- data.frame(Species = UICN_search$result$scientific_name, 
                                   Status = UICN_search$result$category, 
                                   Trend = UICN_search$result$population_trend,
                                   Order = UICN_search$result$order,
                                   Family = UICN_search$result$family,
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

#Search in IUCN and CITES database####
#from IUCN
sp1 <- retrieve_IUCN_data(sp_list$Species)
#from CITES
sp2 <- retrieve_CITES_data(sp_list$Species)
sp3 <- spp_cites_legislation(taxon_id = sp2$taxon_id, verbose = FALSE)
sp3 <- as.data.frame (sp3[["cites_listings"]])

#Merge information from IUCN, CITES and Protected Species by GOI
species_list <- left_join(sp1, sp2, by='Species') %>%
  left_join(., sp3, by='taxon_id') %>%
  left_join(., db,  by="Species") %>%
  select(Order, Family, Species, Status, Trend, appendix, Protected, Endemic, Migratory)
