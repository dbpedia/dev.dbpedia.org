#!/bin/bash
cd "$( dirname "${BASH_SOURCE[0]}")"
while IFS='' read -r line || [[ -n "$line" ]]; do
	entryname=${line%%	*}
	readmeurl=${line##*	}
	echo -e "---\nlayout: page\ntitle: \"$entryname\"\npermalink: \"$entryname\"\n---\n" > "content/$entryname.md"
	curl -s $readmeurl >> "content/$entryname.md"
done < readme-list.tsv
