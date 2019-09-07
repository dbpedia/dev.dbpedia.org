# Download Data from the DBpedia Databus

Databus is currently in Public Beta during 2019, beginning 2020

## Databus SPARQL API 

* URL: `https://databus.dbpedia.org/repo/sparql`
* Follows the SPARQL 1.1 [Protocol](https://www.w3.org/TR/sparql11-protocol/) and [Query Language](https://www.w3.org/TR/sparql11-query/), Virtuoso version 07.20.3217 
* [YASGUI](https://databus.dbpedia.org/yasgui/) - Yet Another SPARQL GUI
* [Virtuoso SPARQL Editor](https://databus.dbpedia.org/repo/sparql)
* [Faceted Search & Find service](https://databus.dbpedia.org/fct/) - some configuration issues exist, will be fixed during next maintenance

**stable vocabularies**

```
# external
PREFIX dcat:   <http://www.w3.org/ns/dcat#>
PREFIX dct:    <http://purl.org/dc/terms/>
PREFIX prov: <http://www.w3.org/ns/prov#>
PREFIX rdf:    <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs:   <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
# DataId core
PREFIX dataid: <http://dataid.dbpedia.org/ns/core#>
# Databus Stable Dataset IDs
PREFIX db:     <https://databus.dbpedia.org/>
```

**UNSTABLE vocabularies, changes after BETA below**
```
PREFIX dataid-debug: <http://dataid.dbpedia.org/ns/debug.ttl#>
PREFIX dataid-cv: <http://dataid.dbpedia.org/ns/cv#>
PREFIX dataid-mt: <http://dataid.dbpedia.org/ns/mt#>
```

## Query downloadURLs of all available files, all versions

```sql
PREFIX dataid: <http://dataid.dbpedia.org/ns/core#>
PREFIX dcat:   <http://www.w3.org/ns/dcat#>
SELECT ?downloadURL, ?dataset, ?stableVersionID, ?stableFileID, ?localpath WHERE {
  # ?dataset URI points to the remote dataid.ttl file
  ?dataset a dataid:Dataset. 
  ?dataset dcat:distribution/dcat:downloadURL ?downloadURL . 
  ?dataset dcat:distribution/dataid:file ?stableFileID .
  ?dataset dataid:version ?stableVersionID
  # when downloading use this ?localpath to solve conflicting file names
  BIND (replace(str(?stableVersionID), "https://databus.dbpedia.org/" , "") AS ?localpath)
} 
LIMIT 10000
OFFSET 0
```

## Content of the SPARQL Database

DBpedia Databus does not host the files itself, these are hosted on the servers (i.e. storage) of its users. Databus Consumers upload their files on their own server in a folder structure mirroring the Databus URIs. Next to their files, they generate a `dataid.ttl` file in RDF-Turtle containing the metadata. We provide an [Upload Client](Databus_Upload_User_Manual) that generates the file and does a `POST` request. 
 
### DBpedia Download Server example (Apache2 web server)

* DataId URL (this is loaded into the SPARQL API): http://downloads.dbpedia.org/repo/lts/mappings/instance-types/2019.08.30/dataid.ttl
* Databus URL (displays the information from dataid.ttl): https://databus.dbpedia.org/dbpedia/mappings/instance-types/2019.08.30
* Apache2 web dir (downloadURLPath): http://downloads.dbpedia.org/repo/lts/mappings/instance-types/2019.08.30/
* Apache2 local directory (package): `/media/bigone/25TB/www/downloads.dbpedia.org/repo/lts/mappings/instance-types/2019.08.30/`

### `dataid.ttl` explained
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
      
        ## Properties used to debug this version or artifact 
        dataid-debug:codeReference>
                <https://github.com/dbpedia/extraction-framework/blob/master/core/src/main/scala/org/dbpedia/extraction/mappings/MappingExtractor.scala> ;
        dataid-debug:documentationLocation
                <https://github.com/dbpedia/databus-maven-plugin/blob/master/dbpedia/mappings/instance-types> ;
        dataid-debug:feedbackChannel
                <https://forum.dbpedia.org/c/databus-dbpedia/mappings> ;
        dataid-debug:issueTracker
                <https://github.com/dbpedia/extraction-framework/issues> ;
        
        # Other metadata
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
        dataid:file                  <https://databus.dbpedia.org/dbpedia/mappings/instance-types/2019.08.30/instance-types_lang=fr_transitive.ttl.bz2> ;
        dcat:downloadURL             <https://downloads.dbpedia.org/repo/lts/mappings/instance-types/2019.08.30/instance-types_lang=fr_transitive.ttl.bz2> ;
        
        
        dataid:associatedAgent       <https://webid.dbpedia.org/webid.ttl#this> ;
        dataid:compression           "bzip2" ;
        dataid:contentVariant        "transitive" , "fr" ;
        dataid:duplicates            "0"^^xsd:decimal ;
        dataid:formatExtension       "ttl" ;
        dataid:isDistributionOf      <https://downloads.dbpedia.org/repo/lts/mappings/instance-types/2019.08.30/dataid.ttl#Dataset> ;
        dataid:nonEmptyLines         "6029295"^^xsd:decimal ;
        dataid:preview               "" ;
        dataid:sha256sum             "fddd665c18c49862a778362763b8151702bae32ce6f9a1ba3722a076da206cb4" ;
        dataid:signature             "QfxGaPzwrzgkIRhZb6YGbkYW5OE1WE0WKXqM2FlifXeTANR7458NQL2erl14eeHUvdHv/0OvF5ZZfegoqM49ovoKpLqhngJNqwdBBk1QzjkDZDuAqZGDbsrQdatBDfhZBhYInTthqSwFhX6sFdnTYM6AQtmgjSrj5duFqm4im1TxJ4fluX2SGnKVzcI/XBBAaBhskXxA+WoGcv07U4uIm6T0kdSa73VDK2WNrL9GQpd5MWWKdnTajbDO/v8QAe2Y0X3Pf/oN2+t+U6W9p5Zug7z2akXANjl4urRk4A84pKNpu0uyLE9ER6OhuCRUF28Lh/aIaHhzc8y61E+okfs55w==" ;
        dataid:sorted                false ;
        dataid:uncompressedByteSize  "888130202"^^xsd:decimal ;
        dataid-cv:lang               "fr" ;
        dataid-cv:tag                "transitive" ;
        dct:conformsTo               "http://dataid.dbpedia.org/ns/core#" ;
        dct:hasVersion               "2019.08.30" ;
        dct:issued                   "2019-08-30T00:00:00Z"^^xsd:dateTime ;
        dct:license                  <http://purl.oclc.org/NET/rdflicense/cc-by3.0> ;
        dct:modified                 "2019-09-06T00:06:55Z"^^xsd:dateTime ;
        dct:publisher                <https://webid.dbpedia.org/webid.ttl#this> ;
        dcat:byteSize                "25882193"^^xsd:decimal ;
        dcat:mediaType               dataid-mt:ApplicationNTriples .

```
## Planned vocabulary changes after beta



######################################################
DBpedia's data is published via [https://databus.dbpedia.org](https://databus.dbpedia.org)
This page contains useful queries. 




## Databus SPARQL API

The recommended way to access the files will be via our new Databus SPARQL API, which enables users to define clear data dependencies for their applications. 
Features:

* Create collections using the shopping cart feature and get the query
* Retrieve the download URLs of the files to download
* Select a suitable application to consume the files (there is a Virtuoso Docker example at the bottom of thispage) 

The endpoint is reachable under:

* https://databus.dbpedia.org/repo/sparql 
* https://databus.dbpedia.org/yasgui/ (still buggy after a while, reset with https://databus.dbpedia.org/yasgui/?_resetYasgui )

## Example Application Virtuoso Docker

1. Download the [Dockerfile](https://github.com/dbpedia/dev.dbpedia.org/raw/master/pics/Dockerfile.dockerfile)
2. Build `docker build -t databus-dump-triplestore .`
3. Load any Databus `?file` query:
```
docker run -p 8890:8890 databus-dump-triplestore $(cat file-with-query.sparql)
```

### Collections and the shopping cart feature
We are working on the collections. The basic idea is to browse over datasets and press "Add to collection". 
Here are known issues:

* you have to press the "add to collection" button twice the first time (session initiation)
* you can not persist the query, it is lost with the session, we are working on the "save"
* copy to clipboard works, so you can browse each dataset and then collect what you need and then export it.  

The collection queries are  `{query1} UNION {query2}` using `?file`


### Query for download URL of English labels, version 2018.12.14 from generic

<img src="https://github.com/dbpedia/dev.dbpedia.org/raw/master/pics/generic_labels_en.png">


### [Generic/Labels](https://databus.dbpedia.org/dbpedia/generic/labels), Latest Version, English only. 
The queries to retrieve the download URLs are stable between versions and can be used to configure data dependencies in applications. The query below will always give the latest version of the English labels dataset: 

```
PREFIX dataid: <http://dataid.dbpedia.org/ns/core#>
PREFIX dct: <http://purl.org/dc/terms/>
PREFIX dcat:  <http://www.w3.org/ns/dcat#>

SELECT ?file {
	?dataset dcat:distribution ?distribution.
	?distribution dataid:contentVariant 'en'^^<http://www.w3.org/2001/XMLSchema#string> .
	?distribution dcat:downloadURL ?file  .
	{SELECT ?dataset ?latest WHERE {
		?dataset dataid:artifact <https://databus.dbpedia.org/dbpedia/generic/labels> .
		?dataset dct:hasVersion ?latest .
	} ORDER BY DESC(?latest) LIMIT 1 }
}
```

<!--
{% raw %}
<iframe frameborder="no" border="0" marginwidth="0" marginheight="0" width="800" height="580" src="https://databus.dbpedia.org/yasgui/yas-embedded_0.1.html?query=PREFIX+xsd%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2001%2FXMLSchema%23%3E%0APREFIX+dcterms%3A+%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Fterms%2F%3E%0APREFIX+rdf%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3E%0APREFIX+rdfs%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0APREFIX+dataid%3A+%3Chttp%3A%2F%2Fdataid.dbpedia.org%2Fns%2Fcore%23%3E%0APREFIX+dcat%3A+%3Chttp%3A%2F%2Fwww.w3.org%2Fns%2Fdcat%23%3E%0A%0ASELECT+%3Fym+SUM(%3Fsize)+as+%3Ffilesize+COUNT(%3Ffile)+as+%3Ffiles+WHERE+%7B%0A++%3Ffile+a+dataid%3ASingleFile+.%0A++%3Ffile+dcat%3AbyteSize+%3Fsize+.%0A++%3Ffile+dcterms%3Aissued+%3Fdate+.%0ABIND+(substr(xsd%3AString(%3Fdate)%2C+1%2C+7)+AS+%3Fym)%0A%7D+%0AGROUP+BY+%3Fym%0AORDER+BY+%3Fym%0A&contentTypeConstruct=text%2Fturtle&contentTypeSelect=application%2Fsparql-results%2Bjson&endpoint=https%3A%2F%2Fdatabus.dbpedia.org%2Frepo%2Fsparql&requestMethod=POST&tabTitle=Query+1&headers=%7B%7D&outputFormat=table"></iframe>
{% endraw %}
-->

### Generic, Mappings, Text group, latest version of all artifacts,  English Wikipedia only minus the Wikilinks artifact

Note: this query is pretty close to what we load in the main endpoint, e.g. the [Transition Group] (https://databus.dbpedia.org/dbpedia/transition) is missing. 


```
PREFIX dataid: <http://dataid.dbpedia.org/ns/core#>
PREFIX dct: <http://purl.org/dc/terms/>
PREFIX dcat:  <http://www.w3.org/ns/dcat#>

SELECT ?file {
    ?dataset dataid:artifact ?artifact .
    ?dataset dataid:version ?latest .
    ?dataset dcat:distribution ?distribution.
    # filter by language and other cv here. 
    ?distribution dataid:contentVariant 'en'^^<http://www.w3.org/2001/XMLSchema#string> .
    ?distribution dcat:downloadURL ?file  .
    {SELECT ?artifact (max(?version) as ?latest) WHERE {
                # filter by group here 
                ?dataset dataid:group ?group . 
                FILTER (?group in (<https://databus.dbpedia.org/dbpedia/generic>, <https://databus.dbpedia.org/dbpedia/generic>, <https://databus.dbpedia.org/dbpedia/mappings> )) .
                # filter by artifact here 
                ?dataset dataid:artifact ?artifact .
                FILTER (?artifact != <https://databus.dbpedia.org/dbpedia/generic/wikilinks>)
                ?dataset dataid:version ?version .
                } GROUP BY ?artifact 
     }
}order by desc(?file)
```

### Transition all artifacts as generated by the GUI
```
PREFIX dataid: <http://dataid.dbpedia.org/ns/core#>
PREFIX dct: <http://purl.org/dc/terms/>
PREFIX dcat: <http://www.w3.org/ns/dcat#>

SELECT DISTINCT ?file WHERE
{
	{
		# Get all files
		SELECT DISTINCT ?file WHERE {
			?dataset dataid:artifact <https://databus.dbpedia.org/dbpedia/transition/linked-hypernyms> .
			?dataset dcat:distribution ?distribution .
			?distribution dct:hasVersion '2019.02.10'^^<http://www.w3.org/2001/XMLSchema#string> .
			?distribution dataid:contentVariant 'en'^^<http://www.w3.org/2001/XMLSchema#string> .
			?distribution dcat:downloadURL ?file .
		}
	}
	UNION
	{
		# Get all files
		SELECT DISTINCT ?file WHERE {
			?dataset dataid:artifact <https://databus.dbpedia.org/dbpedia/transition/links> .
			?dataset dcat:distribution ?distribution .
			?distribution dct:hasVersion '2019.01.01'^^<http://www.w3.org/2001/XMLSchema#string> .
			?distribution dataid:contentVariant 'en'^^<http://www.w3.org/2001/XMLSchema#string> .
			?distribution dcat:downloadURL ?file .
		}
	}
	UNION
	{
		# Get all files
		SELECT DISTINCT ?file WHERE {
			?dataset dataid:artifact <https://databus.dbpedia.org/dbpedia/transition/freebase-links> .
			?dataset dcat:distribution ?distribution .
			?distribution dct:hasVersion '2019.02.10'^^<http://www.w3.org/2001/XMLSchema#string> .
			?distribution dataid:contentVariant 'en'^^<http://www.w3.org/2001/XMLSchema#string> .
			?distribution dcat:downloadURL ?file .
		}
	}
}
```

### sha256sum
Add this to the query:

```
SELECT ?file ?shasum {
	?distribution dataid:sha256sum ?shasum .
```



