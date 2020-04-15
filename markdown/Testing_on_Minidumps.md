# Testing on Minidumps

## Intro

For evaluating the quality of the development process are used minidump tests.
*Minidumps* are small Wikipedia XML dumps which are used to test the extraction framework.
The main goal of this test collection is to retrieve a global overview of the extraction quality. This is required since sometimes an improvement in one part in the code can lead to a decrease or failure in other parts.

## Workflow

The minidump test uses small subset of Wikipedia dumps for extraction.
The testing workflow is as follows:

1. Downloads the newest DBpedia [mappings](http://mappings.dbpedia.org/index.php/Main_Page) and [ontology](https://github.com/dbpedia/ontology-tracker/tree/master/databus/dbpedia/ontology/dbo-snapshots) files.
2. Extracts RDF from the [minidumps](https://github.com/dbpedia/extraction-framework/tree/master/dump/src/test/resources/minidumps) (generic and mapping-based extraction).
3. Evaluates the RDF [syntax quality](http://dev.dbpedia.org/Debugging_DIEF#dief-syntax-evaluation) of the extracted dumps.
4. Validate the extracted RDF dumps with [RDFUnit](https://github.com/AKSW/RDFUnit).

## Minidump Creation (optional)

> Note: A minidump is already provided with the extraction framework.
> Creating a dump is necessary only if you want to test on other Wikipedia articles (changed the URLs list) or test against the most up-to-date version of the Wikipedia articles.

The minidump for testing are defined in the [URL list](https://github.com/dbpedia/extraction-framework/blob/master/dump/src/test/bash/uris.lst) and stored under `$DIEF_DIR/dump/src/test/resources/minidumps`.
Excerpt from the URLs list:

```bash
https://af.wikipedia.org/wiki/Berlyn
https://als.wikipedia.org/wiki/Berlin
https://am.wikipedia.org/wiki/በርሊን
https://an.wikipedia.org/wiki/Berlín
https://ar.wikipedia.org/wiki/برلين
https://arz.wikipedia.org/wiki/بيرلين
https://ast.wikipedia.org/wiki/Berlín
https://az.wikipedia.org/wiki/Berlin
...
```

If you wish to run the tests over additional pages, add more URLs to the list. 
If you edited the URLs list or you want to test against the most up-to-date version of the Wikipedia articles, you are supposed create a new minidump. For this run 

```bash
cd dump/src/test/bash # << $DIEF_DIR/dump/src/test/bash
./createMinidump.sh
```

This will fetch with content of each Wikipedia articles in the "URLs list" and create a dump for each language.
The dumps will be stored in `$DIEF_DIR/dump/src/test/resources/minidumps`
```bash
$DIEF_DIR/dump/src/test/resources/minidumps/en/wiki.xml.bz2
$DIEF_DIR/dump/src/test/resources/minidumps/de/wiki.xml.bz2
$DIEF_DIR/dump/src/test/resources/minidumps/cs/wiki.xml.bz2
...
```

## Minidumps Testing

To perform the minidump tests change to the `dump` directory and execute `mvn test`.

```bash
cd dump/ # << $DIEF_DIR/dump
mvn test
```

If all tests passed, you should see following message:
```
...
TestSuiteTests:
- ValidationExecutor
- Array
- Dataype Pattern
- Map Test
- Ntriple Test
- RDF Evaluation Report
Run completed in 1 minute.
Total number of tests run: 8
Suites: completed 3, aborted 0
Tests: succeeded 8, failed 0, canceled 0, ignored 0, pending 0
All tests passed.
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  01:07 min
[INFO] Finished at: 2020-04-15T15:23:39+02:00
[INFO] ------------------------------------------------------------------------
```

## Next Steps

Great, you learned how to create a minidump and use it to test.
Learn also [how to define custom SHACL test](http://dev.dbpedia.org/Writing_Tests) for validation.