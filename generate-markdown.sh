#!/bin/bash
cd "$( dirname "${BASH_SOURCE[0]}")"
while IFS='' read -r line || [[ -n "$line" ]]; do
	entryname=${line%%	*}
	repourl=${line##*	}
	readmeurl=`echo $repourl/master/README.md | sed s/github.com/raw.githubusercontent.com/g`
	echo -e "---\nlayout: readme\ntitle: \"$entryname\"\npermalink: \"$entryname\"\n---\n" > "content/$entryname.md"
	echo 'This page was included from <a target="_blank" href="'$repourl'">'$repourl'</a>.' >> "content/$entryname.md"
	curl -s $readmeurl >> "content/$entryname.md"
done < readme-list.tsv
