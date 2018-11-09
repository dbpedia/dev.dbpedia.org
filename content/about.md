---
layout: default
title: About
permalink: /
---

# About

## Status of this collection
We are currently working on a major renovation of DBpedia, which includes:
* for developers: being better documented and have clear processes for contribution (this collection)
* for industry: upgrading the free and open resources to be more reliable and offer reliable services and also models to make money with DBpedia
* for researchers: better infrastructure to share and build resources together

These are all big goals and they take time, however we aim to have *this collection of documentation in a decent state by end of Dec 2018*. 


## Purpose of the DBpedia Development Wiki

DBpedia is the construct of hundreds of very skilled knowledge engineers that work in different areas. DBpedia was established in 2006 and back then we were a very small group that could communicate easily. 
Now there are hundreds of extensions of the DBpedia infrastructure and a lot more developers and communication has become very fragmented. 
In order to alleviate this problem, this wiki was created. 

 


## Contributing to this Wiki

There are two modes to contribute:
* write something an commit it at <a target="_blank" href="https://github.com/dbpedia/dev.dbpedia.org">https://github.com/dbpedia/dev.dbpedia.org</a>
* update the README.md of your project and include it here, as is done with <a href="WebID">WebID</a> or <a href="Databus%20Maven%20Plugin">Databus Maven Plugin</a>


## (Outdated) General overview of DBpedia (what we plan to include here and what state it is in)

* DBpedia Core (Data extraction and releases)
    * Wikidata (working, biweekly, documentation missing)
    * Generic (working monthly, documentation missing)
    * Mappings (start ~ mid September)
    * Text (Abstracts + NIF fulltext), work in progress, unclear timeline
    * Commons (work in progress)
    * References (work in progress)
    * ID Management (working, but not documented)
    * Fusion (working, but not documented)
* Main Service
    * HTML, Linked Data and SPARQL is stable (provided by OpenLink)
* Databus Release Framework
    * Databus Maven Plugin
    * Used to do the releases http://downloads.dbpedia.org/repo/lts/
    * currently enough metadata to produce RSS
    * DCAT and DCAT-AP planned
* Spotlight
    * hosting working for English and German
    * other languages work in progress
    * no documentation here
* WebID
    * consolidated tutorial and generators
* DBpedia Services
    * DBpedia Lookup (working, but not automated deployment, no documentation)
    * DBpedia IRI Resolution service (working, automated deployment, documentation in progress)
* DBpedia Live
    * broken, because of Wikimedia API change (being repaired)
    * payment required for the new version unless a volunteer takes over hosting and maintenance
