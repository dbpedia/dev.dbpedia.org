# Setup a DBpedia SPARQL endpoint on your server 

**TODO** [dbpedia/databus-client](https://github.com/dbpedia/databus-client/tree/master/docker)

## Minimal example: 
Loading the DBpedia Ontology into Virtuoso Docker

```
# create folder which will contains the used data
mkdir toLoad
cd toLoad

# create the query
echo "PREFIX dataid: <http://dataid.dbpedia.org/ns/core#>
PREFIX dataid-cv: <http://dataid.dbpedia.org/ns/cv#>
PREFIX dataid-mt: <http://dataid.dbpedia.org/ns/mt#>
PREFIX dct: <http://purl.org/dc/terms/>
PREFIX dcat:  <http://www.w3.org/ns/dcat#>

# Get latest ontology NTriples file 
SELECT DISTINCT ?file WHERE {
 	?dataset dataid:artifact <https://databus.dbpedia.org/denis/ontology/dbo-snapshots> .
	?dataset dcat:distribution ?distribution .
        ?distribution dcat:mediaType dataid-mt:ApplicationNTriples . 
	?distribution dct:hasVersion ?latestVersion .  
	?distribution dcat:downloadURL ?file .

	{
	SELECT (?version as ?latestVersion) WHERE { 
		?dataset dataid:artifact <https://databus.dbpedia.org/denis/ontology/dbo-snapshots> . 
		?dataset dct:hasVersion ?version . 
	} ORDER BY DESC (?version) LIMIT 1 
	} 
	
} " > query

# use dockerized databus-client to downlaod files
docker run --name databus-client \
    -v $(pwd)/query:/opt/databus-client/query \
    -v $(pwd):/var/repo \
    -e FORMAT="ttl" \
    -e COMPRESSION="gz" \
    dbpedia/databus-client

# move file in the right place
mv -t ./ $(find . -name "*.gz")

# remove
docker rm databus-client

docker run --name vos-ca-original \
    -p 8895:8890 -p 1111:1111 \
    -e DBA_PASSWORD=dba \
    -e SPARQL_UPDATE=true \
    -e DEFAULT_GRAPH=http://dbpedia.org/ontology \
    -v $(pwd):/data/toLoad \
    -d tenforce/virtuoso

```

## Old description without Databus Client**
1. Download the [Dockerfile](https://github.com/dbpedia/dev.dbpedia.org/raw/master/pics/Dockerfile.dockerfile)
2. Build `docker build -t databus-dump-triplestore .`
3. Load any Databus `?file` query:
```
docker run -p 8890:8890 databus-dump-triplestore $(cat file-with-query.sparql)
```
**TODO**
* TODO post new Dockers in the [DBpedia Forum](https://forum.dbpedia.org)
* TODO add a running example, e.g. loading the DBpedia ontology into Virtuoso
* TODO Setup Docker Hub to collect more applications and describe the process of adding dockers
* TODO Add the [DBpepdia VAD Chapter Docker](https://github.com/dbpedia/dbpedia-vad-i18n) with queries, so chapters such as de.dbpedia.org or el.dbpedia.org can autoupdate on monthly release
* TODO Add the full SPARQL query used to load http://dbpedia.org/sparql 
