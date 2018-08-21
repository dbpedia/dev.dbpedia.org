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
./generate-markdown.sh

# -H 0.0.0.0 for external access 
jekyll serve -H 0.0.0.0 -P 4444
```

It is possible to serve only the generated `_site/` folder as html.

Add entry to you crontab.
```
crontab -l > tmpcron
# skip first line if crontab is empty
echo "* 0 * * * path/to/generate-markdown.sh" >> tmpcron
crontab tmpcron
rm tmpcron
```

## Docker ( Deprecated at the moment )
```
git clone https://github.com/dbpedia/dev.dbpedia.org.git
cd dev.dbpedia.org
docker build -t mdgath .
docker run -d -p 80:4000 --name mdgath mdgath
```
