DBpedia Live Services are currently under maintenance due to changes of the Wikimedia Recent Changes API and general reconsideration of the architecture.

This documentation is intended for developers who want to understand the structure of DBpedia Live Continuous Extraction as a startingpoint for contributing to the source code. If you want to maintain your own Live Endpoint see the documentation of DBpedia Live Mirror. Installation instructions in this article cover only the installation of the Live Module that extracts triples from recently changed Wikipedia pages.


# Architecture
The DBpedia Live module is intended to provide a continuously (live with a delay period) updated version of DBpedia, as an extension to the regular full dump releases as well as diff files between consecutive dump releases. It tries to bridge the gap between the time of 2 dump releases (usually at least 2 weeks due to Wikimedia Dump release interval) by extracting Wikipedia pages on demand, after they have been modified.

The backbone of DBpedia Live is a queue to keep track of the pages that need to be processed and a relational database (called Live Cache) that is used to store extracted triples and decide whether they are supposed to be added, deleted or reinserted. These triples are published as gzipped N-Triples files. The Live Mirror can consume the information contained in these N-Triples files in order to synchronize a Virtuoso Triple Store. By doing so, the extraction and publication of the changed triples on the one hand and synchronization of changed triples to a Triplestore on the other hand are decoupled.

Live uses a mechanism called Feeder in order to determine which pages need to be processed: one Feeder, that receives a stream of recent changes that is provided by Wikimedia; one Feeder that queries pages that are present in the Live Cache but have not been processed in a long time; and so on (see Feeder section). They fill the Live Queue with Items, which are then processed by a configurable set of extractors, which are used in the in the regular dump extraction (core module of extraction framework).

## LiveQueue
The Live Queue is a combination of a priority blocking queue and a unique set.
It consists of LiveQueueItems each of which is identified by its name (the wiki page name).
This way, it is guaranteed that each item in the queue is unique (based on its name) and processed according to its priority.
It is also a blocking queue. That means, if necessary, a take() will wait for the queue to become non-empty and a put(e) will wait for the queue to become smaller and offer enough space for e.
All fields and methods of the queue are static.

## Feeder
Feeders provide an interface between a stream that contains updates of Wikipedia pages and DBpedia Live Continuous Extraction. The abstract class Feeder fetches a Collection of LiveQueueItems and eventually puts them into the Live Queue. How the items are collected and kept is up to the implementation of its extending classes. 

Currently the EventStreamsFeeder is the only Feeder in use. It consumes the Wikimedia EventStreams recentchange stream (see [https://wikitech.wikimedia.org/wiki/EventStreams](https://wikitech.wikimedia.org/wiki/EventStreams)), using Akka Streams. The EventStreams API uses the ServerSentEvent protocol in order to transmit events, which in turn makes use of the chunked transfer encoding of http. The Akka part of this functionality is implemented in the Scala class EventstreamsHelper.

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

## Initialization and Synchronization

One central question is how the Live Extraction and the triplestore are initialized and then kept in sync. By its nature, the Live module is designed to track changes, but not to cover the entirety of Wikipedia pages, where a lot of old pages might not be edited for a long time. On the other hand, it is not possible to feed the triplestore with a DBpedia dump, as the diffs are produced in the Live Cache and this would result in invalid triples in the triplestore. 

The Live Cache is playing the key role to solve this issue. The initialization process consist of feeding all pageIds to the Live Cache, so there exists a row for every page, where the timestamp of the field "updated" is set to an artificial date in the past, and all other fields are empty. Then, the UnmodifiedFeeder is started at the same time as any other feeder, eventually visiting every row that has not been updated for a certain time interval (that should be picked in a reasonable relation to the one used when initializing the rows of the cache), and putting its pageId into the queue in order to get processed. That way, the "bootstrapping" of live is happening within the module and the Live Mirror can consume the output of the Live Extraction without having to deal with the initialization.



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

In order to initialize the Live Cache with a current dump of pageIDs (see section Initialization and Synchronization), get the latest dump file of the pageIds, in .nt, .ttl, .nq or .tql format (or suffixes of compressed files like .ttl.gz or .nt.bz2), using either IRIs or URIs (like [this](http://downloads.dbpedia.org/2016-10/core-i18n/en/page_ids_en.ttl.bz2), for example). 
 
Then run [this script](https://github.com/dbpedia/extraction-framework/blob/master/scripts/src/main/scala/org/dbpedia/extraction/scripts/UnmodifiedFeederCacheGenerator.scala). 
 
Example run: 

```
cd extraction-framework/scripts
../run UnmodifiedFeederCacheGenerator /data/dbpedia .nt.gz 2013-02-01 en
```


  * run the install-run script
  ```
  cd /extraction-framework/live/
  ../instal-run live
  ```
Control the published files in your publishDiffRepoPath.

Read the logs at /extraction-framework/live/log/main.log*
