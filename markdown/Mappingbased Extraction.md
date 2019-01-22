# Mappingbased Extraction

**TODO** Description.

## Produced Data

**TODO** This.

## Basic Setup

Clone the current [extraction-framework](https://github.com/dbpedia/extraction-framework).
```
git clone https://github.com/dbpedia/extraction-framework
```

Enter the repository and install it ( This can take up to 5 minutes ).
```
mvn clean install
# mvn -T 4 clean install
```

The main properties of the extraction are configured in `core/main/resources/universal.properties`.

Property  |  Description
--|--
`base-dir` |  Location of the data, e.g. wikidumps and extracted data
`log-dir`  |  Location of produced logging data.

The maximal avail memory for the mappingbased extraction can be assigned in `dump/pom.xml`.
```
<launcher>
  <id>extraction</id>
  <mainClass>org.dbpedia.extraction.dump.extract.Extraction</mainClass>
  <jvmArgs>
    ...
    <jvmArg>-Xmx16G</jvmArg>
    ...
  </jvmArgs>
</launcher>
```

For a full mappingbased extraction it is recommended to have more then `100 GB free disk space`.
Further we recommend to assign at least `150 GB of memory`, to avoid exceptions for the larger languages ( e.g. en-wiki and commons-wiki ).

## Usage

This section describes the setup and configuration of a default mappingbased extraction process.
It will extact data from all possible languages, that have an entries in the [mappings-wiki](http://mappings.dbpedia.org/).

**TODO** Add: change languages=en in download.minimal.properties to languages=@mappings
```
# enter dump folder
cd dump/

# download all mappings-wiki related wikidumps
../run download download.10000.properties

# dowload ontology and mappings data
../run download-ontology
../run download-mappings

# start the extraction process
../run extraction extraction.mappings.properties
```

**TODO** Spellcheck.
