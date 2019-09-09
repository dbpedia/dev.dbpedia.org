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
* Databus URI Pattern: `https://databus.dbpedia.org/dbpedia/$group`
* SPARQL `?dataset dataid:group <https://databus.dbpedia.org/dbpedia/generic> .`
* For docu add `?dataset rdfs:comment ?comment . ?dataset dct:description ?description .` to queries.

### [generic](https://databus.dbpedia.org/dbpedia/generic), monthly, deployed
* available for ~140 languages, based on the [pages-articles-multistream Wikimedia dumps](https://dumps.wikimedia.org/), uses [the automatic extractors written in scala](https://github.com/dbpedia/extraction-framework/tree/master/core/src/main/scala/org/dbpedia/extraction/mappings) on the Wiki syntax and produces predicates of the form `http://dbpedia.org/property` or `http://$lang.dbpedia.org/property` as well as other standard vocabularies, such as `foaf`, `rdfs:label`, `skos`, `wgs84` . They have the broadest coverage and decent quality. 
  * generic group has over 20 artifacts with almost 3000 per version total
  * Filter belo is set to 'English only' 
  
```sql
PREFIX dataid: <http://dataid.dbpedia.org/ns/core#>
PREFIX dataid-cv: <http://dataid.dbpedia.org/ns/cv#>
PREFIX dct: <http://purl.org/dc/terms/>
PREFIX dcat:  <http://www.w3.org/ns/dcat#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

# Get all latest English files of generic extraction
SELECT DISTINCT ?file ?shasum WHERE {
    ?dataset dataid:group <https://databus.dbpedia.org/dbpedia/generic> .
    ?dataset dcat:distribution ?distribution .
    ?distribution dataid-cv:lang "en"^^xsd:string .
    ?dataset dct:hasVersion ?latestVersion .
    {
        SELECT (max(?version) as ?latestVersion) WHERE {
           ?dataset dataid:group <https://databus.dbpedia.org/dbpedia/generic> .
           ?dataset dct:hasVersion ?version .
        }
    }
    ?distribution dcat:downloadURL ?file .
    ?distribution dataid:sha256sum ?shasum .
    # debug will be removed in a while
    FILTER NOT EXISTS {?distribution dataid-cv:tag 'debug'^^xsd:string} .       
}

```

###[mappings](https://databus.dbpedia.org/dbpedia/mappings), monthly, deployed 
* avalailable for ~40 languages. The [InfoboxMappingsExtractor](https://github.com/dbpedia/extraction-framework/blob/master/core/src/main/scala/org/dbpedia/extraction/mappings/InfoboxMappingsExtractor.scala) can be configured and optimized with easier to write rules called mappings, edited in the Mappings Wiki. This module produces  triples with `http://dbpedia.org/ontology/` predicates. They have a higher quality, but are fewer. They are an improved complement of the `generic` module. Also ontology types using `rdf:type` are in this module. 
  * The mappings group is far more heterogeneous than generic or wikidata:
     * not every artifact has every language, they are quite mixed
     * some artifacts get extra post-processing such as [mappingbased objects](https://databus.dbpedia.org/dbpedia/mappings/mappingsbased-objects/2019.08.30) or inference such as the [instance-type](https://databus.dbpedia.org/dbpedia/mappings/instance-types/2019.08.30) 
     * we give a query below that shows the different variants available.
     * Luckily there are only six artifacts total and with these four as the most popular (mappingbased-objects, mappingbased-literals, geo-coordinates-mappingbased, instance-types)  

```sql
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX dataid: <http://dataid.dbpedia.org/ns/core#>
PREFIX dataid-cv: <http://dataid.dbpedia.org/ns/cv#>
PREFIX dct: <http://purl.org/dc/terms/>
PREFIX dcat:  <http://www.w3.org/ns/dcat#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

# Show all content variants of mappings, grouped by artifact
SELECT DISTINCT ?artifact ?cvproperty  (group_concat(?cvtmp;separator=",") as ?cv)  WHERE {
    { 
    	SELECT DISTINCT ?artifact ?cvproperty ?cvtmp  {
            ?dataset dataid:group <https://databus.dbpedia.org/dbpedia/mappings> .
      		?dataset dataid:artifact ?artifact .
    		?dataset dcat:distribution ?distribution .
    		?cvproperty rdfs:subPropertyOf  dataid:contentVariant . 
    		?distribution ?cvproperty ?cvtmp .
  		} 
   } 
} GROUP BY ?artifact ?cvproperty
``` 


```sql
PREFIX dataid: <http://dataid.dbpedia.org/ns/core#>
PREFIX dataid-cv: <http://dataid.dbpedia.org/ns/cv#>
PREFIX dct: <http://purl.org/dc/terms/>
PREFIX dcat:  <http://www.w3.org/ns/dcat#>


# Get the latest of the four most popular mappings dataset, English only
SELECT DISTINCT ?file WHERE {
     ?dataset dcat:distribution ?distribution .
     ?dataset dct:hasVersion ?latestVersion .
  	 { 
    	?dataset dataid:artifact ?artifact .
    	FILTER (?artifact in (
			 <https://databus.dbpedia.org/dbpedia/mappings/mappingbased-literals>,
             <https://databus.dbpedia.org/dbpedia/mappings/geo-coordinates-mappingbased>
        )) .
  	 }UNION {
     	?dataset dataid:artifact <https://databus.dbpedia.org/dbpedia/mappings/instance-types> .
    	# pre-calculated transitive closure overrdf:type
    	?distribution dataid:contentVariant "transitive"^^xsd:string .
     } UNION {
     	?dataset dataid:artifact <https://databus.dbpedia.org/dbpedia/mappings/mappingbased-objects> .
        # removes debugging info about disjoint domain and ranges
    	FILTER NOT EXISTS {?distribution dataid-cv:tag ?tag . }
     }
  		?distribution dcat:downloadURL ?file .
        # english
     	?distribution dataid:contentVariant "en"^^xsd:string .             
    {
        SELECT (max(?version) as ?latestVersion) WHERE {
            ?dataset dataid:artifact ?artifact .
    		 FILTER (?artifact in (
             <https://databus.dbpedia.org/dbpedia/mappings/instance-types>,
             <https://databus.dbpedia.org/dbpedia/mappings/mappingbased-objects>,
			 <https://databus.dbpedia.org/dbpedia/mappings/mappingbased-literals>,
             <https://databus.dbpedia.org/dbpedia/mappings/geo-coordinates-mappingbased>
             )) .
            ?dataset dct:hasVersion ?version .
        }
    }
}

```

### [wikidata](https://databus.dbpedia.org/dbpedia/wikidata), monthly, deployed
* applies a set of extractors and mappings on the [Wikidata XML dumps](https://dumps.wikimedia.org/wikidatawiki/) to make Wikidata compatible with `generic` and `mappings`. Uses `http://wikidata.dbpedia.org/resource/Q[0-9+]` as subject. Also has configurable Mappings Extractor to map `P[0-9]+` to `http://dbpedia.org/ontology` and other standard vocabularies. 

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
### [text](https://databus.dbpedia.org/dbpedia/text), under maintenance, offline
* available in 140 languages, uses the HTML queried from the Wikipedia API to extract short and long abstracts and other relevant information for Natural Language Processing via the [NIF Extractor](https://github.com/dies-und-lenes/extraction-framework/blob/multilingual-live/core/src/main/scala/org/dbpedia/extraction/mappings/NifExtractor.scala). Requires online requests to https://en.wikipedia.org/w/api.php or a local mirror, set up with http://www.nongnu.org/wp-mirror/
  * Will run Oct/Nov 2019  
  
### [ontology](https://databus.dbpedia.org/dbpedia/ontology), in development, on ontology edit 
* Provides version snapshots of the DBpedia Ontology downloaded from the [Mappings Wiki](http://mappings.dbpedia.org), 
  * Snapshots are currently developed by [Denis](https://databus.dbpedia.org/denis/ontology/dbo-snapshots) and will be moved soon. 

```sql  
PREFIX dataid: <http://dataid.dbpedia.org/ns/core#>
PREFIX dct: <http://purl.org/dc/terms/>
PREFIX dcat:  <http://www.w3.org/ns/dcat#>

SELECT distinct ?file ?latestVersion ?mediatype WHERE {
 	?dataset dataid:artifact <https://databus.dbpedia.org/denis/ontology/dbo-snapshots> .
	?dataset dcat:distribution ?distribution .
    ?distribution dcat:downloadURL ?file ;
    			  dct:hasVersion ?latestVersion ;
    			  # see all available mediatypes with 
    			  # dcat:mediaType ?mediaType .
                  dcat:mediaType <http://dataid.dbpedia.org/ns/mt#TextTurtle> . 
    {
            SELECT (?version as ?latestVersion) WHERE { 
                ?dataset dataid:artifact <https://databus.dbpedia.org/denis/ontology/dbo-snapshots> . 
                ?dataset dct:hasVersion ?version . 
            } ORDER BY DESC (?version) LIMIT 1 
	} 
}
```

### [transition](https://databus.dbpedia.org/dbpedia/transition), no updates, will be refactored
* mixed datasets from older releases, which we need to consolidate into the new structure
  * contains links to freebase and many other



## Community Extensions
Please read the docu at the databus:

  * [Fusion - all languages fused into one dataset](http://dev.dbpedia.org/DBpedia_Fusion) 
  * [LHD - additional types](https://databus.dbpedia.org/propan/lhd/linked-hypernyms)
  * [DBkWik - extraction from thousand other wikis, such as fandom](https://databus.dbpedia.org/sven-h/dbkwik)
  * your extension

