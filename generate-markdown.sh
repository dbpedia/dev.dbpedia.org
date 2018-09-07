#!/bin/bash
cd "$( dirname "${BASH_SOURCE[0]}")"
while IFS='' read -r line || [[ -n "$line" ]]; do
#	entryname=${line%%	*}
    entryname=`echo "$line" | cut -d$'\t' -f1`
#	repourl=${line##*	}
    repourl=`echo "$line" | cut -d$'\t' -f2`
#	readmeurl=`echo $repourl/master/README.md | sed s/github.com/raw.githubusercontent.com/g`
	readmeurl=`echo "$line" | cut -d$'\t' -f3`
	echo -e "---\nlayout: readme\ntitle: \"$entryname\"\npermalink: \"$entryname\"\n---\n" > "content/$entryname.md"
	echo 'This page was included from <a target="_blank" href="'$repourl'">'$repourl'</a>.' >> "content/$entryname.md"
	curl -s $readmeurl >> "content/$entryname.md"
done < <(tail -n+2 readme-list.tsv)
