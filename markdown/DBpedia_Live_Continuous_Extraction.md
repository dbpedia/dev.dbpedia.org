This documentation is intended for developers who want to understand the structure of DBpedia Live Continuous Extraction as a startingpoint for contributing to the source code. If you want to maintain your own Live Endpoint see the documentation of DBpedia Live Mirror. Installation instructions in this article cover only the installation of the Live Module that extracts triples from recently changed Wikipedia pages.


# Architecture
The DBpedia Live module is intended to provide a continuously (live with a delay period) updated version of DBpedia, as an extension to the regular full dump releases as well as diff files between consecutive dump releases. It tries to bridge the gap between the time of 2 dump releases (usually at least 2 weeks due to Wikimedia Dump release interval) by extracting Wikipedia pages on demand, after they have been modified. Live is also used in order to provide (dump) extraction of abstracts in multiple languages ([DBpedia Chapter languages only](https://wiki.dbpedia.org/join/chapters)), using the [NIF extractors](https://github.com/dbpedia/extraction-framework/blob/master/core/src/main/scala/org/dbpedia/extraction/mappings/AbstractExtractorWikipedia.scala).

The backbone of DBpedia Live is a queue to keep track of the pages that need to be processed and a relational database (called Live Cache) that is used to store extracted triples and decide whether they are supposed to be added, deleted or reinserted. These triples are published as gzipped N-Triples files. The Live Mirror can consume the information contained in these N-Triples files in order to synchronize a Virtuoso Triple Store. By doing so, the extraction and publication of the changed triples on the one hand and synchronization of changed triples to a Triplestore on the other hand are decoupled.

Live uses a mechanism called Feeder in order to determine which pages need to be processed: one Feeder, that receives a stream of recent changes that is provided by Wikimedia; one Feeder that queries pages that are present in the Live Cache but have not been processed in a long time; and so on (see Feeder section). They fill the Live Queue with Items, which are then processed by a configurable set of extractors, which are used in the regular dump extraction (core module of extraction framework).

## Live Queue and Publishing Queue
The Live Queue is a combination of a priority blocking queue and a unique set.
It consists of LiveQueueItems each of which is identified by its name (the wiki page name).
This way, it is guaranteed that each item in the queue is unique (based on its name) and processed according to its priority.
It is also a blocking queue. That means, if necessary, a take() will wait for the queue to become non-empty and a put(e) will wait for the queue to become smaller and offer enough space for e.
All fields and methods of the queue are static.

After the whole extraction and diff process, a DiffData element is produced which is put into a publishing queue (see section Processing).

## Feeder
Feeders provide an interface between a stream that contains updates of Wikipedia pages and DBpedia Live Continuous Extraction. The abstract class Feeder fetches a Collection of LiveQueueItems and eventually puts them into the Live Queue. How the items are collected and kept is up to the implementation of its extending classes.

LiveQueueItems can be created based on either the title of a Wikipedia page or on its page ID.

Currently the EventStreamsFeeder is used in order to fetch information about recent changes of Wikipedia pages. It consumes the Wikimedia EventStreams recentchange stream (see [https://wikitech.wikimedia.org/wiki/EventStreams](https://wikitech.wikimedia.org/wiki/EventStreams)), using Akka Streams. The EventStreams API uses the ServerSentEvent protocol in order to transmit events, which in turn makes use of the chunked transfer encoding of http. The Akka part of this functionality is implemented in the Scala class EventstreamsHelper.

The UnmodifiedFeeder is used in order to update pages that are present in the Live Cache but have not been updated for a certain time interval (called `feeder.unmodified.minDaysAgo` in the `live.ini` configuration file).

## Live Cache: a relational database

The Live Cache is used to produce the diff between different versions of a page. Each row represents a page, which is identified by its page ID. The json contains the triples. They are stored per extractor together with their md5sum hash.

The tablestructure is as follows:

pageID | title | updated |timesUpdated |json |subjects |diff |error
-- | -- | -- | --|--|--|--|--
wikipedia page ID| wikipedia page title | timestamp of when the page was updated | total times the page was updated | latest extraction in JSON format | Distinct subjects extracted from the current page (might be more than one ) | keeps the latest triple diff | if there was an error the last time the page was updated

The SQL statements  and how they are used is defined in DBpediaSQLQueries and JSONCache respectively.


## Extractors
The extractors all live in the core module. There is a separate config file `live.xml` (`live.default.xml`) that specifies the Extractors together with the Wiki Languages they should be used for. This is the only place for language configuration. 


## Processing
Once a LiveQueueItem  is taken out of the Live Queue the extraction process is triggered, and then a diff is produced based on the content of the Live Cache. The logic of this process is implemented in the classes PageProcessor (configurable number of threads, taking an item out of the queue) and LiveExtractionConfigLoader (extracting triples from a page, per configured extractor).

The resulting graph from the extraction is processed in a pipeline of Live Destinations that handles the diff (first stage) as well as the publishing and the update of the Live Cache (final stages).

The first stage of the pipeline receives a set of triples which is the result of a specific extractor applied to a page, and hashes them. It retrieves all triples of the corresponding Cache Item which are stored per extractor together with their hash (this information is contained in the JSON of the Cache Item). The stage produces three triplesets: `added`, `removed` and `unmodified`. If the hashes don't differ, all received triples become `unmodified`. If the hashes differ, the actual filtering of the cache and the received triples takes place, producing the three triplesets accordingly.

The second and final stage of the pipeline updates the Live Cache and transforms the three triplesets `added`, `removed` and `unmodified` to a DiffData Element that is put into a publishing queue after all configured extractors are applied to a page.

A DiffData element consists of a pageID and the four changesets `added`, `removed`, `clear` and `reInserted` which are finally written to files as N-Triples. `Added` and `removed` correspond to the `added` and `removed` triples from the former stage, whereas `clear` consists of the subjects of all the `added`, `removed` and unmodified triples, and `reInserted` comprises both `added` and unmodified triples.

File name | content
-- | --
`added` | extracted triples not contained in the Cache
`removed` | cached triples not present in the extraction
`reInserted` | union of cached and extracted triples, but without `removed`
`clear` | only subjects of all `added`, `removed` and `reInserted` triples

While `added` and `removed` are always produced, the `clear`/`reinsert` sets are only produced if a page was updated a certain number of times (thus the columns timesUpdated in the Cache). 

The files are written if either the number of pages or the number of triples in the publishing queue reaches a threshold, so each file contains triples from multiple pages (see class Publisher).


## Initialization and Synchronization

One central question is how the Live Extraction and the triplestore are initialized and then kept in sync. By its nature, the Live module is designed to track changes, but not to cover the entirety of Wikipedia pages, where a lot of old pages might not be edited for a long time. On the other hand, it is not possible to feed the triplestore with a DBpedia dump, as the diffs are produced in the Live Cache and this would result in invalid triples in the triplestore. 

The Live Cache is playing the key role to solve this issue. The initialization process consist of feeding all pageIds to the Live Cache, so there exists a row for every page, where the timestamp of the field "updated" is set to an artificial date in the past, and all other fields are empty. Then, the UnmodifiedFeeder is started at the same time as any other feeder, eventually visiting every row that has not been updated for a certain time interval (that must be smaller than the interval between the initial timestamp of the pageIDs and now), and putting its pageId into the queue in order to get processed. That way, the "bootstrapping" of live is happening within the module and the Live Mirror can consume the output of the Live Extraction without having to deal with the initialization.

## Available instances
There are currently three instances of DBpedia Live that publish N-triple files: 

+ https://95.217.42.166/changesets
First instance, containing all available diffs since 2013
In Sync with the Openlink Virtuoso Triplestore 
+ https://95.217.42.166/changesets-fresh-init
Second instance, initialized in 2019.
Intended for users who want to maintain their own, new triplestore.
+ https://95.217.42.166/changesets-abstracts
Instance that provides only short and long abstracts in all Chapter Languages.


# Sources and Further Reading
S. Hellmann, C. Stadler, J.Lehmann, and S. Auer: [DBpedia Live Extraction](http://svn.aksw.org/papers/2009/ODBASE_LiveExtraction/dbpedia_live_extraction_public.pdf)
In: Meersman, R., Dillon, T. and Herrero, P. (eds.) On the Move to Meaningful Internet Systems: OTM 2009, pp. 1209-1223.
Springer, Berlin/Heidelberg (2009).


C. Stadler, M. Martin, J. Lehmann, and S. Hellmann: [Update Strategies for DBpedia Live.](https://pdfs.semanticscholar.org/10a2/4110b217fc70c08d3a70f40a589475171328.pdf)
In: Proceedings of the Sixth Workshop on Scripting and Development for the Semantic Web, Crete, Greece, May 31, 2010.


M. Morsey, J. Lehmann, S. Auer, C. Stadler and S. Hellmann: [DBpedia and the Live Extraction of Structured Data from Wikipedia](https://pdfs.semanticscholar.org/593f/1b2f4ff837378fe48ffa39c101895049391d.pdf). In: Program: electronic library and information systems (2012). pp.157-181. DOI: 10.1108/00330331211221828. 

L. Faber, S. Haarmann, S. Serth: [Serving Live Multimedia for the Linked Open Data Cloud. Making DBpedia Live Again](https://dl.gi.de/handle/20.500.12116/4028). In: Maximilian Eibl, Martin Gaedke. (eds.) Lecture Notes in Informatics (LNI), Gesellschaft für Informatik, Bonn (2017). 


# Installation and Configuration
Prerequisites:
```
maven
java 8 
```
  * Clone the Extraction Framework.
  * Copy the default .ini file and the default .xml file and adapt the new files to your setting.
```
$ cp /extraction-framework/live/live.default.ini extraction-framework/live/live.ini

$ cp /extraction-framework/live/live.default.xml extraction-framework/live/live.xml
```


The live.xml file lets you configure which extractors and which Wiki Languages, per extractor, you want to use. The name of this file must also be given in the `live.ini` file in order to provide more flexibility during the development process.

The `live.ini` file lets you configure many things, for example the working directory, the output resp. publish directory, the number of threads and the selection of namespaces, language and also which feeders will be active.

These parameters must be adapted:
```
working_directory
publishDiffRepoPath
languageExtractorConfig
cache.xxxx (see also next paragraph)
```
These parameters are configurable to your needs:
```
ProcessingThreads
feeder.xxx.xxxx (currently only unmodified and eventstreams relevant)
```

  * Prepare the Live Cache

Create a mysql database. The name is up to you. User, password and name of the database have to be configured accordingly in the live.ini file.
```
cache.dsn   = jdbc:mysql://localhost/<name_of_database>?autoReconnect=true&useUnicode=yes
cache.user  = <name_of_user>
cache.pw    = <password>
```

Create the table DBPEDIALIVE_CACHE as in /extraction-framework/live/src/main/SQL/dbstructure.sql. 
```
$ cd /extraction-framework/live/src/main/SQL/
$ mysql -u root -p your_database_name < dbstructure.sql
```

In order to initialize the Live Cache with a current dump of pageIDs (see section Initialization and Synchronization), get the latest dump file of the pageIds, in .nt, .ttl, .nq or .tql format (or suffixes of compressed files like .ttl.gz or .nt.bz2), containing either IRIs or URIs (like [this](http://downloads.dbpedia.org/2016-10/core-i18n/en/page_ids_en.ttl.bz2), for example). 

You need a folderstructure and naming convention like this (applies both for single and multilanguage usage):
```
yourindexfolder
├── arwiki
│ └── 20180101
│     └── arwiki-20180101-page-ids.ttl.bz2
├── cawiki
│ └── 20180101
│     └── cawiki-20180101-page-ids.ttl.bz2
├── cswiki
│ └── 20180101
│     └── cswiki-20180101-page-ids.ttl.bz2
├── dewiki
│ └── 20180101
│     └── dewiki-20180101-page-ids.ttl.bz2
├── enwiki
│ └── 20180101
│     └── enwiki-20180101-page-ids.ttl.bz2
		
```
 
Then run [this script](https://github.com/dbpedia/extraction-framework/blob/master/scripts/src/main/scala/org/dbpedia/extraction/scripts/UnmodifiedFeederCacheGenerator.scala). 
 
Example run: 

```
$ cd extraction-framework/scripts
$ ../run UnmodifiedFeederCacheGenerator /path/to/yourindexfolder  .ttl.bz2 2018-01-01 ar ca cs de en
```

After successfully running the UnmodifiedFeederCacheGenerator you have files named something like `<lang>-cache_generate.sql` that consist of lines like this: 

```
INSERT INTO DBPEDIALIVE_CACHE(wikiLanguage, pageID, title, updated) VALUES("en", 15346757, 'Battery_watch', '2018-01-01') ; 
```

Feed this file to your database.
```
$ mysql -u root -p your_database_name < en-cache_generate.sql
```

  * run the install-run script (after the first successful run you can use only "run" instead of "install-run"):
  ```
$ cd /extraction-framework/live/
$   ../instal-run live
  ```
Control the published files in your publishDiffRepoPath.

Read the logs at `/extraction-framework/live/log/main.log*`
