# GetTaxonCS
## Overview
Get taxonomic and conservation status (GetTaxonCS) is a code to get conservation status and population trend, according to;
1. [IUCN Red List](https://www.iucnredlist.org/)
2. [CITES](https://cites.org/eng)
3. Regulation of the Minister of Environment and Forestry No [P.106/MENLHK/SETJEN/KUM.1/12/2018](https://www.mongabay.co.id/wp-content/uploads/2019/03/Permen-Jenis-Satwa-dan-Tumbuhan-Dilindungi.pdf)

The code generates a data frame with detailed information about taxonomy and the conservation status. The data frame includes the following columns: Taxon; Class, Order, Family, Species, conservation status dan population from the IUCN database; appendix information from the CITES database; and Protected, Endemic, and Migratory data from the regulations of the Ministry of Environment and Forestry (MoEF). For more information on endemic and migratory species, please refer to the [Buku Panduan Identifikasi Satwa Liar Dilindungi](https://kukangku.id/identifikasi-satwa-dilindungi/)

[The code](https://github.com/ryanavri/GetTaxonCS/blob/main/GetTaxonCS.R) itself was inspired by [bienflorencia/rBiodiversidata](https://github.com/bienflorencia/rBiodiversidata)and requires the use of two functions: rl_search() from the [**rredlist**](https://CRAN.R-project.org/package=rredlist) package and `spp_taxonconcept()` from the [**rcites**](https://cran.r-project.org/web/packages/rcites) package. It's important to note that both functions require an API key to function properly..

- To use the API:
  1. Register and create an IUCN token at http://apiv3.iucnredlist.org/api/v3/token
  2. Register and create a CITES token at https://api.speciesplus.net/documentation

Please note that the API key provided in the code is just an example and will not work. You'll need to register for your own token and replace the existing key with your own to use the code.

## Limitation
1. While the code is useful for acquiring taxonomic and conservation status, it is important to note that it only functions on the species level.
2. It is worth mentioning that if the results produce NA's, it does not necessarily mean that the species are not listed in the IUCN or CITES database. There is a possibility that the input name for the species was different from the scientific name in the database, as many bird and plant species have multiple scientific synonyms, and taxonomic names can change frequently. Therefore, it is important to cross-check the scientific names of the species with the relevant databases to ensure accurate results.
