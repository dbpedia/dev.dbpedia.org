---
layout: default
title: About
permalink: /
---

# About

We are currently working on a major renovation of DBpedia, which includes:
* for developers: being better documented and have clear processes for contribution (this bible)
* for industry: upgrading the free and open resources to be more reliable and offer reliable services and also models to make money with DBpedia
* for researchers: better infrastructure to share and build resources together

These are all big goals and they take time and the documentation here will **probably always be outdated, but the best place to go to anyhow**. 


## Purpose of the DBpedia Development Wiki

DBpedia is the construct of hundreds of very skilled knowledge engineers that work in different areas. DBpedia was established in 2006 and back then we were a very small group that could communicate easily.
Now there are hundreds of extensions of the DBpedia data and infrastructure and a lot more developers.
Communication has become very fragmented and in order to alleviate this problem the wiki was created.
1. The purpose is therefore to collect all technical relevant information to use the data, tools and services of DBpedia and serve as a user and development guide.
2. The Wiki should be used to simplify community contributions to the core assets of DBpedia, such as the extraction framework, the releases, DBpedia Spotlight, Lookup by explaining the contribution processes.


{% raw %}
<iframe frameborder="no" border="0" marginwidth="0" marginheight="0" width="800" height="520" src="https://databus.dbpedia.org/yasgui/yas-embedded_0.1.html?query=PREFIX+xsd%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2001%2FXMLSchema%23%3E%0APREFIX+dcterms%3A+%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Fterms%2F%3E%0APREFIX+rdf%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3E%0APREFIX+rdfs%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0APREFIX+dataid%3A+%3Chttp%3A%2F%2Fdataid.dbpedia.org%2Fns%2Fcore%23%3E%0APREFIX+dcat%3A+%3Chttp%3A%2F%2Fwww.w3.org%2Fns%2Fdcat%23%3E%0A%0ASELECT+%3Fym+SUM(%3Fsize)+as+%3Ffilesize+COUNT(%3Ffile)+as+%3Ffiles+WHERE+%7B%0A++%3Ffile+a+dataid%3ASingleFile+.%0A++%3Ffile+dcat%3AbyteSize+%3Fsize+.%0A++%3Ffile+dcterms%3Aissued+%3Fdate+.%0ABIND+(substr(xsd%3AString(%3Fdate)%2C+1%2C+7)+AS+%3Fym)%0A%7D+%0AGROUP+BY+%3Fym%0AORDER+BY+%3Fym%0A&contentTypeConstruct=text%2Fturtle&contentTypeSelect=application%2Fsparql-results%2Bjson&endpoint=https%3A%2F%2Fdatabus.dbpedia.org%2Frepo%2Fsparql&requestMethod=POST&tabTitle=Query+1&headers=%7B%7D&outputFormat=table"></iframe>
{% endraw %}

## Contributing to this Wiki

There are two modes to contribute:
* write something and commit it at <a target="_blank" href="https://github.com/dbpedia/dev.dbpedia.org">https://github.com/dbpedia/dev.dbpedia.org</a>
* update the README.md of your project and include it in the readme-list.csv, as is done with <a href="WebID">WebID</a> or <a href="Databus%20Maven%20Plugin">Databus Maven Plugin</a>


