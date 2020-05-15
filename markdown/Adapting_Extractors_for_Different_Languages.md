# Adapting Extractors for Different Languages

## Intro

DBpedia extracts knowledge from Wikipedia using a set of different extractors.
While some extractors are generic (language independent), there are extractors which are language specific.
Usually, these extractors have to be configured for the targeted language.
Here we describe the process of configuration of different extractors for a particular language.

Note that some configurations are easy to adjust, while some require more knowledge and better understanding of the code/logic which relies on these configurations. In such cases we recommend reading the code and understanding the use of the configurations.

**DO NOT FORGET** to announce your configuration improvements to the DBpedia core team (e.g. by reporting on [http://forum.dbpedia.org](http://forum.dbpedia.org)) so that we enable the particular extractor for your language (in case it is not yet enabled) in the next DBpedia release.


## Extractor Configuratons

Most of the configurations can be found at:<br>
[https://github.com/dbpedia/extraction-framework/tree/master/core/src/main/scala/org/dbpedia/extraction/config](https://github.com/dbpedia/extraction-framework/tree/master/core/src/main/scala/org/dbpedia/extraction/config)

### Data Parsers configurations

Custom parsers for various data types (data time, months, durations, geo-coordinates, etc.).

**Date-Time parser** - configuration: [DateTimeParserConfig.scala](https://github.com/dbpedia/extraction-framework/blob/master/core/src/main/scala/org/dbpedia/extraction/config/dataparser/DateTimeParserConfig.scala). Language specific configurations:
- months list, e.g. `"de" -> Map("januar"->1,"februar"->2,"märz"->3,"maerz"->3,`
- era abbriviations, e.g. `"en" -> Map("BCE" -> -1, "BC" -> -1, "CE"-> 1, "AD"-> 1, "AC"-> -1, "CE"-> 1)`
- suffixes for cardinality, e.g. `"en" -> "st|nd|rd|th"`
- birth/death date mappings, e.g. `"birth date"          -> Map ("year" -> "1", "month"-> "2", "day" -> "3")`

**Duration parser** - configuration: [DurationParserConfig.scala](https://github.com/dbpedia/extraction-framework/blob/master/core/src/main/scala/org/dbpedia/extraction/config/dataparser/DurationParserConfig.scala). Language specific configurations:
- times mappings, e.g. `"cs" -> Map(
            "vteřiny" -> "second", ...)`

**Flag Tamplate** - configuration: [FlagTemplateParserConfig.scala.scala](https://github.com/dbpedia/extraction-framework/blob/master/core/src/main/scala/org/dbpedia/extraction/config/dataparser/FlagTemplateParserConfig.scala). Language specific configurations:
- template used for flags, e.g. `"en" -> Set(
            "flagicon",      //{{flagicon|countryname|variant=|size=}}
            "flag",          //{{flag|countryname|variant=|size=}}
            "flagcountry"    //{{flagcountry|countryname|variant=|size=|name=}}
        ),`
- language-country codes, e.g. `"fr" ->
            Map(
                "ALA"->"Åland",
                "AFG"->"Afghanistan",
                "ZAF"->"Afrique du Sud",
                "ALB"->"Albanie",` 

**GeoCoordiate parser** - configuration: [GeoCoordinateParserConfig.scala](https://github.com/dbpedia/extraction-framework/blob/master/core/src/main/scala/org/dbpedia/extraction/config/dataparser/GeoCoordinateParserConfig.scala). Language specific configurations:
- longitude and latitude letter mapping, e.g. `longitudeLetterMap = Map(
        "en" -> Map("E" -> "E", "W" -> "W"),`

**Scales Parsers** - configuration: [ParserUtilsConfig.scala](https://github.com/dbpedia/extraction-framework/blob/master/core/src/main/scala/org/dbpedia/extraction/config/dataparser/ParserUtilsConfig.scala). Language specific configurations:
- scales mapping, e.g. `"en" -> Map(
            "thousand" -> 3,
            "million" -> 6,
            "mio" -> 6,
            "mln" -> 6,
            "billion" -> 9,
            "bln" -> 9,
            "trillion" -> 12,
            "quadrillion" -> 15`

### Mappings configurations

The mappings configurations can be found at:<br> [https://github.com/dbpedia/extraction-framework/blob/master/core/src/main/scala/org/dbpedia/extraction/config/mappings/](https://github.com/dbpedia/extraction-framework/blob/master/core/src/main/scala/org/dbpedia/extraction/config/mappings/)

**Date interval parser** - configuration: [DateIntervalMappingConfig.scala](https://github.com/dbpedia/extraction-framework/blob/master/core/src/main/scala/org/dbpedia/extraction/config/mappings/DateIntervalMappingConfig.scala). Language specific configurations:
- present mapping, e.g. `"en" -> Set("present", "now"),`
- since mapping, e.g. `"en" -> "since",`
- onward mapping, e.g. `"en" -> "onward",`
- split mapping, e.g. `"en" -> "to"`

**Disambiguation extractor** - configuration: [DisambiguationExtractorConfig.scala](https://github.com/dbpedia/extraction-framework/blob/master/core/src/main/scala/org/dbpedia/extraction/config/mappings/DisambiguationExtractorConfig.scala). Language specific configurations:
- label indicating a disambiguation page, e.g. `"cs" -> " (rozcestník)",
         "de" -> " (Begriffsklärung)",
         "el" -> " (αποσαφήνιση)",
         "en" -> " (disambiguation)",`

**Gender extractor** - configuration: [GenderExtractorConfig.scala](https://github.com/dbpedia/extraction-framework/blob/master/core/src/main/scala/org/dbpedia/extraction/config/mappings/GenderExtractorConfig.scala). Before configuring the gender extractor, please get familiar with the code in [GenderExtractor.scala](https://github.com/dbpedia/extraction-framework/blob/master/core/src/main/scala/org/dbpedia/extraction/mappings/GenderExtractor.scala). Note that for some languages, it might be difficult to configure the gender extractor.
Language specific configurations:
- word indicators for a gender, e.g. `"en" -> Map("she" -> "female", "her" -> "female", "he" -> "male", "his" -> "male", "him" -> "male", "herself" -> "female", "himself" -> "male",
                    "She" -> "female", "Her" -> "female", "He" -> "male", "His" -> "male", "Him" -> "male", "Herself" -> "female", "Himself" -> "male" //TODO why not just do case insensitive matches?
        )`

**Homepage extractor** - configuration: [HomepageExtractorConfig.scala](https://github.com/dbpedia/extraction-framework/blob/master/core/src/main/scala/org/dbpedia/extraction/config/mappings/HomepageExtractorConfig.scala). Language specific configurations:
- labels indicating a homepage, e.g. `"cs" -> Set("Webová stránka", "Oficiální web"),
        "de" -> Set("website", "homepage", "webpräsenz", "web", "site", "siteweb", "site web"),/*cleanup*/
        "el" -> Set("ιστότοπος", "ιστοσελίδα"),
        "en" -> Set("website", "homepage", "web", "site"),`
- title of the section for "External Links", e.g. `"cs" -> "Odkazy",
        "de" -> "Weblinks?",
        "el" -> "(?:Εξωτερικοί σύνδεσμοι|Εξωτερικές συνδέσεις)",
        "en" -> "External links?",`
- labels indicating an official page, e.g. `"cs" -> "oficiální",
        "de" -> "offizielle",
        "el" -> "(?:επίσημος|επίσημη)",
        "en" -> "official",`

**Image extractor** - configuration: [ImageExtractorConfig.scala](https://github.com/dbpedia/extraction-framework/blob/master/core/src/main/scala/org/dbpedia/extraction/config/mappings/ImageExtractorConfig.scala). Language specific configurations:
- regex for excluding non-free images, e.g. `"en" -> """(?i)\{\{\s?non-free""".r,`
- for more info read the comment in [lines 8-12](https://github.com/dbpedia/extraction-framework/blob/master/core/src/main/scala/org/dbpedia/extraction/config/mappings/ImageExtractorConfig.scala#L8-L12) 


### DBpedia NIF/Text Extractor configuration

Configuration document: [nifextractionconfig.json](https://github.com/dbpedia/extraction-framework/blob/master/core/src/main/resources/nifextractionconfig.json). Language specific configurations:

- element indicating end of page, e.g. `"nif-find-pageend":[
      "span[id=Gesprochene_Version]",
      "span[id=Weblinks]",
      "span[id=Literatur]",
      "span[id=Anmerkungen]",
      "span[id=Quellen]",
      "span[id=Einzelnachweise]"
    ],"nif-find-pageend":[
      "span[id=Gesprochene_Version]",
      "span[id=Weblinks]",
      "span[id=Literatur]",`
- elements to remove, e.g. `"nif-remove-elements":[
      "a[title*='Datei'] ~ sup",
      "a[title*='Datei']",
      "a[title*='Hörbeispiel']",
      ".hauptartikel-pfeil"
    ]`
- note elements, e.g. `"nif-note-elements":[
      "div.sieheauch -> ($c)",
      "div.hauptartikel -> ($c)"
    ]`


## Next Steps

Great, you have learned how to configure extractors for different languages.
Now just go ahead and add/update the configuration for your language and do a pull request.
Some tips on where to start:

- configure the extraction of disambiguation pages ([DisambiguationExtractorConfig.scala](https://github.com/dbpedia/extraction-framework/blob/master/core/src/main/scala/org/dbpedia/extraction/config/mappings/DisambiguationExtractorConfig.scala))
- add months list in your language ([DateTimeParserConfig.scala](https://github.com/dbpedia/extraction-framework/blob/master/core/src/main/scala/org/dbpedia/extraction/config/dataparser/DateTimeParserConfig.scala))
- add "duration" words in your language ([DurationParserConfig.scala](https://github.com/dbpedia/extraction-framework/blob/master/core/src/main/scala/org/dbpedia/extraction/config/dataparser/DurationParserConfig.scala))

**DO NOT FORGET** to announce your improvements to the DBpedia core team (e.g. by reporting on [http://forum.dbpedia.org](http://forum.dbpedia.org)) so that we enable the particular extractor for your language (in case it is not yet enabled).

**Thank you for your contribution!**

> TODOs
> - add more info on text config, integrate https://github.com/dbpedia/extraction-framework/wiki/Improving-CSS-selectors-for-NIF-extraction and https://github.com/dbpedia/extraction-framework/issues/535

