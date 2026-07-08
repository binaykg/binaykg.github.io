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

# Create post page
cat > "$POST_FILE" <<EOF

<!DOCTYPE html>
<html>
<head>
<title>Post</title>

<style>
body {
  margin: 0;
  background: #fff;
  color: #1d1d1f;
  font-family: -apple-system, BlinkMacSystemFont, "Helvetica Neue", sans-serif;
}

.container {
  max-width: 720px;
  margin: 80px auto;
  padding: 0 24px;
}

h1 {
  font-size: 38px;
  font-weight: 600;
  letter-spacing: -0.8px;
  margin-bottom: 35px;
}

.content {
  font-size: 18px;
  line-height: 1.7;
  color: #333336;
}

.content p {
  margin-bottom: 24px;
}
</style>

</head>
<body>

<div class="container">
<h1>$TITLE<</h1>

<div class="content">
<p>$DESCRIPTION </p>
<a href="$LINK">$LINK</a>
</div>
</div>

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
