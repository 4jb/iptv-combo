#!/bin/bash
# =====================================
# IPTV Playlist Aggregator & Uploader
# =====================================
# Combines multiple M3U playlists (from URL list file),
# removes duplicates, sorts alphabetically,
# rotates 7 daily backups, and pushes to GitHub
# only if changes exist.
#
# Example cron job (every 6 hours):
# 0 */6 * * * /path/to/download.sh >> /path/to/downlaod.log 2>&1
# =====================================

# === CONFIGURATION ===
WORKDIR="/usr/iptv-combo"       # Local clone of your GitHub repo
DOWNLOAD_FOLDER="$WORKDIR/downloads"          # Final merged playlist name
URL_LIST_FILE="$WORKDIR/playlists"  # Text file with one URL per line
PRIVATE_LIST_FILE="/etc/playlists"  # Text file with one URL per line
OUTPUT_PLAYLIST="$WORKDIR/free4jb-merged.m3u"
UPDATED_PLAYLIST="$WORKDIR/free4jb.m3u"
GITHUB_REMOTE="origin"
GITHUB_BRANCH="main"

# === SCRIPT START ===
set -e
cd "$WORKDIR" || { echo "▒^}^l Repo path not found: $WORKDIR"; exit 1; }

if [[ ! -f "$URL_LIST_FILE" ]]; then
  echo "❌  URL list file not found: $URL_LIST_FILE"
  exit 1
fi

if [[ ! -d "$DOWNLOAD_FOLDER" ]]; then
  echo "❌ Downloads Folder not found: $DOWNLOAD_FOLDER"
  exit 1
fi

echo "➤ Fetching playlists from $URL_LIST_FILE..."
grep -Ev "^#|^$" $URL_LIST_FILE | wget -i - -P $DOWNLOAD_FOLDER -c -nv
echo "✅ Downloaded playlists into $DOWNLOAD_FOLDER folder."

echo "🔄 Renaming Playlists..."
mv $DOWNLOAD_FOLDER/m3u $DOWNLOAD_FOLDER/TVPass.m3u
mv $DOWNLOAD_FOLDER/samsungtvplus_us.m3u $DOWNLOAD_FOLDER/Samsung.m3u
mv $DOWNLOAD_FOLDER/plutotv_us.m3u $DOWNLOAD_FOLDER/PlutoTV.m3u
mv $DOWNLOAD_FOLDER/plex_us.m3u $DOWNLOAD_FOLDER/PlexTV.m3u
mv $DOWNLOAD_FOLDER/us_moveonjoy.m3u $DOWNLOAD_FOLDER/MoveOnJoy.m3u

# === APPEND SOURCE TO CHANNEL NAMES

# Loop over all files ending with .TXT in the current directory
for FILE in $DOWNLOAD_FOLDER/*.m3u; do
  # Skip if the glob doesn't match any files (prevents running on literal "*.m3u")
  [[ -e "$FILE" ]] || continue

  # Remove carriage returns from downloaded playlists.
  echo " ➤ Processing file: $FILE"
  $WORKDIR/cleanup.sh "$FILE"

  # Extract the filename without the extension
  echo "🧹 Setting FILENAME variable to: $SOURCE"
  SOURCE=$(basename "$FILE" .m3u)

  # Run your separate script, EXAMPLE.SH, with the full filename and the stripped name
  $WORKDIR/append.sh "$FILE" " - $SOURCE"
done

# === COMBINE ALL PLAYLISTS
echo "🔄 Starting to combine M3U files from $PLAYLISTS_DIR..."

# Check if the output file already exists and back it up
## TODO: Daily backups
if [ -f "$OUTPUT_PLAYLIST" ]; then
    echo "➤ Backing up existing file: $OUTPUT_PLAYLIST"
    mv -f "$OUTPUT_PLAYLIST" "$OUTPUT_PLAYLIST.bak"
fi

if [[ -f "$PRIVATE_LIST_FILE" ]]; then
  echo "➤ Fetching private playlists from $PRIVATE_LIST_FILE..."
  if [[ -f "$UPDATED_PLAYLIST" ]]; then
    mv $UPDATED_PLAYLIST $UPDATED_PLAYLIST.bak
  fi
  grep -Ev "^#|^$" $PRIVATE_LIST_FILE | wget -i - -P $WORKDIR -c -nv -O $UPDATED_PLAYLIST
fi

# Add the standard M3U header to the new combined file
echo "#EXTM3U" > "$OUTPUT_PLAYLIST"

# Loop through all .m3u files in the specified directory
for file in "$DOWNLOAD_FOLDER"/*.m3u; do
    # Skip if the glob doesn't match any files or if it's the output file
    if [[ ! -e "$file" || "$file" == "$OUTPUT_PLAYLIST" ]]; then
        continue
    fi

    echo "➤ Processing file: $file"

    # Use 'grep' to find all lines that are not the #EXTM3U header.
    # The output is then appended to the combined playlist file.
    grep -v '^#EXTM3U' "$file" >> "$OUTPUT_PLAYLIST"
done

echo "✅ Merged playlists into output file located at: $OUTPUT_PLAYLIST"

# === GIT OPERATIONS ===
echo "🚀 Updating GitHub repo..."
git pull --rebase "$GITHUB_REMOTE" "$GITHUB_BRANCH"
git add -A
git commit -m "Auto-update combined IPTV playlist: $(date '+%Y-%m-%d %H:%M:%S')" || echo "No changes to commit"
git push "$GITHUB_REMOTE" "$GITHUB_BRANCH"

# === FINISHED
echo "🎉 Update complete at $(date)"
