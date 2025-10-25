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
# 0 */6 * * * /path/to/update_playlists.sh >> /path/to/update_playlists.log 2>&1
# =====================================

# === CONFIGURATION ===
WORKDIR="/usr/iptv-combo"       # Local clone of your GitHub repo
DOWNLOAD_FOLDER="$WORKDIR/downloads"          # Final merged playlist name
URL_LIST_FILE="$WORKDIR/playlists"  # Text file with one URL per line

# === SCRIPT START ===
set -e
cd "$WORKDIR" || { echo "▒^}^l Repo path not found: $WORKDIR"; exit 1; }

if [[ ! -f "$URL_LIST_FILE" ]]; then
  echo "▒^}^l URL list file not found: $URL_LIST_FILE"
  exit 1
fi

if [[ ! -d "$DOWNLOAD_FOLDER" ]]; then
  echo "▒^}^l Downloads Folder not found: $DOWNLOAD_FOLDER"
  exit 1
fi

echo "▒^=^t^d Fetching playlists from $URL_LIST_FILE..."
grep -Ev "^#|^$" $URL_LIST_FILE | wget -i - -P $DOWNLOAD_FOLDER -c -nv
echo "▒^|^e Downloaded playlists into $DOWNLOAD_FOLDER folder."

echo "Renaming Playlists..."
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

  # Extract the filename without the extension
  # The `%.*` removes the shortest match from the end of the string
  echo "Processing file: $FILE"
  $WORKDIR/cleanup.sh "$FILE"

  echo "Setting FILENAME variable to: $SOURCE"
  #SOURCE="${FILE%.*}"
  SOURCE=$(basename "$FILE" .m3u)

  # Run your separate script, EXAMPLE.SH, with the full filename and the stripped name
  $WORKDIR/append.sh "$FILE" " - $SOURCE"
done

# === COMBINE ALL PLAYLISTS

OUTPUT_PLAYLIST=$WORKDIR/free4jb.m3u

# --- Script starts here ---
echo "Starting to combine M3U files from $PLAYLISTS_DIR..."

# Check if the output file already exists and remove it to start fresh
if [ -f "$OUTPUT_PLAYLIST" ]; then
    echo "Removing existing file: $OUTPUT_PLAYLIST"
    mv -f "$OUTPUT_PLAYLIST" "$OUTPUT_PLAYLST.bak"
fi

# Add the standard M3U header to the new combined file
echo "#EXTM3U" > "$OUTPUT_PLAYLIST"

# Loop through all .m3u files in the specified directory
for file in "$DOWNLOAD_FOLDER"/*.m3u; do
    # Skip if the glob doesn't match any files or if it's the output file
    if [[ ! -e "$file" || "$file" == "$OUTPUT_PLAYLIST" ]]; then
        continue
    fi

    echo "Processing file: $file"

    # Use 'grep' to find all lines that are not the #EXTM3U header.
    # The output is then appended to the combined playlist file.
    grep -v '^#EXTM3U' "$file" >> "$OUTPUT_PLAYLIST"
done

echo "Combination complete. The master playlist is located at: $OUTPUT_PLAYLIST"

# === FINISHED
echo "Done."
