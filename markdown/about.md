---
layout: default
title: About
permalink: /
---

# About

We are currently working on a major renovation of DBpedia, which includes:
* for developers: being better documented and have clear processes for contribution (this collection)
* for industry: upgrading the free and open resources to be more reliable and offer reliable services and also models to make money with DBpedia
* for researchers: better infrastructure to share and build resources together

These are all big goals and they take time, however we aim to have **this collection of documentation in a decent state by end of Dec 2018**.


## Purpose of the DBpedia Development Wiki

DBpedia is the construct of hundreds of very skilled knowledge engineers that work in different areas. DBpedia was established in 2006 and back then we were a very small group that could communicate easily.
Now there are hundreds of extensions of the DBpedia data and infrastructure and a lot more developers.
Communication has become very fragmented and in order to alleviate this problem the wiki was created.
1. The purpose is therefore to collect all technical relevant information to use the data, tools and services of DBpedia and serve as a user and development guide.
2. The Wiki should be used to simplify community contributions to the core assets of DBpedia, such as the extraction framework, the releases, DBpedia Spotlight, Lookup by explaining the contribution processes.

## Professional Data and Services of Companies
**DBpedia is used by thousands of companies** and we hope that you find something in this collection of free and open source data and software documentation.
We accept some links and notes about commercial services in this wiki, if they follow an open and symbiotic model, i.e. you can prove that you directly contribute or have a strong incentive to contribute to the resource your service is linked from. The DBpedia Association is non-profit, which means that any income needs to be reinvested into the DBpedia asset, so the criteria is met.
Starting 2019, DBpedia will offer a lot of venues to showcase products and market software. Please mailto:dbpedia@infai.org if you would like to have greater visibility for your data, tool or service.

## Research projects in the Development Wiki
**DBpedia is mentioned in over 35,000 scientific papers**.
While we value any research that is derived from DBpedia, we would like to make a clear distinction between research and the actual implementation and deployment of useful and reliable software and services.
This wiki is not the place to present your latest research prototype. Anything included here should have a clear governance and maintainence structure, which is normally not given after the end of any research paper or project.


{% raw %}
<iframe frameborder="no" border="0" marginwidth="0" marginheight="0" width="800" height="520" src="https://databus.dbpedia.org/yasgui/yas-embedded_0.1.html?query=PREFIX+xsd%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2001%2FXMLSchema%23%3E%0APREFIX+dcterms%3A+%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Fterms%2F%3E%0APREFIX+rdf%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3E%0APREFIX+rdfs%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0APREFIX+dataid%3A+%3Chttp%3A%2F%2Fdataid.dbpedia.org%2Fns%2Fcore%23%3E%0APREFIX+dcat%3A+%3Chttp%3A%2F%2Fwww.w3.org%2Fns%2Fdcat%23%3E%0A%0ASELECT+%3Fym+SUM(%3Fsize)+as+%3Ffilesize+COUNT(%3Ffile)+as+%3Ffiles+WHERE+%7B%0A++%3Ffile+a+dataid%3ASingleFile+.%0A++%3Ffile+dcat%3AbyteSize+%3Fsize+.%0A++%3Ffile+dcterms%3Aissued+%3Fdate+.%0ABIND+(substr(xsd%3AString(%3Fdate)%2C+1%2C+7)+AS+%3Fym)%0A%7D+%0AGROUP+BY+%3Fym%0AORDER+BY+%3Fym%0A&contentTypeConstruct=text%2Fturtle&contentTypeSelect=application%2Fsparql-results%2Bjson&endpoint=https%3A%2F%2Fdatabus.dbpedia.org%2Frepo%2Fsparql&requestMethod=POST&tabTitle=Query+1&headers=%7B%7D&outputFormat=table"></iframe>
{% endraw %}

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
