#!/bin/bash

# Folder where index.html exists
BASE_DIR="$(pwd)"
POST_DIR="$BASE_DIR/posts"

# Create posts folder if missing
mkdir -p "$POST_DIR"

echo "Create new post"

read -p "Title: " TITLE
read -p "Description: " DESCRIPTION
read -p "Link: " LINK

# Convert title to filename
FILENAME=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-')
POST_FILE="$POST_DIR/$FILENAME.html"

# Create post page
cat > "$POST_FILE" <<EOF
<!DOCTYPE html>
<html>
<head>
<title>$TITLE</title>

<style>
body {
  font-family: -apple-system, BlinkMacSystemFont, sans-serif;
  max-width: 700px;
  margin: 70px auto;
  color: #1d1d1f;
}

h1 {
  font-size: 42px;
}

p {
  font-size: 20px;
  color: #666;
}
</style>

</head>

<body>

<h1>$TITLE</h1>

<p>$DESCRIPTION</p>

<a href="$LINK">$LINK</a>

</body>
</html>
EOF


# Add entry before closing ul tag in index.html
ENTRY="
  <li>
    <a href=\"posts/$FILENAME.html\">
      <strong>$TITLE</strong><br>
      <span>$DESCRIPTION</span>
    </a>
  </li>
"

sed -i "/<\/ul>/i\\$ENTRY" index.html


echo "Created:"
echo "$POST_FILE"
echo "Updated index.html"


# Git commit
git add index.html "$POST_FILE"

git commit -m "Add post: $TITLE"

# Push changes
git push

echo ""
echo "Done!"
echo "Created: $POST_FILE"
echo "Committed and pushed to Git."
