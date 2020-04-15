# Testing on Minidumps

## Intro

For evaluating the quality of the DIEF development process, we introduce the minidump tests.
The main goal of this test collection is to retrieve a global overview of the extraction quality. This is needed because sometimes the code improvement of one part in the code can lead to a decress or failure of other parts.

### Workflow

The minidump test uses subsets of single official Wikipedia dumps as extraction import.
For now, its implementation will run the following test

* Download the newest DBpedia [mappings](http://mappings.dbpedia.org/index.php/Main_Page) and [ontology](https://github.com/dbpedia/ontology-tracker/tree/master/databus/dbpedia/ontology/dbo-snapshots) files
* Extract RDF from the [minidumps](https://github.com/dbpedia/extraction-framework/tree/master/dump/src/test/resources/minidumps) (generic and mapping-based approach)
* Evaluate the RDF [syntax quality](#dief-syntax-evaluation) of the extracted dumps
* Validate the extracted RDF dumps with [RDFUnit](https://github.com/AKSW/RDFUnit)

### Testing

To perform only the minidump tests change to the `dumps` directory and execute `mvn test`.

```bash
cd dumps/ # << $DIEF_DIR/dumps
mvn test
```