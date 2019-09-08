# Download the DBpedia Knowledge Graph  

This is a technical documentation on how to customize SPARQL queries over the Databus SPARQL API, so you can query exactly the download links that you need. Other useful pages:

* General information about [querying download links from the bus](http://dev.dbpedia.org/Download_Data) (**Required reading**).
* For non-technical users the Databus pages serve as landing pages to show documentation and browser-clickable download links as well as create collections including a SPARQL query generator at the bottom of each page. Once statistics are created and releases are more complete, we will also update the  [Monthly Release](https://wiki.dbpedia.org/develop/datasets/monthly-dataset-releases) and  [Datasets](https://wiki.dbpedia.org/Datasets) pages on dbpedia.org.
* The queries that are documented here can be used ...
  * with [YasGUI and Virtuoso SPARQL Editor](http://dev.dbpedia.org/Download_Data)  
  * with the [Databus-Client](http://dev.dbpedia.org/Databus_Client) including recompression and transformation on download.
  * to [setup your own SPARQL Database with Docker](http://dev.dbpedia.org/Setup_DBpedia_SPARQL_Database) 

## Overview

* DBpedia extracts information from all Wikipedia languages, Wikidata, Commons and other projects
* The extraction runs monthly around the 7th, for details see the [Improve DBpedia section](http://dev.dbpedia.org/Improve_DBpedia) 
* You can also read the documentation and create custom SPARQL queries for individual datasets at the [Databus DBpedia Account](https://databus.dbpedia.org/dbpedia)
* The data is split into different groups or modules according to their dependencies

## Core Groups
Databus URI Pattern: `https://databus.dbpedia.org/dbpedia/$group`

SPARQL `?dataset dataid:group <https://databus.dbpedia.org/dbpedia/wikidata> .`

* **[generic](https://databus.dbpedia.org/dbpedia/generic)** - available for ~140 languages, based on the [pages-articles-multistream Wikimedia dumps](https://dumps.wikimedia.org/), uses [the automatic extractors written in scala](https://github.com/dbpedia/extraction-framework/tree/master/core/src/main/scala/org/dbpedia/extraction/mappings) on the Wiki syntax and produces predicates of the form `http://dbpedia.org/property` or `http://$lang.dbpedia.org/property` as well as other standard vocabularies, such as `foaf`, `rdfs:label`, `skos`, `wgs84` . They have the broadest coverage and decent quality. 
* **[mappings](https://databus.dbpedia.org/dbpedia/mappings)** - avalailable for ~40 languages. The [InfoboxMappingsExtractor](https://github.com/dbpedia/extraction-framework/blob/master/core/src/main/scala/org/dbpedia/extraction/mappings/InfoboxMappingsExtractor.scala) can be configured and optimized with easier to write rules called mappings, edited in the Mappings Wiki. This module produces  triples with `http://dbpedia.org/ontology/` predicates. They have a higher quality, but are fewer. They are an improved complement of the `generic` module. Also ontology types using `rdf:type` are in this module. 
* **[wikidata](https://databus.dbpedia.org/dbpedia/wikidata)** - applies a set of extractors and mappings on the [Wikidata XML dumps](https://dumps.wikimedia.org/wikidatawiki/) to make Wikidata compatible with `generic` and `mappings`. Uses `http://wikidata.dbpedia.org/resource/Q[0-9+]` as subject. Also has configurable Mappings Extractor to map `P[0-9]+` to `http://dbpedia.org/ontology` and other standard vocabularies. 

```sql
PREFIX dataid: <http://dataid.dbpedia.org/ns/core#>
PREFIX dct: <http://purl.org/dc/terms/>
PREFIX dcat:  <http://www.w3.org/ns/dcat#>

# Get all latest files of wikidata extraction
SELECT DISTINCT ?file ?shasum WHERE {
    ?dataset dataid:group <https://databus.dbpedia.org/dbpedia/wikidata> .
    ?dataset dcat:distribution ?distribution .
    ?dataset dct:hasVersion ?latestVersion .
    {
        SELECT (max(?version) as ?latestVersion) WHERE {
           ?dataset dataid:group <https://databus.dbpedia.org/dbpedia/wikidata> .
           ?dataset dct:hasVersion ?version .
        }
    }
    ?distribution dcat:downloadURL ?file .
    ?distribution dataid:sha256sum ?shasum .
    # debug will be removed in a while
    FILTER NOT EXISTS {?distribution <http://dataid.dbpedia.org/ns/cv#tag> 'debug'^^<http://www.w3.org/2001/XMLSchema#string>} .       
}
```

* **offline - [text](https://databus.dbpedia.org/dbpedia/text)** - available in 140 languages, uses the HTML queried from the Wikipedia API to extract short and long abstracts and other relevant information for Natural Language Processing via the [NIF Extractor](https://github.com/dies-und-lenes/extraction-framework/blob/multilingual-live/core/src/main/scala/org/dbpedia/extraction/mappings/NifExtractor.scala). Requires online requests to https://en.wikipedia.org/w/api.php or a local mirror, set up with http://www.nongnu.org/wp-mirror/
  * Will run again in Oct 2019  
* **in development - [ontology](https://databus.dbpedia.org/dbpedia/ontology)** Provides version snapshots of the DBpedia Ontology downloaded from the [Mappings Wiki](http://mappings.dbpedia.org), 
  * Snapshots are currently developed by [Denis](https://databus.dbpedia.org/denis/ontology/dbo-snapshots) and will be moved soon. 
* **[transition](https://databus.dbpedia.org/dbpedia/transition)** - mixed datasets from older releases, which we need to consolidate into the new structure




## Community Extensions


