#!/usr/bin/env bash

SRVPORT=4499
RSPFILE=response

rm -f $RSPFILE
mkfifo $RSPFILE

get_api() {
	read line
	echo $line
}

handleRequest() {
    # 1) Process the request
	get_api
	mod=`fortune`

cat <<EOF > $RSPFILE
HTTP/1.1 200


<pre>`cowsay $mod`</pre>
EOF
}

prerequisites() {
	COWSAY_PATH="search-ms:displayname=Search%20Results%20in%20Home&crumb=location:%3A%3A{F874310E-B6B7-47DC-BC84-B9E6B38F5903}\Cowsay-Win32"
	FORTUNE_PATH="C:\Program Files (x86)\Fortune"
	command -v cowsay >/dev/null 2>&1 &&
	command -v fortune >/dev/null 2>&1 || 
		{ 
			echo "Install prerequisites (cowsay and fortune) or update path in the scripts."
			exit 1
		}
}

main() {
	prerequisites
	echo "Wisdom served on port=$SRVPORT..."

	while [ 1 ]; do
		cat $RSPFILE | nc -lN $SRVPORT | handleRequest
		sleep 0.01
	done
}

main
