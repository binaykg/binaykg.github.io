#!/bin/bash

# Folder where index.html exists
BASE_DIR="$(pwd)"
POST_DIR="$BASE_DIR/posts"

# Create posts folder if missing
mkdir -p "$POST_DIR"

echo "Create new post"

read -p "Title: " TITLE
read -p "Details: " DESCRIPTION
read -p "Link: " LINK

# Convert title to filename
FILENAME=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-')

POST_FILE="$POST_DIR/$FILENAME.html"

TIMESTAMP=$(date "+%Y-%m-%d %H:%M")


# Create post page
cat > "$POST_FILE" <<EOF
<!DOCTYPE html>
<html>
<head>
<title>$TITLE</title>

<style>
body {
  font-family: roboto;
  max-width: 700px;
  margin: 70px auto;
  padding: 20px;
  color: #1d1d1f;
}

h1 {
  font-size: 30px;
  margin-bottom: 30px;
}

p {
  font-size: 16px;
  line-height: 1.6;
  color: #333;
}
</style>

</head>

<body>

<h1>$TITLE</h1>

<p>
$DESCRIPTION
</p>

<a href="$LINK">$LINK</a>

</body>
</html>
EOF


# Add entry to index.html before closing ul tag
ENTRY="  <li><a href=\"posts/$FILENAME.html\">$TITLE</a>    [$TIMESTAMP]</li>"

awk -v entry="$ENTRY" '
/<\/ul>/ {
    print entry
}
{
    print
}' index.html > index.tmp && mv index.tmp index.html


echo ""
echo "Created:"
echo "$POST_FILE"
echo "Updated index.html"



# Git commit
#git add index.html "$POST_FILE"
#git commit -m "Add post: $TITLE"
#git push


#echo ""
#echo "Done!"
#echo "Committed and pushed to Git."

