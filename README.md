# GetTaxonCS

## Overview

**GetTaxonCS** is a code designed to retrieve taxonomic and conservation status information based on three sources:

1.  [IUCN Red List](https://www.iucnredlist.org/)

2.  [CITES](https://cites.org/eng)

3.  The Regulation of the Minister of Forestry of Indonesia No [P.106/MENLHK/SETJEN/KUM.1/12/2018](https://www.mongabay.co.id/wp-content/uploads/2019/03/Permen-Jenis-Satwa-dan-Tumbuhan-Dilindungi.pdf)

The code generates a data frame containing detailed information on taxonomy and conservation status, including columns such as **Class**, **Order**, **Family**, **Species**, **Common Names**, **IUCN Conservation Status**, **CITES Appendix information**, and protection status under Indonesian forestry regulations.

For more information about protected species in Indonesia, please refer to the [Buku Panduan Identifikasi Satwa Liar Dilindungi](https://kukangku.id/identifikasi-satwa-dilindungi/)

[The code](https://github.com/ryanavri/GetTaxonCS/blob/main/GetTaxonCS.R) requires the use of two main functions:

1.  `assessments_by_name()` from the [iucnredlist](https://github.com/IUCN-UK/iucnredlist) package and

2.  `spp_taxonconcept()` from the [**rcites**](https://cran.r-project.org/web/packages/rcites) package.

Please note that both functions require API keys.

## How to Use the API

-   To use the API:
    1.  Register and create an IUCN token at <https://api.iucnredlist.org/>
    2.  Register and create a CITES token at <https://api.speciesplus.net/documentation>

*Note*:
The API keys provided in the example code are placeholders and will not work. You must register for your own API keys and replace the sample keys with your own.

## Limitation

While the code is effective for acquiring taxonomic and conservation status information, it functions **only at the species level**.

Also, if the results contain `NA` values, it does not necessarily mean that the species is not listed in the IUCN or CITES databases.\
This could happen if the input species name differs from the latest accepted scientific name, as many bird and plant species have multiple synonyms, and taxonomic revisions occur frequently. Therefore, it is essential to **cross-check scientific names** against updated databases to ensure accurate results.
