#!/bin/bash

TITLE="$1"

if [ -z "$TITLE" ]; then
    echo "Usage: ./add-entry.sh \"your entry title\""
    exit 1
fi

DATE=$(date +"%Y-%m-%d-%H-%M")
FILENAME="posts/$DATE.html"

cat > "$FILENAME" <<EOF
<!DOCTYPE html>
<html>
<head>
<title>$TITLE</title>
</head>

<body>

<h1>$TITLE</h1>

<p>Date: $(date)</p>

<p>
This is my log entry created from terminal.
</p>

<a href="../index.html">Back to home</a>

</body>
</html>
EOF


echo "<li>
<a href=\"$FILENAME\">$TITLE</a>
</li>" >> entries.tmp


if [ ! -f entries.txt ]; then
    touch entries.txt
fi


echo "<li><a href=\"$FILENAME\">$TITLE</a></li>" >> entries.txt


cat > index.html <<EOF
<!DOCTYPE html>
<html>

<head>
<title>My Log</title>
</head>

<body>

<h1>My Log Entries</h1>

<ul>
EOF


cat entries.txt >> index.html


cat >> index.html <<EOF
</ul>

</body>
</html>
EOF


git add .
git commit -m "Added log entry: $TITLE"
git push

echo "Entry created: $FILENAME"
