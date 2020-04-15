# Improve DBpedia 

# Improve DBpedia 

There are many ways to contribute and help improve DBpedia. Below you can find general ideas for contribution. In addition, feel free to post and ideas for improvement of DBpedia in the [DBpedia Forum](https://forum.dbpedia.org) and help us migrate ideas and approaches into this wiki.

## Fix monthly releases

You can improve the monthly releases in several ways:

* Providing patches to the extraction framework. The changes will be effective on the next run of [MARVIN Release Bot](http://dev.dbpedia.org/MARVIN_Release_Bot). Feel free to make a pull request!
* Improve the mappings at [http://mappings.dbpedia.org](http://mappings.dbpedia.org). Any change made on the mappings will be reflected in the data behind [Mappings](https://databus.dbpedia.org/dbpedia/mappings) and [Ontology](https://databus.dbpedia.org/dbpedia/ontology) data groups.
* Improve [Wikidata mappings](https://github.com/dbpedia/extraction-framework/blob/master/core/src/main/resources/wikidatar2r.json). This improvements will be reflected on the [Wikidata](https://databus.dbpedia.org/dbpedia/wikidata) data group (every artifact with `mapping`)
* Improve the configuration for your language

> TODO: add page which explains how to configure/improve a language

## Write tests for Minidumps

*Minidumps* are small Wikipedia XML dumps which are used to test the extraction framework.
Any errors found in the big dumps can be tested on minidumps **on-commit**.
Defined tests are executed to test the extraction against the minidumps.

Here are several options on how you can improve the testing:

* Extend the minidump size with [language specific URLs](https://github.com/dbpedia/extraction-framework/blob/master/dump/src/test/bash/uris.lst).
* Create more [SHACL tests](https://github.com/dbpedia/extraction-framework/blob/master/dump/src/test/resources/custom-shacl-tests.ttl) for on-commit minidump testing. 
* Create more [DBpedia Specific tests](https://github.com/dbpedia/extraction-framework/blob/master/dump/src/test/resources/dbpedia-specific-ci-tests.ttl). These test are also used in the EvalMod later, which generates [test reports](http://akswnc7.informatik.uni-leipzig.de/eval/repo//dbpedia/mappings/mappingbased-objects/2019.08.30/c6da97f40f67a6fce0f6a254ea122bb9a1d918725e088c1fadc7b0dbae0106c5.html). [![Build Status](http://akswnc7.informatik.uni-leipzig.de/eval/repo//dbpedia/mappings/mappingbased-objects/2019.08.30/c6da97f40f67a6fce0f6a254ea122bb9a1d918725e088c1fadc7b0dbae0106c5.svg)](http://akswnc7.informatik.uni-leipzig.de/eval/repo//dbpedia/mappings/mappingbased-objects/2019.08.30/c6da97f40f67a6fce0f6a254ea122bb9a1d918725e088c1fadc7b0dbae0106c5.html) 

Learn more on how [Testing on Minidumps](http://dev.dbpedia.org/Testing_on_Minidumps) works or how to [Integrate custom SHACL tests](http://dev.dbpedia.org/Integrating_SHACL_Tests).

## Contribute additional datasets

We are open for data contributions from the community.
Feel free to contribute and publish your data on the DBpedia Databus using the [Databus Maven Plugin](http://dev.dbpedia.org/Databus_Upload_Client).

Many datasets have been already contributed by the community. Here are few examples:
* [Linked Hypernyms Dataset](https://databus.dbpedia.org/propan/lhd/linked-hypernyms/2016.04.01)
* [DBkWik](https://databus.dbpedia.org/sven-h/dbkwik/dbkwik/2019.09.02) dataset 

> TODO: add more datasets to the list

## Upload external datasets or linksets
* NOTE: we are working on a good process here, but it is easy to `grep 'sameAs'` from selected, vetted artifacts
* see [geonames](https://databus.dbpedia.org/kurzum/cleaned-data/geonames/2018.03.11)
* these can be loaded into the ID index and Fusion later. 

## DBpedia Strategic Objective: Health and quality of our core data and infrastructure

> TODO: this section does not fit here, consider moving somewhere else or ...

**Copied from an email to the DBpedia Board, as is**

In most cases, data is currently fixed by consumers, people download data or query the endpoint and then massage the data locally. Mappings.dbpedia.org was a first successful attempt to establish a principle where you could contribute to data quality at the source. There is often still no comparable model in other datasets. Data is either read-only or tedious to edit like copying values manually or ad-hoc with bots, which is a bad reuse pattern compared to linking/mapping and automatic ingestion. Here is a list of steps we have designed in the last two years to elevate the mappings model:

* refactor into monthly extractions, so you get mappings.dbpedia.org effects and any software fixes sooner as incentive
* DBpedians can post additional datasets on the bus like the already existing LHD dataset (https://databus.dbpedia.org/propan/lhd/linked-hypernyms/2016.04.01), DBTax, DBkWIK, DBpedia as Tables etc.
* We built MARVIN a release bot, so there is always a working and running version of the extraction, which people can fork and start developing. We can also deploy some of these community forks on our servers, but it is preferred that they integrate them in the extraction framework or generate and store these extensions on their servers from where we copy them.
* we started to add codeReferences, issuetracker and forum links to the data documentation, see e.g. here https://databus.dbpedia.org/dbpedia/mappings/instance-types/2019.08.01 where some of the docu was taken out of forum answers, which effectively helps us to centralize and improve documentation better.
* together with Dimitris, we implemented IRI tests and SHACL tests on a minidump tested on each git commit of the extraction framework with Travis CI. We already successfully took feedback from the forum and issue tracker and encoded them in tests. We found this much less effort than before and we were better able to fix them. The next release on 7th of September incorporates these improvements already.
* we will extend global.dbpedia.org into a debugging Data Browser, see https://global.dbpedia.org/?s=http://dbpedia.org/resource/DBpedia&p=http://dbpedia.org/ontology/status We can link it from the s and p's of the main endpoint as well as any chapter deployments. I think Harald is currently reviving the Chapter Dockers and we have monthly data for all chapters. There is also a new User Script for Wikipedia. From this comparative data browser, we can link to the exact mapping to fix it.
