# Download Data

DBpedia Databus is currently in Public Beta during 2019 until early 2020. We describe how to query it on this page. The Databus website offers more user-friendly choices, such as collections and query builders. 

All databus SPARQL queries can be used ...
* directly via HTTP GET (and POST for longer queries)
* with the [Databus-Client](http://dev.dbpedia.org/Databus_Client)
* Databus add data dependencies to Maven (software with data), see the [Databus-Derive-Plugin](http://dev.dbpedia.org/Databus_Derive_Maven_Integration) 
* to [setup your own SPARQL Database with Docker](http://dev.dbpedia.org/Setup_DBpedia_SPARQL_Database) 
* with future applications and dockers building on the databus

The easiest way to download the files of the DBpedia lastest core release is to go to the [DBpedia Latest Core Collection](https://databus.dbpedia.org/dbpedia/collections/latest-core). Open the page and click on the *QUERY* tab. You will find a few lines of bash script that will download the collection files to your local machine. Here is the auto-generated bash script for the Latest Core collection:

```
query=$(curl -H "Accept:text/sparql" https://databus.dbpedia.org/dbpedia/collections/latest-core)
files=$(curl -H "Accept: text/csv" --data-urlencode "query=${query}" https://databus.dbpedia.org/repo/sparql | tail -n+2 | sed 's/"//g')
while IFS= read -r file ; do wget $file; done <<< "$files"
```

## Databus SPARQL API 

* URL: `https://databus.dbpedia.org/repo/sparql`
* Follows the SPARQL 1.1 [Protocol](https://www.w3.org/TR/sparql11-protocol/) and [Query Language](https://www.w3.org/TR/sparql11-query/), Virtuoso version 07.20.3217 
* [YASGUI](https://databus.dbpedia.org/yasgui/) - Yet Another SPARQL GUI, reset browser cache with [https://databus.dbpedia.org/yasgui/?_resetYasgui]
* [Virtuoso SPARQL Editor](https://databus.dbpedia.org/repo/sparql)
* [Faceted Search & Find service](https://databus.dbpedia.org/fct/) - some configuration issues exist, will be fixed during next maintenance
* At the end of the year, we plan a scalability update (better or more servers, some data moved to additional, external stores). During development it is running on the [smallest Hetzner server](https://www.hetzner.com/dedicated-rootserver/matrix-ex).
* Performance note: Please use aggregates (COUNT, SUM, AVG, GROUP_CONCAT) and Group By sparingly. If too many people run analytics, it impacts performance. Replicate the store with the weekly dumps locally for these.  

**stable vocabularies**

```
# external
PREFIX dcat:   <http://www.w3.org/ns/dcat#>
PREFIX dct:    <http://purl.org/dc/terms/>
PREFIX prov:   <http://www.w3.org/ns/prov#>
PREFIX rdf:    <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs:   <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd:    <http://www.w3.org/2001/XMLSchema#>
# DataId core
PREFIX dataid: <http://dataid.dbpedia.org/ns/core#>
# Databus Stable Dataset IDs
PREFIX db:     <https://databus.dbpedia.org/>
```

**UNSTABLE vocabularies, changes after BETA**
Ontology namespaces are not final yet. Ontologies are not de-referencable online.  Mod data will be moved to an extra server and federated. 
See below for a more detailed list of planned changes.  

```
PREFIX dataid-debug: <http://dataid.dbpedia.org/ns/debug.ttl#>
PREFIX dataid-cv:    <http://dataid.dbpedia.org/ns/cv#>
PREFIX dataid-mt:    <http://dataid.dbpedia.org/ns/mt#>
PREFIX mod:          <http://dataid.dbpedia.org/ns/mod.ttl#> 
PREFIX databus-sys:  <https://databus.dbpedia.org/system/voc/> 
```
## License URLs 
* currently use: http://purl.oclc.org/NET/rdflicense/
* we might switch to one of the following after they are evaluated and vetted:
  * https://joinup.ec.europa.eu/release/dcat-ap-how-refer-licence-documents-and-licence-uris
  * https://creativecommons.org/ns
  * https://dalicc.net/about
  * https://www.w3.org/ns/odrl/2/ODRL21
  * `license.txt` file


## Query all downloadURLs

```sql
#dcat:downloadURL of all available files, all versions
PREFIX dataid: <http://dataid.dbpedia.org/ns/core#>
PREFIX dcat:   <http://www.w3.org/ns/dcat#>
SELECT ?downloadURL, ?stableFileId, ?dataset, ?stableVersionId, ?localpath, ?shasum   WHERE {
  # ?dataset URI points to the remote dataid.ttl file
  ?dataset a dataid:Dataset. 
  ?dataset dcat:distribution/dcat:downloadURL ?downloadURL . 
  ?dataset dcat:distribution/dataid:file ?stableFileId .
  ?dataset dcat:distribution/dataid:sha256sum ?shasum .
  ?dataset dataid:version ?stableVersionId .
  # when downloading use this ?localpath to solve conflicting file names
  BIND (replace(str(?stableVersionId), "https://databus.dbpedia.org/" , "") AS ?localpath)
} 
LIMIT 10000
OFFSET 0
```

## Database Content

DBpedia Databus does not host the files itself, these are hosted on the servers (i.e. storage) of its users. Databus Consumers upload their files on their own server in a folder structure mirroring the Databus URIs. Next to their files, they generate a `dataid.ttl` file in RDF-Turtle containing the metadata. We provide an [Upload Client](Databus_Upload_User_Manual) that generates the file and does a `POST` request. 
 
DBpedia Download Server example (Apache2 web server)

* DataId URL (this is loaded into the SPARQL API): http://downloads.dbpedia.org/repo/lts/mappings/instance-types/2019.08.30/dataid.ttl
* Databus URL (displays the information from dataid.ttl): https://databus.dbpedia.org/dbpedia/mappings/instance-types/2019.08.30
* Apache2 web dir (downloadURLPath): http://downloads.dbpedia.org/repo/lts/mappings/instance-types/2019.08.30/
* Apache2 local directory (package): `/media/bigone/25TB/www/downloads.dbpedia.org/repo/lts/mappings/instance-types/2019.08.30/`

### Databus Website
The Databus uses the SPARQL database as backend. What you see on each page is loaded in the database. Additionally we cache FOAF/WebID profiles and RDF-Turtle files from https://github.com/dbpedia/databus-content as well as [Databus_Mods](Databus_Mods) data. 

Here is an example how Mods are included in the website:

```sql
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX prov: <http://www.w3.org/ns/prov#>
PREFIX dataid: <http://dataid.dbpedia.org/ns/core#>
PREFIX dcat:   <http://www.w3.org/ns/dcat#>

# query all files and their mod results
# group_concat see: https://stackoverflow.com/questions/18212697/aggregating-results-from-sparql-query
SELECT ?fileId (group_concat(?result;separator=" ") as ?results)  WHERE {
  ?dataset dataid:version <https://databus.dbpedia.org/dbpedia/mappings/mappingbased-literals/2018.12.01> .
  ?file dataid:isDistributionOf ?dataset .
  ?file dataid:file ?fileId .
  # mods are prov:Activity
  # identify the activity on the same file
  ?activity prov:generated ?resultsvg .
  ?activity prov:generated ?resultstat .
  ?activity prov:used ?fileId .
  ?resultsvg <http://dataid.dbpedia.org/ns/mod.ttl#svgDerivedFrom> ?fileId .
  ?resultstat <http://dataid.dbpedia.org/ns/mod.ttl#htmlDerivedFrom> ?fileId .
  # transform to image link
  # <img src="smiley.gif" alt="Smiley face" height="42" width="42"> 
  BIND (concat("<a href=\"",?resultstat, "\"> <img src=\"",?resultsvg,"\"></a>" ) AS ?result )
  
  # optionally getting class of the mod
  # ?activity a ?modclass .
  # and the main statsummaries
  # e.g. weekly online rate
  # ?activity ?property ?statSummary .
  # ?summary rdfs:subPropertyOf mod:statSummary
  
} 
Group by ?fileId
```

### Weekly Databus dumps 
Available at: [https://databus.dbpedia.org/dbpedia/databus/databus-data](https://databus.dbpedia.org/dbpedia/databus/databus-data)

Query latest version:

```sql
PREFIX dataid: <http://dataid.dbpedia.org/ns/core#>
PREFIX dct: <http://purl.org/dc/terms/>
PREFIX dcat:  <http://www.w3.org/ns/dcat#>

SELECT ?file ?latestVersion WHERE {
 	?dataset dataid:artifact <https://databus.dbpedia.org/dbpedia/databus/databus-data> .
	?dataset dcat:distribution/dcat:downloadURL ?file .
    ?dataset dcat:distribution/dct:hasVersion ?latestVersion 
	{
            SELECT (?version as ?latestVersion) WHERE { 
                ?dataset dataid:artifact <https://databus.dbpedia.org/dbpedia/databus/databus-data> . 
                ?dataset dct:hasVersion ?version . 
            } ORDER BY DESC (?version) LIMIT 1 
	} 
}
```


# `dataid.ttl` explained
Excerpt from [dataid.ttl of DBpedia/mappings/instance-types/2019.08.30](http://downloads.dbpedia.org/repo/lts/mappings/instance-types/2019.08.30/dataid.ttl). Can be directly used in SPARQL queries. 


```
# Local Dataset URLs use # fragment URLs
# equivalent to dcat:Dataset, a snapshot, revision or version, e.g. 2019.08.30
# links to a set of files 
<https://downloads.dbpedia.org/repo/lts/mappings/instance-types/2019.08.30/dataid.ttl#Dataset>
        a                       dataid:Dataset ;
        rdfs:label              "DBpedia Ontology instance types"@en ;
        rdfs:comment            "..."@en ;
        # two documentation properties using markdown
        dct:description         "..." ;
        dataid:groupdocu        "..." ;
        
        # stable Ids are added to this dataset
        dataid:account          databus:dbpedia ;
        dataid:group            <https://databus.dbpedia.org/dbpedia/mappings> ;
        # artifact is the abstract identity, i.e. next version of this dataset is still the same artifact
        dataid:artifact         <https://databus.dbpedia.org/dbpedia/mappings/instance-types> ;
        dataid:version          <https://databus.dbpedia.org/dbpedia/mappings/instance-types/2019.08.30> ;
      
        # Properties used to debug this version or artifact 
        dataid-debug:codeReference>
                <https://github.com/dbpedia/extraction-framework/blob/master/core/src/main/scala/org/dbpedia/extraction/mappings/MappingExtractor.scala> ;
        dataid-debug:documentationLocation
                <https://github.com/dbpedia/databus-maven-plugin/blob/master/dbpedia/mappings/instance-types> ;
        dataid-debug:feedbackChannel
                <https://forum.dbpedia.org/c/databus-dbpedia/mappings> ;
        dataid-debug:issueTracker
                <https://github.com/dbpedia/extraction-framework/issues> ;
        
        # other metadata
        dct:conformsTo          "http://dataid.dbpedia.org/ns/core#" ;
        # datasets are ordered lexicographically by SPARQL ORDER BY
        dct:hasVersion          "2019.08.30" ;
        dct:issued              "2019-08-30T00:00:00Z"^^xsd:dateTime ;
        dct:license             <http://purl.oclc.org/NET/rdflicense/cc-by3.0> ;
        dct:publisher           <https://webid.dbpedia.org/webid.ttl#this> ;
        dataid:associatedAgent  <https://webid.dbpedia.org/webid.ttl#this> ;
         
        # a slight semantic change to dcat:Distribution, links to the files
        dcat:distribution       <https://downloads.dbpedia.org/repo/lts/mappings/instance-types/2019.08.30/dataid.ttl#instance-types_lang=fr_transitive.ttl.bz2> .

# local file URL also with # fragemnt URL
<https://downloads.dbpedia.org/repo/lts/mappings/instance-types/2019.08.30/dataid.ttl#instance-types_lang=fr_transitive.ttl.bz2>
        # this distribution just describes this file
        a                            dataid:SingleFile ;
        # stable fileId returning HTTP 307
        dataid:file                  <https://databus.dbpedia.org/dbpedia/mappings/instance-types/2019.08.30/instance-types_lang=fr_transitive.ttl.bz2> ;
        # external link to download
        dcat:downloadURL             <https://downloads.dbpedia.org/repo/lts/mappings/instance-types/2019.08.30/instance-types_lang=fr_transitive.ttl.bz2> ;
        
        # useful core metadata about the file
        dataid:sha256sum             "fddd665c18c49862a778362763b8151702bae32ce6f9a1ba3722a076da206cb4" ;
        dataid:signature             "QfxGaPzwrzgkIRhZb6YGbkYW5OE1WE0WKXqM2FlifXeTANR7458NQL2erl14eeHUvdHv/0OvF5ZZfegoqM49ovoKpLqhngJNqwdBBk1QzjkDZDuAqZGDbsrQdatBDfhZBhYInTthqSwFhX6sFdnTYM6AQtmgjSrj5duFqm4im1TxJ4fluX2SGnKVzcI/XBBAaBhskXxA+WoGcv07U4uIm6T0kdSa73VDK2WNrL9GQpd5MWWKdnTajbDO/v8QAe2Y0X3Pf/oN2+t+U6W9p5Zug7z2akXANjl4urRk4A84pKNpu0uyLE9ER6OhuCRUF28Lh/aIaHhzc8y61E+okfs55w==" ;
        dataid:preview               "[~10 lines]" ;
        dct:conformsTo               "http://dataid.dbpedia.org/ns/core#" ;
        dct:hasVersion               "2019.08.30" ;
        dct:issued                   "2019-08-30T00:00:00Z"^^xsd:dateTime ;
        dct:license                  <http://purl.oclc.org/NET/rdflicense/cc-by3.0> ;
        dct:modified                 "2019-09-06T00:06:55Z"^^xsd:dateTime ;
        dct:publisher                <https://webid.dbpedia.org/webid.ttl#this> ;
        dcat:byteSize                "25882193"^^xsd:decimal .
```
## Content variants aka file tags
Databus allows user-tagging in filenames to be able to split large files into smaller packets that are more consumer-friendly. `dataid-cv` is an automatic generated and free vocabulary used for query filtering.  
 
`instance-types_lang=fr_transitive.ttl.bz2` has two such tags

```
#  _lang=fr_ results in 
        dataid:contentVariant        "fr" ;
        dataid-cv:lang               "fr" ;
        dataid-cv:lang  rdfs:subPropertyOf  dataid:contentVariant .
#  _transitive_ (same as _tag=transitive_ )
        dataid:contentVariant        "transitive" ;
        dataid-cv:tag                "transitive" ;
        dataid-cv:lang  rdfs:subPropertyOf  dataid:contentVariant .       
```



## Unstable properties under discussion
The following file properties are under discussion:
       
* At dataset-level, reason: duplicate information        

```     
        dataid:associatedAgent       <https://webid.dbpedia.org/webid.ttl#this> ;
        dataid:isDistributionOf      <https://downloads.dbpedia.org/repo/lts/mappings/instance-types/2019.08.30/dataid.ttl#Dataset> ;  
```


* At file-level, reasons:
  * these are currently generated by the Upload client and therefore they are implementation specific and can become inconsistent between client versions. 
  * if we generate them via [mods](Databus_Mods), they will be more consistent and easier to update.
  * implementing the client in other programming languages will be less effort. 
  * datai-mt is generated using [IANA](https://www.iana.org/assignments/media-types/media-types.xhtml) and replacing `-`,`/` and capitalizing the next letter, a difficult algorithm. A proper XML conversion into Linked Data is needed. 

```        
        
        dcat:mediaType               dataid-mt:ApplicationNTriples ;
        dataid:compression           "bzip2" ;
        dataid:formatExtension       "ttl" ;
        dataid:duplicates            "0"^^xsd:decimal ;
        dataid:nonEmptyLines         "6029295"^^xsd:decimal ;
        dataid:sorted                false ;
        dataid:uncompressedByteSize  "888130202"^^xsd:decimal ;
```





