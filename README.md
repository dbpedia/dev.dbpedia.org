# dev.dbpedia.org
Developer Documentation at <a href="http://dev.dbpedia.org">http://dev.dbpedia.org</a>

## Requirements
```
jekyll curl crontab
```
## Installation 
```
git clone https://github.com/dbpedia/dev.dbpedia.org.git
cd dev.dbpedia.org && ./generate-markdown.sh

# -H 0.0.0.0 for external access 
jekyll serve -H 0.0.0.0 -P 4444
```

It is also possible to serve only the generated `_site/` folder as html.

### Content
For own content edit or add files in the `content` folder or expand the `readme-list.tsv` with external markdown files.

To generate a new page, the `readme-list.csv` contains the headlines and the links to the external markdown files separated by a tabulator.

### Sidebar
Configured in `_includes/sidebar.html`.
Sorted alphabetically with the following code
```
...
{% assign pages_list = site.pages | sort:"title" %}
...
```


### Automatic Update
To update external markdown every hour, add following entry to your crontab.
```
crontab -l > tmpcron
# skip first line if crontab is empty.
# enter dev.dbpedia.org repo folder.
echo "*/10 * * * * /bin/sh -c 'cd `pwd` && /usr/bin/git pull -q origin master && ./generate-markdown.sh'" >> tmpcron
crontab tmpcron && rm tmpcron
```
