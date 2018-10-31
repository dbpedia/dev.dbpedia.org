---
layout: page
title: "ID and Clustering"
permalink: "ID and Clustering"
---
A brief tour through structure and meaning of the uploaded files:
`cluster-groups.tsv.bz2` lists the identity clusters (according to the sameAs assertions in the input data). One cluster per line. The first column gives the global id (decimal representation) that identifies this cluster. An example line:

1045567    <http://commons.dbpedia.org/resource/Málaga> <http://es.dbpedia.org/resource/Málaga>

If one looks up the corresponding lines in `global-ids.tsv.bz2`

```
original_iri    singleton_id    cluster_id
http://commons.dbpedia.org/resource/Málaga    21893128    1045567
http://es.dbpedia.org/resource/Málaga    1045567    1045567
```

one can see that cluster membership is encoded there by the fact that all original IRIs that belong to the same cluster share the same cluster id. The cluster id is selected as the minimum of all singleton_id of IRI for resources that are in the same connected component of the undirected graph induced by the sameAs statements considered (these connected components have been then dubbed cluster in the context of the id management).

To make the resulting new global IRIs shorter, we decided to encode the IDs in base58 for public-facing services. Thus, looking up the corresponding lines in `global-ids-base58.tsv.bz2`

```
original_iri    singleton_id_base58    cluster_id_base58
http://commons.dbpedia.org/resource/Málaga    2wD4j    6Mp2
http://es.dbpedia.org/resource/Málaga    6Mp2    6Mp2
```

will inform under which IRIs the (fused) information about the entity represented by the cluster will be accessible: Primarily under `<https://global.dbpedia.org/id/6Mp2>`, but also (via redirect) under `<https://global.dbpedia.org/id/2wD4j>`.

Mathematically speaking, `<http://es.dbpedia.org/resource/Málaga>` or respectively `<https://global.dbpedia.org/id/6Mp2>` has been chosen as representative for the sameAs-equivalence class of

```
{ <http://commons.dbpedia.org/resource/Málaga>, <http://es.dbpedia.org/resource/Málaga> }
```
