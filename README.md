# dev.dbpedia.org
Developer Documentation at http://dev.dbpedia.org

## Requirements
```
jekyll curl crontab
```
## Installation 
```
git clone https://github.com/dbpedia/dev.dbpedia.org.git
cd dev.dbpedia.org

mkdir jekyll
jekyll new jekyll/
cp src/* jekyll
cd jekyll 
# add -H 0.0.0.0 for external access 
jekyll serve -H 0.0.0.0 -P 4444
```

It is possible to serve the generated jekyll/_site/ folder as html.

Finally add following cronjob.
```
* 0 * * * path/to/generate-markdown.sh
```

## Docker
```
git clone https://github.com/dbpedia/dev.dbpedia.org.git
cd dev.dbpedia.org
docker build -t mdgath .
docker run -d -p 80:4000 --name mdgath mdgath
```
