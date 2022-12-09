# GetTaxonCS
## Overview
Get taxonomic and conservation status (GetTaxonCS) is a code to get conservation status and population trend, according to;
1. [IUCN Red List](https://www.iucnredlist.org/)
2. [CITES](https://cites.org/eng)
3. Regulation of the Minister of Environment and Forestry No [P.106/MENLHK/SETJEN/KUM.1/12/2018](https://www.mongabay.co.id/wp-content/uploads/2019/03/Permen-Jenis-Satwa-dan-Tumbuhan-Dilindungi.pdf)

The code returns a data frame with the following columns: Order, Family, Species, Status and Trend from IUCN Database; appendix from CITES Database; and Protected, Endemic and Migratory from the regulation of the MoEF. More information about endemicity and migratory species is accessible in [Buku Panduan Identifikasi Satwa Liar Dilindungi](https://kukangku.id/identifikasi-satwa-dilindungi/)

[The code](https://github.com/ryanavri/GetTaxonCS/blob/main/GetTaxonCS.R) was inspired by [bienflorencia/rBiodiversidata](https://github.com/bienflorencia/rBiodiversidata). The script will use the `rl_search()` function from the [**rredlist**](https://CRAN.R-project.org/package=rredlist) package and `spp_taxonconcept()` function from the [**rcites**](https://cran.r-project.org/web/packages/rcites) package, both function needs API Key.

- To use the API:
  1. Register and create a token for IUCN in here http://apiv3.iucnredlist.org/api/v3/token
  2. Register and create a token for CITES in here https://api.speciesplus.net/documentation

The api key in this code is just an example and not gonna works, so please register and replace with your own token

## Limitation
1. The code only works up to species level.
2. If the result produce NA`s, does not mean the species are not in IUCN or CITES list, there are possibility the input name for species was different with database (synonym scientific name). It is usually happen for birds and plants.
