---
layout: default
title: About
permalink: /
---

# About
We are currently starting to establish a central documentation wiki for DBpedia.

There are two modes to contribute:
* write something an commit it at <a target="_blank" href="https://github.com/dbpedia/dev.dbpedia.org">https://github.com/dbpedia/dev.dbpedia.org</a>
* update the README.md of your project and include it here, as is done with <a href="WebID">WebID</a> or <a href="Databus%20Maven%20Plugin">Databus Maven Plugin</a>


## General overview of DBpedia (what we plan to include here and what state it is in)

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