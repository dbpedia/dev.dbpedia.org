# Data 

DBpedia's data is published via [https://databus.dbpedia.org](https://databus.dbpedia.org)
This page contains useful queries. 


## File access
We did keep the possibility to look for files via a web directory listing: http://downloads.dbpedia.org/repo/lts/ , which also include markdown documentation files and dataid.ttl . 
`wget --no-parent --mirror http://downloads.dbpedia.org/repo/lts/` 
will download all 200 GB of all groups, artifacts and versions

## Databus SPARQL API

The recommended way to access the files will be via our new Databus SPARQL API, which enables users to define clear data dependencies for their applications. 

### Collections and the shopping cart feature
We are working on the collections. The basic idea is to browse over datasets and press "Add to collection". 
Here are known issues:
* you have to press the "add to collection" button twice the first time (session initiation)
* you can not persist the query, it is lost with the session, we are working on the "save"
* copy to clipboard works, so you can browse each dataset and then collect what you need and then export it.  

The collection queries are  `{query1} UNION {query2}` using `?file`


### Query for download URL of English labels, version 2018.12.14 from generic

<img src="https://github.com/dbpedia/dev.dbpedia.org/raw/master/pics/generic_labels_en.png">

### The SPARQL API:
* https://databus.dbpedia.org/repo/sparql 
* https://databus.dbpedia.org/yasgui/ (still buggy)

### Get the latest version of the English labels artifact
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

### Get the latest version of all download URLs from the generic group extracted from the English Wikipedia:
```
PREFIX dataid: <http://dataid.dbpedia.org/ns/core#>
PREFIX dct: <http://purl.org/dc/terms/>
PREFIX dcat:  <http://www.w3.org/ns/dcat#>

SELECT ?file {
?dataset dcat:distribution ?distribution.
?distribution dataid:contentVariant 'en'^^<http://www.w3.org/2001/XMLSchema#string> .
?distribution dcat:downloadURL ?file  .
{SELECT ?dataset max(?version) WHERE {
		?dataset dataid:group <https://databus.dbpedia.org/dbpedia/generic> .
        ?dataset dct:hasVersion ?version .
} GROUP BY ?dataset }
}
```


