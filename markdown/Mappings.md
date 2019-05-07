# Mappings

## Introduction
The core of DBpedia is extracted from Wikipedia's infoboxes via the `generic` extraction using the `http://dbpedia.org/property/` properties. 
These provide the largest coverage with over 50k different properties. Based on this Mappings are created that refine these properties into `http://dbpedia.org/ontology/` properties. 
These are less diverse (only around 1000 properties) with less coverage, but have a much higher quality. 

## How to edit Mappings
In order to edit Mappings we are using a [Mappings Wiki](http://mappings.dbpedia.org/). Everybody can register and help improve the [Mappingbased Extraction](http://dev.dbpedia.org/Mappingbased_Extraction).

## How to retrieve mapped data
There are several places where you can retrieve mapped data:
1. the frequent dumps for the mapping based extraction accessible via: http://dev.dbpedia.org/Mappingbased_Extraction
2. DBpedia Live Extraction (under maintenance, update of Mappings not working yet 5th May, 2019, UnmodifiedFeeder)
3. At each page in the mappings wiki there is a link `Test this mapping`, for example here: http://mappings.dbpedia.org/index.php/Mapping_en:Infobox_Company
4. In the mappings wiki there is a short manual about custom extractions: http://mappings.dbpedia.org/index.php/Main_Page#Custom_or_Default_Extractor
5. (planned) as part of the [GlobalFactSync Proect](https://meta.wikimedia.org/wiki/Grants:Project/DBpedia/GlobalFactSyncRE) we are developing a GUI for inspecting data from different Wikipedia language editions and Wikidata. A prototype is here: https://global.dbpedia.org
