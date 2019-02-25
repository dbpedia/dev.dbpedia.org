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

### The SPARQL API URL:
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

<!--
{% raw %}
<iframe frameborder="no" border="0" marginwidth="0" marginheight="0" width="800" height="580" src="https://databus.dbpedia.org/yasgui/yas-embedded_0.1.html?query=PREFIX+xsd%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2001%2FXMLSchema%23%3E%0APREFIX+dcterms%3A+%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Fterms%2F%3E%0APREFIX+rdf%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3E%0APREFIX+rdfs%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0APREFIX+dataid%3A+%3Chttp%3A%2F%2Fdataid.dbpedia.org%2Fns%2Fcore%23%3E%0APREFIX+dcat%3A+%3Chttp%3A%2F%2Fwww.w3.org%2Fns%2Fdcat%23%3E%0A%0ASELECT+%3Fym+SUM(%3Fsize)+as+%3Ffilesize+COUNT(%3Ffile)+as+%3Ffiles+WHERE+%7B%0A++%3Ffile+a+dataid%3ASingleFile+.%0A++%3Ffile+dcat%3AbyteSize+%3Fsize+.%0A++%3Ffile+dcterms%3Aissued+%3Fdate+.%0ABIND+(substr(xsd%3AString(%3Fdate)%2C+1%2C+7)+AS+%3Fym)%0A%7D+%0AGROUP+BY+%3Fym%0AORDER+BY+%3Fym%0A&contentTypeConstruct=text%2Fturtle&contentTypeSelect=application%2Fsparql-results%2Bjson&endpoint=https%3A%2F%2Fdatabus.dbpedia.org%2Frepo%2Fsparql&requestMethod=POST&tabTitle=Query+1&headers=%7B%7D&outputFormat=table"></iframe>
{% endraw %}
-->

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
### sha256sum
```
PREFIX dataid: <http://dataid.dbpedia.org/ns/core#>
PREFIX dct: <http://purl.org/dc/terms/>
PREFIX dcat:  <http://www.w3.org/ns/dcat#>

SELECT ?file ?shasum {
	?dataset dcat:distribution ?distribution.
	?distribution dataid:contentVariant 'en'^^<http://www.w3.org/2001/XMLSchema#string> .
	?distribution dcat:downloadURL ?file  .
	?distribution dataid:sha256sum ?shasum .
	{SELECT ?dataset max(?version) WHERE {
			?dataset dataid:group <https://databus.dbpedia.org/dbpedia/generic> .
			?dataset dct:hasVersion ?version .
	} GROUP BY ?dataset }
}
```

## Example Application Virtuoso Docker

1. Download the [Dockerfile](https://github.com/dbpedia/dev.dbpedia.org/raw/master/pics/Dockerfile.dockerfile)
2. Build `docker build -t databus-dump-triplestore .`
3. Load any Databus `?file` query:
```
docker run -p 8890:8890 databus-dump-triplestore $(cat file-with-query.sparql)
```

