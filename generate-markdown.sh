#!/bin/bash
cd "$( dirname "${BASH_SOURCE[0]}")"
rank=0
while IFS='' read -r line || [[ -n "$line" ]]; do
#	entryname=${line%%	*}
	entryname=`echo "$line" | cut -d$'\t' -f1`
#	repourl=${line##*	}
	repourl=`echo "$line" | cut -d$'\t' -f2`

	includetext=""
#	readmeurl=`echo $repourl/master/README.md | sed s/github.com/raw.githubusercontent.com/g`
	readmeurl=`echo "$line" | cut -d$'\t' -f3`

	parent=`echo "$line" | cut -d$'\t' -f4`

    if [ -n "$repourl" ]
    then
        includetext=`echo -e 'This page was included from <a target="_blank" href="'$repourl'">'$repourl'</a>.\n'`
    fi
	if [ -z "$parent" ]
	then
		#echo -e "---\nlayout: readme\ntitle: \"$entryname\"\npermalink: \"$entryname\"\nrank: \"$(echo -n 0$rank)\"\n---\n" > "content/$entryname.md"
		echo -e "---\nlayout: readme\ntitle: \"$entryname\"\npermalink: \"$entryname\"\nrank: $rank\n---\n" > "content/$entryname.md"
		echo "$includetext" >> "content/$entryname.md"
		curl -s "$readmeurl" >> "content/$entryname.md"
	else
		#echo -e "---\nlayout: subpage\ntitle: \"$entryname\"\npermalink: \"$entryname\"\nparent: \"$parent\"\nrank: \"$(echo -n 0$rank)\"\n---\n" > "content/$entryname.md"
		echo -e "---\nlayout: subpage\ntitle: \"$entryname\"\npermalink: \"$entryname\"\nparent: \"$parent\"\nrank: $rank\n---\n" > "content/$entryname.md"
		echo "$includetext" >> "content/$entryname.md"
		curl -s "$readmeurl" >> "content/$entryname.md"
	fi
	((rank+=1))
done < <(tail -n+2 readme-list.tsv)
