---
layout: page
title: "Global ID Lookup Service"
permalink: "Global ID Lookup Service"
---

# DBpedia Same Thing Service
Microservice that looks up global and local URIs for DBpedia resources and Wikidata entities

Provide the DBpedia Same Thing Service with a Wikidata entity or DBpedia resource URI, and it will return the DBpedia global URI and all known local URIs that refer to the same thing.

## Running from an existing image
- Install [Docker Compose](https://docs.docker.com/compose/install/)
- Download compose file: `wget https://raw.githubusercontent.com/aolieman/dbp-same-thing-service/master/docker-compose.yml`
- Run: `docker-compose -f docker-compose.yml up`

This will download the latest image and runs two containers: the `loader` and the webserver (`http`). The loader downloads the latest data set from `downloads.dbpedia.org`, and proceeds to load any source files that haven't been loaded yet into the database. This might take a while to complete. After all data is loaded, a backup is made and the loader stops running. On subsequent boots, the loader will check if there is new data, remove old downloads, and load the new triples into a fresh DB.

The webserver waits for the database to initialize. On the first run, it will have to wait until all source files have been downloaded, and will start listening for requests once the (empty) database has been created. While files are being loaded, the service will respond to requests, but will return `404` for any URI that hasn't been loaded yet. The port on which it listens is configurable in the compose file.

If a new data set is available when these containers are booted, the loader will start processing it immediately. The webserver however, will not wait for the new data to be loaded. It will keep serving requests from the existing database, and will not switch to the newer data while it is running. The next time it is booted it will start using the most recent database. The older database will stay in the `dbdata` volume until it is manually removed.

## Usage
`curl "http://localhost:8087/lookup/?uri=http://www.wikidata.org/entity/Q8087"`
```
{
  "global": "http://id.dbpedia.org/global/4y9Et",
  "locals": [
    "http://dbpedia.org/resource/Geometry",
    "http://de.dbpedia.org/resource/Geometrie",
    "http://fr.dbpedia.org/resource/Géométrie",
    "http://nl.dbpedia.org/resource/Meetkunde",
    "http://sv.dbpedia.org/resource/Geometri",
    "http://www.wikidata.org/entity/Q8087"
  ]
}
```
Percent-encoding of the `uri` parameter is optional. If this example does not work when running the service locally, check if the right port is specified in `docker-compose.yml`.

## Development setup
- Clone this repository
- `docker-compose -f docker-compose.dev.yml up`
- any changes to the webapp code will trigger a live reload

We use [pipenv](https://docs.pipenv.org/) for package management. Set up a local python environment by running `pipenv install` from the project root. Introduce new dependencies with `pipenv install <package_name>` and ensure that the latest `Pipfile.lock` (generated with `pipenv lock`) is included in the same commit as an updated `Pipfile`.

After making any changes other than to python source files, rebuild the image with `docker-compose -f docker-compose.dev.yml build`. The compose file automatically builds the image if none exists, but will not rebuild after changes when using `docker-compose up`.
