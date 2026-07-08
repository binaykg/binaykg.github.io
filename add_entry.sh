#!/bin/bash

read -p "Enter title: " TITLE

read -p "Enter description: " DESCRIPTION


if [ -z "$TITLE" ]; then
    echo "Title cannot be empty"
    exit 1
fi

# Create URL-friendly filename from title
SLUG=$(echo "$TITLE" | \
    tr '[:upper:]' '[:lower:]' | \
    sed 's/ /-/g' | \
    sed 's/[^a-z0-9-]//g')

# Date and time
DATE=$(date +"%Y-%m-%d")
DATETIME=$(date +"%Y-%m-%d %H:%M:%S")


# Create posts directory if missing
mkdir -p posts

# Post filename
POST="posts/$SLUG.html"

# Create individual post page
cat > "$POST" <<EOF
<!DOCTYPE html>
<html>
<head>

<title>$TITLE</title>

<style>
body {
    font-family: Arial, sans-serif;
    max-width: 800px;
    margin: 40px auto;
    line-height: 1.6;
}
</style>
</head>
<body>

<h1>$TITLE</h1>
<p>
<b>Created:</b> $DATETIME
</p>

<hr>
<p>
$DESCRIPTION
</p>
<br>

<a href="../index.html">Back to Log</a>

</body>

</html>
EOF

# Create entries storage file
touch entries.txt

# Add newest entry at the top of entries.txt
echo "<li>
<a href=\"$POST\"><b>$TITLE</b></a>
<br>
<small>$DESCRIPTION</small>
<br>
<small>Created: $DATETIME</small>
</li>
<br>" | cat - entries.txt > entries.tmp

mv entries.tmp entries.txt

# Rebuild index.html

cat > index.html <<EOF
<!DOCTYPE html>
<html>

<head>
<title>My Log</title>
<style>

body {
    font-family: Arial, sans-serif;
    max-width: 800px;
    margin: 40px auto;
    line-height: 1.6;
}

li {
    margin-bottom: 20px;
}

small {
    color: gray;
}

</style>
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

# Git operations
git add .
git commit -m "Added log entry: $TITLE"
git push

echo ""
echo "--------------------------------"
echo "Log entry created successfully"
echo "Post URL:"
echo "$POST"
echo "--------------------------------"
