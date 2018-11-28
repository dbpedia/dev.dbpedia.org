# Architecture
The DBpedia Live module is intended to provide a continuously updated version of DBpedia. The not-live version of DBpedia has mainly two disadvantages the live version tries to solve: first, it relies on an extraction process that requires manual intervention and second, it starts from a static dump of the Wikipedia at a certain point in time and thus does not contain any changes that were applied to the Wikipedia between the creation of the Wikipedia dump and the new DBpedia Release.

The backbone of DBpedia Live is a queue to keep track of the pages that need to be processed and a relational database (called Live Cache) that is used to store extracted triples and decide whether they are supposed to be added, deleted or reinserted. These triples are published as gzipped n-Triple-files. Over time, it evolved a different mechanism called Live Mirror to extract the information contained in these n-Triple-files to a Virtuoso Triple Store: extracting and publishing text-files on the one hand and storing triples to a Triplestore on the other hand are now decoupled.

Live uses a mechanism called Feeder in order to determine which pages need to be processed: one Feeder, that receives a stream of recent changes that is provided by Wikimedia; one Feeder that queries pages that are present in the Live Cache but havent been processed in a long time; and so on (see Feeder). They fill the Live Queue with Items, which are then processed by a configurable set of extractors, not different from the extractors used in the core module.

## Queue
The queue is a combination of a priority blocking queue and a unique set.
It consists of LiveQueueItems each of which is identified by its name (the wiki page name).
This way, it is guaranteed that each item in the queue is unique (based on its name) and processed according to its priority.
It is also a blocking queue. That means, if necessary, a take() will wait for the queue to become non-empty and a put(e) will wait for the queue to become smaller and offer enough space for e.
The current implementation is not fully threadsafe and leaves room for parallelization.

## Feeder


## Processing

### Live Cache: a relational database
The tablestructure is as follows:

pageID | title | updated |timesUpdated |json |subjects |diff |error
-- | -- | -- | --|--|--|--|--
wikipedia page ID| wikipedia page title | timestamp of when the page was updated | total times the page was updated | latest extraction in JSON format | Distinct subjects extracted from the current page (might be more than one ) | keeps the latest triple diff | if there was an error the last time the page was updated

The SQL statements  and how they are used is defined in DBpediaSQLQueries and JSONCache respectively.


### Extractors
The extractors all live in the core module. Which extractors will be used is configured in the ./live.xml file.

## Output and Live Mirror

# Issues
# Sources and Read More
# Installation and Configuration


