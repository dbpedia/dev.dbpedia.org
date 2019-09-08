# Setup a DBpedia SPARQL endpoint on your server 

* Please post new Dockers in the [DBpedia Forum](https://forum.dbpedia.org)
* TODO add a running example, e.g. loading the DBpedia ontology into Virtuoso
* TODO Setup Docker Hub to collect more applications and describe the process of adding dockers
* TODO Add the [DBpepdia VAD Chapter Docker](https://github.com/dbpedia/dbpedia-vad-i18n) with queries, so chapters such as de.dbpedia.org or el.dbpedia.org can autoupdate on monthly release
* TODO Add the full SPARQL query used to load http://dbpedia.org/sparql 

## Minimal example: 
Loading the DBpedia Ontology into Virtuoso Docker

**TODO this is an old description without query and Databus Client**
1. Download the [Dockerfile](https://github.com/dbpedia/dev.dbpedia.org/raw/master/pics/Dockerfile.dockerfile)
2. Build `docker build -t databus-dump-triplestore .`
3. Load any Databus `?file` query:
```
docker run -p 8890:8890 databus-dump-triplestore $(cat file-with-query.sparql)
```
