# Improve DBpedia 

* TODO just started this page. Many things missing.  
* Please post ideas in the [DBpedia Forum](https://forum.dbpedia.org) and help us migrate ideas and approaches into this wiki. 

## Fix monthly releases
* Patches to the extraction framework will be effective on the next run of [MARVIN Release Bot](http://dev.dbpedia.org/MARVIN_Release_Bot)
* Edit mappings on http://mappings.dbpedia.org, effective for the [Mappings](https://databus.dbpedia.org/dbpedia/mappings) and [Ontology](https://databus.dbpedia.org/dbpedia/ontology) groups
* Edit [Wikidata mappings](https://github.com/dbpedia/extraction-framework/blob/master/core/src/main/resources/wikidatar2r.json), effective for the [Wikidata](https://databus.dbpedia.org/dbpedia/wikidata) group (every artifact with `mapping`)

## Write tests for Minidumps
* any errors found in the big dumps can be tested on minidumps **on-commit**
* [extend the minidump size for specific urls](https://github.com/dbpedia/extraction-framework/tree/master/dump/src/test/bash) 
* [add more tests](https://github.com/dbpedia/extraction-framework/blob/master/dump/src/test/resources/dbpedia-specific-ci-tests.ttl) 
  * these are also used on the EvalMod later, which produces [![Build Status](http://akswnc7.informatik.uni-leipzig.de/eval/repo//dbpedia/mappings/mappingbased-objects/2019.08.30/c6da97f40f67a6fce0f6a254ea122bb9a1d918725e088c1fadc7b0dbae0106c5.svg)](http://akswnc7.informatik.uni-leipzig.de/eval/repo//dbpedia/mappings/mappingbased-objects/2019.08.30/c6da97f40f67a6fce0f6a254ea122bb9a1d918725e088c1fadc7b0dbae0106c5.html) 
* Later we will add [SHACL to on-commit minidump testing](https://github.com/dbpedia/extraction-framework/blob/master/dump/src/test/resources/custom-shacl-tests.ttl). 

## Extend DBpedia with additional datasets
* see [LHD](https://databus.dbpedia.org/propan/lhd/linked-hypernyms/2016.04.01)
* see [DBkWik](https://databus.dbpedia.org/sven-h/dbkwik/dbkwik/2019.09.02)

## Upload external datasets or linksets
* NOTE: we are working on a good process here, but it is easy to `grep 'sameAs'` from selected, vetted artifacts
* see [geonames] (https://databus.dbpedia.org/kurzum/cleaned-data/geonames/2018.03.11)
* these can be loaded into the ID index and Fusion later. 

## DBpedia Strategic Objective: Health and quality of our core data and infrastructure
**Copied from an email to the DBpedia Board, as is**

In most cases, data is currently fixed by consumers, people download data or query the endpoint and then massage the data locally. Mappings.dbpedia.org was a first successful attempt to establish a principle where you could contribute to data quality at the source. There is often still no comparable model in other datasets. Data is either read-only or tedious to edit like copying values manually or ad-hoc with bots, which is a bad reuse pattern compared to linking/mapping and automatic ingestion. Here is a list of steps we have designed in the last two years to elevate the mappings model:

* refactor into monthly extractions, so you get mappings.dbpedia.org effects and any software fixes sooner as incentive
* DBpedians can post additional datasets on the bus like the already existing LHD dataset (https://databus.dbpedia.org/propan/lhd/linked-hypernyms/2016.04.01), DBTax, DBkWIK, DBpedia as Tables etc.
* We built MARVIN a release bot, so there is always a working and running version of the extraction, which people can fork and start developing. We can also deploy some of these community forks on our servers, but it is preferred that they integrate them in the extraction framework or generate and store these extensions on their servers from where we copy them.
* we started to add codeReferences, issuetracker and forum links to the data documentation, see e.g. here https://databus.dbpedia.org/dbpedia/mappings/instance-types/2019.08.01 where some of the docu was taken out of forum answers, which effectively helps us to centralize and improve documentation better.
* together with Dimitris, we implemented IRI tests and SHACL tests on a minidump tested on each git commit of the extraction framework with Travis CI. We already successfully took feedback from the forum and issue tracker and encoded them in tests. We found this much less effort than before and we were better able to fix them. The next release on 7th of September incorporates these improvements already.
* we will extend global.dbpedia.org into a debugging Data Browser, see https://global.dbpedia.org/?s=http://dbpedia.org/resource/DBpedia&p=http://dbpedia.org/ontology/status We can link it from the s and p's of the main endpoint as well as any chapter deployments. I think Harald is currently reviving the Chapter Dockers and we have monthly data for all chapters. There is also a new User Script for Wikipedia. From this comparative data browser, we can link to the exact mapping to fix it.
