#!/bin/bash
cd "$( dirname "${BASH_SOURCE[0]}")"

mkdir content
rm -r content/*.md
cp markdown/about.md content/about.md

rank=0
while IFS='' read -r line || [[ -n "$line" ]]; do

	# get the table columns
	entryname=`echo "$line" | cut -d$',' -f1`
	parent=`echo "$line" | cut -d$',' -f2`
	repourl=`echo "$line" | cut -d$',' -f3`
	readmeurl=`echo "$line" | cut -d$',' -f4`
	


	includetext=""
	permalink=`echo "$entryname" | sed "s/ /_/g"`


	# generating the header of each page
    if [ -n "$repourl" ]
    then
        includetext=`echo '**[Edit this page on Github]('$repourl')**'`
    fi
    
	# generate jekyll header
    
	if [ -z "$parent" ]
	then
		echo -e "---\nlayout: readme\ntitle: \"$entryname\"\npermalink: \"$permalink\"\nrank: $rank\n---\n" > "content/$entryname.md"
	else
		echo -e "---\nlayout: subpage\ntitle: \"$entryname\"\npermalink: \"$permalink\"\nparent: \"$parent\"\nrank: $rank\n---\n" > "content/$entryname.md"
	fi
	
	# filling with header and page content
	echo -e "$includetext\n" >> "content/$entryname.md"
	curl -s "$readmeurl" >> "content/$entryname.md"
	
	
	((rank+=1))
done < <(tail -n+2 readme-list.csv)
