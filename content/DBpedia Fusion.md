---
layout: page
title: "DBpedia Fusion"
permalink: "DBpedia Fusion"
---

DBpedia-fusion process to fuse internal and external data.

## Produced Data 
Information about the through the fusion process created datafiles.

### Fused Data

This is the main data generated through the fusion process.
It contains all resources from the input datasets. 
Overlapping resources are fused with the defined fusion function. Hence, if predicates intended to be a functional
property, the process keeps only one value and the rest is discarded. All used
source related URIs for entities are rewritten to the DBpedia global identifiers.

### Enriched Data 

For each source dataset a enriched version based on the fused data is created. 
The enrichment process adds missing information only to the resources contained in the source. 
There are two different cases data is added: In the first case, if a resource in the source data misses properties found in the core data then this properties and its values are added. 
The second case manages if the resource already contains properties with different values from the fused data. 
In this case, if the properties are determined as functional properties, then add nothing, otherwise add all values. 
This ensures that existing values from source datasets stay unchanged in their enriched version.

### Provenance Data 

To keep track of all triple statements in the fusion process, this data is generated simultaneously. 
This provenance dataset contains every triples, regardless of whether it is selected or discarded by the fusion function. 
Further, it contains information about each subject-predicate pair and their values. 
The information contains the source dataset of a triple and if it has been selected fused data.

```
# Provenance data schema

{  
   "@context":{  
      "@base":"http://dbpedia.org/fusion/",
      "@vocab":"http://dbpedia.org/fusion/vocab#"
   },
   "subject":"IRI",
   "predicate":"IRI",
   "objects":[  
      {  
         "source":[  
            {  
               "@value":"graph/dataset"
            }
         ],
         "value":{  
            "@value":"Literal value", "@type":"IRI"
            # xor
            "@id": "IRI"
         },
         "selected":true
      }
   ]
}
```

# TODO section 

## Fusion Methodology

To decide whenever an value relies to a functional predicate or not, for each
property a global median value is calculated. 
This median-number is build on the property cardinality inside each resource.

```
Example median calculation
----

<http://example.com/resource/A> <http://example.com/property> "first value inside of A"@en .
<http://example.com/resource/A> <http://example.com/property> "second value inside of A"@en .
<http://example.com/resource/B> <http://example.com/property> "value inside of B"@en .
<http://example.com/resource/C> <http://example.com/property> "value inside of C"@en .

----
=> sorted caridinallity sequence(1,1,2)
=> median for property <http://example.com/property> 1
```


## Future Development

TODO - combined function of weighted most frequent and preference dataset value

