# Fusion

DBpedia-fusion process to fuse internal and external data.
Rewrittes based on the ID management orignal source IRIs to DBpedia global ids.
Uses the DBpedia global IRI clusters to fuse and enrich the source datasets.

## Produced Data

### Fused Data

* Fused data between all input data sources
* Contains all resource of the input data
* Fusion function is based on
    * functional property decision to decide the number of selected values ( owl:FunctinalProperty determination )
    * value selection based on a preference dependent on the  originated source dataset
* The goal is to improve data quality and data coverage

### Enriched Data

* Enriched versions of the input datasets ( e.g. the language specific DBpedia versions )
* Uses the fused data for the enrichment process
* Improves entity-properties and -values coverage for resources only contained in the source data
* There are two different cases data is added:
    * If a resource in the source data misses properties found in the core data, then this properties and its values are added.
    * If the resource already contains properties with different values from the fused data.
In this case, if the properties are determined as functional properties, then add nothing, otherwise add all values.
This ensures that existing values from source datasets stay unchanged in their enriched version.
* (  No unknown source entities are added )

### Provenance Data

* Keeps track of all triple statements in the fusion process
* This data is generated simultaneously at the data fusion
* Contains every triples, regardless of whether it is selected or discarded by the fusion function
* Information about each subject-predicate pair and their values and descending source
* Information if a triple has been selected for the fused data
* Is currently used for the global.dbpedia.org resource web view

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

## Fusion Methodology

To decided the number of selected values for a property, a cardinality based median is calculated.

```
Example median calculation
----

@preifx ex : <http://example.org/>
ex:A
  ex:property
    "first value"@en , "second valu"@en .
ex:B
  ex:property
    "value of B"@en .
ex:C
  ex:property
    "value of C"@en .

----
=> sorted caridinallity sequence(1,1,2)
=> median for ex:property is 1
```

If the property-median-number equals 1 select only one value, otherwise all.


To select the right value, the property values are weighted on the trustiness of their originated source datasets.

For example `en.dbpedia > de.dbpedia`, which describes that en.dbpedia is more trustfull then de.dbpedia in case of the fusion szenario.


## Future Development

TODO - combined function of weighted most frequent and preference dataset value
