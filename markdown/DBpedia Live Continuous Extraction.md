DBpedia Live Services are currently under maintenance due to changes of the Wikimedia Recent Changes API and general reconsideration of the architecture.

This documentation is intended for developers who want to understand the structure of Live as a startingpoint for contributing to the source code. If you want to maintain your own Live Endpoint see the documentation of DBpedia Live Mirror (in progress). Installation instructions in this article cover only the installation of the Live Module that extracts triples from recently changed Wikipedia pages.


# Architecture
The DBpedia Live module is intended to provide a continuously updated version of DBpedia. The not-live version of DBpedia has mainly two disadvantages the live version tries to solve: first, it relies on an extraction process that requires manual intervention and second, it starts from a static dump of the Wikipedia at a certain point in time and thus does not contain any changes that were applied to the Wikipedia between the creation of the Wikipedia dump and the new DBpedia Release.

The backbone of DBpedia Live is a queue to keep track of the pages that need to be processed and a relational database (called Live Cache) that is used to store extracted triples and decide whether they are supposed to be added, deleted or reinserted. These triples are published as gzipped n-Triple-files. Over time, it evolved a different mechanism called Live Mirror to extract the information contained in these n-Triple-files to a Virtuoso Triple Store: extracting and publishing text-files on the one hand and storing triples to a Triplestore on the other hand are now decoupled.

Live uses a mechanism called Feeder in order to determine which pages need to be processed: one Feeder, that receives a stream of recent changes that is provided by Wikimedia; one Feeder that queries pages that are present in the Live Cache but have not been processed in a long time; and so on (see Feeder). They fill the Live Queue with Items, which are then processed by a configurable set of extractors, not different from the extractors used in the core module.

## Queue
The queue is a combination of a priority blocking queue and a unique set.
It consists of LiveQueueItems each of which is identified by its name (the wiki page name).
This way, it is guaranteed that each item in the queue is unique (based on its name) and processed according to its priority.
It is also a blocking queue. That means, if necessary, a take() will wait for the queue to become non-empty and a put(e) will wait for the queue to become smaller and offer enough space for e.
The current implementation is not fully threadsafe and leaves room for parallelization.

## Feeder
in progress
## Processing
The logic of what is happening with a LiveQueueItem once it is taken out of the queue is implemented in the classes LiveExtractionConfigLoader and PageProcessor.
### Live Cache: a relational database
The tablestructure is as follows:

pageID | title | updated |timesUpdated |json |subjects |diff |error
-- | -- | -- | --|--|--|--|--
wikipedia page ID| wikipedia page title | timestamp of when the page was updated | total times the page was updated | latest extraction in JSON format | Distinct subjects extracted from the current page (might be more than one ) | keeps the latest triple diff | if there was an error the last time the page was updated

The SQL statements  and how they are used is defined in DBpediaSQLQueries and JSONCache respectively.

in progress

### Extractors
The extractors all live in the core module. Which extractors will be used is configured in the ./live.xml file.

## Output and Live Mirror
in progress
# A Brief History of Live
in progress
# Issues
in progress
# Sources and Further Reading
in progress
# Installation and Configuration
Prerequisites:
```
maven
java 8 or higher
```
  * Clone the Extraction Framework.
  * Copy the default .ini file and the default .xml file and adapt the new files to your setting.
```
cp /extraction-framework/live/live.default.ini extraction-framework/live/live.ini

cp /extraction-framework/live/live.default.xml extraction-framework/live/live.xml
```
Currently you have to create a file pw.txt:
```
> /extraction-framework/live/pw.txt
```

The live.xml file lets you configure which extractors you want to use. Adaptation should not be necessary in most cases.

The live.ini file lets you configure many things, for example the working directory, the output resp. publish directory, the number of threads and the selection of namespaces, language and also which feeders will be active.

  * Prepare the Live Cache

Create a mysql database. The name is up to you. User, password and name of the database have to be configured accordingly in the live.ini file.
```
cache.dsn   = jdbc:mysql://localhost/<name_of_database>?autoReconnect=true&useUnicode=yes
cache.user  = <name_of_user>
cache.pw    = <password>
```

Create the table DBPEDIALIVE_CACHE as in /extraction-framework/live/src/main/SQL/dbstructure.sql. 


  * run the install-run script
  ```
  cd /extraction-framework/live/
  ../instal-run live
  ```
Control the published files in your publishDiffRepoPath.

Read the logs at /extraction-framework/live/log/main.log*
