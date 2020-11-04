# DBpedia Spotlight Server Deployment

This document explains how to set up the [demo web page](demo.dbpedia-spotlight.org) and how to set up the language models API. The following is a list of the most general elements to run Docker.

- **Server**: wifo5-24.informatik.uni-mannheim.de (134.155.95.24). 
- **Main folder location**: /root/spotlight-multilingual, containing the following files:
- **Docker version**: Docker version 19.03.12, build 48a66213fe
- **Docker-compose version**: docker-compose version 1.26.2, build eefe0d31

The main folder contains the `spotlight-compose.yml` file and the `sites.xml` file. The `spotlight-compose.yml` contains the configuration to run the language models API and the demo web page. The `sites.xml` contains the configuration for each language such as the URL to access the API, e.g., https://api.dbpedia-spotlight.org/de for access to the German DBpedia-Spotlight.

Each language model is defined as follows:

```
spotlight.[LANG]:
	image: dbpedia/dbpedia-spotlight
	countainer_name: dbpedia-spotligh.[LANG]
	volumes:
		- spotlight-models:/opt/spotlight/models
	restart: unless-stop
	ports:
		- “0.0.0.0:2223-2250:80”
	networks:
		- spotlight-net
	command: /bin/spotlight.sh [LANG]
```

where `[LANG]` is replaced by the corresponding language model. The demo web page follows a similar configuration:

```
web:
	image: dbpedia/dbpedia-spotlight-html-view
	container_name: spotlight-demo
	ports:
		- “0.0.0.0:9271:80”
	volumes:
		- ./sites.xml:/var/www/html/config/sites.xml
	networks:
		- spotlight-net
```

The `sites.xml` file is passed to the docker container through the volumes statement. The networks statement defines all containers as part of the same network. With this configuration, all container is able to communicate with each other.


## Run the docker-compose file

`docker-compose -f spotlight-compose.yml up -d`

**If the server is restarted, it is just needed to run again the same command** (all language models was stored in the spotlight-models docker volume).

## Kill the docker-compose file

`docker-compose -f spotlight-compose.yml kill`
