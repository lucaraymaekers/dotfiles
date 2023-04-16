test -z "${inp:=$1}" && 
	inp="$(cat /dev/stdin)"
echo "inp: ${inp}" 1>&2
