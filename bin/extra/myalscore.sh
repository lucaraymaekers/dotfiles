#!/bin/sh

[ "$1" ] || exit 1
query="$(printf '%s' "$*" | sed 's/\s/%20/g')"
curl -s "https://myanimelist.net/search/prefix.json?type=all&keyword=$query&v=1" \
	-H 'Accept: application/json, text/javascript, */*; q=0.01' |
	jq -r '.categories[].items[] | "\(.payload.score)@\(.name)@\(.url)"' |
	column -t -l 3 -s '@'
