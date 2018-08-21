#!/bin/bash
cd "$( dirname "${BASH_SOURCE[0]}")"
while IFS='' read -r line || [[ -n "$line" ]]; do
	entryname=${line%%	*}
	readmeurl=${line##*	}
	echo -e "---\nlayout: page\ntitle: \"$entryname\"\npermalink: \"$entryname\"\n---\n" > "$entryname.md"
	curl -s $readmeurl >> "$entryname.md"
done < readme-list.tsv
