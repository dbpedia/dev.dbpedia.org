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
To generate a new page, the `readme-list.csv` contains entries with the attributes: "headline", link to the "external repo", the "direct link to the external markdown file", and if it should be a subsection of a "parent menu entry".

To add static content add/edit files in the `markdown` folder and then include it as the same way as the external markdowns in the `readme-list.tsv`.


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
